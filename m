From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [tip:x86/fpu] x86/fpu: Don't export __kernel_fpu_{begin,end}()
Date: Tue, 4 Dec 2018 13:15:10 +0100
Message-ID: <20181204121510.ebw4vb265lcepa2m@linutronix.de>
References: <20181129150210.2k4mawt37ow6c2vq@linutronix.de>
 <tip-7d79adb87fa79e4a4c59424fd5b5a922861fc5f6@git.kernel.org>
 <CAKv+Gu-s59fSWrMevmbJWyBtNVYLkF7FATALGBD470CWsN9C1Q@mail.gmail.com>
 <20181203220841.GB4794@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181203220841.GB4794@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, nstange@suse.de, Rik van Riel <riel@surriel.com>, KVM devel mailing list <kvm@vger.kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, linux-efi <linux-efi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-tip-commits@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 2018-12-03 23:08:41 [+0100], Borislav Petkov wrote:
> On Mon, Dec 03, 2018 at 10:12:19PM +0100, Ard Biesheuvel wrote:
> > > + * Using the FPU in hardirq is not allowed.
> > 
> > According to the documentation in x86/kernel/fpu/core.c, this is not
> > true. So which one is accurate?
> 
> I think you mean the irq from user mode... Yap, we do allow that.
> 
> Sebastian?

Do you refer to
| *   - by IRQ context code to potentially use the FPU
| *     if it's unused.
  
? It is possible to use the FPU in IRQ context.
The FPU could be used in user-context surrounded by kernel_fpu_begin().
This only disables preemption so an IRQ could interrupt it. This IRQ
could then use the FPU or raise a SoftIRQ which would use it.
Therefore on x86 it is required to check with irq_fpu_usable() if the
FPU can be used. If the FPU can not be used, you have to implement
fallback code.

With the "restore FPU on return to userland" series we need to modify
the FPU in a few places. The softirq and preemption is disabled. I
didn't find any in-IRQ users.
Going forward I would like to remove the in-IRQ part and
irq_fpu_usable() and disable softirq as part of kernel_fpu_begin().

> Thx.

Sebastian
