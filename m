From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in
 efi_print_memmap
Date: Tue, 2 Feb 2016 10:22:54 +0100
Message-ID: <56B0756E.9010603@redhat.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

I'll take being CC'd as "please offer an opinion", so I'll offer one. :)

On 02/01/16 23:07, Matt Fleming wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> Print the size in the best-fit B, KiB, MiB, etc. units rather than
> always MiB. This avoids rounding, which can be misleading.
> 
> Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
> decimal units (KB, MB, etc.).
> 
> old:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> 
> new:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB)
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
> Cc: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  arch/x86/platform/efi/efi.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e80826e6f3a9..2c457c5e8203 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -35,6 +35,7 @@
>  #include <linux/efi.h>
>  #include <linux/efi-bgrt.h>
>  #include <linux/export.h>
> +#include <linux/bitops.h>
>  #include <linux/bootmem.h>
>  #include <linux/slab.h>
>  #include <linux/memblock.h>
> @@ -117,6 +118,17 @@ void efi_get_time(struct timespec *now)
>  	now->tv_nsec = 0;
>  }
>  
> +static char * __init efi_size_format(char *buf, size_t size, u64 bytes)
> +{
> +	static const char *const units_2[] = {
> +		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
> +	};

Blech. Blech blech blech. As far as I'm concerned, "IEC binary units"
rewrite history. I propose to just say "KB" & friends.

Not sure if I should refer kernel list subscribers to GNU utility
manuals :), but "dd" gets it right:

       N  and  BYTES  may  be followed by the following multiplicative
       suffixes: c =1, w =2, b =512, kB =1000, K =1024, MB =1000*1000,
       M  =1024*1024, xM =M GB =1000*1000*1000, G =1024*1024*1024, and
       so on for T, P, E, Z, Y.

Anyway, feel free to ignore this.

> +	unsigned long i = bytes ? __ffs64(bytes) / 10 : 0;
> +
> +	snprintf(buf, size, "%llu %s", bytes >> (i * 10), units_2[i]);
> +	return buf;
> +}

The calculation seems correct, and I agree "bytes" should have type
"u64" -- this makes it clearer why we don't have to climb higher than
offset 6 (count 7) in "units".

However, since we're printing the result of the right shift with the
%llu conversion specifier, I believe I'd appreciate either an explicit
((unsigned long long)bytes) >> ... cast there, or a macro for the
conversion specifier. (In userland I'd write "%"PRIu64, but I don't know
if the kernel has anything like that.)

> +
>  void __init efi_find_mirror(void)
>  {
>  	void *p;
> @@ -225,21 +237,20 @@ int __init efi_memblock_x86_reserve_range(void)
>  void __init efi_print_memmap(void)
>  {
>  #ifdef EFI_DEBUG
> -	efi_memory_desc_t *md;
>  	void *p;
>  	int i;
>  
>  	for (p = memmap.map, i = 0;
>  	     p < memmap.map_end;
>  	     p += memmap.desc_size, i++) {
> -		char buf[64];
> +		efi_memory_desc_t *md = p;
> +		u64 size = md->num_pages << PAGE_SHIFT;
> +		char buf[64], buf2[64];
>  
> -		md = p;
> -		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
> +		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%s)\n",
>  			i, efi_md_typeattr_format(buf, sizeof(buf), md),
> -			md->phys_addr,
> -			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
> -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> +			md->phys_addr, md->phys_addr + size - 1,
> +			efi_size_format(buf2, sizeof(buf2), size));
>  	}
>  #endif  /*  EFI_DEBUG  */
>  }
> 

Hm, apparently %llx is used to print u64 here as well. Did I write this
code? :) Is %ll used interchangeably with 64-bits?

Also, I notice there's room for unification with ia64 code. In
"arch/ia64/kernel/efi.c", the efi_init() function open-codes a similar
suffix conversion -- notice it says KB and friends! :)

So maybe the efi_size_format() helper could go into
"drivers/firmware/efi/efi.c", near its friend efi_md_typeattr_format().

Furthermore, the ia64 source has a macro efi_md_size(). Perhaps it can
be moved to a common header and used here as well. Not too important.

... Ultimately, my only semi-important point here is that
efi_size_format() should go into common EFI driver code, and be
(optionally) used on ia64 as well.

Thanks
Laszlo
