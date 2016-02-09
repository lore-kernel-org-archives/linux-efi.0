From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: runtime-wrappers: run UEFI Runtime Services with
 interrupts enabled
Date: Tue, 9 Feb 2016 17:52:34 +0100
Message-ID: <CAKv+Gu_sPq9wesOpEREyopVddpVW2P7m8YCDHHcBHkLk-kH+ew@mail.gmail.com>
References: <20160203105851.GA22159@gmail.com>
	<1454594327-5444-1-git-send-email-ard.biesheuvel@linaro.org>
	<CALCETrWWLGjqXmPKs7wF3uJ+jR-xctU0eYOESdVxMm5b4w8JMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWWLGjqXmPKs7wF3uJ+jR-xctU0eYOESdVxMm5b4w8JMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 8 February 2016 at 20:37, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Feb 4, 2016 5:58 AM, "Ard Biesheuvel" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>
>> OK, since Sai has confirmed that Windows leaves interrupts enabled when
>> calling the EFI variable store related runtime services, we should be able
>> to do the same for Linux, or at least be slightly more confident that we
>> won't have to back out this change later.
>
> Could this use a mutex instead of a spinlock?
>

When I first started working on this code, I proposed using a mutex,
but at the time, we still had the efi-pstore case to worry about
http://article.gmane.org/gmane.linux.kernel.efi/4112

In the mean time, we have modified the efi-pstore code so it simply
gives up when the EFI varstore is busy, and we also got rid of the NMI
special case where locks are ignored. In summary, it sounds to me that
moving to a mutex should be feasible, but I am only really familiar
with the ARM side of the implementation, which is far less complex
than the x86 side, so Matt should confirm.

@Matt?

> Can someone with a mixed mode setup read a variable in a loop and make
> sure it doesn't crash and burn?  It should work fine, but explicit
> testing would be nice.  (It's interesting mainly because doing a mixed
> mode call with interrupts on can result in a non-IST CPL0 to CPL0
> exception delivery, which won't result in a stack switch.  This could
> easily trigger a stack overflow, logic bug, microcode bug, or
> as-yet-unknown CPU "feature".
>
> Hmm.  We should also audit the mixed mode entry code to make sure that
> the high bits of RSP are explicitly clear before switching into compat
> mode.  If I had to make a guess about how CPUs behave, I'd guess
> pessimistically: Intel CPUs clear the high bits of RSP when switching
> into long mode due to interrupt delivery, and AMD CPUs leave them set
> just to mess with us.
>
> Also, a WARN_ON(in_interrupt()) somewhere might be a good sanity check.
>
