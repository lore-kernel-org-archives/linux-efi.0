From: hpa@zytor.com
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Date: Wed, 17 Apr 2019 09:51:47 -0700
Message-ID: <1DE9F317-8B95-40F4-89AF-A3573B1C4881@zytor.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org> <20190416082042.GA69717@gmail.com> <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com> <20190417061650.GA31060@gmail.com> <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com> <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com> <20190417163729.GA53511@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417163729.GA53511@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Drake <drake@endlessm.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jian-Hong Pan <jian-hong@endlessm.com>, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>, linux-tip-commits@vger.kernel.org, Endless Linux Upstreaming Team <linux@endlessm.com>
List-Id: linux-efi@vger.kernel.org

On April 17, 2019 9:37:29 AM PDT, Ingo Molnar <mingo@kernel=2Eorg> wrote:
>
>* hpa@zytor=2Ecom <hpa@zytor=2Ecom> wrote:
>
>> > Just to check, you mean: EFI reboot (and shutdown) become the
>default
>> > methods when the machine is booted in EFI mode, and EFI stuff has
>not
>> > been disabled with a kernel parameter?
>> > Even when running in full hardware ACPI mode=2E
>
>No, I still think "early" EFI is historically better with ACPI reboot=2E
>
>But can we find a firmware flag perhaps that will *not* result in EFI=20
>reboot being turned off?
>
>> This, I believe, is known to not work=2E
>
>Yeah, I bet so=2E
>
>My problem is that the code appears to have the wrong assumptions:
>
> /*
>* For most modern platforms the preferred method of powering off is via
>  * ACPI=2E However, there are some that are known to require the use of
>  * EFI runtime services and for which ACPI does not work at all=2E
>  *
>  * Using EFI is a last resort, to be used only if no other option
>  * exists=2E
>  */
> bool efi_reboot_required(void)
> {
>         if (!acpi_gbl_reduced_hardware)
>                 return false;
>
>         efi_reboot_quirk_mode =3D EFI_RESET_WARM;
>         return true;
> }
>
>
>At minimum the comment is stale: "modern" platforms, *especially* when=20
>the only bootup method is EFI, as in the ACER laptop case, I think the=20
>preferred reboot method is absolutely an EFI reboot - and it's probably
>
>what Windows uses too=2E
>
>The question is, is acpi_gbl_reduced_hardware false on the Acer=20
>TravelMate X514-51T? I think it has to be, for the quirk to make sense
>-=20
>if it's true then efi_reboot_required() would set the reboot method to=20
>EFI=2E
>
>I=2Ee=2E we seem to have a new category of systems that are advertising=
=20
>themselves as 'full ACPI compliant', which are NOT old EFI systems, but
>
>modern EFI systems=2E
>
>Is there some good way to detect these - such as ACPI version or=20
>something?
>
>Thanks,
>
>	Ingo

That is exactly what the reduced hardware flag is supposed to indicate=2E =
As far as what Windows does, the are only two ways to find out: testing som=
ehow, or these days Microsoft might actually answer if we ask nicely=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
