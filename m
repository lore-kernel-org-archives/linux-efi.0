From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Thu, 10 Sep 2015 15:04:19 +0100
Message-ID: <20150910140419.GH29293@leverpostej>
References: <1441371986-4554-1-git-send-email-ard.biesheuvel@linaro.org>
 <1441782414-16284-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150910132211.GF29293@leverpostej>
 <CAKv+Gu91fT=bQ1C3AETDCeKzgJ0fpwm1+gdKF02F7t8VzqVYFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu91fT=bQ1C3AETDCeKzgJ0fpwm1+gdKF02F7t8VzqVYFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> >> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> >> index e8ca6eaedd02..13671a9cf016 100644
> >> --- a/arch/arm64/kernel/efi.c
> >> +++ b/arch/arm64/kernel/efi.c
> >> @@ -258,7 +258,8 @@ static bool __init efi_virtmap_init(void)
> >>                */
> >>               if (!is_normal_ram(md))
> >>                       prot = __pgprot(PROT_DEVICE_nGnRE);
> >> -             else if (md->type == EFI_RUNTIME_SERVICES_CODE)
> >> +             else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
> >> +                      !PAGE_ALIGNED(md->phys_addr))
> >>                       prot = PAGE_KERNEL_EXEC;
> >
> > This looks coarser than necessary. For memory organised like:
> >
> > 0x00000000 - 0x0000F000 (60KiB) : EFI_RUNTIME_SERVICES_CODE
> > 0x0000F000 - 0x00020000 (68KiB) : EFI_RUNTIME_SERVICES_DATA
> >
> > We should be able to make the last 64K non-executable, but with this all
> > 128K is executable, unless I've missed something?
> >
> 
> In theory, yes. But considering that
> 
> a) this only affects 64 KB pages kernels, and
> b) this patch is intended for -stable
> 
> I chose to keep it simple and ignore this, and just relax the
> permissions for any region that is not aligned to 64 KB.
> 
> Since these regions are only mapped during Runtime Services calls, the
> window for abuse is not that large.

Ok, that does sound reasonable.

> > Maybe we could do a two-step pass, first mapping the data as
> > not-executable, then mapping any code pages executable (overriding any
> > overlapping portions, but only for the overlapping parts).
> >
> 
> Let me have a go at that.

Cheers!

> >>               else
> >>                       prot = PAGE_KERNEL;
> >> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> >> index e29560e6b40b..cb4e9c4de952 100644
> >> --- a/drivers/firmware/efi/libstub/arm-stub.c
> >> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> >> @@ -13,6 +13,7 @@
> >>   */
> >>
> >>  #include <linux/efi.h>
> >> +#include <linux/sort.h>
> >
> > Sort isn't an inline in this header. I thought it wasn't safe to call
> > arbitary kernel functions from the stub?
> >
> 
> We call string functions, cache maintenance functions, libfdt
> functions etc etc so it seems not everyone got the memo :-)
> 
> I agree that treating vmlinux both as a static library and as a
> payload from the stub's pov is a bit sloppy, and I do remember
> discussing this, but for the life of me, I can't remember the exact
> issue, other than the use of adrp/add and adrp/ldr pairs, which we
> fixed by setting the PE/COFF section alignment to 4 KB.

I only had a vague recollection that there was a problem, which I
thought was more to do with potential use of absolute kernel virtual
addresses, which would be incorrect in the context of an EFI
application.

Digging a bit, the stub code itself is safe due to commit
f4f75ad5741fe033 ("efi: efistub: Convert into static library"), but that
isn't necessarily true of anything it calls (libfdt uses callbacks in
several places). I think the cache functions we call are all raw asm
which is position-oblivious.

We do seem to be ok so far, however. Maybe we just need to keep an eye
out.

Thanks,
Mark.
