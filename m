From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Thu, 15 Oct 2015 11:10:16 +0100
Message-ID: <20151015101016.GB2975@codeblueprint.co.uk>
References: <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic>
 <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <CALCETrU-_dJ3=+1nHN82mE==YpXGB8USWdrXDc=BVk_J5UdN3A@mail.gmail.com>
 <20151014153522.GC8218@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151014153522.GC8218-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, luv-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 14 Oct, at 05:35:22PM, Borislav Petkov wrote:
> On Wed, Oct 14, 2015 at 08:30:48AM -0700, Andy Lutomirski wrote:
> > Can we just unmap these things until someone tries to do an EFI call,
> > and then unmap them again after the call returns?  We already switch
> > pgds for EFI IIRC.
> 
> hpa did mention an EFI-aware page fault handler at the time. I guess we
> could do that too...

We do this for the Linux UEFI Validation project kernel [1]. There, we
do not map EFI Boot Services regions by default, only if the firmware
tries to access them.

This gives us the opporunity to print an error message if Boot
Services regions are accessed after ExitBootServices() (which is the
bug mjg59 describes in commit 916f676f8dc0 ("x86, efi: Retain boot
service code until after switching to virtual mode")).

But for the issue being discussed in this thread, the thing unmapping
the EFI regions buys you is that they're no longer accessible from the
x86 sleep/wakeup code paths, since those also use trampoline_pgd which
is where the EFI page tables are mapped.

And that's probably a good idea.

[1] - https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=stable&id=9b78793058bf93958aa9529400cb2617ec1bc958

-- 
Matt Fleming, Intel Open Source Technology Center
