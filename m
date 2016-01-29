From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: issue with MEMBLOCK_NOMAP
Date: Fri, 29 Jan 2016 10:53:07 -0500
Message-ID: <1454082787.2821.58.camel@redhat.com>
References: <1454076020.2821.39.camel@redhat.com>
	 <CAKv+Gu97eRFX80+mvFpv85Zc0=B=aa-LXM6KcNAQ+6Kxz3ZTZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu97eRFX80+mvFpv85Zc0=B=aa-LXM6KcNAQ+6Kxz3ZTZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2016-01-29 at 15:06 +0100, Ard Biesheuvel wrote:
> On 29 January 2016 at 15:00, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi Ard,
> >=20
> > I ran into an issue with your MEMBLOCK_NOMAP changes on a particula=
r
> > firmware. The symptom is the kernel panics at boot time when it hit=
s
> > an unmapped page while unpacking the initramfs. As it turns out, th=
e
> > start of the initramfs shares a 64k kernel page with the UEFI memma=
p.
> > I can avoid the problem with:
> >=20
> > @@ -203,7 +203,7 @@ void __init efi_init(void)
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0reserve_regions();
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0early_memunmap(memm=
ap.map, params.mmap_size);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memblock_mark_nomap(para=
ms.mmap & PAGE_MASK,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0PAGE_ALIGN(params.mmap_size +
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0(params.mmap & ~PAGE_MASK)));
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memblock_reserve(params.=
mmap & PAGE_MASK,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0PAGE_ALIGN(params.mmap_size +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
(params.mmap & ~PAGE_MASK)));
> > =C2=A0}
> >=20
> >=20
> > But it makes me worry about the same potential problem with
> > other reserved regions which we nomap. What do you think?
> >=20
>=20
> So I take it this initramfs allocation is not made by the stub but by
> GRUB? Since the stub rounds all allocations to 64 KB ...
>=20
Yes. GRUB.

> In any case, regardless of the underlying cause, if any part of the
> initramfs turns out not to be covered by the linear mapping, we shoul=
d
> invoke your code to move it. So I think it should be a matter of
> refining the logic in relocate_initrd() to do the right thing in this
> case

That thought had crossed my mind. I think it would be easy enough to
trigger the copy if first or last page of initrd is unmapped. Somewhat
related to this is that I want to rework this old patch to deal with
acpi tables outside mapped ram:

=C2=A0=C2=A0https://lkml.org/lkml/2015/5/14/357

Basically, we should be able to just do:

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acp=
i.h
index 15e0aad..4ea638c 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -32,7 +32,7 @@
=C2=A0static inline void __iomem *acpi_os_ioremap(acpi_physical_address=
 phys,
=C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0acpi_size size)
=C2=A0{
-	if (!page_is_ram(phys >> PAGE_SHIFT))
+	if (!memblock_is_memory(phys))
=C2=A0		return ioremap(phys, size);
=C2=A0
=C2=A0	return ioremap_cache(phys, size);

But this doesn't currently work wrt mem=3D which works by removing
the end range of memblocks. If I have mem=3D use the nomap flag
rather than removing the range, the above acpi_os_ioremap change
works, but other issues crop up due to memblock_end_of_DRAM()
returning end of all DRAM regardless of mem=3D. So we end up with
PFNs and struct pages for memory which will never be in linear
map. Fixing memblock_end_of_DRAM() to look at the flags and
return end of mapped DRAM gets things working but I wonder about
other potential trouble spots with this approach. Any thoughts?


>=20
> Your suggested change will break 32-bit ARM, since we use
> ioremap_nocache() to map the UEFI memory map, and ARM does not allow
> that on ranges that are part of the linear mapping.

okay. I'll put together a patch to the initrd relocating code.

Thanks!
