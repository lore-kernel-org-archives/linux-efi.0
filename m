From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Mon, 15 Aug 2016 17:07:09 +0200
Message-ID: <20160815150709.GA6085@nazgul.tnic>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
 <20160815124258.GF30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160815124258.GF30909-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 15, 2016 at 01:42:58PM +0100, Matt Fleming wrote:
> (Cc'ing Boris and Dave)
> 
> On Fri, 05 Aug, at 06:59:35PM, Alex Thorlton wrote:
> > This is a simple change to add in the physical mappings as well as the
> > virtual mappings in efi_map_region_fixed.  The motivation here is to
> > get access to EFI runtime code that is only available via the 1:1
> > mappings on a kexec'd kernel.

So I don't understand: the whole jumping through hoops so that we have
stable virtual mappings just so that the kexec-ed kernel can call EFI
runtime, is now useless?!

What if the physical address is occupied by the kexec kernel?

Why do you guys need the physical mapping all of a sudden?

Your patch is basically rendering all the effort moot and we could've
saved ourselves all that trouble of doing all that virtual address
mapping and done the 1:1 thing.

Which really is probably simpler since we have an EFI-specific page
table and running EFI in the kexec-ed kernel would mean basically
recreating it.

What am I missing?

commit d2f7cbe7b26a74dbbbf8f325b2a6fd01bc34032c
Author: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Date:   Thu Oct 31 17:25:08 2013 +0100

    x86/efi: Runtime services virtual mapping
    
    We map the EFI regions needed for runtime services non-contiguously,
    with preserved alignment on virtual addresses starting from -4G down
    for a total max space of 64G. This way, we provide for stable runtime
    services addresses across kernels so that a kexec'd kernel can still use
    them.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
