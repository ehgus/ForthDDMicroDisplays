module Wrapper

include("TypeAlias.jl")
include("APIstruct.jl")

using .TypeAlias
using .APIstruct
# ----------------------------------------------------------------------
#    Basic error handler
# ----------------------------------------------------------------------

function errortext(rc::FDD_RESULT)
    if rc == 0x01
        "FDD_MEM_INDEX_OUT_OF_BOUNDS"
    elseif rc == 0x02
        "FDD_MEM_NULL_POINTER"
    elseif rc == 0x03
        "FDD_MEM_ALLOC_FAILED"
    elseif rc == 0x04
        "FDD_DEV_SET_TIMEOUT_FAILED"
    elseif rc == 0x05
        "FDD_DEV_SET_BAUDRATE_FAILED"
    elseif rc == 0x06
        "FDD_DEV_OPEN_FAILED"
    elseif rc == 0x07
        "FDD_DEV_NOT_OPEN"
    elseif rc == 0x08
        "FDD_DEV_ALREADY_OPEN"
    elseif rc == 0x09
        "FDD_DEV_NOT_FOUND"
    elseif rc == 0x0A
        "FDD_DEV_ACCESS_DENIE"
    elseif rc == 0x0B
        "FDD_DEV_READ_FAILED"
    elseif rc == 0x0C
        "FDD_DEV_WRITE_FAILED"
    elseif rc == 0x0D
        "FDD_DEV_TIMEOUT"
    elseif rc == 0x0E
        "FDD_DEV_RESYNC_FAILE"
    elseif rc == 0x0F
        "FDD_SLAVE_INVALID_PACKET"
    elseif rc == 0x10
        "FDD_SLAVE_UNEXPECTED_PACKET"
    elseif rc == 0x11
        "FDD_SLAVE_ERROR"
    elseif rc == 0x12
        "FDD_SLAVE_EXCEPTION"
    else
        "Unexpected error type"
    end
end

macro rccheck(apicall)
    str_apicall = "FDD_" * sprint(Base.show_unquoted, apicall)
    return esc(quote
        rc = $apicall
        if rc != 0
            func = $str_apicall
            txt = errortext(rc)
            @error("$(func) : $(txt)")
        end
    end)
end

const SLM_USB_GUID = Dict(
    "R11" => "54ED7AC9-CC23-4165-BE32-79016BAFB950",
)
# ----------------------------------------------------------------------
#    FDD wrapper
# ----------------------------------------------------------------------
include("FDD.jl")

function lib_version()
    version = zeros(Cchar,LIB_VERSION_MAX_LEN)
    @rccheck FDD.LibGetVersion(version)
    unsafe_string(pointer(version))
end

function device_list(device_type::String ,port::String)
    devlist = Ref(Ptr{Dev}(0))
    devcnt = Ref(UInt16(0))
    if port == "USB"
        guid = Base.cconvert(Cstring,SLM_USB_GUID[device_type])
        @rccheck FDD.DevEnumerateWinUSB(guid, devlist, devcnt)
    else
        erorr("This package only support USB connection for now")
    end
    devid = Ref(Ptr{Cchar}(0))
    serial_list = Vector{String}(undef, devcnt[])
    @rccheck FDD.DevGetFirst(devid)
    for i = 1:devcnt[]
        serial_list[i] = unsafe_string(devid[])
        @rccheck FDD.DevGetNext(devid)
    end

    return serial_list
end

function open(port::String,serial::String)
    if port == "USB"
        devpath = split(serial,":")[1]
        @rccheck FDD.DevOpenWinUSB(Base.cconvert(Cstring,devpath), 1000)
    else
        erorr("This package only support USB connection for now")
    end
end

function close()
    @rccheck FDD.DevClose()
end

# ----------------------------------------------------------------------
#    R11 wrapper
# ----------------------------------------------------------------------
include("R11.jl")

EF_PAGE_SIZE = 

function R11_roi()
    disp_type = Ref(UInt8(0))
    @rccheck R11.RpcSysGetDisplayType(disp_type)
    if disp_type[] == 0x3
        return (2048, 1536)
    elseif disp_type[] == 0x05
        return (2048, 2048)
    else
        @error("Unknown display")
    end
end

function R11_list_RO()
    ro_count = Ref(UInt16(0))
    @rccheck R11.RpcRoGetCount(ro_count)
    name_list = Vector{String}(undef, ro_count[])
    max_length = 32
    name = zeros(Cchar,max_length)
    for i=1:ro_count[]
        @rccheck R11.RpcRoGetName(i-1, name, max_length)
        name_list[i] = unsafe_string(pointer(name))
    end
    return name_list
end

function R11_select_RO(RO_name::String)
    name_list = R11_list_RO()
    i = findfirst(x->x==RO_name, name_list)
    @assert !isnothing(i) "The running order '$(RO_name) does not exist"
    @rccheck R11.RpcRoSetSelected(i-1)
end


function R11_start()
    @rccheck R11.RpcRoActivate()
end

function R11_stop()
    @rccheck R11.RpcRoDeactivate()
end

end # module Wrapper