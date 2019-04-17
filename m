From: Ingo Molnar <mingo@kernel.org>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Date: Wed, 17 Apr 2019 18:37:29 +0200
Message-ID: <20190417163729.GA53511@gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com>
 <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
 <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
 <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: Daniel Drake <drake@endlessm.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jian-Hong Pan <jian-hong@endlessm.com>, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>, linux-tip-commits@vger.kernel.org, Endless Linux Upstreaming Team <linux@endlessm.com>
List-Id: linux-efi@vger.kernel.org


* hpa@zytor.com <hpa@zytor.com> wrote:

> > Just to check, you mean: EFI reboot (and shutdown) become the default
> > methods when the machine is booted in EFI mode, and EFI stuff has not
> > been disabled with a kernel parameter?
> > Even when running in full hardware ACPI mode.

No, I still think "early" EFI is historically better with ACPI reboot.

But can we find a firmware flag perhaps that will *not* result in EFI 
reboot being turned off?

> This, I believe, is known to not work.

Yeah, I bet so.

My problem is that the code appears to have the wrong assumptions:

 /*
  * For most modern platforms the preferred method of powering off is via
  * ACPI. However, there are some that are known to require the use of
  * EFI runtime services and for which ACPI does not work at all.
  *
  * Using EFI is a last resort, to be used only if no other option
  * exists.
  */
 bool efi_reboot_required(void)
 {
         if (!acpi_gbl_reduced_hardware)
                 return false;

         efi_reboot_quirk_mode = EFI_RESET_WARM;
         return true;
 }


At minimum the comment is stale: "modern" platforms, *especially* when 
the only bootup method is EFI, as in the ACER laptop case, I think the 
preferred reboot method is absolutely an EFI reboot - and it's probably 
what Windows uses too.

The question is, is acpi_gbl_reduced_hardware false on the Acer 
TravelMate X514-51T? I think it has to be, for the quirk to make sense - 
if it's true then efi_reboot_required() would set the reboot method to 
EFI.

I.e. we seem to have a new category of systems that are advertising 
themselves as 'full ACPI compliant', which are NOT old EFI systems, but 
modern EFI systems.

Is there some good way to detect these - such as ACPI version or 
something?

Thanks,

	Ingo
