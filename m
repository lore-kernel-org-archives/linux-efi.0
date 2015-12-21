From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 1/4] x86/efi: show actual ending addresses in
 efi_print_memmap
Date: Mon, 21 Dec 2015 16:44:19 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEC3C9C@G9W0745.americas.hpqcorp.net>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-2-git-send-email-elliott@hpe.com>
 <20151221155038.GD4227@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151221155038.GD4227@codeblueprint.co.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt@codeblueprint.co.uk]
> Sent: Monday, December 21, 2015 9:51 AM
> To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/4] x86/efi: show actual ending addresses in
> efi_print_memmap
> 
> On Thu, 17 Dec, at 07:28:31PM, Robert Elliott wrote:
> > Adjust efi_print_memmap to print the real end address of each
> > range, not 1 byte beyond. This matches other prints like those for
> > SRAT and nosave memory.
> >
> > Change the closing ) to ] to match the opening [.
> >
> > old:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC]
> range=[0x0000000880000000-0x0000000c80000000) (16384MB)
> >
> > new:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC]
> range=[0x0000000880000000-0x0000000c7fffffff] (16384MB)
> >
> > Example other address range prints:
> >     SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
> >     PM: Registered nosave memory: [mem 0x880000000-0xc7fffffff]
> >
> > Signed-off-by: Robert Elliott <elliott@hpe.com>
> > ---
> >  arch/x86/platform/efi/efi.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Is this change purely for aesthetic reasons? We're usually not in the
> habit of changing the output of print messages without a good reason
> because people downstream do rely on them being consistent.

The format of that line is architecture-specific and only appears
under the efi=debug kernel parameter, so I don't know how much
anyone relies on the specific format.  Good question for the lists.

arch/ia64/kernel/efi.c shares the range=[...) format, but prints
the range after the bitmask rather than before:
	printk("mem%02d: %s "
		"range=[0x%016lx-0x%016lx) (%4lu%s)\n",
		i, efi_md_typeattr_format(buf, sizeof(buf), md),
		md->phys_addr,
		md->phys_addr + efi_md_size(md), size, unit);

arch/arm64/kernel/efi.c has no mem prefix, or range=[...) text
surrounding the range:
	pr_info("  0x%012llx-0x%012llx %s",
		paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
		efi_md_typeattr_format(buf, sizeof(buf), md));
	pr_cont("*");
	pr_cont("\n");

The x86 code is inside ifdef EFI_DEBUG, which is always
defined in that file.  I wonder if it was supposed to change
to efi_enabled(EFI_DBG) to be based off the efi=debug kernel
parameter?  efi_init() qualified the call to this function
based on that:
        if (efi_enabled(EFI_DBG))
                efi_print_memmap();

In arch/ia64/kernel/efi.c efi_init(), EFI_DEBUG is set to 0
so the print doesn't happen at all without editing the
source code.  It doesn't use efi_enabled(EFI_DBG).

arch/arm64/kernel/efi.c uses efi_enabled(EFI_DBG) exclusively.

---
Robert Elliott, HPE Persistent Memory
