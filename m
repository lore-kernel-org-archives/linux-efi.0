From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: page align EFI ROM image ranges
Date: Fri, 11 Aug 2017 14:54:13 +0200
Message-ID: <20170811125413.umxgpqos3vmva5cg@gmail.com>
References: <4a28637c-d5ff-95ed-5bee-2b1e465f2d79@gmail.com>
 <20170804120650.GE8187@codeblueprint.co.uk>
 <20170810144637.qpqqr5rs3lhag6av@gmail.com>
 <a215cd33-bbd2-8efa-8acf-8b504e625a46@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a215cd33-bbd2-8efa-8acf-8b504e625a46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stuart Hayes <stuart.w.hayes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Stuart Hayes <stuart.w.hayes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The kernel's EFI stub locates and copies EFI ROM images into memory, which it allocates using the byte-granular EFI allocate_pool function.  These memory ranges are then added to setup_data, and later to e820 (in e820__reserve_setup_data()).  The e820 ranges are parsed to create nosave regions (in e820__register_nosave_regions()), but when non-page-aligned e820 regions are parsed, a nosave page is added at the beginning and end of each non-page-aligned region, which results in data not getting saved or restored during a hibernate/resume.  This can result in random failures after a hibernate/resume.
>  
> Round up the allocation size to a whole number of pages, and use EFI allocate_pages to ensure that the EFI ROM copy regions are page-aligned.
> 
> On a system with six EFI ROM images, before the patch:
> 
> e820: update [mem 0x64866020-0x6486e05f] usable ==> usable
> e820: update [mem 0x6147a020-0x61499c5f] usable ==> usable
> e820: update [mem 0x60fff020-0x6105785f] usable ==> usable
> e820: update [mem 0x60fa6020-0x60ffe85f] usable ==> usable
> e820: update [mem 0x60f4d020-0x60fa585f] usable ==> usable
> e820: update [mem 0x60ef4020-0x60f4c85f] usable ==> usable
> ...
> PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
> PM: Registered nosave memory: [mem 0x60ef4000-0x60ef4fff]
> PM: Registered nosave memory: [mem 0x60f4c000-0x60f4cfff]
> PM: Registered nosave memory: [mem 0x60f4d000-0x60f4dfff]
> PM: Registered nosave memory: [mem 0x60fa5000-0x60fa5fff]
> PM: Registered nosave memory: [mem 0x60fa6000-0x60fa6fff]
> PM: Registered nosave memory: [mem 0x60ffe000-0x60ffefff]
> PM: Registered nosave memory: [mem 0x60fff000-0x60ffffff]
> PM: Registered nosave memory: [mem 0x61057000-0x61057fff]
> PM: Registered nosave memory: [mem 0x6147a000-0x6147afff]
> PM: Registered nosave memory: [mem 0x61499000-0x61499fff]
> PM: Registered nosave memory: [mem 0x64866000-0x64866fff]
> PM: Registered nosave memory: [mem 0x6486e000-0x6486efff]
> PM: Registered nosave memory: [mem 0x6cf6e000-0x6f3ccfff]
> 
> After the patch:
> 
> e820: update [mem 0x64866000-0x6486efff] usable ==> usable
> e820: update [mem 0x6147a000-0x61499fff] usable ==> usable
> e820: update [mem 0x60fff000-0x61057fff] usable ==> usable
> e820: update [mem 0x60fa6000-0x60ffefff] usable ==> usable
> e820: update [mem 0x60f4d000-0x60fa5fff] usable ==> usable
> e820: update [mem 0x60ef4000-0x60f4cfff] usable ==> usable
> ...
> PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
> PM: Registered nosave memory: [mem 0x6cf6e000-0x6f3ccfff]
> 
> Signed-off-by: Stuart Hayes <stuart.w.hayes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes in V2:
>   Update the comments in the code.
>   Add same fix to __setup_efi_pci32()
> 
> --- linux-4.13-rc2/arch/x86/boot/compressed/eboot.c.orig	2017-08-01 12:12:04.696049106 -0400
> +++ linux-4.13-rc2/arch/x86/boot/compressed/eboot.c	2017-08-07 13:00:15.165374388 -0400
> @@ -127,7 +127,13 @@ __setup_efi_pci32(efi_pci_io_protocol_32
>  
>  	size = pci->romsize + sizeof(*rom);
>  
> -	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
> +	/*
> +	 * Get whole pages because this will be added to e820, and
> +	 * e820__register_nosave_regions() expects page-aligned regions.

BTW., could we please also do a separate robustness fix to 
e820__register_nosave_regions(), which complains about regions that have bad 
alignment, and fixes them up if possible?

That way if with just the robustness fix applied we'd get the warning on your 
system - and hibernation should work - and with this second fix we'd get a silent 
bootup and a working system.

Or something like that?

Thanks,

	Ingo
