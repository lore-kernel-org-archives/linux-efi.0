From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 1/2] efi: import USB I/O related declarations from the UEFI spec
Date: Sat, 19 Aug 2017 16:17:39 +0100
Message-ID: <20170819151740.625-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardened-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In preparation of adding support for the Chaoskey USB stick to the
UEFI stub, import the USB I/O protocol declarations and related types
to linux/efi.h.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/efi.h | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 12e05118657c..253749cd9b62 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -22,6 +22,7 @@
 #include <linux/pstore.h>
 #include <linux/range.h>
 #include <linux/reboot.h>
+#include <linux/usb/ch9.h>
 #include <linux/uuid.h>
 #include <linux/screen_info.h>
 
@@ -622,6 +623,7 @@ void efi_native_runtime_setup(void);
 #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
 #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define APPLE_PROPERTIES_PROTOCOL_GUID		EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
+#define EFI_USB_IO_PROTOCOL_GUID		EFI_GUID(0x2b2f68d6, 0x0cd2, 0x44cf,  0x8e, 0x8b, 0xbb, 0xa2, 0x0b, 0x1b, 0x5b, 0x75)
 
 #define EFI_IMAGE_SECURITY_DATABASE_GUID	EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596,  0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
 #define EFI_SHIM_LOCK_GUID			EFI_GUID(0x605dab50, 0xe046, 0x4300,  0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
@@ -1569,4 +1571,68 @@ struct linux_efi_random_seed {
 	u8	bits[];
 };
 
+typedef enum {
+	EfiUsbDataIn,
+	EfiUsbDataOut,
+	EfiUsbNoData
+} efi_usb_data_direction_t;
+
+#define EFI_USB_NOERROR			0x0000
+#define EFI_USB_ERR_NOTEXECUTE		0x0001
+#define EFI_USB_ERR_STALL		0x0002
+#define EFI_USB_ERR_BUFFER		0x0004
+#define EFI_USB_ERR_BABBLE		0x0008
+#define EFI_USB_ERR_NAK			0x0010
+#define EFI_USB_ERR_CRC			0x0020
+#define EFI_USB_ERR_TIMEOUT		0x0040
+#define EFI_USB_ERR_BITSTUFF		0x0080
+#define EFI_USB_ERR_SYSTEM		0x0100
+
+typedef struct {
+	u8	request_type;
+	u8	request;
+	u16	value;
+	u16	index;
+	u16	length;
+} efi_usb_device_request_t;
+
+typedef efi_status_t (*efi_async_usb_transfer_callback_t)(void *, unsigned long,
+							  void *, u32);
+
+typedef struct efi_usb_io_protocol {
+	efi_status_t (*control_transfer)(struct efi_usb_io_protocol *,
+					 efi_usb_device_request_t *,
+					 efi_usb_data_direction_t,
+					 u32, void *, unsigned long, u32 *);
+	efi_status_t (*bulk_transfer)(struct efi_usb_io_protocol *, u8, void *,
+				      unsigned long *, unsigned long, u32 *);
+	efi_status_t (*async_int_transfer)(struct efi_usb_io_protocol *, u8,
+					  efi_bool_t, unsigned long,
+					  unsigned long,
+					  efi_async_usb_transfer_callback_t,
+					  void *);
+	efi_status_t (*sync_int_transfer)(struct efi_usb_io_protocol *, u8,
+					  void *, unsigned long *,
+					  unsigned long, u32 *);
+	efi_status_t (*isoc_transfer)(struct efi_usb_io_protocol *, u8, void *,
+				      unsigned long, u32 *);
+	efi_status_t (*async_isoc_transfer)(struct efi_usb_io_protocol *, u8 *,
+					    void *, unsigned long,
+					    efi_async_usb_transfer_callback_t,
+					    void *);
+	efi_status_t (*get_device_descriptor)(struct efi_usb_io_protocol *,
+					      struct usb_device_descriptor *);
+	efi_status_t (*get_config_descriptor)(struct efi_usb_io_protocol *,
+					      struct usb_config_descriptor *);
+	efi_status_t (*get_iface_descriptor)(struct efi_usb_io_protocol *,
+					     struct usb_interface_descriptor *);
+	efi_status_t (*get_ep_descriptor)(struct efi_usb_io_protocol *, u8,
+					  struct usb_endpoint_descriptor *);
+	efi_status_t (*get_string_descriptor)(struct efi_usb_io_protocol *,
+					       u16, u8, efi_char16_t **);
+	efi_status_t (*get_supported_languages)(struct efi_usb_io_protocol *,
+						u16 **, u16 *);
+	efi_status_t (*port_reset)(struct efi_usb_io_protocol *);
+} efi_usb_io_protocol_t;
+
 #endif /* _LINUX_EFI_H */
-- 
2.11.0
