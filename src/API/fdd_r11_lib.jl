module R11

using ..Wrapper: R11_SDK_DLL
using ..TypeAlias
using ..FDDstruct
using ..FDDerror
using Libdl: dlsym

# ----------------------------------------------------------------------
#    R11CommLib API
# ----------------------------------------------------------------------

function LibGetVersion(version, maxLen)
    F = dlsym(R11_SDK_DLL[],:R11_LibGetVersion)
    @rccheck ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt8), version, maxLen)
end

function RpcSysSelectAddr(rs485Addr)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysSelectAddr)
    @rccheck ccall(F, FDD_RESULT, (UInt8,),rs485Addr)
end

function RpcSysGetBoardType(boardType)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetBoardType)
    @rccheck ccall(F, FDD_RESULT, (UInt8,),boardType)
end

function RpcSysReboot()
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysReboot)
    @rccheck ccall(F, FDD_RESULT, (),)
end

function RpcSysGetStoredChecksum(bpIndex, bpChecksum)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetStoredChecksum)
    @rccheck ccall(F, FDD_RESULT, (UInt16, Ptr{UInt32}), bpIndex, bpChecksum)
end

function RpcSysGetCalculatedChecksum(bpIndex, bpChecksum)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetCalculatedChecksum)
    @rccheck ccall(F, FDD_RESULT, (UInt16, Ptr{UInt32}), bpIndex, bpChecksum)
end

function RpcSysGetBitplaneCount(bpCount)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetBitplaneCount)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt32},), bpCount)
end

function RpcSysReloadRepertoire()
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysReloadRepertoire)
    @rccheck ccall(F, FDD_RESULT, (),)
end

function RpcSysGetRepertoireName(repName, maxLen)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetRepertoireName)
    @rccheck ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt8), repName, maxLen)
end

function RpcSysSaveSettings()
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysSaveSettings)
    @rccheck ccall(F, FDD_RESULT, (),)
end

function RpcSysGetDaughterboardType(dbType)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetDaughterboardType)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), dbType)
end

function RpcSysGetADC(adcChannel, adcValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetADC)
    @rccheck ccall(F, FDD_RESULT, (UInt8, Ptr{UInt16}), adcChannel, adcValue)
end

function RpcSysGetBoardID(boardId)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetBoardID)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), boardId)
end

function RpcSysGetDisplayType(dispType)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetDisplayType)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), dispType)
end

function RpcSysGetDisplayTemp(dispTemp)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetDisplayTemp)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt16},), dispTemp)
end

function RpcSysGetSerialNum(serialNum)
    F = dlsym(R11_SDK_DLL[],:R11_RpcSysGetSerialNum)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt32},), serialNum)
end

function RpcMicroGetCodeTimestamp(timestamp, maxLen)
    F = dlsym(R11_SDK_DLL[],:R11_RpcMicroGetCodeTimestamp)
    @rccheck ccall(F, FDD_RESULT, (Ptr{Cchar}, UInt8), timestamp, maxLen)
end

function RpcMicroGetCodeVersion(version)
    F = dlsym(R11_SDK_DLL[],:R11_RpcMicroGetCodeVersion)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt16},),version)
end

function RpcFlashEraseBlock(flashPage)
    F = dlsym(R11_SDK_DLL[],:R11_RpcFlashEraseBlock)
    @rccheck ccall(F, FDD_RESULT, (UInt32,), flashPage)
end

function RpcRoGetCount(roCount)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoGetCount)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt16},), roCount)
end

function RpcRoGetSelected(roIndex)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoGetSelected)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt16},), roIndex)
end

function RpcRoGetDefault(roIndex)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoGetDefault)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt16},), roIndex)
end

function RpcRoSetSelected(roIndex)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoSetSelected)
    @rccheck ccall(F, FDD_RESULT, (UInt16,), roIndex)
end

function RpcRoSetDefault(roIndex)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoSetDefault)
    @rccheck ccall(F, FDD_RESULT, (UInt16,), roIndex)
end

function RpcRoGetActivationType(actType)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoGetActivationType)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), actType)
end

function RpcRoGetActivationState(actState)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoGetActivationState)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), actState)
end

function RpcRoActivate()
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoActivate)
    @rccheck ccall(F, FDD_RESULT, (),)
end

function RpcRoDeactivate()
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoDeactivate)
    @rccheck ccall(F, FDD_RESULT, (),)
end

function RpcRoGetName(roIndex, roName, maxLen)
    F = dlsym(R11_SDK_DLL[],:R11_RpcRoGetName)
    @rccheck ccall(F, FDD_RESULT, (UInt16, Ptr{Cchar}, UInt8), roIndex, roName, maxLen)
end

function RpcLedSet(ledValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcLedSet)
    @rccheck ccall(F, FDD_RESULT, (UInt8,), ledValue)
end

function RpcLedGet(ledValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcLedGet)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), ledValue)
end

function RpcFlipTpSet(flipTpValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcFlipTpSet)
    @rccheck ccall(F, FDD_RESULT, (UInt8,), flipTpValue)
end

function RpcFlipTpGet(flipTpValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcFlipTpGet)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), flipTpValue)
end

function RpcMaintLedSet(ledEnable)
    F = dlsym(R11_SDK_DLL[],:R11_RpcMaintLedSet)
    @rccheck ccall(F, FDD_RESULT, (BOOL,), ledEnable)
end

function RpcMaintLedGet(ledEnable)
    F = dlsym(R11_SDK_DLL[],:R11_RpcMaintLedGet)
    @rccheck ccall(F, FDD_RESULT, (Ptr{BOOL},), ledEnable)
end

function DevGetProgress(pro)
    F = dlsym(R11_SDK_DLL[],:R11_DevGetProgress)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), pro)
end

function FlashRead(buf, offset, len)
    F = dlsym(R11_SDK_DLL[],:R11_FlashRead)
    @rccheck ccall(F, FDD_RESULT, (Ptr{Cvoid}, UInt16, UInt16), buf, offset, len)
end

function FlashWrite(buf, offset, len)
    F = dlsym(R11_SDK_DLL[],:R11_FlashWrite)
    @rccheck ccall(F, FDD_RESULT, (Ptr{Cvoid}, UInt16, UInt16), buf, offset, len)
end

function FlashBurn(page)
    F = dlsym(R11_SDK_DLL[],:R11_FlashBurn)
    @rccheck ccall(F, FDD_RESULT, (UInt32,), page)
end

function FlashGrab(page)
    F = dlsym(R11_SDK_DLL[],:R11_FlashGrab)
    @rccheck ccall(F, FDD_RESULT, (UInt32,), page)
end

function RpcM137CurrentLimitSet(maxValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcM137CurrentLimitSet)
    @rccheck ccall(F, FDD_RESULT, (UInt8,), maxValue)
end

function RpcM137CurrentLimitGet(maxValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcM137CurrentLimitGet)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), maxValue)
end

function RpcM137TemperatureLimitSet(maxValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcM137TemperatureLimitSet)
    @rccheck ccall(F, FDD_RESULT, (UInt8,), maxValue)
end

function RpcM137TemperatureLimitGet(maxValue)
    F = dlsym(R11_SDK_DLL[],:R11_RpcM137TemperatureLimitGet)
    @rccheck ccall(F, FDD_RESULT, (Ptr{UInt8},), maxValue)
end

end