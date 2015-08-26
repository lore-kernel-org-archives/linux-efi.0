From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/5] arm64: clone early_init_dt_add_memory_arch() to
 override default
Date: Wed, 26 Aug 2015 15:43:25 +0100
Message-ID: <20150826144325.GA10728@bivouac.eciton.net>
References: <1440576391-25725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1440576391-25725-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440576391-25725-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leo.yan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 26, 2015 at 10:06:27AM +0200, Ard Biesheuvel wrote:
> Override the __weak early_init_dt_add_memory_arch() with our own
> version. We need this in a subsequent patch to make the handling of
> the memory nodes conditional on whether we are booting via UEFI or
> not.

Worth clarifying that this is a direct copy?
("Our own version" can be read as there being modifications here.)

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/mm/init.c | 41 ++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index f5c0680d17d9..ab25fde7397c 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -374,3 +374,44 @@ static int __init keepinitrd_setup(char *__unused)
>  
>  __setup("keepinitrd", keepinitrd_setup);
>  #endif
> +
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +	const u64 phys_offset = __pa(PAGE_OFFSET);
> +
> +	if (!PAGE_ALIGNED(base)) {
> +		if (size < PAGE_SIZE - (base & ~PAGE_MASK)) {
> +			pr_warn("Ignoring memory block 0x%llx - 0x%llx\n",
> +				base, base + size);
> +			return;
> +		}
> +		size -= PAGE_SIZE - (base & ~PAGE_MASK);
> +		base = PAGE_ALIGN(base);
> +	}
> +	size &= PAGE_MASK;
> +
> +	if (base > MAX_MEMBLOCK_ADDR) {
> +		pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
> +				base, base + size);
> +		return;
> +	}
> +
> +	if (base + size - 1 > MAX_MEMBLOCK_ADDR) {
> +		pr_warning("Ignoring memory range 0x%llx - 0x%llx\n",
> +				((u64)MAX_MEMBLOCK_ADDR) + 1, base + size);
> +		size = MAX_MEMBLOCK_ADDR - base + 1;
> +	}
> +
> +	if (base + size < phys_offset) {
> +		pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
> +			   base, base + size);
> +		return;
> +	}
> +	if (base < phys_offset) {
> +		pr_warning("Ignoring memory range 0x%llx - 0x%llx\n",
> +			   base, phys_offset);
> +		size -= phys_offset - base;
> +		base = phys_offset;
> +	}
> +	memblock_add(base, size);
> +}
> -- 
> 1.9.1

Would it be too crazy to do this via an added call to a weak
memblock_use_dt() function in the original instead, to avoid
duplicating this entire function?

We need the functionality for 4/5 (nice cleanup) and 5/5 (bugfix), so
happy with whatever works.

/
    Leif
