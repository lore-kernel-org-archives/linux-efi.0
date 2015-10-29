From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] [v2] arm64: efi: make sure vmlinux load address aligned
 on 2MB
Date: Thu, 29 Oct 2015 13:43:33 +0000
Message-ID: <20151029134333.GE28221@leverpostej>
References: <1446053844-27281-1-git-send-email-timur@codeaurora.org>
 <20151028180836.GB26777@leverpostej>
 <56311014.9020400@codeaurora.org>
 <20151028182139.GC26777@leverpostej>
 <CAKv+Gu-76knWJ+ffAemeR7sBBtVB68pmZNPGQZRZKhmnd21F9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-76knWJ+ffAemeR7sBBtVB68pmZNPGQZRZKhmnd21F9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 29, 2015 at 11:59:46AM +0900, Ard Biesheuvel wrote:
> On 29 October 2015 at 03:21, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Wed, Oct 28, 2015 at 01:12:36PM -0500, Timur Tabi wrote:
> >> On 10/28/2015 01:08 PM, Mark Rutland wrote:
> >>
> >> >arm64: efi: ensure kernel is loaded at correct address
> >> >
> >> >The kernel image needs to be loaded text_offset_bytes from a 2M-aligned
> >> >base, per Documentation/arm64/booting.txt. If loaded at the wrong offset
> >> >modulo 2M, __create_page_tables will create incorrect page tables.
> >> >
> >> >The EFI stub implicitly assumes that dram_base (i.e. the lowest address
> >> >with a EFI_MEMORY_WB attribute) is 2M-aligned, and tries to load the
> >> >kernel at dram_base + TEXT_OFFSET. If dram_base is not 2M-aligned, the
> >> >kernel will be loaded at the wrong offset from 2M.
> >>
> >> Thanks, I'll use that.  I messed up a couple other things, so I need
> >> to send out a v3 anyway.
> >>
> >> >>-           *image_addr = *reserve_addr = dram_base + TEXT_OFFSET;
> >> >>+           *image_addr = *reserve_addr =
> >> >>+                   round_up(dram_base, SZ_2M) + TEXT_OFFSET;
> >> >
> >> >We also need to fix the test for whether we need to relocate the kernel:
> >> >(*image_addr != (dram_base + TEXT_OFFSET)).
> >> >
> >> >When dram_base is not 2M aligned, that is broken, and it's been broken
> >> >since it was introduced in commit 3c7f255039a2ad6e ("arm64: efi: add EFI
> >> >stub") in v3.16.
> >> >
> >> >It's a bit hideous to fix the general case, though, it seems.
> >>
> >> Um, so I should I do something more in my v3 patch, or is this a
> >> change for a different patch?
> >
> > I think there should be a single patch, but please hold off v3 for a day
> > or so. I think there a few more edge cases here, and I'm currently
> > investigating.
> >
> 
> Apologies for the drive-by nature of my contributions to this thread.
> I am currently travelling.
> 
> I think the below should address both issues (and I even tried to
> compile it this time)
> 
> -----------------8<-----------------
> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> index 816120ece6bc..78dfbd34b6bf 100644
> --- a/arch/arm64/kernel/efi-stub.c
> +++ b/arch/arm64/kernel/efi-stub.c
> @@ -25,10 +25,20 @@
>         unsigned long kernel_size, kernel_memsize = 0;
>         unsigned long nr_pages;
>         void *old_image_addr = (void *)*image_addr;
> +       unsigned long preferred_offset;
> +
> +       /*
> +        * The preferred offset of the kernel Image is TEXT_OFFSET bytes beyond
> +        * a 2 MB aligned base, which itself may be lower than dram_base, as
> +        * long as the resulting offset equals or exceeds it.
> +        */
> +       preferred_offset = round_down(dram_base, SZ_2M) + TEXT_OFFSET;
> +       if (preferred_offset < dram_base)
> +               preferred_offset += SZ_2M;
> 
>         /* Relocate the image, if required. */
>         kernel_size = _edata - _text;
> -       if (*image_addr != (dram_base + TEXT_OFFSET)) {
> +       if (*image_addr != preferred_offset) {
>                 kernel_memsize = kernel_size + (_end - _edata);
> 
>                 /*
> @@ -42,7 +52,7 @@
>                  * Mustang), we can still place the kernel at the address
>                  * 'dram_base + TEXT_OFFSET'.
>                  */
> -               *image_addr = *reserve_addr = dram_base + TEXT_OFFSET;
> +               *image_addr = *reserve_addr = preferred_offset;
>                 nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
>                            EFI_PAGE_SIZE;
>                 status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
> 

This looks good to me, and I've given it a spin on Juno (though I
haven't fiddled with dram_base). I trust that you will respin this as a
patch when you get the chance.

There is another (existing) problem I spotted, in that we'll sometimes
move the kernel to a worse address. If the kernel was loaded at a valid
address (i.e. image_addr % SZ_2MB == TEXT_OFFSET), but not at the
preferred offset, we try to relocate it, even if it's already at the
lowest possible address.

That doesn't break boot, so it's not as big a problem, and it's probably
better sovled with the split VA stuff.

Thanks,
Mark.
