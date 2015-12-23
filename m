From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/4] x86/efi: show actual ending addresses in
 efi_print_memmap
Date: Wed, 23 Dec 2015 12:47:11 +0000
Message-ID: <20151223124711.GB2471@codeblueprint.co.uk>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-2-git-send-email-elliott@hpe.com>
 <20151221155038.GD4227@codeblueprint.co.uk>
 <94D0CD8314A33A4D9D801C0FE68B40295BEC3C9C@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEC3C9C-W1gbDvblbosSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 21 Dec, at 04:44:19PM, Elliott, Robert (Persistent Memory) wrote:
> 
> The format of that line is architecture-specific and only appears
> under the efi=debug kernel parameter, so I don't know how much
> anyone relies on the specific format.  Good question for the lists.
 
Both kernel and non-kernel developers are consumers of these debug
statements, and people do come to rely on the format of the text.

I have certainly become acustomed to the current format we have,
particularly when debugging issues via other users, i.e. when I'm not
the person running the kernel being debugged.

Just because it's a debug option doesn't mean it's completely open to
modification. Reasonable Justification must be provided. Having said
that, I think you provide a good argument in your other email,

  https://lkml.kernel.org/r/94D0CD8314A33A4D9D801C0FE68B40295BEC74CF-W1gbDvblbosSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org

> arch/ia64/kernel/efi.c shares the range=[...) format, but prints
> the range after the bitmask rather than before:
> 	printk("mem%02d: %s "
> 		"range=[0x%016lx-0x%016lx) (%4lu%s)\n",
> 		i, efi_md_typeattr_format(buf, sizeof(buf), md),
> 		md->phys_addr,
> 		md->phys_addr + efi_md_size(md), size, unit);
> 
> arch/arm64/kernel/efi.c has no mem prefix, or range=[...) text
> surrounding the range:
> 	pr_info("  0x%012llx-0x%012llx %s",
> 		paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
> 		efi_md_typeattr_format(buf, sizeof(buf), md));
> 	pr_cont("*");
> 	pr_cont("\n");
> 
> The x86 code is inside ifdef EFI_DEBUG, which is always
> defined in that file.  I wonder if it was supposed to change
> to efi_enabled(EFI_DBG) to be based off the efi=debug kernel
> parameter?  efi_init() qualified the call to this function
> based on that:
>         if (efi_enabled(EFI_DBG))
>                 efi_print_memmap();
 
The EFI_DEBUG symbol should just be deleted. It's been enabled since
forever and really provides no value, because as you point out,
printing of the memory map is guarded by EFI_DBG anyway.

I'll send out a patch for ripping that out.

> In arch/ia64/kernel/efi.c efi_init(), EFI_DEBUG is set to 0
> so the print doesn't happen at all without editing the
> source code.  It doesn't use efi_enabled(EFI_DBG).
> 
> arch/arm64/kernel/efi.c uses efi_enabled(EFI_DBG) exclusively.
