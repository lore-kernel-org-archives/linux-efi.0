From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 02/10] x86/efi: Return error status if mapping EFI regions fail
Date: Fri, 8 Feb 2019 16:50:37 +0100
Message-ID: <CAKv+Gu83HJo29=d4VEMCi3D2PH-Crqrt_oUz14Ogz2r0W9ih+g@mail.gmail.com>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
 <20190202094119.13230-3-ard.biesheuvel@linaro.org> <20190204071809.GA115714@gmail.com>
 <CAKv+Gu-vxV_U03jdMY0N1UMDWcB1jZLKj-ONV2rsw3UTeimhBg@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F486FF4C3@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F486FF4C3@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 4 Feb 2019 at 23:29, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>
> > > > efi_map_region() creates VA mappings for an given EFI region using
> > > > any one of the two helper functions (namely __map_region() and
> > old_map_region()).
> > > > These helper functions *could* fail while creating mappings and
> > > > presently their return value is not checked. Not checking for the
> > > > return value of these functions might create issues because after
> > > > these functions return "md->virt_addr" is set to the requested
> > > > virtual address (so it's assumed that these functions always succeed
> > > > which is not quite true). This assumption leads to "md->virt_addr"
> > > > having invalid mapping should any of
> > > > __map_region() or old_map_region() fail.
> > > >
> > > > Hence, check for the return value of these functions and if indeed
> > > > they fail, turn off EFI Runtime Services forever because kernel
> > > > cannot prioritize among EFI regions.
> > > >
> [...................]
> > > > -void __init old_map_region(efi_memory_desc_t *md)
> > > > +int __init old_map_region(efi_memory_desc_t *md)
> > > >  {
> > > >       u64 start_pfn, end_pfn, end;
> > > >       unsigned long size;
> > > > @@ -601,10 +601,14 @@ void __init old_map_region(efi_memory_desc_t
> > *md)
> > > >               va = efi_ioremap(md->phys_addr, size,
> > > >                                md->type, md->attribute);
> > > >
> > > > -     md->virt_addr = (u64) (unsigned long) va;
> > > > -     if (!va)
> > > > +     if (!va) {
> > > >               pr_err("ioremap of 0x%llX failed!\n",
> > > >                      (unsigned long long)md->phys_addr);
> > > > +             return -ENOMEM;
> > > > +     }
> > > > +
> > > > +     md->virt_addr = (u64)(unsigned long)va;
> > > > +     return 0;
> > >
> > > Just wondering, shouldn't the failure path set ->virt_addr to
> > > something safe, just in case a caller doesn't check the error and relies on it?
> > >
> > > That's because in this commit we've now changed it from 0 to undefined.
> > >
> >
> > Indeed. We don't usually rely on the value of ->virt_addr when
> > EFI_RUNTIME_SERVICES is unset, but there is some sysfs code, and perhaps
> > some other places where we do reference ->virt_addr, and not assigning it at all
> > is obviously wrong, and potentially hazardous.
> >
>
> Ok.. makes sense.
> Do you think md->virt_addr = 0 for fail case is ok?
>

0 should be fine. You shouldn't be able to dereference that anywhere.


> > > > +int __init efi_map_region_fixed(efi_memory_desc_t *md) { return 0;
> > > > +}
> > >
> > > Inline functions should be marked inline ...
> > >
> > > >       if (efi_va < EFI_VA_END) {
> > > > -             pr_warn(FW_WARN "VA address range overflow!\n");
> > > > -             return;
> > > > +             pr_err(FW_WARN "VA address range overflow!\n");
> > > > +             return -ENOMEM;
> > > >       }
> > > >
> > > >       /* Do the VA map */
> > > > -     __map_region(md, efi_va);
> > > > +     if (__map_region(md, efi_va))
> > > > +             return -ENOMEM;
> > > > +
> > > >       md->virt_addr = efi_va;
> > > > +     return 0;
> > >
> > > Same error return problem of leaving ->virt_addr undefined.
> > >
>
> Sure! Will fix it in V2.
>
> > > Note that I also fixed up the grammar and readability of the changelog
> > > - see the updated version below.
>
> Thanks for fixing :)
>
> > >
> > > Thanks,
> > >
> > >         Ingo
> > >
> > > =============>
> > > Subject: x86/efi: Return error status if mapping of EFI regions fails
> > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > Date: Sat, 2 Feb 2019 10:41:11 +0100
> > >
> > > From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> > >
> > > efi_map_region() creates VA mappings for a given EFI region using one
> > > of the two helper functions (namely __map_region() and old_map_region()).
> > >
> > > These helper functions could fail while creating mappings and
> > > presently their return value is not checked.
> > >
> > > Not checking for the return value of these functions might create
> > > bugs, because after these functions return "md->virt_addr" is set to
> > > the requested virtual address (so it's assumed that these functions
> > > always succeed which is not quite true). This assumption leads to
> > > "md->virt_addr" having invalid mapping, should any of __map_region()
> > > or old_map_region() fail.
> > >
> > > Hence, check for the return value of these functions and if indeed
> > > they fail, turn off EFI Runtime Services forever because kernel cannot
> > > prioritize among EFI regions.
> > >
> > > This also fixes the comment "FIXME: add error handling" in
> > > kexec_enter_virtual_mode().
> > >
> >
> > Thanks Ingo.
> >
> > Sai, could you please respin this and use Ingo's updated version of the commit
> > log?
>
> Sure! I will send a V2 with the mentioned changes.
>
> Regards,
> Sai
