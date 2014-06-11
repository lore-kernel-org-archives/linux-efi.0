From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: efi_call on SGI
Date: Wed, 11 Jun 2014 12:32:33 -0500
Message-ID: <20140611173233.GE3275@sgi.com>
References: <20140609200017.GD2700@sgi.com>
 <20140610080300.GA28607@pd.tnic>
 <20140610204414.GB29302@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140610204414.GB29302-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 10, 2014 at 10:44:14PM +0200, Borislav Petkov wrote:
> Btw,
> 
> while we're at it, I see uv_bios_call is sometimes done with preemption
> disabled around it and sometimes it is not (at least I don't see it)...
> 
> In any case, if SGI uses the EFI pagetable now too, you probably would
> want to do the efi calls like the rest of x86 does them - see the 64-bit
> version of efi_call_virt() in arch/x86/include/asm/efi.h for an example
> what I mean.
> 
> Now, you could either copy that macro or you could accomodate it to
> serve everyone's needs - depends on what you'd prefer.
> 
> I'm just saying - I had stumbled across this while the debugging session
> was going on and wanted to point that out but it wasn't too important at
> the time so...

Thanks, Boris.  I'll take a look at that.  I'm not sure why we would've
chosen to do things differently there; wouldn't have been around for
that, but I'll see if we can fix things up so that we're doing
everything the way that everyone else is.

- Alex
