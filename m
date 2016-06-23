From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64:acpi Fix the acpi alignment exeception when
 'mem=' specified
Date: Thu, 23 Jun 2016 13:42:30 +0100
Message-ID: <20160623124229.GD8836@leverpostej>
References: <1466681415-8058-1-git-send-email-dennis.chen@arm.com>
 <1466681415-8058-2-git-send-email-dennis.chen@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466681415-8058-2-git-send-email-dennis.chen-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, nd-5wv7dgnIgG8@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 23, 2016 at 07:30:15PM +0800, Dennis Chen wrote:
> This is a rework patch based on [1]. According to the proposal from
> Mark Rutland, when applying the system memory limit through 'mem=x'
> kernel command line, don't remove the rest memory regions above the
> limit from the memblock, instead marking them as MEMBLOCK_NOMAP region,
> which will preserve the ability to identify regions as normal memory
> while not using them for allocation and the linear map.
> 
> Without this patch, the ACPI core will map those acpi data regions(if
> they are above the limit) as device type memory, which will result in
> the alignment exception when ACPI core parses the AML data stream 
> since the parsing will produce some non-alignment accesses.
>
> [1]:http://lists.infradead.org/pipermail/linux-arm-kernel/2016-June/438443.html

Please rewrite the message to be standalone (i.e. so peopel can read
this without having to folow the link).

Explain why using mem= makes ACPI think regions should be mapped as
Device memory, the problems this causes for ACPICA, then cover why we
want to nomap the region.

> Signed-off-by: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Cc: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/arm64/mm/init.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index d45f862..e509e24 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -222,12 +222,14 @@ void __init arm64_memblock_init(void)
>  
>  	/*
>  	 * Apply the memory limit if it was set. Since the kernel may be loaded
> -	 * high up in memory, add back the kernel region that must be accessible
> -	 * via the linear mapping.
> +	 * in the memory regions above the limit, so we need to clear the
> +	 * MEMBLOCK_NOMAP flag of this region to make it can be accessible via
> +	 * the linear mapping.
>  	 */
>  	if (memory_limit != (phys_addr_t)ULLONG_MAX) {
> -		memblock_enforce_memory_limit(memory_limit);
> -		memblock_add(__pa(_text), (u64)(_end - _text));
> +		memblock_mem_limit_mark_nomap(memory_limit);
> +		if (!memblock_is_map_memory(__pa(_text)))
> +			memblock_clear_nomap(__pa(_text), (u64)(_end - _text));

I think that the memblock_is_map_memory() check should go. Just because
a page of the kernel image is mapped doesn't mean that the rest is. That
will make this a 1-1 change.

Other than that, this looks right to me.

Thanks,
Mark.

>  	}
>  
>  	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && initrd_start) {
> -- 
> 1.8.3.1
> 
