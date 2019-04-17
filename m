From: hpa@zytor.com
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Date: Wed, 17 Apr 2019 08:15:55 -0700
Message-ID: <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org> <20190416082042.GA69717@gmail.com> <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com> <20190417061650.GA31060@gmail.com> <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Drake <drake@endlessm.com>, Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jian-Hong Pan <jian-hong@endlessm.com>, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>, linux-tip-commits@vger.kernel.org, Endless Linux Upstreaming Team <linux@endlessm.com>
List-Id: linux-efi@vger.kernel.org

On April 17, 2019 5:38:41 AM PDT, Daniel Drake <drake@endlessm=2Ecom> wrote=
:
>On Wed, Apr 17, 2019 at 2:16 PM Ingo Molnar <mingo@kernel=2Eorg> wrote:
>> Ok, so acpi_gbl_reduced_hardware is set when the =2E=2E=2E 'reduced
>hardware'
>> bit is set:
>>
>>         acpi_gbl_reduced_hardware =3D FALSE;
>>         if (acpi_gbl_FADT=2Eflags & ACPI_FADT_HW_REDUCED) {
>>                 acpi_gbl_reduced_hardware =3D TRUE;
>>         }
>>
>>
>> which is described as:
>>
>>  #define ACPI_FADT_HW_REDUCED        (1<<20)     /* 20: [V5] ACPI
>hardware is not implemented (ACPI 5=2E0) */
>>
>> That seems counter-intuitive to me: if no full ACPI hardware is
>> implemented then we should assume reduced ACPI functionality, i=2Ee=2E =
if
>the
>> EFI runtime is otherwise available we should default to it=2E
>
>It's a bit confusing, but my loose understanding is that previous
>versions of the ACPI spec required system implementors to implement
>the whole thing; but that's increasingly impractical today, e=2Eg=2E with
>ARM systems coming along, which do not gel well with some of the
>historical x86-rooted design aspects that spilled over into ACPI=2E The
>V5 spec introduces reduced mode as an opt-in new feature, but for
>compatibility with pre-V5 implementations it needs to consider "full
>hardware" mode as the default=2E
>
>> Feel free to send a patch that makes EFI reboot the default one under
>> these circumstances,
>
>Just to check, you mean: EFI reboot (and shutdown) become the default
>methods when the machine is booted in EFI mode, and EFI stuff has not
>been disabled with a kernel parameter?
>Even when running in full hardware ACPI mode=2E
>
>Thanks
>Daniel

This, I believe, is known to not work=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
