From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi: runtime-wrappers: run UEFI Runtime Services with
 interrupts enabled
Date: Thu, 11 Feb 2016 16:04:05 +0000
Message-ID: <20160211160405.GK4134@codeblueprint.co.uk>
References: <20160203105851.GA22159@gmail.com>
 <1454594327-5444-1-git-send-email-ard.biesheuvel@linaro.org>
 <CALCETrWWLGjqXmPKs7wF3uJ+jR-xctU0eYOESdVxMm5b4w8JMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWWLGjqXmPKs7wF3uJ+jR-xctU0eYOESdVxMm5b4w8JMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

On Mon, 08 Feb, at 11:37:58AM, Andy Lutomirski wrote:
> On Feb 4, 2016 5:58 AM, "Ard Biesheuvel" <ard.biesheuvel@linaro.org> wrote:
> >
> > OK, since Sai has confirmed that Windows leaves interrupts enabled when
> > calling the EFI variable store related runtime services, we should be able
> > to do the same for Linux, or at least be slightly more confident that we
> > won't have to back out this change later.
> 
> Could this use a mutex instead of a spinlock?
> 
> Can someone with a mixed mode setup read a variable in a loop and make
> sure it doesn't crash and burn?  It should work fine, but explicit
> testing would be nice.  (It's interesting mainly because doing a mixed
> mode call with interrupts on can result in a non-IST CPL0 to CPL0
> exception delivery, which won't result in a stack switch.  This could
> easily trigger a stack overflow, logic bug, microcode bug, or
> as-yet-unknown CPU "feature".
 
I don't have physical hardware for testing mixed mode anymore (that
was returned to Intel when I left) but testing with Qemu didn't turn
up any problems when running with interrupts enabled.

> Hmm.  We should also audit the mixed mode entry code to make sure that
> the high bits of RSP are explicitly clear before switching into compat
> mode.  If I had to make a guess about how CPUs behave, I'd guess
> pessimistically: Intel CPUs clear the high bits of RSP when switching
> into long mode due to interrupt delivery, and AMD CPUs leave them set
> just to mess with us.
 
Interesting thought. I'm not aware of anyone testing mixed mode with
AMD CPUs, so that would be a good data point.

> Also, a WARN_ON(in_interrupt()) somewhere might be a good sanity check.

lockdep should catch this kind of stuff pretty quickly since we grab
the spinlock in every code path.
