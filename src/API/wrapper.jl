module Wrapper

include("alias.jl")
include("fdd_struct.jl")
include("error_handler.jl")
include("fdd_common_lib.jl")
include("fdd_r11_lib.jl")

using .TypeAlias
using .FDDStruct

const SLM_USB_GUID = Dict(
    "R11" => "54ED7AC9-CC23-4165-BE32-79016BAFB950",
)
# ----------------------------------------------------------------------
#    FDD wrapper
# ----------------------------------------------------------------------

function lib_version()
    LIB_VERSION_MAX_LEN = 64
    version = zeros(Cchar,LIB_VERSION_MAX_LEN)
    FDD.LibGetVersion(version)
    unsafe_string(pointer(version))
end

function device_list(device_type::String ,port::String)
    devlist = Ref(Ptr{Dev}(0))
    devcnt = Ref(UInt16(0))
    if port == "USB"
        guid = Base.cconvert(Cstring,SLM_USB_GUID[device_type])
        FDD.DevEnumerateWinUSB(guid, devlist, devcnt)
    else
        erorr("This package only support USB connection for now")
    end
    devid = Ref(Ptr{Cchar}(0))
    serial_list = Vector{String}(undef, devcnt[])
    FDD.DevGetFirst(devid)
    for i = 1:devcnt[]
        serial_list[i] = unsafe_string(devid[])
        FDD.DevGetNext(devid)
    end

    return serial_list
end

function open(port::String,serial::String)
    @assert port == "USB" "This package only support USB connection for now"
    devpath = split(serial,":")[1]
    FDD.DevOpenWinUSB(Base.cconvert(Cstring,devpath), 1000)
end

function close()
    FDD.DevClose()
end

# ----------------------------------------------------------------------
#    R11 wrapper
# ----------------------------------------------------------------------

function R11_roi()
    disp_type = Ref(UInt8(0))
    R11.RpcSysGetDisplayType(disp_type)
    if disp_type[] == 0x3
        return (2048, 1536)
    elseif disp_type[] == 0x05
        return (2048, 2048)
    else
        error("Unknown display")
    end
end

function R11_list_RO()
    ro_count = Ref(UInt16(0))
    R11.RpcRoGetCount(ro_count)
    name_list = Vector{String}(undef, ro_count[])
    max_length = 32
    name = zeros(Cchar,max_length)
    for i=1:ro_count[]
        R11.RpcRoGetName(i-1, name, max_length)
        name_list[i] = unsafe_string(pointer(name))
    end
    return name_list
end

function R11_select_RO(RO_name::String)
    name_list = R11_list_RO()
    i = findfirst(x->x==RO_name, name_list)
    @assert !isnothing(i) "The running order '$(RO_name) does not exist"
    R11.RpcRoSetSelected(i-1)
end

function R11_start()
    R11.RpcRoActivate()
end

function R11_stop()
    R11.RpcRoDeactivate()
end

end # module Wrapper