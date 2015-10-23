From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] efi: Fix warning of int-to-pointer-cast on x86 32-bit
 builds
Date: Fri, 23 Oct 2015 10:50:11 +0200
Message-ID: <20151023085011.GB21631@gmail.com>
References: <1445593826-4578-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <CAKv+Gu8WPvG5rzBB57eK1_Ehj1wB19wR=zzBDRoQbmhRfpCGng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8WPvG5rzBB57eK1_Ehj1wB19wR=zzBDRoQbmhRfpCGng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>, Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo.kernel.org@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kamezawa.hiroyu@jp.fujitsu.com, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On 23 October 2015 at 11:50, Taku Izumi <izumi.taku@jp.fujitsu.com> wrote:
> > commit-0f96a99 introduces the following warning message:
> >
> >   drivers/firmware/efi/fake_mem.c:186:20: warning: cast to pointer
> >   from integer of different size [-Wint-to-pointer-cast]
> >
> > new_memmap_phy was defined as a u64 value and casted to void*.
> > This causes a warning of int-to-pointer-cast on x86 32-bit
> > environment.
> >
> > This patch changes the type of "new_memmap_phy" variable
> > from "u64" into "ulong" to avoid it.
> >
> > v1 -> v2:
> >  - change the type of "new_memmap_phy" from phys_addr_t
> >    into ulong according to Ard's comment
> >
> > Reported-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> > ---
> >  drivers/firmware/efi/fake_mem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
> > index 32bcb14..1f483b4 100644
> > --- a/drivers/firmware/efi/fake_mem.c
> > +++ b/drivers/firmware/efi/fake_mem.c
> > @@ -59,7 +59,7 @@ void __init efi_fake_memmap(void)
> >         u64 start, end, m_start, m_end, m_attr;
> >         int new_nr_map = memmap.nr_map;
> >         efi_memory_desc_t *md;
> > -       u64 new_memmap_phy;
> > +       ulong new_memmap_phy;
> >         void *new_memmap;
> >         void *old, *new;
> >         int i;
> 
> 
> After looking at the original (already merged) patch 11/11 again, I
> realize this is still not right: the problem is that efi_memory_map's
> phys_map member uses a void* type to hold a physical address, which
> happens to be correct in the normal case even when phys_addr_t is
> larger than void* (like on ARM with LPAE enabled) since the address it
> holds is the address of an allocation performed by the firmware, which
> only uses 1:1 addressable memory.
> 
> However, overwriting memmap.phys_map with a value produced my
> memblock_alloc() is problematic, since the allocation may be above 4
> GB on 32-bit (L)PAE platforms. So the correct way to do this would be
> to set the memblock limit to 4GB before memblock_alloc() on 32-bit
> platforms, and restore it afterwards. This is a bit of a kludge,
> though, and it would be more correct to change the type of
> efi_memory_map::phys_map to phys_addr_t, although I don't know what
> the potential fallout of that change is. Matt?
> 
> So that means your v1 of this patch is correct after all, and the
> warning spotted by Ingo uncovered a problem with the original series
> that requires an additional fix.

No, v1 is not right either. This type cast loses information:

        memmap.phys_map = (void *)new_memmap_phy;

Because there are countless platforms where 'void *' is 32-bit while physical 
addresses are wider.

No way of fudging around the type of 'new_memmap_phy' will solve that bug, it 
might only make the symptoms and the warning go away ...

The real problem is with the inappropriate (too narrow) type of memmap.phys_map, 
not with the type of new_memmap_phy. The cast just hides it.

One more page in the '1000 real-life examples of why type casts are evil' book.

Thanks,

	Ingo
