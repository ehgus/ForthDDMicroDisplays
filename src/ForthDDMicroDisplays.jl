module ForthDDMicroDisplays

using MicroDisplays

import MicroDisplays:
    open,
    close,
    write,
    isopen,
    size

export ForthDDMicroDisplay,
    open,
    close,
    start!,
    stop!,
    avail_image,
    write,
    isopen,
    size

include("API/Wrapper.jl")
include("ForthDDMicroDisplay.jl")

end # module ForthDDMicrodisplays
