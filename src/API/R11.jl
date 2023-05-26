module R11

using ..TypeAlias
using ..APIstruct
import Libdl: dlopen, dlsym

dir_path = "C:/Program Files/Forth dimension display/Software/R11CommLib/examples/msvc/lib"

const R11_DLL = Ref{Ptr{Cvoid}}(0)
function __init__()
    R11_DLL[] = dlopen(joinpath(dir_path, "R11CommLib-1.8-x64.dll"))
end

# ----------------------------------------------------------------------
#    R11CommLib API
# ----------------------------------------------------------------------

function LibGetVersion(version, maxLen)
    F = dlsym(R11_DLL[],:R11_LibGetVersion)
    ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt8), version, maxLen)
end

function RpcSysSelectAddr(rs485Addr)
    F = dlsym(R11_DLL[],:R11_RpcSysSelectAddr)
    ccall(F, FDD_RESULT, (UInt8,),rs485Addr)
end

function RpcSysGetBoardType(boardType)
    F = dlsym(R11_DLL[],:R11_RpcSysGetBoardType)
    ccall(F, FDD_RESULT, (UInt8,),boardType)
end

function RpcSysReboot()
    F = dlsym(R11_DLL[],:R11_RpcSysReboot)
    ccall(F, FDD_RESULT, (),)
end

function RpcSysGetStoredChecksum(bpIndex, bpChecksum)
    F = dlsym(R11_DLL[],:R11_RpcSysGetStoredChecksum)
    ccall(F, FDD_RESULT, (UInt16, Ptr{UInt32}), bpIndex, bpChecksum)
end

function RpcSysGetCalculatedChecksum(bpIndex, bpChecksum)
    F = dlsym(R11_DLL[],:R11_RpcSysGetCalculatedChecksum)
    ccall(F, FDD_RESULT, (UInt16, Ptr{UInt32}), bpIndex, bpChecksum)
end

function RpcSysGetBitplaneCount(bpCount)
    F = dlsym(R11_DLL[],:R11_RpcSysGetBitplaneCount)
    ccall(F, FDD_RESULT, (Ptr{UInt32},), bpCount)
end

function RpcSysReloadRepertoire()
    F = dlsym(R11_DLL[],:R11_RpcSysReloadRepertoire)
    ccall(F, FDD_RESULT, (),)
end

function RpcSysGetRepertoireName(repName, maxLen)
    F = dlsym(R11_DLL[],:R11_RpcSysGetRepertoireName)
    ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt8), repName, maxLen)
end

function RpcSysSaveSettings()
    F = dlsym(R11_DLL[],:R11_RpcSysSaveSettings)
    ccall(F, FDD_RESULT, (),)
end

function RpcSysGetDaughterboardType(dbType)
    F = dlsym(R11_DLL[],:R11_RpcSysGetDaughterboardType)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), dbType)
end

function RpcSysGetADC(adcChannel, adcValue)
    F = dlsym(R11_DLL[],:R11_RpcSysGetADC)
    ccall(F, FDD_RESULT, (UInt8, Ptr{UInt16}), adcChannel, adcValue)
end

function RpcSysGetBoardID(boardId)
    F = dlsym(R11_DLL[],:R11_RpcSysGetBoardID)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), boardId)
end

function RpcSysGetDisplayType(dispType)
    F = dlsym(R11_DLL[],:R11_RpcSysGetDisplayType)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), dispType)
end

function RpcSysGetDisplayTemp(dispTemp)
    F = dlsym(R11_DLL[],:R11_RpcSysGetDisplayTemp)
    ccall(F, FDD_RESULT, (Ptr{UInt16},), dispTemp)
end

function RpcSysGetSerialNum(serialNum)
    F = dlsym(R11_DLL[],:R11_RpcSysGetSerialNum)
    ccall(F, FDD_RESULT, (Ptr{UInt32},), serialNum)
end

function RpcMicroGetCodeTimestamp(timestamp, maxLen)
    F = dlsym(R11_DLL[],:R11_RpcMicroGetCodeTimestamp)
    ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt8), timestamp, maxLen)
end

function RpcMicroGetCodeVersion(version)
    F = dlsym(R11_DLL[],:R11_RpcMicroGetCodeVersion)
    ccall(F, FDD_RESULT, (Ptr{UInt16},),version)
end

function RpcFlashEraseBlock(flashPage)
    F = dlsym(R11_DLL[],:R11_RpcFlashEraseBlock)
    ccall(F, FDD_RESULT, (UInt32,), flashPage)
end

function RpcRoGetCount(roCount)
    F = dlsym(R11_DLL[],:R11_RpcRoGetCount)
    ccall(F, FDD_RESULT, (Ptr{UInt16},), roCount)
