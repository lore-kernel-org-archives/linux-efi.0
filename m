From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL 00/13] First batch of EFI updates for v4.13
Date: Mon, 5 Jun 2017 11:07:56 +0200
Message-ID: <20170605090755.6hf2b7hqgvfn44ao@gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu8RCwmwifH5nONSi4BkkA0d5oNZP9uX0iBagXOOXe7tpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8RCwmwifH5nONSi4BkkA0d5oNZP9uX0iBagXOOXe7tpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> (trim cc)
> 
> On 2 June 2017 at 13:51, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > The following changes since commit 5ed02dbb497422bf225783f46e6eadd237d23d6b:
> >
> >   Linux 4.12-rc3 (2017-05-28 17:20:53 -0700)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next
> >
> > for you to fetch changes up to 3acbd5a24ab9d9a82c56d9018f4d340fa574b91d:
> >
> >   efi: arm: enable DMI/SMBIOS (2017-06-02 13:38:56 +0000)
> >
> > ----------------------------------------------------------------
> > First batch of EFI changes for v4.13:
> > - rework the EFI capsule loader to allow for workarounds for non-compliant
> >   firmware to be implemented more easily and in a more self contained
> >   manner (Ard)
> > - implement a capsule loader quirk for Quark X102x, which prepends a
> >   security header in a non-compliant way (Jan Kiszka)
> > - enable SMBIOS/DMI support for the ARM architecture (Ard)
> > - add EFI_PGT_DUMP support for x86_32 and kexec (Sai Praneeth)
> > - some other cleanups
> >
> > ----------------------------------------------------------------
> > Andy Lutomirski (1):
> >       x86/efi: Clean up efi CR3 save/restore
> >
> > Ard Biesheuvel (4):
> >       efi/capsule-loader: Use a cached copy of the capsule header
> >       efi/capsule-loader: Redirect calls to efi_capsule_setup_info via weak alias
> >       efi/capsule-loader: Use page addresses rather than struct page pointers
> >       efi: arm: enable DMI/SMBIOS
> >
> > Fabian Frederick (1):
> >       efi/capsule: Remove NULL test on kmap()
> >
> > Geliang Tang (1):
> >       efi/efi_test: Use memdup_user() helper
> >
> > Jan Kiszka (5):
> >       efi/capsule: Fix return code on failing kmap/vmap
> >       efi/capsule: Remove pr_debug on ENOMEM or EFAULT
> >       efi/capsule: Clean up pr_err/info messages
> >       efi/capsule: Adjust return type of efi_capsule_setup_info
> >       efi/capsule: Add support for Quark security header
> >
> > Sai Praneeth (1):
> >       x86/efi: Add EFI_PGT_DUMP support for x86_32 and kexec
> >
> 
> All,
> 
> I just noticed that this patch lacks my signoff. This is due to the
> fact that Matt queued this particular patch, and I didn't update the
> branch to add my sob, so it is only signed off by Matt not me.
> 
> How should we handle this now, and in the future? Matt and I share
> maintainership responsibilities, and so everything that gets queued
> into the EFI tree may be treated as signed off by either and/or the
> both of us. For multi-maintainer trees that get pulled directly, this
> is usually not an issue AFAIK, but given that Ingo is the one that
> deals with EFI usually, and prefers to apply the patches individually,
> this may  get flagged as a missing signoff.

So the root problem is that that's not the proper usage of SOB: SOB tracks the 
true propagation of patches, it's not an Acked-by tag.

What should be added instead in such cases is an Acked-by or Reviewed-by from your 
co-maintainer when you apply the patch - and a SOB of yourself. That is how we are 
doing it in -tip: you'll see that 99% of the patches there get signed off by only 
one of the co-maintainers.

> In any case, I am happy to respin the patches, re-sign the tag etc if this is 
> deemed necessary.

It would be nice to fix your SOB flow: the maintainer who queues up a patch should 
add the SOB, and add an Acked-by of the co-maintainer if the co-maintainer agrees 
with the patch as well. The tree should typically not be rebased after that point 
(especially not by the other co-maintainer) - that's just indicative of a messy 
workflow.

( In rare circumstances we do double signoffs as well in -tip, when there's a
  _true_ patch flow between the maintainers, but it's the exception, not the
  rule. )

Thanks,

	Ingo
