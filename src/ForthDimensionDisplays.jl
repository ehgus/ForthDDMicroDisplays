module ForthDimensionDisplays

using Reexport
using Preferences
using ExternalDeviceIOs
@reexport import ExternalDeviceIOs: activate, deactivate, isactivated
@reexport import ExternalDeviceIOs.Trigger: trigger_mode, trigger_mode!, trigger

import Base:
    open,
    close,
    isopen,
    size

export ForthDimensionDisplay,
    available_running_orders,
    running_order,
    running_order!

include("API/wrapper.jl")
using .Wrapper: get_library_path, set_library_path!
include("micro_display.jl")

end # module ForthDimensionDisplays
