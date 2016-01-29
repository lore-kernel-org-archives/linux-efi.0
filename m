From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: issue with MEMBLOCK_NOMAP
Date: Fri, 29 Jan 2016 19:09:30 +0100
Message-ID: <CAKv+Gu8UZZJN2Gortb0qoPgFJveBDXeVA7uX5pXDULbGaOQoLg@mail.gmail.com>
References: <1454076020.2821.39.camel@redhat.com>
	<CAKv+Gu97eRFX80+mvFpv85Zc0=B=aa-LXM6KcNAQ+6Kxz3ZTZQ@mail.gmail.com>
	<1454082787.2821.58.camel@redhat.com>
	<CAKv+Gu-QMewJT5wyKTYy3QsgsO3nWtSGJ3XKy-6DHsWEwJ-9xg@mail.gmail.com>
	<1454090235.2821.66.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454090235.2821.66.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 January 2016 at 18:57, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2016-01-29 at 17:16 +0100, Ard Biesheuvel wrote:
>> On 29 January 2016 at 16:53, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Fri, 2016-01-29 at 15:06 +0100, Ard Biesheuvel wrote:
>> > > On 29 January 2016 at 15:00, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > > > Hi Ard,
>> > > >
>> > > > I ran into an issue with your MEMBLOCK_NOMAP changes on a particular
>> > > > firmware. The symptom is the kernel panics at boot time when it hits
>> > > > an unmapped page while unpacking the initramfs. As it turns out, the
>> > > > start of the initramfs shares a 64k kernel page with the UEFI memmap.
>> > > > I can avoid the problem with:
>> > > >
>> > > > @@ -203,7 +203,7 @@ void __init efi_init(void)
>> > > >
>> > > >         reserve_regions();
>> > > >         early_memunmap(memmap.map, params.mmap_size);
>> > > > -       memblock_mark_nomap(params.mmap & PAGE_MASK,
>> > > > -                           PAGE_ALIGN(params.mmap_size +
>> > > > -                                      (params.mmap & ~PAGE_MASK)));
>> > > > +       memblock_reserve(params.mmap & PAGE_MASK,
>> > > > +                        PAGE_ALIGN(params.mmap_size +
>> > > > +                                   (params.mmap & ~PAGE_MASK)));
>> > > >  }
>> > > >
>> > > >
>> > > > But it makes me worry about the same potential problem with
>> > > > other reserved regions which we nomap. What do you think?
>> > > >
>> > >
>> > > So I take it this initramfs allocation is not made by the stub but by
>> > > GRUB? Since the stub rounds all allocations to 64 KB ...
>> > >
>> > Yes. GRUB.
>> >
>>
>> We have already fixed EDK2 a while ago to round up all regions
>> returned by AllocatePages() to round up to 64 KB. Do you know if this
>> is a GRUB issue (i.e., it traverses the memory map and finds a free
>> range and explicitly allocates it) or a firmware issue?
>
> Grub uses AllocatePages() to get memory for the initrd. The firmware
> that hit this was fairly old (released last May I think). The problem
> didn't show up on newer firmware for same platform but that doesn't
> really mean anything definitive.
>

Indeed. I added the alignment in EDK2 to ensure that runtime regions
are aligned to 64 KB but there is no requirement to that effect for
LoaderData, which I presume is what is used for the initramfs

>>
>> > > In any case, regardless of the underlying cause, if any part of the
>> > > initramfs turns out not to be covered by the linear mapping, we should
>> > > invoke your code to move it. So I think it should be a matter of
>> > > refining the logic in relocate_initrd() to do the right thing in this
>> > > case
>> >
>> > That thought had crossed my mind. I think it would be easy enough to
>> > trigger the copy if first or last page of initrd is unmapped.
>>
>> Indeed. If some page in the middle is missing, then you're really
>> doing something fishy, so I don't see why we should care about that as
>> well.
>>
>> > Somewhat
>> > related to this is that I want to rework this old patch to deal with
>> > acpi tables outside mapped ram:
>> >
>> >   https://lkml.org/lkml/2015/5/14/357
>> >
>> > Basically, we should be able to just do:
>> >
>> > diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
>> > index 15e0aad..4ea638c 100644
>> > --- a/arch/arm64/include/asm/acpi.h
>> > +++ b/arch/arm64/include/asm/acpi.h
>> > @@ -32,7 +32,7 @@
>> >  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
>> >                                             acpi_size size)
>> >  {
>> > -       if (!page_is_ram(phys >> PAGE_SHIFT))
>> > +       if (!memblock_is_memory(phys))
>> >                 return ioremap(phys, size);
>> >
>> >         return ioremap_cache(phys, size);
>> >
>>
>> I think we should fix acpi_os_ioremap(). IIRC it is used via two
>> different code paths that distinguish between memory and I/O, and end
>> up using the same function for no good reason.
>
> I remember this being mentioned before. It would be a nice solution.
>

Indeed. I'll have a look into this on Monday

>>
>> > But this doesn't currently work wrt mem= which works by removing
>> > the end range of memblocks. If I have mem= use the nomap flag
>> > rather than removing the range, the above acpi_os_ioremap change
>> > works, but other issues crop up due to memblock_end_of_DRAM()
>> > returning end of all DRAM regardless of mem=. So we end up with
>> > PFNs and struct pages for memory which will never be in linear
>> > map. Fixing memblock_end_of_DRAM() to look at the flags and
>> > return end of mapped DRAM gets things working but I wonder about
>> > other potential trouble spots with this approach. Any thoughts?
>> >
>>
>> Actually, I think mem= should be considered a development feature, not
>> a production feature, and if its use is suboptimal in this respect, so
>> be it.
>
> It is mostly a devel/debug feature but the production case is
> with kdump where the kexec'd kernel gathering the dump info has
> to be restricted to its own sandbox.
>

Well, with the upcoming changes for KASLR, mem= is not guaranteed to
reserve the memory you expect. It would be much better to define more
unambiguously which region is available for the kexec kernel.

>>
>> But to address this particular issue, it would probably be better to
>> fix page_is_ram(). I have made some attempts in that direction in the
>> past, but that never landed anywhere. Since ACPI on arm64 is tightly
>> coupled to UEFI, implementing page_is_ram() as something that
>> interrogates the UEFI memory map if efi_enabled(EFI_MEMMAP) would be
>> reasonable imo. (Or perhaps putting that in acpi_os_ioremap()
>> directly?)
>>
>> >
>> > >
>> > > Your suggested change will break 32-bit ARM, since we use
>> > > ioremap_nocache() to map the UEFI memory map, and ARM does not allow
>> > > that on ranges that are part of the linear mapping.
>> >
>> > okay. I'll put together a patch to the initrd relocating code.
>> >
>>
>> Great!
>
