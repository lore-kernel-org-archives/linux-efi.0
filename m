From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Mon, 19 Sep 2016 09:56:36 +0100
Message-ID: <20160919085547.GA11118@leverpostej>
References: <1474005912.3930.10.camel@gmail.com>
 <20160916093149.GC16797@codeblueprint.co.uk>
 <1474020059.3881.3.camel@gmail.com>
 <20160916143007.GF16797@codeblueprint.co.uk>
 <20160916144519.GA3179@leverpostej>
 <1474050376.3903.17.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474050376.3903.17.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 16, 2016 at 08:26:16PM +0200, Mike Galbraith wrote:
> On Fri, 2016-09-16 at 15:45 +0100, Mark Rutland wrote:
> 
> > > diff --git a/arch/x86/platform/efi/quirks.c
> > > b/arch/x86/platform/efi/quirks.c
> > > index f14b7a9da24b..e881b4b2ffd6 100644
> > > --- a/arch/x86/platform/efi/quirks.c
> > > +++ b/arch/x86/platform/efi/quirks.c
> > > @@ -201,8 +201,10 @@ void __init efi_arch_mem_reserve(phys_addr_t
> > > addr, u64 size)
> > >  		return;
> > >  	}
> > >  
> > > +	size = round_up(size, EFI_PAGE_SIZE);
> > 
> > i.e. have:
> > 
> > 	size += addr % EFI_PAGE_SIZE;
> > 	size = round_up(size, EFI_PAGE_SIZE);
> > 	addr = round_down(base, EFI_PAGE_SIZE);
>                           ^^^^
> 
> s/base/addr did work, was that what you meant to write, or am I lucky? 

That was what I meant to write, though the two statements aren't
necessarily mutually exclusive. ;)

I'll have to leave it to you and Matt to figure out what the real
solution is -- I'm not familiar with this code and was just
pattern-matching.

Thanks,
Mark.
