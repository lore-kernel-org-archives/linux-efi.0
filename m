From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] x86/efi: always map first physical page into EFI
 pagetables
Date: Wed, 25 Jan 2017 21:36:43 +0100
Message-ID: <20170125203643.tjrql7hekcnpt4u2@pd.tnic>
References: <alpine.LSU.2.20.1701252048550.25515@cbobk.fhfr.pm>
 <alpine.LSU.2.20.1701252130410.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1701252130410.25515-YHPUNQjx9ReKbouaWp301Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>, Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 25, 2017 at 09:31:53PM +0100, Jiri Kosina wrote:
> 
> [ CCing mailinglists that got eaten by my newly configured mail setup, 
>   sorry for that ]
> 
> On Wed, 25 Jan 2017, Jiri Kosina wrote:
> 
> > From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> > 
> > Commit 129766708 ("x86/efi: Only map RAM into EFI page tables if in 
> > mixed-mode") stopped creating 1:1 mapping for all RAM in case of running 
> > in native 64bit mode.
> > 
> > It turns out though that there are 64bit EFI implementations in the wild 
> > (this particular problem has been reported on Lenovo Yoga 710-11IKB) which 
> > still make use of first physical page for their own private use (which is 
> > what legacy BIOS used to do, but EFI specification doesn't grant any such 
> > right to EFI BIOS ... oh well).

And now the same rant for the wider audience:

What is this EFI spec even? Toilet paper? Perhaps not even that.

Geez, can we simply say, firmware people, you f*cked up big time. Now
take all that crap with you to your basement, *think* hard about all the
issues we've had and then reengineer the whole thing from the beginning.
Completely anew. Then come back and we can talk.

There's a reason I don't want to deal with that major stinking pile of
crap called firmware but somehow I always get sucked back in.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
