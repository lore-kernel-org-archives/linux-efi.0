From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/14] efi: runtime-wrappers: Run UEFI Runtime Services
 with interrupts enabled
Date: Wed, 3 Feb 2016 10:57:24 +0100
Message-ID: <CAKv+Gu-AWTQNG3ObSZt0cHV1YFb8UbYpkq-uVBqMW0wryfv_ig@mail.gmail.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
	<1454364428-494-8-git-send-email-matt@codeblueprint.co.uk>
	<20160203094340.GA15890@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203094340.GA15890-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 February 2016 at 10:43, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>
>> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> The UEFI spec allows Runtime Services to be invoked with interrupts
>> enabled. The only reason we were disabling interrupts was to prevent
>> recursive calls into the services on the same CPU, which will lead to
>> deadlock. However, the only context where such invocations may occur
>> legally is from efi-pstore via efivars, and that code has been updated
>> to call a non-blocking alternative when invoked from a non-interruptible
>> context.
>>
>> So instead, update the ordinary, blocking UEFI Runtime Services wrappers
>> to execute with interrupts enabled. This aims to prevent excessive interrupt
>> latencies on uniprocessor platforms with slow variable stores.
>
> Well, those excessive latencies would affect SMP platforms as well, just that
> there are (usually) other CPUs free to do execution, right?
>

Correct.

> More fundamentally, this makes me nervous:
>
>  > The UEFI spec allows Runtime Services to be invoked with interrupts enabled.
>  > [...]
>
> So what really matters is not what the spec says, but how Windows executes UEFI
> firmware code in practice.
>
> If major versions of Windows calls UEFI firmware with interrupts disabled, then
> frankly I don't think we should interrupt them under Linux either, regardless of
> what the spec says ...
>
> Random firmware code getting interrupted by the OS changes timings and might have
> other side effects the firmware code might not expect - so the question is, does
> Windows already de facto allow the IRQ preemption of firmware calls?
>

Good question. I will try to find out.

> Also, this:
>
>> -     unsigned long flags;
>>       efi_status_t status;
>>
>> -     spin_lock_irqsave(&efi_runtime_lock, flags);
>> +     BUG_ON(in_irq());
>> +
>> +     spin_lock(&efi_runtime_lock);
>
> ... how does crashing the kernel help debuggability?
>
> Please use WARN_ON_ONCE() - or in fact, this assert is probably not needed at all,
> as lockdep will warn about IRQ unsafe lock usage.
>

Actually, reading back the original thread, Matt had already
identified this problem, and v2/v3 of this patch removed all of them
but one, so thanks for spotting that.

> I'd add comments to the efi_runtime_lock definition site explaining that this is
> never taken from IRQ contexts.
>

OK.
