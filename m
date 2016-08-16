From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Tue, 16 Aug 2016 07:50:10 +0200
Message-ID: <20160816055010.GB7911@nazgul.tnic>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
 <20160815124258.GF30909@codeblueprint.co.uk>
 <20160815150709.GA6085@nazgul.tnic>
 <20160815184731.GS214806@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160815184731.GS214806-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 15, 2016 at 01:47:31PM -0500, Alex Thorlton wrote:
> The only thing we're adding here is the physical mappings, to match
> what is availble in the primary kernel.

I can see what it does - I just am questioning the reasoning for as we
did all that effort so that kexec can have stable virtual mappings.

I guess we still need a way to pass the virtual mappings to kexec
as they're immutable as some "smartass" decided to allow to call
SetVirtualAddressMap only once.

> This is sort of a hand-wavey answer - I will investigate the his further...

Yeah, it'll be interesting to know whether that is an issue because if
we do the 1:1 mappings in the kexec kernel too and there's an address
conflict, then we better know upfront.

> It's not that we need it all of the sudden, necessarily, it's just that
> we've had to make other changes to make things work with the new,
> (almost) completely isolated, EFI page tables.  We ended up choosing the
> lesser of two evils, and have decided to temporarily rely on the
> physical address of our runtime code, instead of continuing to rely on
> EFI_OLD_MEMMAP.

Well, if it starts to cause trouble, you probably will have to revert.

> If there are strong objections to this change, I won't pursue it
> further.

I don't really care all that much as long as it doesn't break the
existing situation. I've long given up on the hope that EFI and all its
incarnations will hold on to some spec... :-)

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
