# ForthDimensionDisplays.jl

A SLM controller from Forth Dimension Displays

It is early stage of the development and only tested with QXGA with R11 interface.

## example

```julia
using ForthDimensionDisplays

md = ForthDimensionDisplay("winUSB",:R11)

open(md) do io
    @show imagedim(io)
    @show running_order(io)
    @show trigger_mode(io)
    ro_names =  available_running_orders(io)
    running_order!(io,ro_names[end])
    @show running_order(io)
    @show trigger_mode(io)
    activate(io) do activate_io
        sleep(3)
    end
end

```