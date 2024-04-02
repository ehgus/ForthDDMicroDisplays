module ForthDimensionDisplays

using Reexport
using VariableIOs
using VariableIOs.VariableArrayIOs

export ForthDimensionDisplay

@reexport import VariableIOs:
    activate,
    deactivate,
    isactivated

@reexport import VariableIOs.VariableArrayIOs:
    region_of_interest

import Base:
    open,
    close,
    isopen,
    # while execution
    display

function __init__()
    @assert Sys.iswindows() "It only works on windows"
end

include("API/wrapper.jl")
include("micro_display.jl")

end # module ForthDimensionDisplays
