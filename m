From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Tue, 3 May 2016 13:47:51 -0500
Message-ID: <20160503184751.GE113599@stormcage.americas.sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160502100222.GB25669@pd.tnic>
 <20160502222719.GW113599@stormcage.americas.sgi.com>
 <20160503001036.GX113599@stormcage.americas.sgi.com>
 <20160503094820.GA27503@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503094820.GA27503-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, May 03, 2016 at 11:48:20AM +0200, Borislav Petkov wrote:
> On Mon, May 02, 2016 at 07:10:36PM -0500, Alex Thorlton wrote:
> > +#define uv_call_virt(f, args...) \
> > +({                                                                     \
> > +       efi_status_t __s;                                               \
> > +       kernel_fpu_begin();                                             \
> > +       __s = ((efi_##f##_t __attribute__((regparm(0)))*)               \
> > +               f)(args);                                               \
> > +       kernel_fpu_end();                                               \
> > +       __s;                                                            \
> > +})
> 
> Right, can you use the EFI-ones in
> drivers/firmware/efi/runtime-wrappers.c directly?
> 
>  (So they're going to land there, I'm staring at latest -tip and those calls
>   have become all fancy now:
> with efi_call_virt_check_flags() checking for IRQ flags corruption... And so
> on, but that's beside the point... )

I think this will work for us, for the most part.  Only issue is that
the efi_call_virt macro is only accessible from inside
runtime-wrappers.c.  If we could pull that macro (and whatever else it
needs) up to the header file, I think that might work for us.  Not sure
if that's the appropriate solution, but it's a start.

> > -       ret = efi_call((void *)__va(tab->function), (u64)which,
> > -                       a1, a2, a3, a4, a5);
> > +       ret = uv_call_virt(tab->function, (u64)which, a1, a2, a3, a4, a5);
> > +
> 
> That could be simply
> 
> 		efi_call_virt(tab->function, ...)
> 
> methinks.

Looking at the -tip code, this sounds correct.

> > [   56.232086] BUG: unable to handle kernel paging request at ffffffff8106148f
> > [   56.239880] IP: [<fffffffedbb408ce>] 0xfffffffedbb408ce
> > [   56.245721] PGD 8698e0067 PUD 1a08063 PMD 10001e1 
> 
> PMD looks ok to me.
> 
> Have you tried CONFIG_EFI_PGT_DUMP ? It will dump to dmesg so you might
> be able to spot stuff.

Yes, I do have CONFIG_EFI_PGT_DUMP=y.  I don't *think* I see anything
strange in there, but I could be missing something.  I will send you a
full dump of my log buffer wit MLs et. al. off of Cc.

Take note that the Oops bits here indicate that it was a *write* from
kernel space that triggered this most recent Oops, whereas the ones we
were hitting before were all just missing pages in the mappings.

This means my suggestiong about the "if(efi_scratch..." bit was wrong.
This issue is still rolling around in my head.  I'll address it below.

> Also, you could dump them from debugfs *right* before loading the module
> and then look at stuff.
> 
> Also 2, booting with efi=debug should give you how the EFI regions get
> mapped.

I will try both of those ideas and see if I notice anything
interesting.

> > The bad paging request here appears to be on the:
> > 
> > if (efi_scratch.use_pgd)
> > 
> > Line of uv_call_virt.  It looks like it's having trouble accessing the
> > efi_scratch struct using the EFI page table.  I'm not sure why this
> > is an issue with callbacks from modules and not with the ones in
> > uv_system_init and friends.
> 
> Just this one module or all modules doing EFI calls?

I think this is our only module that does EFI calls (at least the only
module doing EFI calls in efi.uv_systab, as opposed to efi.systab), so
I'm not sure about that.

> > I'm thinking there's probably a better way to do this than by
> > copying the whole efi_call_virt macro - this was a quick and dirty
> > solution.
> 
> Yeah, try using the generic facilities. We should be able to accomodate
> all users...

This is probably the answer for the future, when we can expect the
changes to these macros be merged with the mainline kernel, but I don't
know exactly how long it will be before that happens.

I think we really want to come up with a fix to get into the mainline
kernel, sooner, rather than later.  If that means coming up with an
interim fix, and then planning for the changes in -tip later, then we
might have to deal with that.

Even though we're still having issues with our callbacks, we have
proof-of-concept fixes for our first 2 issues.  In my mind, I think it
would be best to fix as much as possible now, just to make sure that
everything is in the best shape possible.  If this means leaving the
callbacks broken for now, that might just have to be a fact of life.

Let me know what you guys think!

- Alex
