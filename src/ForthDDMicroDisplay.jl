
mutable struct ForthDDMicroDisplay <: MicroDisplay
    device_type::String
    port::String
    serial::String
    isopen::Bool
    function ForthDDMicroDisplay(device_type,port="USB")
        if device_type != "R11"
            @error("Other microdisplay is not yet implemented")
        end
        if port != "USB"
            @error("This port except USB is not implemented")
        end
        serial = ""
        new(device_type, port, serial, false)
    end
end

function open!(microdisplay::ForthDDMicroDisplay)
    if isopen(microdisplay)
        return
    end
    serial_list = Wrapper.device_list(microdisplay.device_type, microdisplay.port)
    if isempty(serial_list)
        @error("device is not detected. Check the connection and GUID")
    end
    serial = serial_list[1]
    Wrapper.open(microdisplay.port, serial)
    # sucess connection
    microdisplay.serial = serial
    microdisplay.isopen = true
    return
end

function close!(microdisplay::ForthDDMicroDisplay)
    if !isopen(microdisplay)
        return
    end
    Wrapper.close()
    # success disconnection
    microdisplay.serial = ""
    microdisplay.isopen = false
    return
end

function start!(microdisplay::ForthDDMicroDisplay)
    if microdisplay.device_type == "R11"
        Wrapper.R11_start()
    else
        @error("unsupported device")
    end
end

function stop!(microdisplay::ForthDDMicroDisplay)
    if microdisplay.device_type == "R11"
        Wrapper.R11_stop()
    else
        @error("unsupported device")
    end
end

function avail_image(microdisplay::ForthDDMicroDisplay)
    if microdisplay.device_type == "R11"
        Wrapper.R11_list_RO()
    else
        @error("unsupported device")
    end
end

function write!(microdisplay::ForthDDMicroDisplay, RO_name)
    if microdisplay.device_type == "R11"
        Wrapper.R11_select_RO(RO_name)
    else
        @error("unsupported device")
    end
end

isopen(microdisplay::ForthDDMicroDisplay) = microdisplay.isopen

function size(microdisplay::ForthDDMicroDisplay)
    if microdisplay.device_type == "R11"
        Wrapper.R11_roi()
    else
        @error("unsupported device")
    end
end