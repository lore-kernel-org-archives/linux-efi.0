From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 7/8] arm64/efi: remove free_boot_services() and friends
Date: Fri, 9 Jan 2015 15:49:24 +0000
Message-ID: <20150109154924.GH11258@arm.com>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
 <1420742914-2404-8-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420742914-2404-8-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 08, 2015 at 06:48:33PM +0000, Ard Biesheuvel wrote:
> Now that we are calling SetVirtualAddressMap() from the stub, there is no
> need to reserve boot-only memory regions, which implies that there is also
> no reason to free them again later.
> 
> Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 123 +-----------------------------------------------
>  1 file changed, 1 insertion(+), 122 deletions(-)

[...]

> -static void __init free_boot_services(void)
> -{
> -	u64 total_freed = 0;
> -	u64 keep_end, free_start, free_end;
> -	efi_memory_desc_t *md;
> -
> -	/*
> -	 * If kernel uses larger pages than UEFI, we have to be careful
> -	 * not to inadvertantly free memory we want to keep if there is
> -	 * overlap at the kernel page size alignment. We do not want to
> -	 * free is_reserve_region() memory nor the UEFI memmap itself.
> -	 *
> -	 * The memory map is sorted, so we keep track of the end of
> -	 * any previous region we want to keep, remember any region
> -	 * we want to free and defer freeing it until we encounter
> -	 * the next region we want to keep. This way, before freeing
> -	 * it, we can clip it as needed to avoid freeing memory we
> -	 * want to keep for UEFI.
> -	 */
> -
> -	keep_end = 0;
> -	free_start = 0;
> -
> -	for_each_efi_memory_desc(&memmap, md) {
> -		u64 paddr, npages, size;

I'm glad to see the back of this function, thanks.

Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>

Will
