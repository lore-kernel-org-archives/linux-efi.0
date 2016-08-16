From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Tue, 16 Aug 2016 13:30:28 +0100
Message-ID: <20160816123028.GN30909@codeblueprint.co.uk>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
 <20160815124258.GF30909@codeblueprint.co.uk>
 <20160815150709.GA6085@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160815150709.GA6085@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 15 Aug, at 05:07:09PM, Borislav Petkov wrote:
> On Mon, Aug 15, 2016 at 01:42:58PM +0100, Matt Fleming wrote:
> > (Cc'ing Boris and Dave)
> > 
> > On Fri, 05 Aug, at 06:59:35PM, Alex Thorlton wrote:
> > > This is a simple change to add in the physical mappings as well as the
> > > virtual mappings in efi_map_region_fixed.  The motivation here is to
> > > get access to EFI runtime code that is only available via the 1:1
> > > mappings on a kexec'd kernel.
> 
> So I don't understand: the whole jumping through hoops so that we have
> stable virtual mappings just so that the kexec-ed kernel can call EFI
> runtime, is now useless?!
> 
> What if the physical address is occupied by the kexec kernel?
 
That's impossible, because that would mean we loaded the kexec kernel
over the top of physical pages of EFI services. We still need to be
able to invoke EFI services from kexec - we just can't change their
virtual mappings.

Unless I've misunderstood your question.

> Why do you guys need the physical mapping all of a sudden?
 
This is because of the way that the SGI firmware works and that the
"new" virtual address mappings are usable on SGI+kexec now.

> Your patch is basically rendering all the effort moot and we could've
> saved ourselves all that trouble of doing all that virtual address
> mapping and done the 1:1 thing.
 
No, some Apple platforms will not boot if SetVirtualAddressMap()
passes 1:1 mappings, and we only enter the firmware via the 1:1
mappings for EFI mixed mode calls. We're still using the virtual
runtime mappings in the commit you reference below most of the time.
 
> Which really is probably simpler since we have an EFI-specific page
> table and running EFI in the kexec-ed kernel would mean basically
> recreating it.
> 
> What am I missing?
> 
> commit d2f7cbe7b26a74dbbbf8f325b2a6fd01bc34032c
> Author: Borislav Petkov <bp@suse.de>
> Date:   Thu Oct 31 17:25:08 2013 +0100
> 
>     x86/efi: Runtime services virtual mapping
>     
>     We map the EFI regions needed for runtime services non-contiguously,
>     with preserved alignment on virtual addresses starting from -4G down
>     for a total max space of 64G. This way, we provide for stable runtime
>     services addresses across kernels so that a kexec'd kernel can still use
>     them.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> ECO tip #101: Trim your mails when you reply.
> --
