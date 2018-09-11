From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Random crashes with i386 and efi boots
Date: Tue, 11 Sep 2018 09:36:51 -0700
Message-ID: <90A7FF2E-F186-49CF-A028-CDE317BE13E1@amacapital.net>
References: <20180910215659.GA17966@roeck-us.net> <D213F8BC-5C8E-44A2-810F-918B915F0804@amacapital.net> <877118e5-beee-4551-28d3-79e7aa52f74e@roeck-us.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877118e5-beee-4551-28d3-79e7aa52f74e@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Joerg Roedel <jroedel@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org



> On Sep 11, 2018, at 6:30 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>=20
> On 09/11/2018 04:52 AM, Andy Lutomirski wrote:
>>> On Sep 10, 2018, at 2:56 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>=20
>>> Hi folks,
>>>=20
>>> even after commit eeb89e2bb1ac ("x86/efi: Load fixmap GDT in
>>> efi_call_phys_epilog()"), my i386/efi qemu boot tests still crash random=
ly
>>> (roughly 5-10% of the time). As before, I don't see much useful output i=
n
>>> the qemu log (this time it doesn't even complain about a triple fault).
>>>=20
>>> Debugging shows that the crash happens in efi_call_phys_epilog().
>>> A sample log from a crashed test run is attached below. It appears that
>>> the crash happens if there is an interrupt at a critical section of the
>>> code.
>>>=20
>>> While playing with the code, I found a possible fix.
>>>=20
>>> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_=
32.c
>>> index 05ca14222463..9959657127f4 100644
>>> --- a/arch/x86/platform/efi/efi_32.c
>>>  +++ b/arch/x86/platform/efi/efi_32.c
>>> @@ -85,10 +85,9 @@ pgd_t * __init efi_call_phys_prolog(void)
>>>=20
>>> void __init efi_call_phys_epilog(pgd_t *save_pgd)
>>> {
>>> +    load_fixmap_gdt(0);
>>>    load_cr3(save_pgd);
>>>    __flush_tlb_all();
>>> -
>>> -    load_fixmap_gdt(0);
>>> }
>> We have IRQs on here?  It seems plausible that we=E2=80=99re in a window w=
here the EFI pgd doesn=E2=80=99t have cpu_entry_area mapped. Also, the hard c=
oded CPU 0 is suspicious.
> The hard coded CPU 0 was always there. The call is ultimately from
> efi_enter_virtual_mode(), which is called from start_kernel().
> so presumably it is guaranteed to run on CPU 0.
>=20
>> Maybe try instrumenting the code to check whether the clone_pgd_range cal=
ls in setup_percpu.c have happened yet?
> The crash is seen late in the boot process, so I am quite sure it happened=
,
> but I can add a check if needed. I think that might be a different problem=
,
> though.
>=20
>> Your patch may well be correct, but, if we have IRQs on, we should really=
 have cpu_entry_area mapped in both pgds.
>> Or we could turn off IRQs. Why on Earth are IRQs on in a context where th=
e fixmap gdt is unusable?
>=20
> =46rom arch/x86/platform/efi/efi.c:phys_efi_set_virtual_address_map():
>=20
>    save_pgd =3D efi_call_phys_prolog();
>    local_irq_save(flags);
>    status =3D efi_call_phys(...);
>        local_irq_restore(flags);
>=20
>        efi_call_phys_epilog(save_pgd);
>=20
> So, yes, interrupts are very much enabled.

Does fixing that solve the problem?  It seems more robust.

>=20
> I ran several additional test sequences. With above patch, no failures wit=
h
> 500 boots. Without it, failure rate (long term average) across 500 boots
> is around 10%. Another data point: Moving load_fixmap_gdt(0); after
> load_cr3(save_pgd); does not help; it has to come first.
>=20
> Guenter
