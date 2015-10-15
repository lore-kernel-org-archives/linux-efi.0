From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Thu, 15 Oct 2015 12:33:32 +0200
Message-ID: <20151015103332.GE4267@pd.tnic>
References: <20151012113605.GB7384@pd.tnic>
 <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <CALCETrU-_dJ3=+1nHN82mE==YpXGB8USWdrXDc=BVk_J5UdN3A@mail.gmail.com>
 <20151014153522.GC8218@pd.tnic>
 <20151015101016.GB2975@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151015101016.GB2975-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, luv-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 15, 2015 at 11:10:16AM +0100, Matt Fleming wrote:
> We do this for the Linux UEFI Validation project kernel [1]. There, we
> do not map EFI Boot Services regions by default, only if the firmware
> tries to access them.
> 
> This gives us the opporunity to print an error message if Boot
> Services regions are accessed after ExitBootServices() (which is the
> bug mjg59 describes in commit 916f676f8dc0 ("x86, efi: Retain boot
> service code until after switching to virtual mode")).

Yeah, that's actually a good idea. Why not upstream it for the wider
audience so that people can actually start reporting b0rked UEFIs? With
a big and nice FW_BUG splat in there...

> But for the issue being discussed in this thread, the thing unmapping
> the EFI regions buys you is that they're no longer accessible from the
> x86 sleep/wakeup code paths, since those also use trampoline_pgd which
> is where the EFI page tables are mapped.
> 
> And that's probably a good idea.
> 
> [1] - https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=stable&id=9b78793058bf93958aa9529400cb2617ec1bc958

In reading that commit message above, the fact that the braindead
decision of allowing SetVirtualAddressMap() to be called only once
reminds me that we can't really have a PF handler for runtime
services as *all* mappings need to be ready before calling
SetVirtualAddressMap().

Or, alternatively, we can prep them, call SetVirtualAddressMap() and
then unmap them all and map them again at the same addresses only in the
PF handler, each time a runtime call happens. When that call finishes,
we unmap them again...

Hmm, perhaps not worth the trouble...


-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
