From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi: Add esrt support.
Date: Thu, 26 Feb 2015 16:00:33 +0800
Message-ID: <20150226080033.GB6207@darkstar.redhat.com>
References: <1424357660-13733-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424357660-13733-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 02/19/15 at 09:54am, Peter Jones wrote:
> Add sysfs files for the EFI System Resource Table (ESRT) under
> /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> entries/ as a subdir.
> 
> The EFI System Resource Table (ESRT) provides a read-only catalog of
> system components for which the system accepts firmware upgrades via
> UEFI's "Capsule Update" feature.  This module allows userland utilities
> to evaluate what firmware updates can be applied to this system, and
> potentially arrange for those updates to occur.
> 
> The ESRT is described as part of the UEFI specification, in version 2.5
> which should be available from http://uefi.org/specifications in early
> 2015.  If you're a member of the UEFI Forum, information about its
> addition to the standard is available as UEFI Mantis 1090.
> 
> For some hardware platforms, additional restrictions may be found at
> http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256.aspx ,
> and additional documentation may be found at
> http://download.microsoft.com/download/5/F/5/5F5D16CD-2530-4289-8019-94C6A20BED3C/windows-uefi-firmware-update-platform.docx
> .
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c   |   2 +
>  drivers/firmware/efi/Makefile |   2 +-
>  drivers/firmware/efi/efi.c    |  68 ++++++-
>  drivers/firmware/efi/esrt.c   | 441 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h           |   8 +
>  5 files changed, 519 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/firmware/efi/esrt.c

Update documentation under Documentation/ABI/testing/?

[snip]

>  /*
> @@ -95,6 +96,8 @@ static ssize_t systab_show(struct kobject *kobj,
>  		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
>  	if (efi.uga != EFI_INVALID_TABLE_ADDR)
>  		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
> +	if (efi.esrt != EFI_INVALID_TABLE_ADDR)
> +		str += sprintf(str, "ESRT=0x%lx\n", efi.esrt);
>  
>  	return str - buf;
>  }

Add more output in /sys/firmware/efi/systab is wrong, one table address should
have one file under /sys/firmware/efi/, we have created the systab in the wrong
way but we should not continue to add things..

Thanks
Dave
