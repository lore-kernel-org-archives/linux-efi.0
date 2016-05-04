From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Wed, 4 May 2016 11:32:53 -0500
Message-ID: <20160504163253.GG113599@stormcage.americas.sgi.com>
References: <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160502100222.GB25669@pd.tnic>
 <20160502222719.GW113599@stormcage.americas.sgi.com>
 <20160503001036.GX113599@stormcage.americas.sgi.com>
 <20160503094820.GA27503@pd.tnic>
 <20160503184751.GE113599@stormcage.americas.sgi.com>
 <20160504103636.GA21554@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504103636.GA21554-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 04, 2016 at 12:36:36PM +0200, Borislav Petkov wrote:
> On Tue, May 03, 2016 at 01:47:51PM -0500, Alex Thorlton wrote:
> > I think this will work for us, for the most part.  Only issue is that
> > the efi_call_virt macro is only accessible from inside
> > runtime-wrappers.c.  If we could pull that macro (and whatever else it
> > needs) up to the header file, I think that might work for us.  Not sure
> > if that's the appropriate solution, but it's a start.
> 
> Should be doable. You could give it a try and see how ugly it can get.

I can do that.  I don't think it should be too bad - I just wanted to
make sure that was an appropriate move before starting to work on it.

> > Yes, I do have CONFIG_EFI_PGT_DUMP=y.  I don't *think* I see anything
> > strange in there, but I could be missing something.  I will send you a
> > full dump of my log buffer wit MLs et. al. off of Cc.
> 
> Sure.

I am sending this shortly.  Yesterday evening got away from me :)

> > Take note that the Oops bits here indicate that it was a *write* from
> > kernel space that triggered this most recent Oops, whereas the ones we
> > were hitting before were all just missing pages in the mappings.
> > 
> > This means my suggestiong about the "if(efi_scratch..." bit was wrong.
> > This issue is still rolling around in my head.  I'll address it below.
> 
> One thing I don't see in your uv_call_virt() is you're not grabbing
> efi_runtime_lock like the rest of the EFI callers do. And there's
> __wake_up_common() somewhere there in the callstack, not on the current
> frame but there's also another uv_bios_call() in there and this all
> looks like some locking issue...
> 
> So please convert it to the generic one first, do the calls as runtime
> services in drivers/firmware/efi/runtime-wrappers.c do and we can
> continue debugging.

Got it.

> > This is probably the answer for the future, when we can expect the
> > changes to these macros be merged with the mainline kernel, but I don't
> > know exactly how long it will be before that happens.
> 
> What's the hurry exactly here? You want stuff fixed in 4.6 when it
> releases in less than two weeks?

Well, in a perfect world, yes.  I realize that might be a bit of a
stretch, but we'd *really* prefer to have 4.6 not be outright broken.  I
think we might be able to get at least a few small fixes through to at
least get our machines booting.  If worse comes to worse, we can get the
fixes into -tip and then wrap back around and try to fix up 4.6 in a
later stable kernel release.  I guess the best we can do is try to work
quickly and see where things end up.

> Lemme try to understand the fallout range: that's only UV1 or UV3 too?
> Because the latest oops comes from UV3...
> 
> If it is UV1 only, I'd say we don't care since you guys wanted to even
> kill that support :-)

Sorry, I may not have made this clear.  Currently *all* UVs *except* for
UV1s are broken.  All of the testing I've done since we started
discussing this issue has been done on a UV3000, but everything >= UV2
is currently broken.

> Btw, does "efi=old_memmap" fix things and could it be used as an interim
> workaround until we've fixed everything properly and stuff has trickled
> into -stable.?

Unfortunately, without the call for map_low_mmrs, even that doesn't
work.  I think that's an easy fix that we might be able to get in for
4.6 though.  It's literally a one-liner.  I'm going to try to get that
out today, so at least our old workaround still works.  I think it might
still have some trouble with modules doing EFI calls, but I'd be at
least halfway happy if the machine boots :)

- Alex
