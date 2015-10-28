From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64: efi: make sure vmlinux load address aligned on
 2MBytes
Date: Wed, 28 Oct 2015 17:26:19 +0000
Message-ID: <20151028172619.GA26777@leverpostej>
References: <1445981041-8774-1-git-send-email-timur@codeaurora.org>
 <CAKv+Gu_ivkemFva-Fu0E24mQqE-m0jPWBzo5OZAr7cyM08hqug@mail.gmail.com>
 <563101DD.8080508@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <563101DD.8080508-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 28, 2015 at 12:11:57PM -0500, Timur Tabi wrote:
> On 10/27/2015 09:06 PM, Ard Biesheuvel wrote:
> >
> >diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> >index 816120ece6bc..a60ce249cfc0 100644
> >--- a/arch/arm64/kernel/efi-stub.c
> >+++ b/arch/arm64/kernel/efi-stub.c
> >@@ -42,7 +42,8 @@
> >                  * Mustang), we can still place the kernel at the address
> >                  * 'dram_base + TEXT_OFFSET'.
> >                  */
> >-               *image_addr = *reserve_addr = dram_base + TEXT_OFFSET;
> >+               *image_addr = *reserve_addr = round_up(dram_base, SZ_2M) +
> >+                                                      TEXT_OFFSET);
> >                 nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
> >                            EFI_PAGE_SIZE;
> >                 status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
> 
> Tested-by: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Tested-by: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

I assume with the trailing ')' removed. ;)

With that:

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

> However, I think this formatting is easier to read:
> 
> 		*image_addr = *reserve_addr =
> 			round_up(dram_base, SZ_2M) + TEXT_OFFSET;

I have no strong feeling on this either way.

> This does make the kernel boot, but we suspect that there may be
> another problem.  We need to investigate it, but we have a suspicion
> that the EFI stub is trying to allocate from the Runtime Data block,
> and the alignment adjustment "fixes" the problem by moving the
> pointer to Conventional Memory.

I don't follow. EFI_BOOT_SERVICES.AllocatePages() should only give us
pages which are available, so it shouldn't ever return pages which are
runtime data -- it would fail and we'd fall back to efi_low_alloc().

Could you elaborate?

> Anyway, is there any chance we can get this fix into 4.3?  I'd hate
> to have 4.3 released knowing that it's broken on our hardware.

It's probably too late now, but it should certainly be Cc'd stable and
get backported.

Thanks,
Mark.
