From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Random crashes with i386 and efi boots
Date: Tue, 11 Sep 2018 04:52:02 -0700
Message-ID: <D213F8BC-5C8E-44A2-810F-918B915F0804@amacapital.net>
References: <20180910215659.GA17966@roeck-us.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910215659.GA17966@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Joerg Roedel <jroedel@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org



> On Sep 10, 2018, at 2:56 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>=20
> Hi folks,
>=20
> even after commit eeb89e2bb1ac ("x86/efi: Load fixmap GDT in
> efi_call_phys_epilog()"), my i386/efi qemu boot tests still crash randomly=

> (roughly 5-10% of the time). As before, I don't see much useful output in
> the qemu log (this time it doesn't even complain about a triple fault).=20=

>=20
> Debugging shows that the crash happens in efi_call_phys_epilog().
> A sample log from a crashed test run is attached below. It appears that
> the crash happens if there is an interrupt at a critical section of the
> code.
>=20
> While playing with the code, I found a possible fix.
>=20
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32=
.c
> index 05ca14222463..9959657127f4 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -85,10 +85,9 @@ pgd_t * __init efi_call_phys_prolog(void)
>=20
> void __init efi_call_phys_epilog(pgd_t *save_pgd)
> {
> +    load_fixmap_gdt(0);
>    load_cr3(save_pgd);
>    __flush_tlb_all();
> -
> -    load_fixmap_gdt(0);
> }

We have IRQs on here?  It seems plausible that we=E2=80=99re in a window whe=
re the EFI pgd doesn=E2=80=99t have cpu_entry_area mapped. Also, the hard co=
ded CPU 0 is suspicious.

Maybe try instrumenting the code to check whether the clone_pgd_range calls i=
n setup_percpu.c have happened yet?

Your patch may well be correct, but, if we have IRQs on, we should really ha=
ve cpu_entry_area mapped in both pgds.

Or we could turn off IRQs. Why on Earth are IRQs on in a context where the f=
ixmap gdt is unusable?
