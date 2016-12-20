From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3] efi: prune invalid memory map entries
Date: Tue, 20 Dec 2016 12:53:45 +0000
Message-ID: <20161220125345.GC2225@codeblueprint.co.uk>
References: <1481624710-20892-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481624710-20892-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 13 Dec, at 10:25:10AM, Ard Biesheuvel wrote:
> From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Some machines, such as the Lenovo ThinkPad W541 with firmware GNET80WW
> (2.28), include memory map entries with phys_addr=0x0 and num_pages=0.
> 
> Currently the log output for this case (with efi=debug) looks like:
> 
> [    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |  |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> 
> This is clearly wrong, and also not as informative as it could be.  This
> patch changes it so that if we find obviously invalid memory map
> entries, we print an error and those entries.  It also detects the
> display of the address range calculation overflow, so the new output is:
> 
> [    0.000000] efi: [Firmware Bug]: Invalid EFI memory map entries:
> [    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000] (invalid)
> 
> It also detects memory map sizes that would overflow the physical
> address, for example phys_addr=0xfffffffffffff000 and
> num_pages=0x0200000000000001, and prints:
> 
> [    0.000000] efi: [Firmware Bug]: Invalid EFI memory map entries:
> [    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[phys_addr=0xfffffffffffff000-0x20ffffffffffffffff] (invalid)
> 
> It then removes these entries from the memory map.
> 
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> [ardb: refactor for clarity with no functional changes, avoid PAGE_SHIFT]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> I took the liberty of refactoring the code because I found it difficult
> to understand. No functional changes are intended, although I couldn't
> figure out if the memcpy() in the original code is (a) correct, and (b)
> attempts to copy multiple entries at once.
> 
> Also, pr_warn sounds more appropriate for complaining about broken firmware,
> but perhaps this is archite-cultural thing as well.
> 
>  arch/x86/platform/efi/efi.c | 70 ++++++++++++++++++++
>  include/linux/efi.h         |  1 +
>  2 files changed, 71 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index bf99aa7005eb..0a1550b82beb 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -210,6 +210,74 @@ int __init efi_memblock_x86_reserve_range(void)
>  	return 0;
>  }
>  
> +#define OVERFLOW_ADDR_SHIFT	(64 - EFI_PAGE_SHIFT)
> +#define OVERFLOW_ADDR_MASK	(U64_MAX << OVERFLOW_ADDR_SHIFT)
> +#define U64_HIGH_BIT		(~(U64_MAX >> 1))
> +
> +static bool __init efi_memmap_entry_valid(const efi_memory_desc_t *md, int i)
> +{
> +	static __initdata bool once = true;
> +	u64 end = (md->num_pages << EFI_PAGE_SHIFT) + md->phys_addr - 1;
> +	u64 end_hi = 0;
> +	char buf[64];
> +
> +	if (md->num_pages == 0) {
> +		end = 0;
> +	} else if (md->num_pages > EFI_PAGES_MAX ||
> +		   EFI_PAGES_MAX - md->num_pages <
> +		   (md->phys_addr >> EFI_PAGE_SHIFT)) {
> +		end_hi = (md->num_pages & OVERFLOW_ADDR_MASK)
> +			>> OVERFLOW_ADDR_SHIFT;
> +
> +		if ((md->phys_addr & U64_HIGH_BIT) && !(end & U64_HIGH_BIT))
> +			end_hi += 1;
> +	} else {
> +		return true;
> +	}
> +
> +	if (once) {
> +		pr_warn(FW_BUG "Invalid EFI memory map entries:\n");
> +		once = false;
> +	}

Maybe use pr_warn_once() here instead of rolling your own 'once' flag?

Otherwise this looks fine to me.
