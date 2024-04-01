module ForthDDMicroDisplays

using Reexport
using VariableIOs
using VariableIOs.VariableArrayIOs

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

include("API/Wrapper.jl")
include("ForthDDMicroDisplay.jl")

end # module ForthDDMicrodisplays
