From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: issue with MEMBLOCK_NOMAP
Date: Fri, 29 Jan 2016 12:57:15 -0500
Message-ID: <1454090235.2821.66.camel@redhat.com>
References: <1454076020.2821.39.camel@redhat.com>
	 <CAKv+Gu97eRFX80+mvFpv85Zc0=B=aa-LXM6KcNAQ+6Kxz3ZTZQ@mail.gmail.com>
	 <1454082787.2821.58.camel@redhat.com>
	 <CAKv+Gu-QMewJT5wyKTYy3QsgsO3nWtSGJ3XKy-6DHsWEwJ-9xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-QMewJT5wyKTYy3QsgsO3nWtSGJ3XKy-6DHsWEwJ-9xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2016-01-29 at 17:16 +0100, Ard Biesheuvel wrote:
> On 29 January 2016 at 16:53, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 2016-01-29 at 15:06 +0100, Ard Biesheuvel wrote:
> > > On 29 January 2016 at 15:00, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > > > Hi Ard,
> > > >=20
> > > > I ran into an issue with your MEMBLOCK_NOMAP changes on a parti=
cular
> > > > firmware. The symptom is the kernel panics at boot time when it=
 hits
> > > > an unmapped page while unpacking the initramfs. As it turns out=
, the
> > > > start of the initramfs shares a 64k kernel page with the UEFI m=
emmap.
> > > > I can avoid the problem with:
> > > >=20
> > > > @@ -203,7 +203,7 @@ void __init efi_init(void)
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0reserve_regions=
();
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0early_memunmap(=
memmap.map, params.mmap_size);
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memblock_mark_nomap(=
params.mmap & PAGE_MASK,
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0PAGE_ALIGN(params.mmap_size +
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0(params.mmap & ~PAGE_MASK)));
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memblock_reserve(par=
ams.mmap & PAGE_MASK,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0PAGE_ALIGN(params.mmap_size +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0(params.mmap & ~PAGE_MASK)));
> > > > =C2=A0}
> > > >=20
> > > >=20
> > > > But it makes me worry about the same potential problem with
> > > > other reserved regions which we nomap. What do you think?
> > > >=20
> > >=20
> > > So I take it this initramfs allocation is not made by the stub bu=
t by
> > > GRUB? Since the stub rounds all allocations to 64 KB ...
> > >=20
> > Yes. GRUB.
> >=20
>=20
> We have already fixed EDK2 a while ago to round up all regions
> returned by AllocatePages() to round up to 64 KB. Do you know if this
> is a GRUB issue (i.e., it traverses the memory map and finds a free
> range and explicitly allocates it) or a firmware issue?

Grub uses AllocatePages() to get memory for the initrd. The firmware
that hit this was fairly old (released last May I think). The problem
didn't show up on newer firmware for same platform but that doesn't
really mean anything definitive.

>=20
> > > In any case, regardless of the underlying cause, if any part of t=
he
> > > initramfs turns out not to be covered by the linear mapping, we s=
hould
> > > invoke your code to move it. So I think it should be a matter of
> > > refining the logic in relocate_initrd() to do the right thing in =
this
> > > case
> >=20
> > That thought had crossed my mind. I think it would be easy enough t=
o
> > trigger the copy if first or last page of initrd is unmapped.
>=20
> Indeed. If some page in the middle is missing, then you're really
> doing something fishy, so I don't see why we should care about that a=
s
> well.
>=20
> > Somewhat
> > related to this is that I want to rework this old patch to deal wit=
h
> > acpi tables outside mapped ram:
> >=20
> > =C2=A0 https://lkml.org/lkml/2015/5/14/357
> >=20
> > Basically, we should be able to just do:
> >=20
> > diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm=
/acpi.h
> > index 15e0aad..4ea638c 100644
> > --- a/arch/arm64/include/asm/acpi.h
> > +++ b/arch/arm64/include/asm/acpi.h
> > @@ -32,7 +32,7 @@
> > =C2=A0static inline void __iomem *acpi_os_ioremap(acpi_physical_add=
ress phys,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0acpi_size size)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!page_is_ram(phys >>=
 PAGE_SHIFT))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!memblock_is_memory(=
phys))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return ioremap(phys, size);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ioremap_cach=
e(phys, size);
> >=20
>=20
> I think we should fix acpi_os_ioremap(). IIRC it is used via two
> different code paths that distinguish between memory and I/O, and end
> up using the same function for no good reason.

I remember this being mentioned before. It would be a nice solution.

>=20
> > But this doesn't currently work wrt mem=3D which works by removing
> > the end range of memblocks. If I have mem=3D use the nomap flag
> > rather than removing the range, the above acpi_os_ioremap change
> > works, but other issues crop up due to memblock_end_of_DRAM()
> > returning end of all DRAM regardless of mem=3D. So we end up with
> > PFNs and struct pages for memory which will never be in linear
> > map. Fixing memblock_end_of_DRAM() to look at the flags and
> > return end of mapped DRAM gets things working but I wonder about
> > other potential trouble spots with this approach. Any thoughts?
> >=20
>=20
> Actually, I think mem=3D should be considered a development feature, =
not
> a production feature, and if its use is suboptimal in this respect, s=
o
> be it.

It is mostly a devel/debug feature but the production case is
with kdump where the kexec'd kernel gathering the dump info has
to be restricted to its own sandbox.

>=20
> But to address this particular issue, it would probably be better to
> fix page_is_ram(). I have made some attempts in that direction in the
> past, but that never landed anywhere. Since ACPI on arm64 is tightly
> coupled to UEFI, implementing page_is_ram() as something that
> interrogates the UEFI memory map if efi_enabled(EFI_MEMMAP) would be
> reasonable imo. (Or perhaps putting that in acpi_os_ioremap()
> directly?)
>=20
> >=20
> > >=20
> > > Your suggested change will break 32-bit ARM, since we use
> > > ioremap_nocache() to map the UEFI memory map, and ARM does not al=
low
> > > that on ranges that are part of the linear mapping.
> >=20
> > okay. I'll put together a patch to the initrd relocating code.
> >=20
>=20
> Great!
