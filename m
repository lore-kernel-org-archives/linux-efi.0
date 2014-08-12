From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 3/5] efi arm64: do not enter virtual mode in case booting
 with efi=noruntime or noefi
Date: Tue, 12 Aug 2014 11:46:27 +0100
Message-ID: <20140812104627.GI29013@arm.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <1407823822-23829-3-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1407823822-23829-3-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 12, 2014 at 07:10:20AM +0100, Dave Young wrote:
> In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
> should error out.
> 
> At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
> the function or it will leak early mem.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e72f310..324cdd1 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -386,7 +386,10 @@ static int __init arm64_enter_virtual_mode(void)
>  	int count = 0;
>  	unsigned long flags;
>  
> -	if (!efi_enabled(EFI_BOOT)) {
> +	mapsize = memmap.map_end - memmap.map;
> +	early_memunmap(memmap.map, mapsize);
> +
> +	if (!efi_enabled(EFI_BOOT) || efi_runtime_disabled()) {

Hmm, is this right? We only set EFI_BOOT if we find EFI parameters in the
DT (see efi_init -> uefi_init), so you run the risk of unmapping something
we never mapped here.

Furthermore, there seems to be a leak in uefi_init anyway, as we return
-EINVAL if the signature of the EFI table doesn't match without unmapping it
first.

Will