end

function RpcRoGetSelected(roIndex)
    F = dlsym(R11_DLL[],:R11_RpcRoGetSelected)
    ccall(F, FDD_RESULT, (Ptr{UInt16},), roIndex)
end

function RpcRoGetDefault(roIndex)
    F = dlsym(R11_DLL[],:R11_RpcRoGetDefault)
    ccall(F, FDD_RESULT, (Ptr{UInt16},), roIndex)
end

function RpcRoSetSelected(roIndex)
    F = dlsym(R11_DLL[],:R11_RpcRoSetSelected)
    ccall(F, FDD_RESULT, (UInt16,), roIndex)
end

function RpcRoSetDefault(roIndex)
    F = dlsym(R11_DLL[],:R11_RpcRoSetDefault)
    ccall(F, FDD_RESULT, (UInt16,), roIndex)
end

function RpcRoGetActivationType(actType)
    F = dlsym(R11_DLL[],:R11_RpcRoGetActivationType)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), actType)
end

function RpcRoGetActivationState(actState)
    F = dlsym(R11_DLL[],:R11_RpcRoGetActivationState)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), actState)
end

function RpcRoActivate()
    F = dlsym(R11_DLL[],:R11_RpcRoActivate)
    ccall(F, FDD_RESULT, (),)
end

function RpcRoDeactivate()
    F = dlsym(R11_DLL[],:R11_RpcRoDeactivate)
    ccall(F, FDD_RESULT, (),)
end

function RpcRoGetName(roIndex, roName, maxLen)
    F = dlsym(R11_DLL[],:R11_RpcRoGetName)
    ccall(F, FDD_RESULT, (UInt16, Ptr{Cchar}, UInt8), roIndex, roName, maxLen)
end

function RpcLedSet(ledValue)
    F = dlsym(R11_DLL[],:R11_RpcLedSet)
    ccall(F, FDD_RESULT, (UInt8,), ledValue)
end

function RpcLedGet(ledValue)
    F = dlsym(R11_DLL[],:R11_RpcLedGet)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), ledValue)
end

function RpcFlipTpSet(flipTpValue)
    F = dlsym(R11_DLL[],:R11_RpcFlipTpSet)
    ccall(F, FDD_RESULT, (UInt8,), flipTpValue)
end

function RpcFlipTpGet(flipTpValue)
    F = dlsym(R11_DLL[],:R11_RpcFlipTpGet)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), flipTpValue)
end

function RpcMaintLedSet(ledEnable)
    F = dlsym(R11_DLL[],:R11_RpcMaintLedSet)
    ccall(F, FDD_RESULT, (BOOL,), ledEnable)
end

function RpcMaintLedGet(ledEnable)
    F = dlsym(R11_DLL[],:R11_RpcMaintLedGet)
    ccall(F, FDD_RESULT, (Ptr{BOOL},), ledEnable)
end

function DevGetProgress(pro)
    F = dlsym(R11_DLL[],:R11_DevGetProgress)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), pro)
end

function FlashRead(buf, offset, len)
    F = dlsym(R11_DLL[],:R11_FlashRead)
    ccall(F, FDD_RESULT, (Ptr{Cvoid}, UInt16, UInt16), buf, offset, len)
end

function FlashWrite(buf, offset, len)
    F = dlsym(R11_DLL[],:R11_FlashWrite)
    ccall(F, FDD_RESULT, (Ptr{Cvoid}, UInt16, UInt16), buf, offset, len)
end

function FlashBurn(page)
    F = dlsym(R11_DLL[],:R11_FlashBurn)
    ccall(F, FDD_RESULT, (UInt32,), page)
end

function FlashGrab(page)
    F = dlsym(R11_DLL[],:R11_FlashGrab)
    ccall(F, FDD_RESULT, (UInt32,), page)
end

function RpcM137CurrentLimitSet(maxValue)
    F = dlsym(R11_DLL[],:R11_RpcM137CurrentLimitSet)
    ccall(F, FDD_RESULT, (UInt8,), maxValue)
end

function RpcM137CurrentLimitGet(maxValue)
    F = dlsym(R11_DLL[],:R11_RpcM137CurrentLimitGet)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), maxValue)
end

function RpcM137TemperatureLimitSet(maxValue)
    F = dlsym(R11_DLL[],:R11_RpcM137TemperatureLimitSet)
    ccall(F, FDD_RESULT, (UInt8,), maxValue)
end

function RpcM137TemperatureLimitGet(maxValue)
    F = dlsym(R11_DLL[],:R11_RpcM137TemperatureLimitGet)
    ccall(F, FDD_RESULT, (Ptr{UInt8},), maxValue)
end

end