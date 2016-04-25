From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCHv3 1/5] efi/runtime-wrappers: detect FW irq flag corruption
Date: Mon, 25 Apr 2016 16:59:22 +0100
Message-ID: <20160425155922.GC2829@codeblueprint.co.uk>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
 <1461591994-14918-2-git-send-email-mark.rutland@arm.com>
 <571E25B1.8070305@arm.com>
 <20160425141557.GA2829@codeblueprint.co.uk>
 <CAKv+Gu8yH4u0-DNezUTk5b1DQJdEaH4RxR7YMQcwmkuRmEaNEw@mail.gmail.com>
 <20160425142435.GB2829@codeblueprint.co.uk>
 <20160425142735.GA14974@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160425142735.GA14974@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 25 Apr, at 03:27:35PM, Mark Rutland wrote:
> 
> I have no strong preference so long as the code is correct.
> 
> Another option is to get rid of the bool entirely:
> 
> 	flags ^= cur_flags;
> 	if (!WARN_ON(flags & ARCH_EFI_IRQ_FLAGS_MASK))
> 		return;

OK, let's do the following because we need flags to be preserved for
printing,

---

	unsigned long cur_flags, mismatch;

	local_save_flags(cur_flags);

	mismatch = flags ^ cur_flags;
	if (!WARN_ON_ONCE(mismatch & ARCH_EFI_IRQ_FLAGS_MASK))
		return;
