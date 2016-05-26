From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: remove spurious WARN_ON for !4K kernels
Date: Thu, 26 May 2016 11:56:52 +0100
Message-ID: <20160526105652.GD32186@leverpostej>
References: <1464189116-30898-1-git-send-email-mark.rutland@arm.com>
 <BA565A9C-8CC0-42E4-9821-7941852F835A@linaro.org>
 <20160525161207.GD30956@leverpostej>
 <CAKv+Gu94GLWUJBCtNUDb4Jak3KL0-MGkUfk82fZ5UdwWH60P_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu94GLWUJBCtNUDb4Jak3KL0-MGkUfk82fZ5UdwWH60P_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 25, 2016 at 08:23:35PM +0200, Ard Biesheuvel wrote:
> On 25 May 2016 at 18:12, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Wed, May 25, 2016 at 05:23:01PM +0200, Ard Biesheuvel wrote:
> >>
> >>
> >> > On 25 mei 2016, at 17:11, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wr=
ote:
> >> >
> >> > Since commit 1fd55a9a09b0293a ("arm64/efi: Apply strict permissi=
ons to
> >> > UEFI Runtime Services regions"), booting a !4K page kernel resul=
ts in a
> >> > boot-time splat on some systems, due to to a WARN_ONCE added in =
that
> >> > commit which fires if the base address of an EFI memory descript=
or is
> >> > not aligned to the kernel page size (which might be 4K, 16K, or =
64K).
> >> >
> >> > On page 38 of the UEFI 2.6 specification it is stated:
> >> >
> >> >    If a 64KiB physical page contains any 4KiB page with any of t=
he
> >> >    following types listed below, then all 4KiB pages in the 64Ki=
B
> >> >    page must use identical ARM Memory Page Attributes (as descri=
bed
> >> >    in Table 8):
> >> >    =E2=80=94 EfiRuntimeServicesCode
> >> >    =E2=80=94 EfiRuntimeServicesData
> >> >    =E2=80=94 EfiReserved
> >> >    =E2=80=94 EfiACPIMemoryNVS
> >> >    Mixed attribute mappings within a larger page are not allowed=
=2E
> >> >
> >>
> >> The same section mentions that the ro/xp etc attributes are unused=
 on
> >> arm, so if we go by the letter here, we need to remove those memor=
y
> >> protection features entirely. So a spec update is clearly in order
> >> here.
> >
> > Yes; that definitely needs fixing.
> >
> > FWIW, I don't think that matters in this case (assuming the usual E=
=46I
> > memory desc dump stuff prints those).
> >
> > My memory map (and the remap triggering the WARN_ONCE) look like:
> >
> > [    0.000000] efi: Getting EFI parameters from FDT:
> > [    0.000000] efi:   System Table: 0x00000083ff34bf18
> > [    0.000000] efi:   MemMap Address: 0x00000083fcefd618
> > [    0.000000] efi:   MemMap Size: 0x00000540
> > [    0.000000] efi:   MemMap Desc. Size: 0x00000030
> > [    0.000000] efi:   MemMap Desc. Version: 0x00000001
> > [    0.000000] efi: EFI v2.40 by American Megatrends
> > [    0.000000] efi:  ACPI 2.0=3D0x83ff1c3000  SMBIOS 3.0=3D0x83ff34=
7798
> > [    0.000000] efi: Processing EFI memory map:
> > [    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped =
I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> > [    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped =
I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> > [    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped =
I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> > [    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data  =
     |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
> > [    0.000000] efi:   0x008001e80000-0x008001ffffff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x008002000000-0x008002ddffff [Loader Data   =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x008002de0000-0x00801fdfffff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x00801fe00000-0x00801fe0ffff [Loader Data   =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x00801fe10000-0x00801fffbfff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x00801fffc000-0x00801fffffff [Boot Data     =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x008020000000-0x0083f0ffffff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083f1000000-0x0083f101ffff [Boot Data     =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083f1020000-0x0083fb542fff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083fb543000-0x0083fc2a2fff [Loader Code   =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083fc2a3000-0x0083fcefcfff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083fcefd000-0x0083fcefefff [Loader Data   =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083fceff000-0x0083fd01afff [Loader Code   =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083fd01b000-0x0083fea67fff [Boot Data     =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083fea68000-0x0083febd3fff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083febd4000-0x0083ff186fff [Boot Code     =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083ff187000-0x0083ff1b6fff [Reserved      =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
> > [    0.000000] efi:   0x0083ff1b7000-0x0083ff1c4fff [ACPI Reclaim M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
> > [    0.000000] efi:   0x0083ff1c5000-0x0083ff20ffff [Conventional M=
emory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083ff210000-0x0083ff224fff [Loader Data   =
     |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> > [    0.000000] efi:   0x0083ff225000-0x0083ff226fff [ACPI Memory NV=
S    |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
> > [    0.000000] efi:   0x0083ff227000-0x0083ff34bfff [Runtime Data  =
     |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
>=20
> OK, so how is this expected to work then, with the regions described
> above? Neither are covered by the linear mapping, and both have all o=
f
> {WB,WT,WC,UC} set, which means that each region can be mapped by the
> OS as any of those types.

I was under the impression that in practice, we only mapped the memory
as WB (which happens to match the attributes for the linear mapping).

Where do we use WT, WC, or UC mappings in the kernel?

> I don't know which type we use for this
> particular ACPI Memory NVS region, but it could be any of those, whil=
e
> the runtime data regions are mapped as writeback cacheable in the EFI
> page tables. So while the spec needs to be updated, I think the de
> facto conclusion is that the only way we can do this safely is to
> either force 64 KB alignment, or -as a workaround- ensure that region=
s
> that share a 64 KB page frame are limited to the same attributes in
> the OS view of the UEFI memory map.

I think that we have to do the latter, given existing systems.

I would prefer the former, and if we can get that into the spec that
would be great.

Thanks,
Mark.
