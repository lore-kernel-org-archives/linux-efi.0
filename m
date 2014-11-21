From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 11/13] arm64/efi: use plain memblock API for adding
 and removing reserved RAM
Date: Fri, 21 Nov 2014 10:21:13 -0500
Message-ID: <1416583273.6398.71.camel@deneb.redhat.com>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1416315432-8534-12-git-send-email-ard.biesheuvel@linaro.org>
	 <1416504536.6398.58.camel@deneb.redhat.com>
	 <CAKv+Gu9XQWrQyPi+8=vhXWkJXtnJ+8=evNC-Z_MkWR8Wuk6Awg@mail.gmail.com>
	 <1416506069.6398.64.camel@deneb.redhat.com>
	 <CAKv+Gu_2kn10dh7LMbhVVYu8+LkMoN_Vxi-tnmCEcBTJ7qs_Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_2kn10dh7LMbhVVYu8+LkMoN_Vxi-tnmCEcBTJ7qs_Jg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2014-11-21 at 13:07 +0100, Ard Biesheuvel wrote:
> On 20 November 2014 18:54, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, 2014-11-20 at 18:38 +0100, Ard Biesheuvel wrote:
> >> On 20 November 2014 18:28, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > On Tue, 2014-11-18 at 13:57 +0100, Ard Biesheuvel wrote:
> >> >> diff --git a/drivers/firmware/efi/virtmap.c
> >> >> b/drivers/firmware/efi/virtmap.c
> >> >> index 98735fb43581..4b6a5c31629f 100644
> >> >> --- a/drivers/firmware/efi/virtmap.c
> >> >> +++ b/drivers/firmware/efi/virtmap.c
> >> >> @@ -8,6 +8,7 @@
> >> >>   */
> >> >>
> >> >>  #include <linux/efi.h>
> >> >> +#include <linux/memblock.h>
> >> >>  #include <linux/mm_types.h>
> >> >>  #include <linux/rbtree.h>
> >> >>  #include <linux/rwsem.h>
> >> >> @@ -97,8 +98,15 @@ void __init efi_virtmap_init(void)
> >> >>                 u64 paddr, npages, size;
> >> >>                 pgprot_t prot;
> >> >>
> >> >> -               if (!efi_mem_is_usable_region(md))
> >> >> +               paddr = md->phys_addr;
> >> >> +               npages = md->num_pages;
> >> >> +               memrange_efi_to_native(&paddr, &npages);
> >> >> +               size = npages << PAGE_SHIFT;
> >> >> +
> >> >> +               if (!efi_mem_is_usable_region(md)) {
> >> >>                         efi_register_mem_resource(md);
> >> >> +                       memblock_remove(paddr, size);
> >> >> +               }
> >> >
> >> > What exactly is the memblock_remove trying to accomplish? With it, I
> >> > get:
> >> >
> >>
> >> The idea was pfn_valid() will then return false for those pfns,
> >> allowing us to distinguish them from memory that the kernel may be
> >> using, primarily for /dev/mem filtering. But apparently it is causing
> >> problems for you, so I will have to figure out if there is a better
> >> way of addressing this.
> >>
> > Okay. Well I think that works for pfn_valid, but it is confusing the
> > mem_cgroup code. I think because you end up with multiple memory regions
> > after creating the holes. Earlier memory management code saw one memory
> > region. And because this comes after paging_init(), all of the memory
> > ends up in the kernel linear mapping which is something we were trying
> > to avoid.
> >
> 
> I will drop the memblock_remove() then. I guess I could make the test
> in devmem_is_allowed() do
> 
> if (!memblock_is_memory() || memblock_is_reserved())
> 
> instead of 'if (!pfn_valid())' so that reserved regions become
> accessible with having to remove them.

Maybe we should add a new memblock to keep track of uefi tables.
The memblock_is_reserved() seems overly permissive to me.

> 
> Are you happy with the other change in this patch, i.e., using
> memblock_add() directly so that we don't have to deal with the
> rounding?
> 

Yeah, I think that's okay. Everything else seems to be working fine
in my testing.
