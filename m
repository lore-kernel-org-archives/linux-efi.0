From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64/efi: efistub: get text offset and image size
 from the Image header
Date: Tue, 15 Jul 2014 10:47:33 +0100
Message-ID: <20140715094733.GU26465@leverpostej>
References: <1405354671-14031-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405354671-14031-3-git-send-email-ard.biesheuvel@linaro.org>
 <20140714165446.GN26465@leverpostej>
 <CAKv+Gu_Pf8O92eAO5ENQJPJ6yWMP2U0M90Uc_CYW8MSU7cFWHw@mail.gmail.com>
 <20140714182908.GQ26465@leverpostej>
 <CAKv+Gu9hJ9yqkM0xxNPygMydd6Sg2+ZDGg7DnEqc8L_4G=CL_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9hJ9yqkM0xxNPygMydd6Sg2+ZDGg7DnEqc8L_4G=CL_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

[...]

> >> >> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> >> >> index 9b61d66e2d20..4ba90b2ef677 100644
> >> >> --- a/arch/arm64/kernel/efi-stub.c
> >> >> +++ b/arch/arm64/kernel/efi-stub.c
> >> >> @@ -11,8 +11,7 @@
> >> >>   */
> >> >>  #include <linux/efi.h>
> >> >>  #include <asm/efi.h>
> >> >> -#include <asm/sections.h>
> >> >> -
> >> >> +#include <asm/image_hdr.h>
> >> >>
> >> >>  efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
> >> >>                                unsigned long *image_addr,
> >> >> @@ -23,24 +22,28 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
> >> >>                                efi_loaded_image_t *image)
> >> >>  {
> >> >>       efi_status_t status;
> >> >> -     unsigned long kernel_size, kernel_memsize = 0;
> >> >> +     struct arm64_image_hdr *hdr = (struct arm64_image_hdr *)*image_addr;
> >> >> +
> >> >> +     /* make sure image_addr points to an arm64 kernel Image */
> >> >> +     if (!arm64_image_hdr_check(hdr)) {
> >> >> +             pr_efi_err(sys_table, "Kernel Image header check failed\n");
> >> >> +             return EFI_LOAD_ERROR;
> >> >> +     }
> >> >
> >> > Surely this should always be the case if the stub is linked into the
> >> > kernel?
> >> >
> >> > It would be nice to know the rationale for this.
> >> >
> >>
> >> Well, there is an actual issue addressed by this: the PE/COFF .text
> >> section covers everything from stext to _edata, so it does not cover
> >> the header itself. In fact, PE/COFF does not allow the headers
> >> themselves to be covered by a section (or at least, the Tianocore/EDK2
> >> UEFI implementation does not). So the pointer points *outside* of the
> >> .text section, and we are assuming that whatever is at that [negative]
> >> offset in the file was also copied to the same offset in memory.(For
> >> instance, there is no reason to assume that all implementations of EFI
> >> will copy data that is not part of any section to RAM when booting an
> >> image located in NOR flash)
> >
> > If we are making assumptions which aren't always valid, then why the
> > hell are we making them in the first place, and then trying to validate
> > them? How does reading an address that we have absolutely no guarantee
> > as to the contents of solve that problem?
> >
> 
> Isn't that the whole point of a magic number?

Well...

I'd expect boot loaders and tools to use the magic number to identify an
image, knowing that the whole thing has been copied.

Using it in this way seems remarkably fragile, given that we're using it
to test that UEFI did something it's arguably not supposed to.

> > This sounds amazingly fragile, and as far as I can tell the header check
> > doesn't address the issue so much as paper over it with a failure that's
> > not even guaranteed to be graceful (e.g. if no memory exists at the
> > negative offset we're accessing we will simply explode).
> >
> 
> The memory is guaranteed to exist, only the header is not guaranteed
> to have been copied into it.

Ok. 

> > Is this the first step towards splitting the stub form the kernel
> > proper such that we can rely on the image header being present?
> >
> > If that's the case then please put that in the commit message and cover,
> > because it's not obvious and there's no point wasting time arguing over
> > whether to put a piece of useful context into the commit message.
> >
> 
> Well, the more I think of it, the more I am leaning towards dropping
> this patch and taking the opposite approach.
> Even if we build the stub LE and link it into a BE kernel, we should
> be able to poke the right values into the right places at build time
> rather than rely on a header of which we can't be even sure that it
> exists in the expected place.

That sounds like a better solution to me. We should try to drop all
reliance on the header if we can't expect it to be present.

> >>
> >> >>
> >> >>       /* Relocate the image, if required. */
> >> >> -     kernel_size = _edata - _text;
> >> >> -     if (*image_addr != (dram_base + TEXT_OFFSET)) {
> >> >> -             kernel_memsize = kernel_size + (_end - _edata) + TEXT_OFFSET;
> >> >> -             status = efi_low_alloc(sys_table, kernel_memsize, SZ_2M,
> >> >> +     if (*image_addr != (dram_base + hdr->text_offset) ||
> >> >> +         image->image_size < hdr->image_size) {
> >> >
> >> > As far as I can tell the size of the Image (image->image_size) is always
> >> > going to be less than the effective run time image size
> >> > (hdr->image_size).
> >> >
> >>
> >> Currently, yes.
> >>
> >> > The SizeOfImage field in head.S which I assume image->image_size is
> >> > derived from (not having a UEFI spec in front of me) seems to cover
> >> > everything up to _edata but skips the BSS, and initial page tables, but
> >> > this is covered by the header's image_size field.
> >> >
> >> > Am I missing something? Surely we _always_ expect image->image_size to
> >> > be smaller than hdr->image_size?
> >> >
> >>
> >> At some point, we may extend the virtual size of .text all the way to _end.
> >> (Without growing the actual payload, the remainder will be zero
> >> initialized by the loader)
> >
> > Surely either way we know which is going to be the case? Either it's
> > smaller (as it is now) or we've padded it (which we have not done).
> >
> > Why not either assume it's smaller or change the virtual size of .text?
> >
> 
> Well, the trouble is that we use more memory by padding the .text
> section, leaving less room for the reallocation which we need to do in
> 99% of the cases. This is somewhat of a waste if EFI loaded the Image
> close to base of DRAM.

But if we don't pad then we know it must be smaller, no?

> But after seeing Mark Salter's stub patch for APM Mustang, this needs
> major rework anyway, but my position is now that we should not touch
> the header *at all* from the stub.

Ok. If we're not going to touch the header that sounds fine to me.

Thanks,
Mark.
