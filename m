From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 21 Oct 2015 21:38:07 +0100
Message-ID: <20151021203807.GA20338@codeblueprint.co.uk>
References: <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic>
 <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <20151014210257.GF2782@codeblueprint.co.uk>
 <20151021094242.GA12155@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151021094242.GA12155-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 21 Oct, at 11:42:42AM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > > > Right, we could do that, but then we wouldn't be able to support 
> > > > creation/updating variables at runtime, such as when you install a 
> > > > distribution for the first time, or want to boot a new kernel filename 
> > > > directly from the firmware without a boot loader (and need to modify the 
> > > > BootXXXX variables).
> > > 
> > > Do we know the precise position and address range of these variables?
> > > 
> > > We could map them writable (but not executable), and the rest executable (but 
> > > not writable).
> >  
> > The variables are stored in NVRAM, which we don't map into the kernel virtual 
> > address space. [...]
> 
> Just curious: is there firmware that memory maps those variables privately?
 
Good question, not sure. I suspect not because it becomes much harder
to protect those oh-so-precious variables from errant code wanting to
write to them.

Usually things get written on x86 from SMM code.

> > [...] We have to initiate the transaction of writing to the variables by 
> > executing EFI runtime services.
> > 
> > We obviously have buffers that we pass to the BIOS that contain variable data, 
> > but these should be NX anyway because they're regular kernel allocations.
> > 
> > > That raises the question whether the same physical page ever mixes variables 
> > > and actual code - but the hope would be that it's suffiently page granular for 
> > > this to work.
> > 
> > I don't think that would ever happen.
> 
> Ok, that's promising, so how about this then to solve the security weakness the 
> new warning unearthed: map the whole EFI range as 'r-x (NX)', but detect writes 
> from the page fault handler and transparently allow them to flip over the range to 
> 'rw-'.
> 
> Note that for security reasons we don't allow a subsequent flipping back to NX if 
> there's an NX fault on the same page, i.e. this new mechanism is a monotonic 
> one-way process that should dynamically 'map out' data pages versus executable 
> pages.
> 
> It should also be pretty robust, assuming we can take page faults while EFI code 
> is executing and is trying to modify EFI data: is that the case?

Yes, we can do that but I think I misunderstood what you were asking
when you said,

 > That raises the question whether the same physical page ever mixes variables and
 > actual code - but the hope would be that it's suffiently page granular for this to
 > work.
 
I was talking about EFI variables as defined in the UEFI spec, i.e.
backed by some peristent storage mechanism. I wasn't talking about
".data" objects.

It *is* possible for physical pages to contain both EFI code and data,
as Ard mentioned, and we have no way of distinguishing when EFI code
tried to write to a EfiRuntimeServicesCode page/region because there's
also legitimate data there and when an exploit attempt is taking
place.

In which case, I think we'd essentially map everything with execute
permission apart from the heap and other dynamically allocated objects
stored in EfiRuntimeServicesData.

But at that point, can't we just leave all these regions unmapped
unless we're in the EFI code paths? And that includes not leaving the
mappings around duing the suspend/resume code. 
