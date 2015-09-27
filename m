From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sun, 27 Sep 2015 09:03:55 +0200
Message-ID: <20150927070355.GB26125@gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
 <20150926055643.GA25877@gmail.com>
 <20150926134329.GA3144@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150926134329.GA3144-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> > So could we make the whole code obviously bottom-up? Such as first calculating 
> > the size of virtual memory needed, then allocating a _single_, obviously 
> > continuous mapping, and then doing a very clear in-order mapping within that 
> > window? That would remove any bitness and legacy dependencies.
>  
> So, we could, and in fact the first version of this patch did just that. You can 
> find it here,
> 
>   https://lkml.kernel.org/r/1441372447-23439-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
> 
> But Ard suggested re-using the existing code and simply changing the order we 
> map the memmap entries in.

Such implementational arguments (which are an internal cost) never trump 
compatibility and robustness concerns (which are an external constraint).

> [...] And given the constraint for a small patch for backporting, I think it's a 
> better solution. [...]

Ugh, backporting size is _even less_ of a valid argument when it comes to firmware 
support correctness!

We can (perhaps) use these already existing patches as a simpler backport, but 
there's absolutely no reason to keep that code as a solution:

> [...] The actual virtual addresses we pick are exactly the same with the two 
> patches.

So I'm NAK-ing this for now:

 - The code is it reads today pretends to be an 'allocator'. It is _NOT_ an
   allocator, because all the sections have already been determined by the
   firmware, and, as we just learned the hard way, we do not want to deviate from 
   that! There's nothing to 'allocate'!

   What these patches seem to implement is an elaborate 'allocator' that ends up
   doing nothing on 'new 64-bit' ...

 - The 32-bit and 64-bit and 'old_mmap' asymmetries:

	if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {

   seem fragile and nonsensical. The question is: is it possible for the whole EFI
   image to be larger than a couple of megabytes? If not then 32-bit should just
   mirror the firmware layout as well, and if EFI_OLD_MEMMAP does anything
   differently from this _obvious_ 1:1 mapping of the EFI memory offsets then it's
   not worth keeping as a legacy, because there's just nothing better than
   mirroring the firmware layout.

My suggestion would be to just 1:1 map what the EFI tables describe, modulo the 
single absolute offset by which we shift the whole thing to a single base.

Is there any technical reason why we'd want to deviate from that? Gigabytes of 
tables or gigabytes of holes that 32-bit cannot handle? Firmware that wants an OS 
layout that differs from the firmware layout?

Also, nobody seems to be asking the obvious hardware compatibility question when 
trying to implement a standard influenced in great part by an entity that is 
partly ignorant of and partly hostile to Linux: how does Windows map the EFI 
sections, under what OSs are these firmware versions tested? I suspect no firmware 
is released that crashes on bootup on all OSs that can run on that hardware, 
right?

Thanks,

	Ingo
