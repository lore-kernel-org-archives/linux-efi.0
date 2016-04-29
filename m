From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Fri, 29 Apr 2016 10:45:15 -0500
Message-ID: <20160429154515.GJ113599@stormcage.americas.sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160429090115.GB2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160429090115.GB2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 29, 2016 at 10:01:15AM +0100, Matt Fleming wrote:
> On Wed, 27 Apr, at 10:41:32AM, Alex Thorlton wrote:
> > 
> > From what I know, this works because the first PGD entry (the one
> > containing the identity mappings) of the trampoline_pgd is shared with
> > the main kernel PGD (init_level4_pgt), so when __map_region maps this
> > stuff into the trampoline_pgd, we get it in the kernel PGD as well.
>  
> Correct.
> 
> > The way I understand it, the motivation behind this change is to isolate
> > the EFI runtime services code/data from the regular kernel page tables,
> 
> Yep.

Thanks for confirming my suspicions.  This one was really bothering me.

I'd rather have broken code and know why it's broken, than have working
code and not know why it works :)

> > but it appears that we've isolated a bit more than that.  I do
> > understand that if we were doing an actual EFI callback, we'd switch
> > over to the efi_pgd, where we'd have this stuff mapped in, but, until
> > now, we've been able to read these MMRs using the regular kernel page
> > table without issues.
> > 
> > Please let me know what you guys think about this issue, and if you have
> > any suggestions for possible solutions.  Any input is greatly
> > appreciated!
> 
> The issue is that you're relying on the EFI mapping code to map these
> regions for you, and that's a bug. These regions have nothing to do
> with EFI.

Understood, and agreed.

> Arguably it's always been a bug. You're not alone though, there were
> also other pieces of code piggy-backing on the EFI mapping functions,
> and EFI code piggy-backing on the regular kernel mapping functions,
> see 452308de6105 ("x86/efi: Fix boot crash by always mapping boot
> service regions into new EFI page tables").
> 
> I agree with Boris' suggestion that removing the "if (is_uv1_hub())"
> check in uv_system_init() is probably the way to go, since it should
> always be the responsibility of uv_system_init() to setup these
> mappings.

I have tried this, but there are some issues there as well (see my
response to Boris's last message).  I think we're getting closer to
having this all figured out, but there are still some pieces missing
from the puzzle.

Thanks for the input, Matt.  Please let me know if you have any ideas
about the remaining issue that I described!

- Alex
