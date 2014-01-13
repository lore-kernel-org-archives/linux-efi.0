From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 4/6] arm64: add EFI stub
Date: Mon, 13 Jan 2014 19:49:38 +0100
Message-ID: <201401131949.39358.arnd@arndb.de>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com> <1389392950-22457-5-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389392950-22457-5-git-send-email-msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Friday 10 January 2014, Mark Salter wrote:
> This patch adds PE/COFF header fields to the start of the Image
> so that it appears as an EFI application to EFI firmware. An EFI
> stub is included to allow direct booting of the kernel Image. Due
> to EFI firmware limitations, only little endian kernels with 4K
> page sizes are supported at this time. Support in the COFF header
> for signed images was provided by Ard Biesheuvel.
> 
> Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

You got the ordering of the S-o-b lines wrong. Since you send the
patch, your name should come last.

> +config EFI_STUB
> +	bool "EFI stub support"
> +	depends on !ARM64_64K_PAGES && OF
> +	select LIBFDT
> +	default y
> +	help
> +	  This kernel feature allows an Image to be loaded directly
> +	  by EFI firmware without the use of a bootloader.
> +	  See Documentation/efi-stub.txt for more information.
> +
>  endmenu

Why not ARM64_64K_PAGES? I thought that it was going to be the
default for a lot of distros that would need to run on UEFI systems.

>  menu "Userspace binary formats"
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 5ba2fd4..1c52b84 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -4,6 +4,8 @@
>  
>  CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
>  AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
> +CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
> +			   -I$(src)/../../../scripts/dtc/libfdt

Hmm, this is pretty ugly. I notice the same has been done on MIPS
as well, but I'd hope we can find a proper way to do it.

> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> new file mode 100644
> index 0000000..10d02bf
> --- /dev/null
> +++ b/arch/arm64/kernel/efi-stub.c
> +
> +/* Include shared EFI stub code */
> +#include "../../../drivers/firmware/efi/efi-stub-helper.c"
> +#include "../../../drivers/firmware/efi/fdt.c"

It gets worse here.

	Arnd
