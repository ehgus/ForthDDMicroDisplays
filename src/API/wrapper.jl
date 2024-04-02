module Wrapper

include("alias.jl")
include("fdd_struct.jl")
include("fdd_error.jl")
include("fdd_common_lib.jl")
include("fdd_r11_lib.jl")

using .TypeAlias
using .FDDstruct

# ----------------------------------------------------------------------
#    FDD wrapper
# ----------------------------------------------------------------------

function lib_version()
    version = zeros(Cchar,MAX_TEXT_LEN)
    FDD.LibGetVersion(version)
    unsafe_string(pointer(version))
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