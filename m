From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4 05/12] efi: export more efi table variable to sysfs
Date: Tue, 26 Nov 2013 15:57:31 +0000
Message-ID: <20131126155731.GM11521@console-pimps.org>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-6-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385445477-9665-6-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Nov, at 01:57:50PM, Dave Young wrote:
> Export fw_vendor, runtime and config tables physical
> addresses to /sys/firmware/efi/systab becaue kexec
> kernel will need them.
 
This commit log needs updating.

> From EFI spec these 3 variables will be updated to
> virtual address after entering virtual mode. But
> kernel startup code will need the physical address.
> 
> changelog:
> Greg: add standalone sysfs files instead of add lines to systab
> Document them as testing ABI
> Greg: use group attrs and is_visible
> Boris: align comments lines
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-firmware-efi | 26 ++++++++++++++++
>  arch/x86/platform/efi/efi.c                  |  4 +++
>  drivers/firmware/efi/efi.c                   | 44 ++++++++++++++++++++++++++++
>  include/linux/efi.h                          |  3 ++
>  4 files changed, 77 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
> new file mode 100644
> index 0000000..9252a24
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi
> @@ -0,0 +1,26 @@
> +What:		/sys/firmware/efi/fw_vendor
> +Date:		Nov 2013
> +Contact:	Dave Young <dyoung-8RVElS0ezzQdnm+yROfE0A@public.gmane.org>

redhat.org eh? Typo or legit?

> +Description:
> +		Shows the physical address of firmware vendor in the EFI
> +		system table.

It shows the physical address of the firmware vendor "entry" or "field"
in the EFI system table.

> +Users:
> +		Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

The "Kexec mailing list" isn't a user, kexec is.

-- 
Matt Fleming, Intel Open Source Technology Center
