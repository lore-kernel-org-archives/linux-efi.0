From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 4.19 083/100] x86/fpu: Dont export
 __kernel_fpu_{begin,end}()
Date: Wed, 1 May 2019 13:59:30 +0200
Message-ID: <20190501115930.wa7ubea67rmsoqo7@wunner.de>
References: <20190430113608.616903219@linuxfoundation.org>
 <20190430113612.682532449@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190430113612.682532449@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Borislav Petkov <bp@suse.de>, Rik van Riel <riel@surriel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Nicolai Stange <nstange@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?iso-8859-1?B?S3I/P23hPz8=?= <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, kvm ML <kvm@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, x86-ml <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 30, 2019 at 01:38:52PM +0200, Greg Kroah-Hartman wrote:
> commit 12209993e98c5fa1855c467f22a24e3d5b8be205 upstream.
> 
> There is one user of __kernel_fpu_begin() and before invoking it,
> it invokes preempt_disable(). So it could invoke kernel_fpu_begin()
> right away. The 32bit version of arch_efi_call_virt_setup() and
> arch_efi_call_virt_teardown() does this already.
> 
> The comment above *kernel_fpu*() claims that before invoking
> __kernel_fpu_begin() preemption should be disabled and that KVM is a
> good example of doing it. Well, KVM doesn't do that since commit
> 
>   f775b13eedee2 ("x86,kvm: move qemu/guest FPU switching out to vcpu_run")
> 
> so it is not an example anymore.
> 
> With EFI gone as the last user of __kernel_fpu_{begin|end}(), both can
> be made static and not exported anymore.

This is just a cleanup and therefore doesn't seem to satisfy the rules
for stable patches per Documentation/process/stable-kernel-rules.rst
("It must fix a real bug that bothers people / fix a problem that causes
a build error").

Why is it being queued up for stable and why are the rules disregarded here?

Thanks,

Lukas
