From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 07/14] efi: runtime-wrappers: Run UEFI Runtime Services
 with interrupts enabled
Date: Wed, 3 Feb 2016 10:43:41 +0100
Message-ID: <20160203094340.GA15890@gmail.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-8-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454364428-494-8-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> The UEFI spec allows Runtime Services to be invoked with interrupts
> enabled. The only reason we were disabling interrupts was to prevent
> recursive calls into the services on the same CPU, which will lead to
> deadlock. However, the only context where such invocations may occur
> legally is from efi-pstore via efivars, and that code has been updated
> to call a non-blocking alternative when invoked from a non-interruptible
> context.
> 
> So instead, update the ordinary, blocking UEFI Runtime Services wrappers
> to execute with interrupts enabled. This aims to prevent excessive interrupt
> latencies on uniprocessor platforms with slow variable stores.

Well, those excessive latencies would affect SMP platforms as well, just that 
there are (usually) other CPUs free to do execution, right?

More fundamentally, this makes me nervous:

 > The UEFI spec allows Runtime Services to be invoked with interrupts enabled. 
 > [...]

So what really matters is not what the spec says, but how Windows executes UEFI 
firmware code in practice.

If major versions of Windows calls UEFI firmware with interrupts disabled, then 
frankly I don't think we should interrupt them under Linux either, regardless of 
what the spec says ...

Random firmware code getting interrupted by the OS changes timings and might have 
other side effects the firmware code might not expect - so the question is, does 
Windows already de facto allow the IRQ preemption of firmware calls?

Also, this:

> -	unsigned long flags;
>  	efi_status_t status;
>  
> -	spin_lock_irqsave(&efi_runtime_lock, flags);
> +	BUG_ON(in_irq());
> +
> +	spin_lock(&efi_runtime_lock);

... how does crashing the kernel help debuggability?

Please use WARN_ON_ONCE() - or in fact, this assert is probably not needed at all, 
as lockdep will warn about IRQ unsafe lock usage.

I'd add comments to the efi_runtime_lock definition site explaining that this is 
never taken from IRQ contexts.

Thanks,

	Ingo
