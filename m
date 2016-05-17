From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 1/2] Create UV efi_call macros
Date: Tue, 17 May 2016 15:14:01 -0500
Message-ID: <20160517201401.GP98477@stormcage.americas.sgi.com>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
 <1462996545-98387-2-git-send-email-athorlton@sgi.com>
 <20160512120600.GF2728@codeblueprint.co.uk>
 <20160516225840.GL98477@stormcage.americas.sgi.com>
 <20160517121122.GC21993@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160517121122.GC21993-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, May 17, 2016 at 01:11:22PM +0100, Matt Fleming wrote:
> On Mon, 16 May, at 05:58:40PM, Alex Thorlton wrote:
> > 
> > I was simply re-using the efi_call implementation.  Boris suggested that
> > I re-write this using the efi_call_virt macro, so I just went with that.
> > It all seems to work just fine, so I don't see much reason to stray away
> > from that implementation.  That being said, I'm obviously not a huge fun
> > of the code duplication across the macros.  I think there's probably a
> > way to minimize this, though I haven't quite worked out the best method
> > yet (ideas are welcome :)
> 
> The reason I'm pressing for details is that we have a related issue
> with the EFI thunking code (CONFIG_EFI_MIXED), where the function
> pointer we want to call isn't accessible via the EFI System Table, see
> efi_thunk().
> 
> Well, technically it *is* accessible, you just can't dereference the
> services at runtime because the pointers in the tables are not 64-bit.
> 
> But the same constraints exist for EFI thunk and UV code; given a
> function pointer to execute that isn't in efi.systab, setup the EFI
> runtime environment and call a custom ABI function.

I took a look at this, and see what you mean.  You pass in the same
pointer to efi_thunk, which handles essentially the same setup
stuff as efi_call_virt (sync low mappings, disable interrupts, switch
page tables), sans a few of the finer details in
arch_efi_call_virt_setup.

The separate efi_thunk macro is necessary in this case, because you
need to use the efi64_thunk call, with your runtime_service32 massaged
pointer, instead of efi_call, with a pointer straight out of
systab->runtime. This is a similar scenario to ours, in that we
need uv_efi_call instead of efi_call, with our own pointer, instead of
systab->runtime.

The only difference here is that your efi64_thunk call needs a
slightly different setup/teardown than the regular efi_call, so you
need that efi_thunk to be hacked up a bit more (compared to
efi_call_virt) than my uv_efi_call_virt macro.

IINM, we could probably make up for this discrepancy by having a
different arch_efi_call_virt_setup/teardown for the !efi_is_native case
(not sure if that is a feasible idea, correct me if that's stupid).

> I haven't tested this (or thought through all the implications), but
> could you look at providing a table (or something) for mapping a
> function name to a ptr,func pair, e.g.
> 
> 	thunk_get_time:	runtime_services32(get_time), efi64_thunk
> 	thunk_set_time:	runtime_services32(set_time), efi64_thunk
> 	...
> 	uv_call_func: efi.uv_systab->function, uv_efi_call_virt
> 
> which we could use in arch_efi_call_virt()? That should give us much
> less code duplication and hide all this inside arch/x86.

This sounds like it could be a good way to handle this.  I will need to
think about it.  Unless someone can say for certain that we can use the
same arch_efi_call_virt_setup/teardown for your efi64_thunk call that we
use for efi_call, then we'll also have to take that into account, which
might make things uglier.  Not horrible, but more complicated.

I'm starting to play with this over here to see if I can get a cleaner
implementation working.

Let me know if you have other thoughts.  Thanks for the input!

- Alex
