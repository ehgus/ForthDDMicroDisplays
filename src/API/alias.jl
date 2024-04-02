module TypeAlias

export FDD_RESULT, BOOL,
    MAX_TEXT_LEN,
    USB_VENDOR_ID, DEVICE_INFO

const FDD_RESULT = BOOL = UInt8
const MAX_TEXT_LEN = 128
const USB_VENDOR_ID = 0x19EC 

const DEVICE_INFO = (
    R11 = (
        # communication
        usb_product_id = 0x0503,
        usb_guid = "54ED7AC9-CC23-4165-BE32-79016BAFB950",
        rs232_baudrate = 115200,
        rs485_baudrate = 256000,
        # flash memory
        external_flash = (
            image_base = 0x01000000,
            image_end = 0x0102FFFF,
            user_base = 0x01031000,
            user_end = 0x0103FDFF,
            page_size = 2048, # Bytes
            pages_per_block = 64
        ),
        internal_flash = (
            page_size = 256, # Bytes
            pages_per_block = 1,
            repertoire_base = 0x00000200
        )
    ),
)

end