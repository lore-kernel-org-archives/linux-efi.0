From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Date: Thu, 15 Jan 2015 19:41:27 +0000
Message-ID: <20150115194127.GB12079@codeblueprint.co.uk>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
 <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 14 Jan, at 10:27:47AM, Andy Lutomirski wrote:
> 
> How are you manually triggering an MCE?  I've been playing with some
> MCE stuff recently, but the only reasonably reliable way I know of to
> trigger an MCE is using WHEA, and I don't have a box with WHEA, and I
> assume your ASUS T100 doesn't either.
 
As Borislav mentions, I used 'int $18', solely to trigger the 64-bit
exception handler code paths in the middle of the EFI mixed mode code.

> > Where this won't work so well is at boot time before we jump to the
> > kernel proper. There, we still need to restore the firmware's GDT so
> > that interrupts are serviced correctly before ExitBootServices() (in
> > particular, ia32 Tianocore assumes __KERNEL_CS is a 32-bit CS).
> 
> Tianocore makes assumptions about the kernel's GDT layout?  Yuck.

No, but 32-bit Tianocore does rely on the second GDT entry being a
32-bit CS.

It has no knowledge of Linux's GDT layout.

-- 
Matt Fleming, Intel Open Source Technology Center
