From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] efi: import USB I/O related declarations from
 the UEFI spec
Date: Sat, 2 Sep 2017 08:41:42 +0200
Message-ID: <20170902064142.GA26383@kroah.com>
References: <20170819151740.625-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170819151740.625-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardened-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 19, 2017 at 04:17:39PM +0100, Ard Biesheuvel wrote:
> In preparation of adding support for the Chaoskey USB stick to the
> UEFI stub, import the USB I/O protocol declarations and related types
> to linux/efi.h.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  include/linux/efi.h | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 12e05118657c..253749cd9b62 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -22,6 +22,7 @@
>  #include <linux/pstore.h>
>  #include <linux/range.h>
>  #include <linux/reboot.h>
> +#include <linux/usb/ch9.h>
>  #include <linux/uuid.h>
>  #include <linux/screen_info.h>
>  
> @@ -622,6 +623,7 @@ void efi_native_runtime_setup(void);
>  #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
>  #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>  #define APPLE_PROPERTIES_PROTOCOL_GUID		EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
> +#define EFI_USB_IO_PROTOCOL_GUID		EFI_GUID(0x2b2f68d6, 0x0cd2, 0x44cf,  0x8e, 0x8b, 0xbb, 0xa2, 0x0b, 0x1b, 0x5b, 0x75)
>  
>  #define EFI_IMAGE_SECURITY_DATABASE_GUID	EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596,  0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
>  #define EFI_SHIM_LOCK_GUID			EFI_GUID(0x605dab50, 0xe046, 0x4300,  0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
> @@ -1569,4 +1571,68 @@ struct linux_efi_random_seed {
>  	u8	bits[];
>  };
>  
> +typedef enum {
> +	EfiUsbDataIn,
> +	EfiUsbDataOut,
> +	EfiUsbNoData
> +} efi_usb_data_direction_t;
> +
> +#define EFI_USB_NOERROR			0x0000
> +#define EFI_USB_ERR_NOTEXECUTE		0x0001
> +#define EFI_USB_ERR_STALL		0x0002
> +#define EFI_USB_ERR_BUFFER		0x0004
> +#define EFI_USB_ERR_BABBLE		0x0008
> +#define EFI_USB_ERR_NAK			0x0010
> +#define EFI_USB_ERR_CRC			0x0020
> +#define EFI_USB_ERR_TIMEOUT		0x0040
> +#define EFI_USB_ERR_BITSTUFF		0x0080
> +#define EFI_USB_ERR_SYSTEM		0x0100
> +
> +typedef struct {
> +	u8	request_type;
> +	u8	request;
> +	u16	value;
> +	u16	index;
> +	u16	length;
> +} efi_usb_device_request_t;

A typedef?

Also, those values are little-endian, right?  And finally, they are
crossing the user/kernel boundry, so they should be using the __ variant
of the variable type, right?

And finally, why does efi.h care about device specific stuff like this?
Are you going to want to add all different types of efi devices here in
the future?  That does not seem wise from a maintaince point-of-view...

thanks,

greg k-h
