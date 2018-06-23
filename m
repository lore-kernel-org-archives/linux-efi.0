From: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
Subject: Re: [PATCH] make radeon driver find ATOM BIOS again on 64-bit EFI
 systems
Date: Sat, 23 Jun 2018 21:18:28 +0200
Message-ID: <20180623191828.i7hrhgebiwcn6nh7@chaos.in-kiel.de>
References: <20180623174258.GA15904@chaos.in-kiel.de>
 <CAKv+Gu8yA1L6P=W70gm1u_uuF9xJ+XVWeWB0MxC3Fur=_DeVmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8yA1L6P=W70gm1u_uuF9xJ+XVWeWB0MxC3Fur=_DeVmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-efi@vger.kernel.org

Am Sat, Jun 23, 2018 at 08:09:19PM +0200 schrieb Ard Biesheuvel:
> (+ Hans, who may be able to test this on 32-bit h/w)
> 
> On 23 June 2018 at 19:43, Wilfried Klaebe
> <linux-kernel@lebenslange-mailadresse.de> wrote:
> > make radeon driver find ATOM BIOS again on 64-bit EFI systems
> >
> > Commit 2c3625cb9fa2c477d5877a1819e29d6a902e5fef ("efi/x86: Fold
> > __setup_efi_pci32() and __setup_efi_pci64() into one function")
> > broke finding radeon's BIOS ROM on Apple MacBook Pro 8,2. Fix.
> >
> >
> > On my Apple MacBook Pro 8,2, Linux 4.18-rc1 was unable to locate a BIOS
> > ROM for the radeon GPU. Comparing Linux 4.17 and 4.18-rc1 dmesg:
> >
> >  radeon 0000:01:00.0: Invalid PCI ROM header signature: expecting 0xaa55, got 0x0000
> >  radeon 0000:01:00.0: Invalid PCI ROM header signature: expecting 0xaa55, got 0x0000
> > -ATOM BIOS: Apple
> > +[drm:radeon_get_bios [radeon]] *ERROR* Unable to locate a BIOS ROM
> >
> > Bisecting found 2c3625cb9fa2c477d5877a1819e29d6a902e5fef.
> >
> > Comparing the old __setup_efi_pci32 and __setup_efi_pci64, and looking
> > at what the new __setup_efi_pci does, I noticed that the first does
> >
> >         status = efi_early->call(pci->attributes, pci,
> >                                  EfiPciIoAttributeOperationGet, 0, 0,
> >                                  &attributes);
> >
> > while the second does
> >
> >         status = efi_early->call(pci->attributes, pci,
> >                                  EfiPciIoAttributeOperationGet, 0,
> >                                  &attributes);
> >
> > (note the difference of one "0, "), while the third has two occurences
> > of "0, " too in it's EfiPciIoAttributeOperationGet call construct.
> >
> > Testing confirmed my machine works as expected with the variant with
> > just one "0, "; I cannot test if this is true for other 64-bit EFI
> > machines or maybe even 32-bit EFI machines.
> >
> >
> > Signed-off-by: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
> > Fixes: 2c3625cb9fa2 ("efi/x86: Fold __setup_efi_pci32() and __setup_efi_pci64() into one function")
> >
> 
> Hello Wilfried,
> 
> Thanks for tracking down this issue.
> 
> It seems the two 0s in the 32-bit version are there because the type
> of the argument is UINT64. So instead, I'd like to apply this change:
> 
> >         void *romimage;
> >
> >         status = efi_call_proto(efi_pci_io_protocol, attributes, pci,
> > -                               EfiPciIoAttributeOperationGet, 0, 0,
> > +                               EfiPciIoAttributeOperationGet, 0ULL,
> >                                 &attributes);
> >         if (status != EFI_SUCCESS)
> >
> 
> unless anyone objects?

Just compiled and booted that: works too. I therefore won't object.

Tested-by: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>

Regards,
Wilfried
