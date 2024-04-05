using .Wrapper.TypeAlias
using .Wrapper: FDDstruct, FDD, R11

struct ForthDimensionDisplay <: ExternalDeviceName
    port::String
    interface::Symbol
    function ForthDimensionDisplay(port, interface)
        @assert port ∈ ("winUSB", "HID", "RS232", "RS485") "Available ports are 'winUSB', 'HID', 'RS232', 'RS485'."
        @assert interface ∈ keys(DEVICE_INFO) "Available interface is only R11. Contribution is needed."
        new(port, interface)
    end
end

mutable struct ForthDimensionDisplayIOStream <: ExternalDeviceIOStream
    device_name::String
    device_id::String
    interface::Symbol
    isopen::Bool
end

function open(md::ForthDimensionDisplay; timeout_millisecond = 1000)
    dev_list = C_NULL
    dev_cnt = Ref(UInt16(0))
    # configure a connection
    if md.port == "winUSB"
        guid = DEVICE_INFO[md.interface][:usb_guid]
        FDD.DevEnumerateWinUSB(guid, dev_list, dev_cnt)
    elseif md.port == "HID"
        vid = USB_VENDOR_ID
        pid = DEVICE_INFO[md.interface][:usb_product_id]
        FDD.DevEnumerateHID(vid, pid, dev_list, dev_cnt)
    else
        FDD.DevEnumerateComPorts(dev_list, dev_cnt)
    end
    @assert dev_cnt[] > 0 "The $(md.interface) interface is not accessible through $(md.port) port"
    # select the first device found by enumeration
    ref_dev_info = Ref(Ptr{Cchar}(0))
    FDD.DevGetFirst(ref_dev_info)
    dev_info = split(unsafe_string(ref_dev_info[]),":")
    dev_id = dev_info[1]
    dev_name = dev_info[2]
    # open a connection
    if md.port == "winUSB"
        FDD.DevOpenWinUSB(dev_id, timeout_millisecond)
    elseif md.port == "HID"
        FDD.DevOpenHID(dev_id, timeout_millisecond)
    elseif md.port == "RS232"
        baudrate = DEVICE_INFO[md.interface][:rs232_baudrate]
        FDD.DevOpenComPort(dev_id, timeout_millisecond, baudrate, true)
    elseif md.port == "RS485"
        baudrate = DEVICE_INFO[md.interface][:rs485_baudrate]
        FDD.DevOpenComPort(dev_id, timeout_millisecond, baudrate, false)
    end
    io = ForthDimensionDisplayIOStream(dev_name, dev_id, md.interface, true)
    deactivate(io)
    io
end

function close(md::ForthDimensionDisplayIOStream)
    if !isopen(md)
        return
    end
    FDD.DevClose()
    md.isopen = false
    md
end

isopen(md::ForthDimensionDisplayIOStream) = getfield(md, :isopen)

function activate(md::ForthDimensionDisplayIOStream; timeout_millisecond = 1000)
    @assert isopen(md) "The microdisplay is not accessible"
    @assert md.interface === :R11 "Other interfaces except R11 are not supported"
    R11.RpcRoActivate()
end

function deactivate(md::ForthDimensionDisplayIOStream)
    @assert isopen(md) "The microdisplay is not accessible"
    @assert md.interface === :R11 "Other interfaces except R11 are not supported"
    R11.RpcRoDeactivate()
end

function isactivated(md::ForthDimensionDisplayIOStream)
    @assert isopen(md) "The microdisplay is not accessible"
    @assert md.interface === :R11 "Other interfaces except R11 are not supported"
    ref_act_state = Ref(UInt8(0))
    R11.RpcRoGetActivationState(ref_act_state)
    act_state = ref_act_state[]
    if act_state == 0x56
        true
    else
        false
    end
end

function available_running_orders(md::ForthDimensionDisplayIOStream)
    @assert isopen(md) "The microdisplay is not accessible"
    @assert md.interface === :R11 "Other interfaces except R11 are not supported"
    ro_cnt =  Ref(UInt16(0))
    R11.RpcRoGetCount(ro_cnt)
    ro_name_list = Vector{String}(undef, ro_cnt[])
    max_length = 32
    name = zeros(Cchar, max_length)
    for idx = 1:ro_cnt[]
        R11.RpcRoGetName(idx-1, name, max_length)
        ro_name_list[idx] = unsafe_string(pointer(name))
    end
    ro_name_list
end

function running_order(md::ForthDimensionDisplayIOStream)
    ro_name_list = available_running_orders(md)
    ref_idx = Ref(UInt16(0xffff))
    R11.RpcRoGetSelected(ref_idx)
    idx = ref_idx[] + 1
    ro_name_list[idx]
end

function running_order!(md::ForthDimensionDisplayIOStream, ro_name::String)
    ro_name_list = available_running_orders(md)
    idx = findfirst(==(ro_name), ro_name_list)
    @assert !isnothing(idx) "Available running orders are $(ro_name_list)"
    idx -= 1
    R11.RpcRoSetSelected(idx)
    deactivate(md)
end

function imagedim(md::ForthDimensionDisplayIOStream)
    @assert isopen(md) "The microdisplay is not accessible"
    @assert md.interface === :R11 "Other interfaces except R11 are not supported"
    disp_type = Ref(UInt8(0))
    R11.RpcSysGetDisplayType(disp_type)
    if disp_type[] == 0x00
        error("Display is not detected")
    elseif disp_type[] == 0x03
        (2048, 1536)
    elseif disp_type[] == 0x05
        (2048, 2048)
    elseif disp_type[] == 0xFF
        error("Unknown display")
    else
        error("Unknow display type")
    end
end

function trigger_mode(md::ForthDimensionDisplayIOStream)
    @assert isopen(md) "The microdisplay is not accessible"
    @assert md.interface === :R11 "Other interfaces except R11 are not supported"
    ref_act_type = Ref(UInt8(0))
    R11.RpcRoGetActivationType(ref_act_type)
    act_type = ref_act_type[]
    if act_type == 0x01
        "automatic"
    elseif act_type == 0x02
        "software trigger"
    elseif act_type == 0x04
        "hardware trigger"
    else
        error("Unknown trigger type")
    end
end

function trigger(md::ForthDimensionDisplayIOStream)
    activate(md)
end