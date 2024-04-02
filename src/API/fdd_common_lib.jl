module FDD

using ..TypeAlias
using ..FDDStruct
import Libdl: dlopen, dlsym

dir_path = "C:/Program Files/Forth dimension display/Software/R11CommLib/examples/msvc/lib"

const FDD_DLL = Ref{Ptr{Cvoid}}(0)
function __init__()
    FDD_DLL[] = dlopen(joinpath(dir_path, "R11CommLib-1.8-x64.dll"))
end

# ----------------------------------------------------------------------
#    CommLib API
# ----------------------------------------------------------------------

function LibGetVersion(version)
    F = dlsym(FDD_DLL[], :FDD_LibGetVersion)
    ccall(F, FDD_RESULT, (Ptr{Cchar},), version)
end

function ExcGetMsg(msg)
    F = dlsym(FDD_DLL[], :FDD_ExcGetMsg)
    ccall(F, FDD_RESULT, (Ptr{Ptr{Cchar}},), msg)
end

function DevEnumerateComPorts(devList, devCount)
    F = dlsym(FDD_DLL[], :FDD_DevEnumerateComPorts)
    ccall(F, FDD_RESULT, (Ptr{Ptr{Dev}}, Ptr{UInt16}), devList, devCount)
end

function DevEnumerateHID(vid, pid, devList, devCount)
    F = dlsym(FDD_DLL[], :FDD_DevEnumerateHID)
    ccall(F, FDD_RESULT, (UInt16, UInt16, Ptr{Ptr{Dev}}, Ptr{UInt16}), vid, pid, devList, devCount)
end

function DevEnumerateWinUSB(guid, devList, devCount)
    F = dlsym(FDD_DLL[], :FDD_DevEnumerateWinUSB)
    ccall(F, FDD_RESULT, (Cstring, Ptr{Ptr{Dev}}, Ptr{UInt16}), guid, devList, devCount)
end

function DevGetFirst(pDevId)
    F = dlsym(FDD_DLL[], :FDD_DevGetFirst)
    ccall(F, FDD_RESULT, (Ptr{Ptr{Cchar}},), pDevId)
end

function DevGetNext(pDevId)
    F = dlsym(FDD_DLL[], :FDD_DevGetNext)
    ccall(F, FDD_RESULT, (Ptr{Ptr{Cchar}},), pDevId)
end

function DevOpenComPort(portName, timeout, baudRate, doResync)
    F = dlsym(FDD_DLL[], :FDD_DevOpenComPort)
    ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt16, UInt32, BOOL), portName, timeout, baudRate, doResync)
end

function DevOpenHID(devPath, timeout)
    F = dlsym(FDD_DLL[], :FDD_DevOpenHID)
    ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt16), devPath, timeout)
end

function DevOpenWinUSB(devPath, timeout)
    F = dlsym(FDD_DLL[], :FDD_DevOpenWinUSB)
    ccall(F, FDD_RESULT, (Cstring, UInt16), devPath, timeout)
end

function DevSetTimeout(timeout)
    F = dlsym(FDD_DLL[], :FDD_DevSetTimeout)
    ccall(F, FDD_RESULT, (UInt16,), timeout)
end

function DevGetTimeout(timeout)
    F = dlsym(FDD_DLL[], :FDD_DevGetTimeout)
    ccall(F, FDD_RESULT, (UInt16,), timeout)
end

function DevClose()
    F = dlsym(FDD_DLL[], :FDD_DevClose)
    ccall(F, FDD_RESULT, (), )
end

function FlashRead(buf, offset, len)
    F = dlsym(FDD_DLL[], :FDD_FlashRead)
    ccall(F, FDD_RESULT, (Ptr{Cvoid}, UInt16, UInt16), buf, offset, len)
end

function FlashWrite(buf, offset, len)
    F = dlsym(FDD_DLL[], :FDD_FlashWrite)
    ccall(F, FDD_RESULT, (Ptr{Cvoid}, UInt16, UInt16), buf, offset, len)
end

end # module FDD