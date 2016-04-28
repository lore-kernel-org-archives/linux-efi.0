From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Thu, 28 Apr 2016 14:57:11 +0200
Message-ID: <20160428125711.GB9164@pd.tnic>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160428014128.GF113599-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 27, 2016 at 08:41:28PM -0500, Alex Thorlton wrote:
> In this particular instance, it's not using the EFI page table - it's
> showing that the register isn't mapped into the main kernel page tabl=
e,
> via the bad paging request.  The issue isn't that there's something
> wrong with the EFI page table, but that something appears to be missi=
ng
> from the kernel table.

So my question stands: you said 67a9108ed4313 is causing this and this
commit creates an EFI-specific page table and that shouldn't have
anything to do with how the MMR stuff is mapped, should it?

> Well, quite a while back, these MMRs got mapped in using
> init_extra_mapping_uc in map_low_mmrs.  Back then, yes, they were map=
ped
> straight into the kernel page table.
>=20
> After d2f7cbe7b26a74 ("x86/efi: Runtime services virtual mapping") wa=
s
> introduced (I'm sure you remember the BIOS issue we had a while back)=
 we
> had to fall back to using EFI_OLD_MEMMAP, so for a while we relied on
> efi_ioremap.

Hmm, but you see my confusion, right? Why is init_extra_mapping_uc()
influenced by the EFI changes? It uses __init_extra_mapping() and it
maps into init_mm's pgd.

> Eventually we got a BIOS fix that allowed us to start using the new
> memmap scheme, at which point we removed the init_extra_mapping_uc()s=
,
> since the efi_map_region code appeared to be doing what we needed.

Why would you even do that? Why are you even mapping MMRs using EFI
facilities?

I'm more confused today.

So what I see from here is this:

* MMRs and EFI shouldn't have anything in common. Imagine there were an
UV box without EFI (you probably are going to say there's no such thing
but imagine anyway): how are you going to map the MMR space then?

* I think you should restore the old case where you mapped the MMRs
using init_extra_mapping_uc().

And I think

  d394f2d9d8e1 ("x86/platform/UV: Remove EFI memmap quirk for UV2+")

was wrong in doing

+       if (is_uv1_hub())
+               map_low_mmrs();

for the simple fact that MMRs mapping and EFI shouldn't depend on one
another.

So the proper fix would be to remove the if- check.

Or am I missing something here and MMRs need EFI?

 (However, UV1 apparently works fine without it).

Right?

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--=20
