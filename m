From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/2] arm64: don't make early_*map() calls post
 paging_init()
Date: Wed, 7 Jan 2015 13:13:06 +0000
Message-ID: <CAKv+Gu9NRRFZG0S6oFJqPG1+1O2-SZah4wqoi0YPofL33X3nJw@mail.gmail.com>
References: <1420551673-31416-1-git-send-email-leif.lindholm@linaro.org>
 <1420551673-31416-2-git-send-email-leif.lindholm@linaro.org>
 <1420576522.16211.30.camel@t520.localdomain>
 <20150107105841.GE7485@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150107105841.GE7485@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 7 January 2015 at 10:58, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Jan 06, 2015 at 08:35:22PM +0000, Mark Salter wrote:
>> On Tue, 2015-01-06 at 13:41 +0000, Leif Lindholm wrote:
>> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> > index 6fac253..e311066 100644
>> > --- a/arch/arm64/kernel/efi.c
>> > +++ b/arch/arm64/kernel/efi.c
>> > @@ -313,17 +313,26 @@ void __init efi_init(void)
>> >     memmap.desc_size = params.desc_size;
>> >     memmap.desc_version = params.desc_ver;
>> >
>> > -   if (uefi_init() < 0)
>> > -           return;
>> > +   if (uefi_init() >= 0)
>> > +           reserve_regions();
>> >
>> > -   reserve_regions();
>> > +   early_memunmap(memmap.map, params.mmap_size);
>> >  }
>> >
>> > -void __init efi_idmap_init(void)
>> > +void __init efi_memmap_init(void)
>> >  {
>> > +   u64 mapsize;
>> > +
>> >     if (!efi_enabled(EFI_BOOT))
>> >             return;
>> >
>> > +   /* replace early memmap mapping with permanent mapping */
>> > +   mapsize = memmap.map_end - memmap.map;
>> > +   memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
>> > +                                              mapsize);
>>
>> ioremap_cache() could potententially fail here if the phys_map address
>> doesn't have a valid pfn (not in the kernel linear ram mapping) because
>> some of the underlying vm support hasn't been initialized yet.
>
> Can you be more specific about the case you have in mind, please? pfn_valid
> uses the memblocks on arm64, and that should all have been sorted out in
> paging_init(). What's the issue that you're anticipating?
>

I think Mark's concern is that it is too early to call
__get_free_page(), which is what happens if ioremap_cache() finds that
the requested address is not covered by the existing linear mapping.
Currently, UEFI reserved RAM regions are covered by the linear
mapping, but that is something we intend to change in the future.

-- 
Ard.
