From: Daniel Drake <drake@endlessm.com>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot,
 efi: Use EFI reboot for Acer TravelMate X514-51T)
Date: Wed, 17 Apr 2019 20:38:41 +0800
Message-ID: <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com> <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417061650.GA31060@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jian-Hong Pan <jian-hong@endlessm.com>, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, hpa@zytor.com, linux-efi@vger.kernel.org, Len Brown <len.brown@intel.com>, linux-tip-commits@vger.kernel.org, Endless Linux Upstreaming Team <linux@endlessm.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 17, 2019 at 2:16 PM Ingo Molnar <mingo@kernel.org> wrote:
> Ok, so acpi_gbl_reduced_hardware is set when the ... 'reduced hardware'
> bit is set:
>
>         acpi_gbl_reduced_hardware = FALSE;
>         if (acpi_gbl_FADT.flags & ACPI_FADT_HW_REDUCED) {
>                 acpi_gbl_reduced_hardware = TRUE;
>         }
>
>
> which is described as:
>
>  #define ACPI_FADT_HW_REDUCED        (1<<20)     /* 20: [V5] ACPI hardware is not implemented (ACPI 5.0) */
>
> That seems counter-intuitive to me: if no full ACPI hardware is
> implemented then we should assume reduced ACPI functionality, i.e. if the
> EFI runtime is otherwise available we should default to it.

It's a bit confusing, but my loose understanding is that previous
versions of the ACPI spec required system implementors to implement
the whole thing; but that's increasingly impractical today, e.g. with
ARM systems coming along, which do not gel well with some of the
historical x86-rooted design aspects that spilled over into ACPI. The
V5 spec introduces reduced mode as an opt-in new feature, but for
compatibility with pre-V5 implementations it needs to consider "full
hardware" mode as the default.

> Feel free to send a patch that makes EFI reboot the default one under
> these circumstances,

Just to check, you mean: EFI reboot (and shutdown) become the default
methods when the machine is booted in EFI mode, and EFI stuff has not
been disabled with a kernel parameter?
Even when running in full hardware ACPI mode.

Thanks
Daniel
