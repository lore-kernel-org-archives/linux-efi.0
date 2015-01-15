From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Date: Thu, 15 Jan 2015 22:21:01 +0000
Message-ID: <20150115222101.GE12079@codeblueprint.co.uk>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
 <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
 <20150115194127.GB12079@codeblueprint.co.uk>
 <54B81C2E.2090909@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54B81C2E.2090909-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 15 Jan, at 11:59:42AM, H. Peter Anvin wrote:
> On 01/15/2015 11:41 AM, Matt Fleming wrote:
> >>
> >>Tianocore makes assumptions about the kernel's GDT layout?  Yuck.
> >
> >No, but 32-bit Tianocore does rely on the second GDT entry being a
> >32-bit CS.
> >
> >It has no knowledge of Linux's GDT layout.
> >
> 
> If it assumes that descriptor 16 is a 32-bit CS (and what about
> data? 24?) that *is* making assumptions on the kernel.

Bear in mind that this is before ExitBootServices() is invoked, so where
the firmware still thinks it (not the OS) "owns" the platform.

None of this comes into play at Runtime.

-- 
Matt Fleming, Intel Open Source Technology Center
