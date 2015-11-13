From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 6/6] Documentation/x86: Update EFI memory region
 description
Date: Fri, 13 Nov 2015 22:22:29 +0000
Message-ID: <20151113222229.GG2716@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-7-git-send-email-matt@codeblueprint.co.uk>
 <20151113092210.GB19922@gmail.com>
 <20151113092906.GD2716@codeblueprint.co.uk>
 <CA+55aFxeyspaa_VCv9fRqTpuamFD95siSx9oXp57aO3Fi=EwXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxeyspaa_VCv9fRqTpuamFD95siSx9oXp57aO3Fi=EwXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Nov, at 08:42:54AM, Linus Torvalds wrote:
> On Fri, Nov 13, 2015 at 1:29 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > On Fri, 13 Nov, at 10:22:10AM, Ingo Molnar wrote:
> >
> > You've snipped the patch hunk that gives the address range used,
> 
> I'm actually wondering if we should strive to make the UEFI stuff more
> like a user process, and just map the UEFI mappings in low memory in
> that magic UEFI address space.
 
We map things in the user address space now but only for the purposes
of having an identity mapping, for the reasons that I mentioned
previously: bust firmware accesses and for the SetVirtaulAddressMap()
call [1]. Importantly, the kernel does not access the identity mapping
directly.

So if we were to repurpose the user address space it would make sense
to just have the identity mapping be the one and only mapping.

However, going through the identity addresses to invoke EFI runtime
services is known to break some Apple Macs. It's probably worth
revisiting this issue, because I don't have any further details.

Having a separate mapping in the user address space that isn't the
identity mapping is also possible of course.

> We won't be able to run those things *as* user space, since I assume
> the code will want to do a lot of kernely things, but shouldn't we aim
> to make it look as much like that as possible? Maybe some day we could
> even strive to run it in some controlled environment (ie user space
> with fixups, virtual machine, whatever), but even if we never get
> there it sounds like a potentially good idea to try to set up the
> mappings to move in that direction..

It would be interesting to see how far we could push this, say, using
SMAP/SMEP to further isolate what kernel pieces the firmware can
touch. It's not about security guarantees since most of the firmware
functionality is implemented in SMM today for x86, but it does go some
way towards providing protection from unintended accesses.

> No big hurry, and maybe there are good reasons not to go that way. The
> first step is indeed just to get rid of the WX mappings in the normal
> kernel page tables.

I think it's worth exploring.

[1] Oh, and also for the EFI mixed mode code (running 64-bit kernels
on 32-bit EFI), but less people tend to care about that ;-)
