From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: dmi: List SMBIOS3 table before SMBIOS table
Date: Thu, 30 Apr 2015 11:30:06 +0100
Message-ID: <20150430103006.GA3014@codeblueprint.co.uk>
References: <20150428093012.4c859240@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150428093012.4c859240-R0o5gVi9kd7kN2dkZ6Wm7A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 Apr, at 09:30:12AM, Jean Delvare wrote:
> The SMBIOS3 table should appear before the SMBIOS table in
> /sys/firmware/efi/systab. This allows user-space utilities which
> support both to pick the SMBIOS3 table with a single pass on systems
> where both are implemented. The SMBIOS3 entry point is more capable
> than the SMBIOS entry point so it should be preferred.
> 
> This follows the same logic as the ACPI20 table being listed before
> the ACPI table.
 
Now we need to ask the reverse question: Do any userspace utils use the
last SMBIOS table entry as the preferred one? I suspect not because
SMBIOS3 is so new but we need to highlight the risk of breaking
functionality since this file forms an ABI.

Anyone aware of such a tool?

Also Jean, this patch could do with a new comment describing the
importance of the table entry order so we don't break it in the future.

> Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-4.1-rc1.orig/drivers/firmware/efi/efi.c	2015-04-27 02:59:10.000000000 +0200
> +++ linux-4.1-rc1/drivers/firmware/efi/efi.c	2015-04-28 09:19:20.910416344 +0200
> @@ -85,10 +85,10 @@ static ssize_t systab_show(struct kobjec
>  		str += sprintf(str, "ACPI20=0x%lx\n", efi.acpi20);
>  	if (efi.acpi != EFI_INVALID_TABLE_ADDR)
>  		str += sprintf(str, "ACPI=0x%lx\n", efi.acpi);
> -	if (efi.smbios != EFI_INVALID_TABLE_ADDR)
> -		str += sprintf(str, "SMBIOS=0x%lx\n", efi.smbios);
>  	if (efi.smbios3 != EFI_INVALID_TABLE_ADDR)
>  		str += sprintf(str, "SMBIOS3=0x%lx\n", efi.smbios3);
> +	if (efi.smbios != EFI_INVALID_TABLE_ADDR)
> +		str += sprintf(str, "SMBIOS=0x%lx\n", efi.smbios);
>  	if (efi.hcdp != EFI_INVALID_TABLE_ADDR)
>  		str += sprintf(str, "HCDP=0x%lx\n", efi.hcdp);
>  	if (efi.boot_info != EFI_INVALID_TABLE_ADDR)
> 
> 
> -- 
> Jean Delvare
> SUSE L3 Support
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matt Fleming, Intel Open Source Technology Center
