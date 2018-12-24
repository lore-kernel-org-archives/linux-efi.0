From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Don't unmap EFI boot services code/data regions
 for EFI_OLD_MEMMAP and EFI_MIXED_MODE
Date: Mon, 24 Dec 2018 10:38:44 +0100
Message-ID: <CAKv+Gu8_9zMKhNyL=R7ZJHU=cFCkASVEOrm_4kqmTQG+7wPFbw@mail.gmail.com>
References: <20181222022234.7573-1-sai.praneeth.prakhya@intel.com>
 <20181222105410.GA130780@gmail.com> <CAKv+Gu93dgfXsq_sRzvXBw-h=8pn2BtrQLtpwtjK51potpOtdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu93dgfXsq_sRzvXBw-h=8pn2BtrQLtpwtjK51potpOtdg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On Sat, 22 Dec 2018 at 12:04, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Sat, 22 Dec 2018 at 11:54, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com> wrote:
> >
> > > Commit d5052a7130a6 ("x86/efi: Unmap EFI boot services code/data regions
> > > from efi_pgd") forgets to take two EFI modes into consideration namely
> > > EFI_OLD_MEMMAP and EFI_MIXED_MODE.
> >
> > So the commit sha1 ended up being this one in tip:efi/core:
> >
> >   08cfb38f3ef4: x86/efi: Unmap EFI boot services code/data regions from efi_pgd
> >
> > > EFI_OLD_MEMMAP is a legacy way of mapping EFI regions into swapper_pg_dir
> > > using ioremap() and init_memory_mapping(). This feature can be enabled by
> > > passing "efi=old_map" as kernel command line argument. But,
> > > efi_unmap_pages() unmaps EFI boot services code/data regions *only* from
> > > efi_pgd and hence cannot be used for unmapping EFI boot services code/data
> > > regions from swapper_pg_dir.
> > >
> > > Introduce a temporary fix to not unmap EFI boot services code/data regions
> > > when EFI_OLD_MEMMAP is enabled while working on a real fix.
> > >
> > > EFI_MIXED_MODE is another feature where a 64-bit kernel runs on a
> > > 64-bit platform crippled by a 32-bit firmware. To support EFI_MIXED_MODE,
> > > all RAM (i.e. namely EFI regions like EFI_CONVENTIONAL_MEMORY,
> > > EFI_LOADER_<CODE/DATA>, EFI_BOOT_SERVICES_<CODE/DATA> and
> > > EFI_RUNTIME_CODE/DATA regions) is mapped into efi_pgd all the time to
> > > facilitate EFI runtime calls access it's arguments in 1:1 mode. Hence,
> > > don't unmap EFI boot services code/data regions when booted in mixed mode.
> > >
> > > Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> > > Cc: Borislav Petkov <bp@alien8.de>
> > > Cc: Ingo Molnar <mingo@kernel.org>
> > > Cc: Andy Lutomirski <luto@kernel.org>
> > > Cc: Dave Hansen <dave.hansen@intel.com>
> > > Cc: Bhupesh Sharma <bhsharma@redhat.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  arch/x86/platform/efi/quirks.c | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > >
> > > diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> > > index 09e811b9da26..9c34230aaeae 100644
> > > --- a/arch/x86/platform/efi/quirks.c
> > > +++ b/arch/x86/platform/efi/quirks.c
> > > @@ -380,6 +380,22 @@ static void __init efi_unmap_pages(efi_memory_desc_t *md)
> > >       u64 pa = md->phys_addr;
> > >       u64 va = md->virt_addr;
> > >
> > > +     /*
> > > +      * To Do: Remove this check after adding functionality to unmap EFI boot
> > > +      * services code/data regions from direct mapping area because
> > > +      * "efi=old_map" maps EFI regions in swapper_pg_dir.
> > > +      */
> > > +     if (efi_enabled(EFI_OLD_MEMMAP))
> > > +             return;
> > > +
> > > +     /*
> > > +      * EFI mixed mode has all RAM mapped to access arguments while making
> > > +      * EFI runtime calls, hence don't unmap EFI boot services code/data
> > > +      * regions.
> > > +      */
> > > +     if (!efi_is_native() && IS_ENABLED(CONFIG_EFI_MIXED))
>
> AFAIK efi_is_native() can only return false is CONFIG_EFI_MIXED is
> set, so this expression can be simplified.
>
> > > +             return;
> >
> > I suppose old_mmap and mixed mode stopped working altogether after the
> > unmapping changes? What are the symptoms, instant reboots, crasher, or
> > some more benign behavior like non-working runtime EFI functionality?
> >
> > If Ard acks this I'll apply it immediately, as these bugs look like
> > show-stoppers for merging the EFI tree into v4.21.
> >
>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> with the sidenote that I won't be able to test this myself until
> monday at the earliest.

OK, so I have tested both efi=old_map and mixed mode before and after
applying this patch, using QEMU/KVM with 64-bit and 32-bit builds of
OVMF [respectively]

efi=old_map is indeed broken before and needs this patch.

Mixed mode works just fine both before and after applying the patch,
but I suggest we keep this patch as-is and address mixed mode later if
needed (I spotted a couple of things in the boot log that may need
some attention but I'm not sure if the issue is in Linux or in OVMF)
