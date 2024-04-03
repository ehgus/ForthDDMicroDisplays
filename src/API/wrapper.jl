module Wrapper

include("alias.jl")
include("fdd_struct.jl")
include("fdd_error.jl")
include("fdd_common_lib.jl")
include("fdd_r11_lib.jl")

using .TypeAlias
using .FDDstruct

function lib_version(target_lib::AbstractString)
    version_name = zeros(Cchar,MAX_TEXT_LEN)
    if target_lib == "common"
        FDD.LibGetVersion( version_name)
    elseif target_lib == "R11"
        R11.LibGetVersion( version_name, MAX_TEXT_LEN)
    else
        error("Supported target libraries are 'common' and 'R11'.")
    end
    unsafe_string(pointer(version_name))
end

end # module Wrapper