From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Mon, 15 Aug 2016 13:47:31 -0500
Message-ID: <20160815184731.GS214806@stormcage.americas.sgi.com>
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
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 15, 2016 at 05:07:09PM +0200, Borislav Petkov wrote:
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

Well, anyone who is using the mappings in -4G down range still needs
your code to map their stuff into the appropriate spot in the kexec'd
kernel, so anybody who is doing things in the most up-to-date manner
still makes use of your new code, right?

AFAIK, we pass up the efi_runtime_map to the kexec'd kernel, and then
process the memory descriptors one by one, mapping in their virtual
addresses during kexec_enter_virtual_mode.  All of this relies on your
efforts to pass up the virtual mappings.  The only thing we're adding
here is the physical mappings, to match what is availble in the primary
kernel.

> What if the physical address is occupied by the kexec kernel?

Ah, that's a good question.  I usually don't force the placement of my
crashkernel, so I can't exactly comment intelligently on what will
happen in that situation.  I will look into this, but in our case, I
believe that the primary kernel would either fail to boot, or fail to
load the kexec kernel if we placed it over the range where are EFI code
gets mapped in, which I think is an issue even without this patch.

IIRC, the crashkernel memory gets reserved really early, so I'd imagine
we'd hit the former problem, since we will try to remap into that same
space in uv_bios_init.

This is sort of a hand-wavey answer - I will investigate the his further to
make sure that I'm not making any stupid assumptions (there's a good
chance that I am :)

> Why do you guys need the physical mapping all of a sudden?

It's not that we need it all of the sudden, necessarily, it's just that
we've had to make other changes to make things work with the new,
(almost) completely isolated, EFI page tables.  We ended up choosing the
lesser of two evils, and have decided to temporarily rely on the
physical address of our runtime code, instead of continuing to rely on
EFI_OLD_MEMMAP.

I guess what I'm saying is, if we hadn't been relying on some
semi-undefined behavior in the EFI memory mapping scheme, we would've
been relying on the physical address for quite a while, since nobody
would have been mapping in the virtual address for us.

It's important to note that we've been dancing back and forth between
workarounds for some slightly inorrect assumptions, and some actual bug
fixes.  We're working to get everything 100% compatible with the new
memory mapping schemes, but there're a few pieces of the puzzle we
haven't gotten around to yet.

> Your patch is basically rendering all the effort moot and we could've
> saved ourselves all that trouble of doing all that virtual address
> mapping and done the 1:1 thing.
> 
> Which really is probably simpler since we have an EFI-specific page
> table and running EFI in the kexec-ed kernel would mean basically
> recreating it.
> 
> What am I missing?

I don't think it renders all of your effort worthless.  It just allows
those who haven't had a chance to completely update their code to work
with the new mapping schemes a way to utilize EFI runtime callbacks, in
a kexec'd kernel.

I do understand that, in a perfect world, we would be able to just hop
right in and use your memory mapping scheme.  At the same time, I don't
see how this is that much different from what we already do in the
primary, non-kexec'd kernel.

If there are strong objections to this change, I won't pursue it
further.  We will be able to achieve the same effect once we've had a
chance to update our code to register a callback with
SetVirtualAddressMap to fix up our function pointer.  This is on my
upcoming to-do list, but it'll be a little bit before I have a chance to
get it finished.

Thanks for the input, Boris!

- Alex
