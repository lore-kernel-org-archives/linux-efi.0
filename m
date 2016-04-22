From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 2/6] arm64: ptdump: add region marker for kasan shadow
 region
Date: Fri, 22 Apr 2016 18:09:32 +0100
Message-ID: <20160422170932.GU10606@leverpostej>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
 <1461343688-8552-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461343688-8552-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 22, 2016 at 06:48:04PM +0200, Ard Biesheuvel wrote:
> Annotate the KASAN shadow region with boundary markers, so that its
> mappings stand out in the page table dumper output.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

Mark.

> ---
>  arch/arm64/mm/dump.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
> index 493461159462..8404190fe2bd 100644
> --- a/arch/arm64/mm/dump.c
> +++ b/arch/arm64/mm/dump.c
> @@ -23,6 +23,7 @@
>  #include <linux/seq_file.h>
>  
>  #include <asm/fixmap.h>
> +#include <asm/kasan.h>
>  #include <asm/memory.h>
>  #include <asm/pgtable.h>
>  #include <asm/pgtable-hwdef.h>
> @@ -33,6 +34,10 @@ struct addr_marker {
>  };
>  
>  static const struct addr_marker address_markers[] = {
> +#ifdef CONFIG_KASAN
> +	{ KASAN_SHADOW_START,		"Kasan shadow start" },
> +	{ KASAN_SHADOW_END,		"Kasan shadow end" },
> +#endif
>  	{ MODULES_VADDR,		"Modules start" },
>  	{ MODULES_END,			"Modules end" },
>  	{ VMALLOC_START,		"vmalloc() Area" },
> -- 
> 2.7.4
> 
