From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] Documentation/x86: Update EFI memory region
 description
Date: Wed, 18 Nov 2015 09:18:59 +0100
Message-ID: <20151118081859.GB23844@gmail.com>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-7-git-send-email-matt@codeblueprint.co.uk>
 <20151113092210.GB19922@gmail.com>
 <20151113092906.GD2716@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151113092906.GD2716-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Fri, 13 Nov, at 10:22:10AM, Ingo Molnar wrote:
> > 
> > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > 
> > > +We map EFI runtime services in the efi_pgd PGD in the virtual range of
> > > +64Gb (arbitrarily set, can be raised if needed). The mappings are not
> > > +part of any other kernel PGD and are only available during EFI runtime
> > > +calls.
> > 
> > Is that virtual address range 0-64Gb, i.e.:
> > 
> > 	0x00000000.00000000 - 0x00000010.00000000
> > 
> > or is it somewhere else?
> 
> You've snipped the patch hunk that gives the address range used,
> 
> diff --git a/Documentation/x86/x86_64/mm.txt
> b/Documentation/x86/x86_64/mm.txt
> index 05712ac83e38..a9885bb1ac22 100644
> --- a/Documentation/x86/x86_64/mm.txt
> +++ b/Documentation/x86/x86_64/mm.txt
> @@ -16,6 +16,8 @@ ffffec0000000000 - fffffc0000000000 (=44 bits) kasan
> shadow memory (16TB)
>  ... unused hole ...
>  ffffff0000000000 - ffffff7fffffffff (=39 bits) %esp fixup stacks
>  ... unused hole ...
> +ffffffef00000000 - ffffffff00000000 (=64 GB) EFI region mapping space
> +... unused hole ...
>  ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping,
> from phys 0
>  ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
>  ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls

Ah yes - but then the text is misleading, what does 'in the virtual range of 64Gb' 
mean? A virtual memory range is a specific range of addresses - like in the table 
you extended.

A better phrasing would be something like:

 We map EFI runtime services in the 'efi_pgd' PGD in a 64Gb large virtual memory
 window (this size is arbitrary, it can be raised later if needed).

Agreed?

Thanks,

	Ingo
