From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] dmi: add support for SMBIOS 3.0 64-bit entry point
Date: Tue, 14 Oct 2014 11:59:51 +0100
Message-ID: <20141014105951.GE22224@bivouac.eciton.net>
References: <1413208113-16374-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413208113-16374-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 13, 2014 at 03:48:33PM +0200, Ard Biesheuvel wrote:
> Version 3.0 of the DTMF SMBIOS reference spec defines a new entry point
> type that supports a 64-bit address for the SMBIOS structure table. This
> is needed by platforms whose system RAM resides above the 4 GB physical
> address boundary, such as upcoming 64-bit ARM platforms.
> 
> This is a preliminary RFC implementation, as there is no definition available
> yet for SMBIOS3_TABLE_GUID, which the (currently still in draft) SMBIOS v3.0
> spec refers to.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  				goto out;
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 8590099ac148..9035c1b74d58 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -30,6 +30,7 @@ struct efi __read_mostly efi = {
>  	.acpi       = EFI_INVALID_TABLE_ADDR,
>  	.acpi20     = EFI_INVALID_TABLE_ADDR,
>  	.smbios     = EFI_INVALID_TABLE_ADDR,
> +	.smbios3    = EFI_INVALID_TABLE_ADDR,

Is there any particular need to add a separate pointer for v3?
In both cases, the pointer is a physical address stored as an unsigned
long.

/
    Leif
