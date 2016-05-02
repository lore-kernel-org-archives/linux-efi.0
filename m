From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Mon, 2 May 2016 17:27:19 -0500
Message-ID: <20160502222719.GW113599@stormcage.americas.sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160502100222.GB25669@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160502100222.GB25669-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 02, 2016 at 12:02:22PM +0200, Borislav Petkov wrote:
> On Fri, Apr 29, 2016 at 10:41:19AM -0500, Alex Thorlton wrote:
> > You can see here that we've made it past the MMR read in uv_system_init,
> > but we die inside of our first EFI callback.  In this example, it looks
> > like we're using the kernel page table at the time of the failure, and I
> > believe that the failing address is somewhere in our EFI runtime code:
> 
> I think I see what's going on:
> 
> [    5.367290] PGD 1f81067 PUD 87ffff067 PMD 87fff8067 PTE 0
> 
> PTE 0 because, most probably, you need to sync
> efi_sync_low_kernel_mappings(). Why?
> 
> So the point of time this call is done, is, IINM, after we have
> enabled virtual mode. I.e., it is being done in start_kernel() and
> your callstack points at rest_init() which happens later in that same
> function.
> 
> So IMO what you should be doing, instead, is doing efi_call_virt() in
> uv_bios_call() which should take care of everything.
> 
> I think this naked efi_call() in uv_bios_call() should not be there
> but UV should be calling the _phys or _virt helpers from the EFI core.
> 
> Preferrably someone should go and audit all those EFI calls in UV and
> figure out which one to use, _phys or _virt depending on the point in
> time this call is being done.

I think you're definitely right about needing to switch to something
closer to the efi_call_virt/phys macros, but those, unfortunately, don't
work right out of the box.  The efi_call_virt macro assumes that the
function pointer being passed in is in efi.systab, but our function
pointer is in efi.uv_systab.

I'm working on getting a slightly modified efi_call_virt working, but am
having some problems with it.  I've got it switching over to the EFI
page table, but it's still giving me a bad paging request while trying
to call into our EFI code.

> For example, uv_system_init() should all be _virt calls, obviously.
> And from a quick scan, most of the EFI calls are coming from there so
> everything should be _virt.

I'll make sure we take a look at this once we've sorted out our other
issues.  Thanks for pointing this out!

> Btw, uv_bios_call_reentrant() looks unused, might want to remove it
> while at it.

I'll be sure to check this out as well.

Thanks for the help.  I'll get back to you when I know a bit more about
what's happening with our runtime callbacks!

- Alex
