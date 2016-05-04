From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Wed, 4 May 2016 12:36:36 +0200
Message-ID: <20160504103636.GA21554@pd.tnic>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160502100222.GB25669@pd.tnic>
 <20160502222719.GW113599@stormcage.americas.sgi.com>
 <20160503001036.GX113599@stormcage.americas.sgi.com>
 <20160503094820.GA27503@pd.tnic>
 <20160503184751.GE113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503184751.GE113599-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, May 03, 2016 at 01:47:51PM -0500, Alex Thorlton wrote:
> I think this will work for us, for the most part.  Only issue is that
> the efi_call_virt macro is only accessible from inside
> runtime-wrappers.c.  If we could pull that macro (and whatever else i=
t
> needs) up to the header file, I think that might work for us.  Not su=
re
> if that's the appropriate solution, but it's a start.

Should be doable. You could give it a try and see how ugly it can get.

> Yes, I do have CONFIG_EFI_PGT_DUMP=3Dy.  I don't *think* I see anythi=
ng
> strange in there, but I could be missing something.  I will send you =
a
> full dump of my log buffer wit MLs et. al. off of Cc.

Sure.

> Take note that the Oops bits here indicate that it was a *write* from
> kernel space that triggered this most recent Oops, whereas the ones w=
e
> were hitting before were all just missing pages in the mappings.
>=20
> This means my suggestiong about the "if(efi_scratch..." bit was wrong=
=2E
> This issue is still rolling around in my head.  I'll address it below=
=2E

One thing I don't see in your uv_call_virt() is you're not grabbing
efi_runtime_lock like the rest of the EFI callers do. And there's
__wake_up_common() somewhere there in the callstack, not on the current
frame but there's also another uv_bios_call() in there and this all
looks like some locking issue...

So please convert it to the generic one first, do the calls as runtime
services in drivers/firmware/efi/runtime-wrappers.c do and we can
continue debugging.

> This is probably the answer for the future, when we can expect the
> changes to these macros be merged with the mainline kernel, but I don=
't
> know exactly how long it will be before that happens.

What's the hurry exactly here? You want stuff fixed in 4.6 when it
releases in less than two weeks?

Lemme try to understand the fallout range: that's only UV1 or UV3 too?
Because the latest oops comes from UV3...

If it is UV1 only, I'd say we don't care since you guys wanted to even
kill that support :-)

Btw, does "efi=3Dold_memmap" fix things and could it be used as an inte=
rim
workaround until we've fixed everything properly and stuff has trickled
into -stable.?

Thanks.

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--=20
