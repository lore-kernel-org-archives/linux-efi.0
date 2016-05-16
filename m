From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH 1/2] Create UV efi_call macros
Date: Mon, 16 May 2016 17:58:40 -0500
Message-ID: <20160516225840.GL98477@stormcage.americas.sgi.com>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
 <1462996545-98387-2-git-send-email-athorlton@sgi.com>
 <20160512120600.GF2728@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160512120600.GF2728@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org, Dimitri Sivanich <sivanich@sgi.com>, Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-efi@vger.kernel.org

On Thu, May 12, 2016 at 01:06:00PM +0100, Matt Fleming wrote:
> (Adding author of arch_efi_call code)
> 
> On Wed, 11 May, at 02:55:44PM, Alex Thorlton wrote:
> > We need a slightly different macro than the standard efi_call_virt,
> > since those macros all assume that the function pointer, f, that gets
> > passed in will live somewhere in efi.systab->runtime.  Our EFI function
> > pointer lives in efi.uv_systab, so we can't use the standard macros out
> > of the box.
>  
> Is that true of all EFI services pointers? From reading the SGI/UV
> code I got the impression that it's possible to call the standard
> services via efi.systab->runtime but you also need the ability to call
> these UV bios functions, which are not accessible via efi.systab.

No, sorry.  I wasn't very clear there.  All of the standard EFI services
(get_time, get_variable, etc.) are still called through
efi.systab->runtime on UV.  It's only the special UV-specific function
pointer that is accessed through uv_systab, but, either way, we will
still need a slightly different macro to make that happen.

> Do you actually want the same environment setup and teardown to happen
> when calling efi.uv_systab ? Or are you simply trying to reuse the
> efi_call() implementation?

I was simply re-using the efi_call implementation.  Boris suggested that
I re-write this using the efi_call_virt macro, so I just went with that.
It all seems to work just fine, so I don't see much reason to stray away
from that implementation.  That being said, I'm obviously not a huge fun
of the code duplication across the macros.  I think there's probably a
way to minimize this, though I haven't quite worked out the best method
yet (ideas are welcome :)

> > This commit creates some new uv_* macros that are functionally
> > equivalent to the standard ones, with the exception of allowing us to
> > use a different function pointer.  I figure that we won't want to call
> > these uv_* in the end (we'll probably want something more generic), but
> > I thought I would get everyone's thoughts on how we might best reach
> > that goal instead of just trying to come up with a new implementation on
> > my own.
> > 
> > By itself, this commit does get our machines booting, but it needs the
> > small fix to the efi_call assembly code for our modules to work.
>  
> Could you provide some more details in the changelog on why your
> machine doesn't boot without this change?

Absolutely.  I wasn't sure exactly how much detail was necessary.  I'll
put a brief write-up of the original problem in the commit message for
the next version.

- Alex
