From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Date: Wed, 17 Dec 2014 08:54:56 -0800
Message-ID: <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
References: <5491B4A8.905@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5491B4A8.905@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

[trying again with .org spelled correctly.  also cc: bpetkov]

On Wed, Dec 17, 2014 at 8:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> I figured I should send this email before I forget about this issue:
>
> If you run perf record across any EFI mixed mode call or otherwise
> receive an NMI or MCE, the machine triple-faults.  The cause is
> straightforward: there is no valid IDT when we have long mode disabled
> for the duration of the EFI call.
>
> As far as I know, the only way to have continuously functional interrupt
> handling across a long mode transition is to install an interrupt vector
> table and hope that CPUs actually do something intelligent when
> receiving an interrupt with LME=1, LMA=1, and PG=0.  Yuck.
>
> Could we get away with issuing 32-bit EFI calls in compat mode, i.e.
> with a 32-bit CPL0 CS but while still in long mode?  I think that
> delivery of an IST interrupt (which includes both NMI and MCE) will
> correctly switch to a fully valid 64-bit state and would correctly
> switch back when we execute IRET at the end.  (Am I missing some reason
> that switching bitness without a privilege level change doesn't work
> well?  I haven't thought of anything, other than the lack of SS/SP controls
> on intra-ring interrupts, but that shouldn't be an issue here.)
>
> As an added benefit, this would considerably simplify the code.
>
> --Andy
