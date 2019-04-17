From: Ingo Molnar <mingo@kernel.org>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Date: Wed, 17 Apr 2019 08:16:50 +0200
Message-ID: <20190417061650.GA31060@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Drake <drake@endlessm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jian-Hong Pan <jian-hong@endlessm.com>, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, hpa@zytor.com, linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>, linux-tip-commits@vger.kernel.org, Endless Linux Upstreaming Team <linux@endlessm.com>
List-Id: linux-efi@vger.kernel.org


* Daniel Drake <drake@endlessm.com> wrote:

> On Tue, Apr 16, 2019 at 4:20 PM Ingo Molnar <mingo@kernel.org> wrote:
> > I wanted to get a second opinion from the EFI folks for this whole
> > concept. On x86 we default to ACPI reboot on modern systems, and we
> > default to EFI reboot on modern EFI systems, via the
> > efi_reboot_required() method which keys off on acpi_gbl_reduced_hardware
> > to create a barrier for older ACPI systems.
> 
> So if acpi_gbl_reduced_hardware is set, we are on a "modern EFI
> system", and EFI reboot is used.
> 
> > It appears that Acer TravelMate X514-51T systems get marked as
> > 'acpi_gbl_reduced_hardware' which enables ACPI-reboot, but they require
> > EFI-reboot.
> 
> We will double check, but in this case I believe the system is *not*
> marked as reduced hardware, which is why ACPI reboot is used.

Ok, so acpi_gbl_reduced_hardware is set when the ... 'reduced hardware' 
bit is set:

        acpi_gbl_reduced_hardware = FALSE;
        if (acpi_gbl_FADT.flags & ACPI_FADT_HW_REDUCED) {
                acpi_gbl_reduced_hardware = TRUE;
        }


which is described as:

 #define ACPI_FADT_HW_REDUCED        (1<<20)     /* 20: [V5] ACPI hardware is not implemented (ACPI 5.0) */

That seems counter-intuitive to me: if no full ACPI hardware is 
implemented then we should assume reduced ACPI functionality, i.e. if the 
EFI runtime is otherwise available we should default to it.

> > Should we perhaps re-think the boundary between EFI-reboot and
> > ACPI-reboot systems? I.e. if the EFI runtime is enabled, shouldn't we
> > just use the EFI reboot method?
> 
> I agree this is a good question.
> 
> We also previously hit a similar issue for shutdown on Acer laptops
> which is still unresolved.
> https://marc.info/?l=linux-acpi&m=148857214431346&w=2

Yeah.

Feel free to send a patch that makes EFI reboot the default one under 
these circumstances, we could put it into tip:x86/platform or so, and let 
it get tested for another kernel cycle. If it's problem-free we could 
push that upstream. (Famous last words.)

(This won't affect the ACER notebook quirk in tip:x86/urgent, which is 
the short-term solution and the -stable tag.)

Thanks,

	Ingo
