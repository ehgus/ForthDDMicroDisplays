
struct ForthDDMicroDisplay <: IODeviceName
    device_type::String
    port::String
    function ForthDDMicroDisplay()
        # For now, it only support R11 with USB connection
        new("R11", "USB")
    end
end

mutable struct ForthDDMicroDisplayIOStream <: VariableArrayIOStream
    device_type::String
    serial::String
    isopen::Bool
end

function open(md::ForthDDMicroDisplay)
    serial_list = Wrapper.device_list(md.device_type, md.port)
    if isempty(serial_list)
        error("device is not detected. Check the connection and GUID")
    end
    serial = serial_list[1]
    Wrapper.open(md.port, serial)
    # sucess connection
    ForthDDMicroDisplayIOStream(md.device_type, serial, true)
end

function close(md::ForthDDMicroDisplayIOStream)
    if !isopen(md)
        return
    end
    Wrapper.close()
    md.isopen = false
    md
end

isopen(md::ForthDDMicroDisplayIOStream) = md.isopen

function activate(md::ForthDDMicroDisplayIOStream)
    Wrapper.R11_start()
end

function deactivate(md::ForthDDMicroDisplayIOStream)
    Wrapper.R11_stop()
end

function isactivated(md::ForthDDMicroDisplayIOStream)
    error("Not implemented")
end

function avail_image(md::ForthDDMicroDisplayIOStream)
    Wrapper.R11_list_RO()
end

function display(md::ForthDDMicroDisplayIOStream, RO_name)
    Wrapper.R11_select_RO(RO_name)
end

function region_of_interest(md::ForthDDMicroDisplayIOStream)
    Wrapper.R11_roi()
end