using .Wrapper.TypeAlias
using .Wrapper: FDDstruct, FDD, R11

struct ForthDimensionDisplay <: IODeviceName
    port::String
    interface::Symbol
    function ForthDimensionDisplay(port, interface)
        @assert port ∈ ("winUSB", "HID", "RS232", "RS485") "Available ports are 'winUSB', 'HID', 'RS232', 'RS485'."
        @assert interface ∈ keys(DEVICE_INFO) "Available interface is only R11. Contribution is needed."
        new(port, interface)
    end
end

mutable struct ForthDimensionDisplayIOStream <: VariableArrayIOStream
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
    ForthDimensionDisplayIOStream(dev_name, dev_id, md.interface, true)
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

function activate(md::ForthDimensionDisplayIOStream)
    Wrapper.R11_start()
end

function deactivate(md::ForthDimensionDisplayIOStream)
    Wrapper.R11_stop()
end

function isactivated(md::ForthDimensionDisplayIOStream)
    error("Not implemented")
end

function avail_image(md::ForthDimensionDisplayIOStream)
    Wrapper.R11_list_RO()
end

function display(md::ForthDimensionDisplayIOStream, RO_name)
    Wrapper.R11_select_RO(RO_name)
end

function region_of_interest(md::ForthDimensionDisplayIOStream)
    Wrapper.R11_roi()
end