From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv3 1/5] efi/runtime-wrappers: detect FW irq flag corruption
Date: Mon, 25 Apr 2016 17:03:25 +0100
Message-ID: <20160425160324.GB24831@leverpostej>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
 <1461591994-14918-2-git-send-email-mark.rutland@arm.com>
 <571E25B1.8070305@arm.com>
 <20160425141557.GA2829@codeblueprint.co.uk>
 <CAKv+Gu8yH4u0-DNezUTk5b1DQJdEaH4RxR7YMQcwmkuRmEaNEw@mail.gmail.com>
 <20160425142435.GB2829@codeblueprint.co.uk>
 <20160425142735.GA14974@leverpostej>
 <20160425155922.GC2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160425155922.GC2829@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Robin Murphy <robin.murphy@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 25, 2016 at 04:59:22PM +0100, Matt Fleming wrote:
> On Mon, 25 Apr, at 03:27:35PM, Mark Rutland wrote:
> > 
> > I have no strong preference so long as the code is correct.
> > 
> > Another option is to get rid of the bool entirely:
> > 
> > 	flags ^= cur_flags;
> > 	if (!WARN_ON(flags & ARCH_EFI_IRQ_FLAGS_MASK))
> > 		return;
> 
> OK, let's do the following because we need flags to be preserved for
> printing,
> 
> ---
> 
> 	unsigned long cur_flags, mismatch;
> 
> 	local_save_flags(cur_flags);
> 
> 	mismatch = flags ^ cur_flags;
> 	if (!WARN_ON_ONCE(mismatch & ARCH_EFI_IRQ_FLAGS_MASK))
> 		return;
> 

Sure; that looks good to me.

Cheers,
Mark.
