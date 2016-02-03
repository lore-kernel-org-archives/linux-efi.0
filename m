From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 07/14] efi: runtime-wrappers: Run UEFI Runtime Services
 with interrupts enabled
Date: Wed, 3 Feb 2016 12:01:37 +0000
Message-ID: <20160203120137.GE2597@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-8-git-send-email-matt@codeblueprint.co.uk>
 <20160203094340.GA15890@gmail.com>
 <CAKv+Gu-AWTQNG3ObSZt0cHV1YFb8UbYpkq-uVBqMW0wryfv_ig@mail.gmail.com>
 <20160203105851.GA22159@gmail.com>
 <CAKv+Gu8KZW4m1O5KheBpteOr6tCgNT-FnVkXK-g05=qrzT5xiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8KZW4m1O5KheBpteOr6tCgNT-FnVkXK-g05=qrzT5xiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 03 Feb, at 12:33:10PM, Ard Biesheuvel wrote:
> On 3 February 2016 at 11:58, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> >> > More fundamentally, this makes me nervous:
> >> >
> >> >  > The UEFI spec allows Runtime Services to be invoked with interrupts
> >> >  > enabled. [...]
> >> >
> >> > So what really matters is not what the spec says, but how Windows executes
> >> > UEFI firmware code in practice.
> >> >
> >> > If major versions of Windows calls UEFI firmware with interrupts disabled,
> >> > then frankly I don't think we should interrupt them under Linux either,
> >> > regardless of what the spec says ...
> >> >
> >> > Random firmware code getting interrupted by the OS changes timings and might
> >> > have other side effects the firmware code might not expect - so the question
> >> > is, does Windows already de facto allow the IRQ preemption of firmware calls?
> >> >
> >>
> >> Good question. I will try to find out.
> >
> > Note that if there's a reasonable (but not 100%) case in favor of keeping irqs
> > enabled, we can try your patch, with the possibility that we might have to revert
> > it, should it cause problems.
> >
> 
> I think this might have been the reason Matt wanted this in -next
> early, but I will let him confirm whether that was the case.
 
It was indeed. Additionally I didn't want the EFI material to miss the
merge window again.

> > In practice we probably already interrupt EFI services with NMI interrupts, which
> > can be pretty heavy as well if they for example generate printks.
> >
> > So I'm not against this change in a strong fashion - I'm just a bit cautious and
> > it would be nice to know how Windows behaves here.
> >
> 
> I am not sure how yet, but I am going to try and figure out what
> Windows does. I suppose hacking OVMF to record some IRQ mask
> information when RT services are being invoked should be sufficient,
> but I am going to need some help from someone that understands OVMF
> and x86 (Matt?)

Sure, I can help out with that. Hit me up on IRC. I'm also looping in
Sai who has done OVMF hacking for OS diagnostics in the past.
