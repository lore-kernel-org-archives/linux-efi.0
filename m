From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 3/4] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Thu, 21 Jan 2016 14:35:58 -0800
Message-ID: <20160121143558.2ae43ccf550e1693cd05834f@linux-foundation.org>
References: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453389752-68175-3-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453389752-68175-3-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 21 Jan 2016 17:22:31 +0200 Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> 
> Print the base in the best-fit B, KiB, MiB, etc. units rather than
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

hm,

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
> -		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
> +		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%s)\n",
>  			i, efi_md_typeattr_format(buf, sizeof(buf), md),
> -			md->phys_addr,
> -			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,

Where did this " - 1" come from?  I can't find a tree which has this.

> -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> +			md->phys_addr, md->phys_addr + size - 1,

So I did s/ - 1// here, but worried.

> +			efi_size_format(buf3, sizeof(buf3), size));
>  	}
>  #endif  /*  EFI_DEBUG  */
>  }
