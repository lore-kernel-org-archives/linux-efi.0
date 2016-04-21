From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv2 5/5] efi/runtime-wrappers: detect FW irq flag corruption
Date: Thu, 21 Apr 2016 18:18:14 +0100
Message-ID: <20160421171814.GB3078@leverpostej>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
 <1461238529-12810-6-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu-Sou_-UgBwrj939JQr8M5=ScZZ4M9Y-hRUa8WrkwBK7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Sou_-UgBwrj939JQr8M5=ScZZ4M9Y-hRUa8WrkwBK7Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "hpa@zytor.com" <hpa@zytor.com>, Leif Lindholm <leif.lindholm@linaro.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Matt Fleming <matt@codeblueprint.co.uk>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 21, 2016 at 07:05:32PM +0200, Ard Biesheuvel wrote:
> On 21 April 2016 at 13:35, Mark Rutland <mark.rutland@arm.com> wrote:
> > @@ -25,8 +27,11 @@
> >  #define efi_call_virt(f, args...)                                      \
> >  ({                                                                     \
> >         efi_status_t __s;                                               \
> > +       unsigned long flags;                                            \
> >         arch_efi_call_virt_setup();                                     \
> > +       local_save_flags(flags);                                        \
> >         __s = arch_efi_call_virt(f, args);                              \
> > +       efi_call_virt_check_flags(flags, __stringify(f));               \
> >         arch_efi_call_virt_teardown();                                  \
> >         __s;                                                            \
> >  })
> > @@ -35,12 +40,29 @@
> >  #ifndef __efi_call_virt
> >  #define __efi_call_virt(f, args...)                                    \
> >  ({                                                                     \
> > +       unsigned long flags;                                            \
> >         arch_efi_call_virt_setup();                                     \
> > +       local_irq_save(flags);                                          \
> 
> We shouldn't disable interrupts here. I assume this is a typo, and you
> intended to use local_save_flags() as above?

Oh, yes. That's an impressive mistake on my behalf; thanks for spotting
that!

I've been seeing issues with GetVariable and GetNextVariable, which
happen to only exercise the correct macro above.

> Other than that, this series looks fine to me.
> 
> With the above fixed:
> 
> For the series (except the x86 patch)
> 
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Cheers!

Mark.
