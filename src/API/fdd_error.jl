module FDDerror

using ..TypeAlias

export @rccheck

struct DisplayError <: Exception
    msg::String
end

function errortext(rc::FDD_RESULT)
    if rc == 0x01
        "FDD_MEM_INDEX_OUT_OF_BOUNDS"
    elseif rc == 0x02
        "FDD_MEM_NULL_POINTER"
    elseif rc == 0x03
        "FDD_MEM_ALLOC_FAILED"
    elseif rc == 0x04
        "FDD_DEV_SET_TIMEOUT_FAILED"
    elseif rc == 0x05
        "FDD_DEV_SET_BAUDRATE_FAILED"
    elseif rc == 0x06
        "FDD_DEV_OPEN_FAILED"
    elseif rc == 0x07
        "FDD_DEV_NOT_OPEN"
    elseif rc == 0x08
        "FDD_DEV_ALREADY_OPEN"
    elseif rc == 0x09
        "FDD_DEV_NOT_FOUND"
    elseif rc == 0x0A
        "FDD_DEV_ACCESS_DENIE"
    elseif rc == 0x0B
        "FDD_DEV_READ_FAILED"
    elseif rc == 0x0C
        "FDD_DEV_WRITE_FAILED"
    elseif rc == 0x0D
        "FDD_DEV_TIMEOUT"
    elseif rc == 0x0E
        "FDD_DEV_RESYNC_FAILE"
    elseif rc == 0x0F
        "FDD_SLAVE_INVALID_PACKET"
    elseif rc == 0x10
        "FDD_SLAVE_UNEXPECTED_PACKET"
    elseif rc == 0x11
        "FDD_SLAVE_ERROR"
    elseif rc == 0x12
        "FDD_SLAVE_EXCEPTION"
    else
        "Unexpected error type"
    end
end

macro rccheck(expr)
    (Meta.isexpr(expr,:ccall) && expr.args[1] === :ccall && expr.args[3] === Symbol(FDD_RESULT)) || "invalid use of @rccheck"
    return quote
        rc = $(esc(expr))
        if rc != 0
            txt = errortext(rc)
            throw(DisplayError(txt))
        end
    end
end

end # module FDDerror