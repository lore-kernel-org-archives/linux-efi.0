From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Random crashes with i386 and efi boots
Date: Tue, 11 Sep 2018 11:05:25 -0700
Message-ID: <51FDF5AF-2FE8-4817-9A5C-8CE4A8BC23AB@amacapital.net>
References: <20180910215659.GA17966@roeck-us.net> <D213F8BC-5C8E-44A2-810F-918B915F0804@amacapital.net> <877118e5-beee-4551-28d3-79e7aa52f74e@roeck-us.net> <90A7FF2E-F186-49CF-A028-CDE317BE13E1@amacapital.net> <20180911174158.7qu6f4vfnfzqqrcf@suse.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911174158.7qu6f4vfnfzqqrcf@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Joerg Roedel <jroedel@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org



> On Sep 11, 2018, at 10:41 AM, Joerg Roedel <jroedel@suse.de> wrote:
>=20
> On Tue, Sep 11, 2018 at 09:36:51AM -0700, Andy Lutomirski wrote:
>>>   save_pgd =3D efi_call_phys_prolog();
>>>   local_irq_save(flags);
>>>   status =3D efi_call_phys(...);
>>>       local_irq_restore(flags);
>>>=20
>>>       efi_call_phys_epilog(save_pgd);
>>>=20
>>> So, yes, interrupts are very much enabled.
>>=20
>> Does fixing that solve the problem?  It seems more robust.
>=20
> The problem is still that in efi_call_phys_prolog() we load the gdt with
> its physical address, and when we reload the %cr3 in _epilog from
> initial_page_table to swapper_pg_dir again the gdt is no longer mapped.
> Blocking interrupts is more robust, but we can't block NMIs that way
> that would also trigger the issue, no?
>=20
> So I am in favor of changing the order in efi_call_phys_epilog() too.
>=20

I=E2=80=99m rather confused here.  We=E2=80=99re loading CR3 with page table=
s that don=E2=80=99t have the fixmap mapped?  With interrupts on?  And we ex=
pect it to work?  This is *nuts*.

There are IMO only three sane fixes here:

1. Load the fixmap, cpu_entry_area, etc into the EFI page table.  Drop the G=
DT reload entirely.

2. Do this whole virtual map dance earlier so we don=E2=80=99t have IRQs and=
 NMIs and such. Maybe while we=E2=80=99re still using the initial page table=
?

3. Just identity map all the EFI regions. Make EFI page tables that literall=
y map them at their physical addresses *and* map the entire kernel, just lik=
e we do for normal user mms.

Sure, as a stopgap, turning off IRQs and applying Guenter=E2=80=99s patch se=
ems okay, but this code is not okay.=
