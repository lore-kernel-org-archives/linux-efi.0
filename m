From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Sat, 23 Jan 2016 08:44:05 -0800
Message-ID: <1453567445.2470.24.camel@HansenPartnership.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453560913-134672-4-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2016-01-23 at 16:55 +0200, Andy Shevchenko wrote:
> From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> 
> Print the size in the best-fit B, KiB, MiB, etc. units rather than
> always MiB. This avoids rounding, which can be misleading.
> 
> Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
> decimal units (KB, MB, etc.).
> 
> old:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |  
>  |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff)
> (16384MB)
> 
> new:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |  
>  |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB)
> 
> Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c
> b/arch/x86/platform/efi/efi.c
> index e0846b5..3badc8a 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -35,10 +35,12 @@
>  #include <linux/efi.h>
>  #include <linux/efi-bgrt.h>
>  #include <linux/export.h>
> +#include <linux/bitops.h>
>  #include <linux/bootmem.h>
>  #include <linux/slab.h>
>  #include <linux/memblock.h>
>  #include <linux/spinlock.h>
> +#include <linux/string_helpers.h>
>  #include <linux/uaccess.h>
>  #include <linux/time.h>
>  #include <linux/io.h>
> @@ -117,6 +119,14 @@ void efi_get_time(struct timespec *now)
>  	now->tv_nsec = 0;
>  }
>  
> +static char * __init efi_size_format(char *buf, size_t size, u64
> bytes)
> +{
> +	unsigned long i = bytes ? __ffs64(bytes) / 10 : 0;

What if size is zero, which might happen on a UEFI screw up?  Also it
gives really odd results for non power of two memory sizes. 16384MB
prints as 16GiB but 16385 prints as 16385MiB.

If the goal is to have a clean interface reporting only the first four
significant figures and a size exponent, then a helper would be much
better than trying to open code this ad hoc.

Not an attack on you patch per-se, but I really hate the IEC convention
that was essentially a ploy by disk manufacturers to inflate their disk
sizes by 10% simply by relabelling them.  Everyone was happy when a GB
was 2^30, now everyone's simply confused whenever they see GB.  We had
to pander to this in block devices because people got annoyed when we
reported a size that was different from the label but are you sure we
have to extend the madness to memory?

James


> +	snprintf(buf, size, "%llu %s", bytes >> (i * 10),
> string_units_2[i]);
>
> +	return buf;
> +}
> +
>  void __init efi_find_mirror(void)
>  {
>  	void *p;
> @@ -225,21 +235,20 @@ int __init efi_memblock_x86_reserve_range(void)
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
> +		u64 size = md->num_pages << EFI_PAGE_SHIFT;
> +		char buf[64], buf3[32];
>  
> -		md = p;
> -		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx]
> (%lluMB)\n",
> +		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx]
> (%s)\n",
>  			i, efi_md_typeattr_format(buf, sizeof(buf),
> md),
> -			md->phys_addr,
> -			md->phys_addr + (md->num_pages <<
> EFI_PAGE_SHIFT) - 1,
> -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> +			md->phys_addr, md->phys_addr + size - 1,
> +			efi_size_format(buf3, sizeof(buf3), size));
>  	}
>  #endif  /*  EFI_DEBUG  */
>  }
