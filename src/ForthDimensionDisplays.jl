module ForthDimensionDisplays

using Reexport
using VariableIOs
using VariableIOs.VariableArrayIOs

export ForthDimensionDisplay,
    imagedim,
    available_running_orders,
    running_order,
    running_order!

@reexport import VariableIOs:
    activate,
    deactivate,
    isactivated,
    trigger_mode,
    trigger

import Base:
    open,
    close,
    isopen

include("API/wrapper.jl")
include("micro_display.jl")

end # module ForthDimensionDisplays
