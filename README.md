# ForthDimensionDisplays.jl

A SLM controller from Forth Dimension Displays

It is early stage of the development and only tested with QXGA with R11 interface.

## example

```julia
using ForthDimensionDisplays

md = ForthDimensionDisplay("winUSB",:R11)

open(md) do io
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

## Shared library configuration
The default library path is set supposing you install the recent Recorder library for all users.
You can check and change the path using `get_library_path` and `set_library_path!`.
The directory should contains 'R11CommLib-1.8-x64.dll'.

```Julia
old_path = PcoCameras.get_library_path()
new_path = "some/dir/of/shared/library/"
PcoCameras.set_library_path!(new_path)
```