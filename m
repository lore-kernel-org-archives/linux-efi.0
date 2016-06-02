From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 2/3] Update uv_bios_call to use efi_call_virt_generic
Date: Thu, 2 Jun 2016 16:56:31 -0500
Message-ID: <20160602215631.GF242721@stormcage.americas.sgi.com>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
 <1463598701-178201-3-git-send-email-athorlton@sgi.com>
 <20160602194547.GK2658@codeblueprint.co.uk>
 <20160602211403.GD242721@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602211403.GD242721-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 02, 2016 at 04:14:03PM -0500, Alex Thorlton wrote:
> On Thu, Jun 02, 2016 at 08:45:47PM +0100, Matt Fleming wrote:
> > Unless I've missed it, I didn't see an explanation in the changelog of
> > why it's OK to switch from using __va(tab->function) to tab->function
> > directly, which presumably is a physical address.
> > 
> > Was that intended?
> 
> It was intended.  The motivation is so that we can use the same
> "dereference the pointer inside the macro" stuff that we do with the
> efi.systab->runtime pointer.  IINM, the reason it works is because we do
> 
> /*
>  * Make sure the 1:1 mappings are present as a catch-all for b0rked
>  * firmware which doesn't update all internal pointers after switching
>  * to virtual mode and would otherwise crap on us.
>  */
> __map_region(md, md->phys_addr);
> 
> Inside of efi_map_region, so we know we'll have that physical address
> mapped into the EFI page table.
> 
> Upon review, I'm wondering if the correct thing to do  here is to
> update that pointer during the switch to virtual mode, to avoid the
> b0rkage mentioned in the above comment.

Realizing after I typed this that the b0rkage in question is firmware
b0rkage, so the comment there doesn't really apply to this situation.

> Either way, the straigh tab->function dereference should work while
> using the EFI page table, but I do wonder if that tab->function address
> should have been updated to the __va() version of itself before we reach
> this point.

I played with this some and it's not working the way I expected.  In
thinking about it, I believe the reason is fairly obvious.  We have
already switched to the EFI page table when we try to dereference the
pointer, so if we have some ffff88.... address, it won't be mapped
(this is somewhat related to the situation that got us here in the first
place).

I think, in order for this to work, tab->function has to be either the
physical address, or the address in the ffffffef....  range that also
gets mapped in during efi_map_region.

My brain is getting close to fried for the day, so this might be utter
nonsense, but it's sounding pretty reasonable to me right now.  We'll
see how I feel about it tomorrow :)

Let me know what you think!

- Alex
