From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH RFC] x86 early_ioremap: increase FIX_BTMAPS_SLOTS to 8
Date: Sun, 14 Sep 2014 15:14:12 +0100
Message-ID: <20140914141412.GJ18582@console-pimps.org>
References: <20140826090641.GA16550@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140826090641.GA16550-4/PLUo9XfK+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Aug, at 05:06:41PM, Dave Young wrote:
> 3.16 kernel boot fail with earlyprintk=efi, it keeps scrolling at the
> bottom line of screen.
> 
> Bisected, the first bad commit is below:
> commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> Author: Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date:   Fri Apr 4 12:38:57 2014 +0800
> 
>     ACPICA: Tables: Fix table checksums verification before installation.

[...]

> Quote reply from Lv.zheng about the early ioremap slot usage in this case:
> 
> """
> In early_efi_scroll_up(), 2 mapping entries will be used for the src/dst screen buffer.
> In drivers/acpi/acpica/tbutils.c, we've improved the early table loading code in acpi_tb_parse_root_table().
> We now need 2 mapping entries:
> 1. One mapping entry is used for RSDT table mapping. Each RSDT entry contains an address for another ACPI table.
> 2. For each entry in RSDP, we need another mapping entry to map the table to perform necessary check/override before installing it.
> 
> When acpi_tb_parse_root_table() prints something through EFI earlyprintk console, we'll have 4 mapping entries used.
> The current 4 slots setting of early_ioremap() seems to be too small for such a use case.
> """
> 
> Thus increase the slot to 8 in this patch to fix this issue.
> boot-time mappings become 512 page with this patch.
 
This analysis and solution makes sense to me, but I was really hoping
for one of the x86 maintainers to ACK the below patch. I'm happy to take
it through the EFI tree if it's not picked up into tip meanwhile.

Also, Dave, it sounds like this should be tagged for stable if the bug
has been around since v3.16?

> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> I'm not sure if this is ok in 32bit, review and comments are appreciated.
>  arch/x86/include/asm/fixmap.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/include/asm/fixmap.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/fixmap.h
> +++ linux/arch/x86/include/asm/fixmap.h
> @@ -106,14 +106,14 @@ enum fixed_addresses {
>  	__end_of_permanent_fixed_addresses,
>  
>  	/*
> -	 * 256 temporary boot-time mappings, used by early_ioremap(),
> +	 * 512 temporary boot-time mappings, used by early_ioremap(),
>  	 * before ioremap() is functional.
>  	 *
> -	 * If necessary we round it up to the next 256 pages boundary so
> +	 * If necessary we round it up to the next 512 pages boundary so
>  	 * that we can have a single pgd entry and a single pte table:
>  	 */
>  #define NR_FIX_BTMAPS		64
> -#define FIX_BTMAPS_SLOTS	4
> +#define FIX_BTMAPS_SLOTS	8
>  #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
>  	FIX_BTMAP_END =
>  	 (__end_of_permanent_fixed_addresses ^


-- 
Matt Fleming, Intel Open Source Technology Center
