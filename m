From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi: always map first physical page into EFI
 pagetables
Date: Wed, 25 Jan 2017 21:31:53 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701252130410.25515@cbobk.fhfr.pm>
References: <alpine.LSU.2.20.1701252048550.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.20.1701252048550.25515-YHPUNQjx9ReKbouaWp301Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>, Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


[ CCing mailinglists that got eaten by my newly configured mail setup, 
  sorry for that ]

On Wed, 25 Jan 2017, Jiri Kosina wrote:

> From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> 
> Commit 129766708 ("x86/efi: Only map RAM into EFI page tables if in 
> mixed-mode") stopped creating 1:1 mapping for all RAM in case of running 
> in native 64bit mode.
> 
> It turns out though that there are 64bit EFI implementations in the wild 
> (this particular problem has been reported on Lenovo Yoga 710-11IKB) which 
> still make use of first physical page for their own private use (which is 
> what legacy BIOS used to do, but EFI specification doesn't grant any such 
> right to EFI BIOS ... oh well).
> 
> In case there is no mapping for this particular frame in EFI pagetables, 
> as soon as firmware tries to make use of it, triple fault occurs and the 
> system reboots (in case of Yoga 710-11IKB this is very early during boot).
> 
> Fix that by always mapping the first page of physical memory into EFI 
> pagetables.
> 
> Note: just reverting 129766708 is not enough on v4.9-rc1+ to fix the 
> regression on affected hardware, as commit ab72a27da ("x86/efi: 
> Consolidate region mapping logic") later made the first physical frame not 
> to be mapped anyway.
> 
> Fixes: 129766708 ("x86/efi: Only map RAM into EFI page tables if in mixed-mode")
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # v4.8+
> Cc: Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>
> Reported-by: Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>
> Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> ---
> 
> Thanks a lot to Matt for excellent hint how to debug EFI failures
> 
>  arch/x86/platform/efi/efi_64.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 319148b..02ae2ab 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -269,6 +269,17 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	efi_scratch.use_pgd = true;
>  
>  	/*
> +	 * Certain firmware versions are way too sentimental and still believe
> +	 * they are exclusive and unquestionable owners of first physical page.
> +	 * Create 1:1 mapping for this page to avoid triple faults during early
> +	 * boot with such firmware.
> +	 */
> +	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
> +		pr_err("Failed to create 1:1 mapping of first page\n");
> +		return 1;
> +	}
> +
> +	/*
>  	 * When making calls to the firmware everything needs to be 1:1
>  	 * mapped and addressable with 32-bit pointers. Map the kernel
>  	 * text and allocate a new stack because we can't rely on the
> -- 
> Jiri Kosina
> SUSE Labs
> 
> 

-- 
Jiri Kosina
SUSE Labs
