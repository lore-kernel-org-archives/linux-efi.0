From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 3/5] arm64: efi: avoid block mappings for unaligned UEFI
 memory regions
Date: Wed, 29 Jun 2016 17:45:25 +0100
Message-ID: <20160629164525.GE2522@e104818-lin.cambridge.arm.com>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
 <1467204690-10790-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467204690-10790-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 29, 2016 at 02:51:28PM +0200, Ard Biesheuvel wrote:
> +	if (!PAGE_ALIGNED(md->phys_addr) ||
> +	    !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT)) {
> +		/*
> +		 * If the end address of this region is not aligned to page
> +		 * size, the mapping is rounded up, and may end up sharing a
> +		 * page frame with the next UEFI memory region. If we create
> +		 * a block entry now, we may need to split it again when mapping
> +		 * the next region, and support for that is going to be removed
> +		 * from the MMU routines. So avoid block mappings altogether in
> +		 * that case.
> +		 */
> +		allow_block_mappings = false;
> +	}

How common is it for large areas to have unaligned start/end? I wonder
whether it's worth implementing my approach to look ahead and explicitly
check the overlap with the next section instead of disabling block
mappings altogether for this region.

-- 
Catalin
