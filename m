From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Thu, 10 Sep 2015 16:03:00 +0100
Message-ID: <20150910150300.GK29293@leverpostej>
References: <1441371986-4554-1-git-send-email-ard.biesheuvel@linaro.org>
 <1441782414-16284-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150910132211.GF29293@leverpostej>
 <CAKv+Gu91fT=bQ1C3AETDCeKzgJ0fpwm1+gdKF02F7t8VzqVYFA@mail.gmail.com>
 <20150910140419.GH29293@leverpostej>
 <CAKv+Gu-U0zcQpqXeb4BoRL+BcJvJ0dxRx6gZb77eJc520Spd2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-U0zcQpqXeb4BoRL+BcJvJ0dxRx6gZb77eJc520Spd2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> OK so what we could do is the following:
> 
> ------------8<--------------
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e8ca6eaedd02..39fa2a70a7f1 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -233,6 +233,7 @@ void __init efi_init(void)
>  static bool __init efi_virtmap_init(void)
>  {
>         efi_memory_desc_t *md;
> +       u64 prev_end = 0;
> 
>         for_each_efi_memory_desc(&memmap, md) {
>                 u64 paddr, npages, size;
> @@ -256,13 +257,26 @@ static bool __init efi_virtmap_init(void)
>                  * executable, everything else can be mapped with the XN bits
>                  * set.
>                  */
> -               if (!is_normal_ram(md))
> +               if (!is_normal_ram(md)) {
>                         prot = __pgprot(PROT_DEVICE_nGnRE);
> -               else if (md->type == EFI_RUNTIME_SERVICES_CODE)
> +               } else if (md->type == EFI_RUNTIME_SERVICES_CODE) {
>                         prot = PAGE_KERNEL_EXEC;
> -               else
> +               } else {
> +                       /*
> +                        * If we are running with >4 KB pages and the current
> +                        * region shares a page frame with the preceding one,
> +                        * we should not map the leading page again since doing
> +                        * so may take its executable permissions away.
> +                        */
> +                       if (PAGE_SIZE > EFI_PAGE_SIZE && paddr < prev_end) {
> +                               paddr += PAGE_SIZE;
> +                               size -= PAGE_SIZE;
> +                               if (!size)
> +                                       continue;
> +                       }
>                         prot = PAGE_KERNEL;
> -
> +               }
> +               prev_end = paddr + size;
>                 create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
>         }
>         return true;
> ------------8<--------------
> 
> This will ensure that only the pages that are shared between 2 or more
> regions may have their permissions upgraded, but only if any of these
> regions requires it.
> 
> I prefer the much simpler previous version, though, and I think it is
> more suitable for -stable. I can always follow up with an improvement
> like this for v4.3-late.

Ok. Let's go with your previous version for now.

Could you put something in the commit message about this limitation, so
that we don't forget?

> >> >>               else
> >> >>                       prot = PAGE_KERNEL;
> >> >> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> >> >> index e29560e6b40b..cb4e9c4de952 100644
> >> >> --- a/drivers/firmware/efi/libstub/arm-stub.c
> >> >> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> >> >> @@ -13,6 +13,7 @@
> >> >>   */
> >> >>
> >> >>  #include <linux/efi.h>
> >> >> +#include <linux/sort.h>
> >> >
> >> > Sort isn't an inline in this header. I thought it wasn't safe to call
> >> > arbitary kernel functions from the stub?
> >> >
> >>
> >> We call string functions, cache maintenance functions, libfdt
> >> functions etc etc so it seems not everyone got the memo :-)
> >>
> >> I agree that treating vmlinux both as a static library and as a
> >> payload from the stub's pov is a bit sloppy, and I do remember
> >> discussing this, but for the life of me, I can't remember the exact
> >> issue, other than the use of adrp/add and adrp/ldr pairs, which we
> >> fixed by setting the PE/COFF section alignment to 4 KB.
> >
> > I only had a vague recollection that there was a problem, which I
> > thought was more to do with potential use of absolute kernel virtual
> > addresses, which would be incorrect in the context of an EFI
> > application.
> >
> 
> That was it, of course. Unlike the x86 stub, which is built with -fPIC
> (as is the ARM decompressor, btw), the arm64 kernel is position
> dependent. Fortunately, the small code model is mostly position
> independent by default, but it would be good if we could spot any
> problems at build time.
> 
> > Digging a bit, the stub code itself is safe due to commit
> > f4f75ad5741fe033 ("efi: efistub: Convert into static library"), but that
> 
> libstub is linked into vmlinux so that does not make a different at all

Ok. I assumed that inter-stub references would still be relative, but I
have no idea what the linker would do.

> > We do seem to be ok so far, however. Maybe we just need to keep an eye
> > out.
> >
> 
> I'd much rather restrict the code that goes into the stub somehow than
> deal with any absolute references. Perhaps we could reuse some of the
> section mismatch code in some way to tag certain code as stub-safe and
> do a verification pass on the binary.

It would be great if we could, though I'm not really sure how that would
work.

Imagine stub_foo calls fdt_blah, which calls kern_baz by absolute
address. Normally the latter call is fine, but not when the original
call comes from the stub. I don't think the section mismatch code has
any way to contextualize calls like that, and I don't know what criteria
we could use for annotating code.

Let's not have that delay this patch, however. That's a bigger can of
worms.

Thanks,
Mark.
