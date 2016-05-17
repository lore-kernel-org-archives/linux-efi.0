From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] Create UV efi_call macros
Date: Tue, 17 May 2016 13:11:22 +0100
Message-ID: <20160517121122.GC21993@codeblueprint.co.uk>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
 <1462996545-98387-2-git-send-email-athorlton@sgi.com>
 <20160512120600.GF2728@codeblueprint.co.uk>
 <20160516225840.GL98477@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160516225840.GL98477-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 16 May, at 05:58:40PM, Alex Thorlton wrote:
> 
> I was simply re-using the efi_call implementation.  Boris suggested that
> I re-write this using the efi_call_virt macro, so I just went with that.
> It all seems to work just fine, so I don't see much reason to stray away
> from that implementation.  That being said, I'm obviously not a huge fun
> of the code duplication across the macros.  I think there's probably a
> way to minimize this, though I haven't quite worked out the best method
> yet (ideas are welcome :)

The reason I'm pressing for details is that we have a related issue
with the EFI thunking code (CONFIG_EFI_MIXED), where the function
pointer we want to call isn't accessible via the EFI System Table, see
efi_thunk().

Well, technically it *is* accessible, you just can't dereference the
services at runtime because the pointers in the tables are not 64-bit.

But the same constraints exist for EFI thunk and UV code; given a
function pointer to execute that isn't in efi.systab, setup the EFI
runtime environment and call a custom ABI function.

I haven't tested this (or thought through all the implications), but
could you look at providing a table (or something) for mapping a
function name to a ptr,func pair, e.g.

	thunk_get_time:	runtime_services32(get_time), efi64_thunk
	thunk_set_time:	runtime_services32(set_time), efi64_thunk
	...
	uv_call_func: efi.uv_systab->function, uv_efi_call_virt

which we could use in arch_efi_call_virt()? That should give us much
less code duplication and hide all this inside arch/x86.
