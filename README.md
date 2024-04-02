# ForthDimensionDisplays.jl

A SLM controller from Forth Dimension Displays

It is early stage of the development

## example

```julia
using ForthDimensionDisplays

DDdisp = ForthDDMicroDisplay("R11");

open!(DDdisp)
ro_list = avail_image(DDdisp)
select_RO(DDdisp, ro_list[1])

using ForthDDSLMs.Wrapper
using ForthDDSLMs.Wrapper.R11

act_type = Ref(UInt8(0))
R11.RpcRoGetActivationType(act_type)
@show act_type[] #x01: immediate, x02: sw, x04: hw
act_state = Ref(UInt8(0))
R11.RpcRoGetActivationState(act_state)
@show act_state[]

R11.RpcRoActivate()

R11.RpcRoDeactivate()

function test_sleep()
    R11.RpcRoActivate()
    sleep(3)
    R11.RpcRoDeactivate()
end

# terminate control
close(DDdisp)
```