From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Date: Wed, 14 Jan 2015 10:27:47 -0800
Message-ID: <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
References: <5491B4A8.905@amacapital.net> <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org> <20150114165151.GA3479@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150114165151.GA3479-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 14, 2015 at 8:51 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Wed, 31 Dec, at 06:37:39PM, Matt Fleming wrote:
>> On Wed, 17 Dec, at 08:54:56AM, Andy Lutomirski wrote:
>> > > As far as I know, the only way to have continuously functional interrupt
>> > > handling across a long mode transition is to install an interrupt vector
>> > > table and hope that CPUs actually do something intelligent when
>> > > receiving an interrupt with LME=1, LMA=1, and PG=0.  Yuck.
>> > >
>> > > Could we get away with issuing 32-bit EFI calls in compat mode, i.e.
>> > > with a 32-bit CPL0 CS but while still in long mode?  I think that
>> > > delivery of an IST interrupt (which includes both NMI and MCE) will
>> > > correctly switch to a fully valid 64-bit state and would correctly
>> > > switch back when we execute IRET at the end.  (Am I missing some reason
>> > > that switching bitness without a privilege level change doesn't work
>> > > well?  I haven't thought of anything, other than the lack of SS/SP controls
>> > > on intra-ring interrupts, but that shouldn't be an issue here.)
>> > >
>> > > As an added benefit, this would considerably simplify the code.
>>
>> I can't immediately think of a reason that this wouldn't work, but I've
>> Cc'd more x86 folks for additional insight.
>>
>> I will schedule some time to look into this issue in the new year.
>> Thanks Andy.
>
> I finally got some time to look into this, and running with
> __KERNEL32_CS seems to work fine at runtime both with Qemu + 32-bit OVMF
> and on my ASUS T100. Manually triggering an MCE exception immediately
> before invoking the firmware service recovers gracefully.

How are you manually triggering an MCE?  I've been playing with some
MCE stuff recently, but the only reasonably reliable way I know of to
trigger an MCE is using WHEA, and I don't have a box with WHEA, and I
assume your ASUS T100 doesn't either.

>
> Where this won't work so well is at boot time before we jump to the
> kernel proper. There, we still need to restore the firmware's GDT so
> that interrupts are serviced correctly before ExitBootServices() (in
> particular, ia32 Tianocore assumes __KERNEL_CS is a 32-bit CS).

Tianocore makes assumptions about the kernel's GDT layout?  Yuck.

--Andy
