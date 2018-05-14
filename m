From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] efi/x86: Clean up the eboot code a bit
Date: Mon, 14 May 2018 08:58:52 +0200
Message-ID: <20180514065852.GE16596@gmail.com>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
 <20180504060003.19618-16-ard.biesheuvel@linaro.org>
 <20180514064323.GB16596@gmail.com>
 <CAKv+Gu-v-dw28pjo_8of_dNR7mEMK3ngDUksFYUTWwro14PFfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-v-dw28pjo_8of_dNR7mEMK3ngDUksFYUTWwro14PFfw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Hans de Goede <hdegoede@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On 14 May 2018 at 08:43, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > So I looked at arch/x86/boot/compressed/eboot.c to improve a printk message and
> > ended up with the cleanups below.
> >
> > Only build tested.
> >
> > Thanks,
> >
> >         Ingo
> >
> > =================>
> > Subject: efi/x86: Clean up the eboot code
> > From: Ingo Molnar <mingo@kernel.org>
> > Date: Mon May 14 08:33:40 CEST 2018
> >
> > Various small cleanups:
> >
> >  - Standardize printk messages:
> >
> >      'alloc' => 'allocate'
> >      'mem'   => 'memory'
> >
> >    also put variable names in printk messages between quotes.
> >
> >  - Align mass-assignments vertically for better readability
> >
> >  - Break multi-line function prototypes at the name where possible,
> >    not in the middle of the parameter list
> >
> >  - Use a newline before return statements consistently.
> >
> >  - Use curly braces in a balanced fashion.
> >
> >  - Remove stray newlines.
> >
> > No change in functionality.
> >
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Matt Fleming <matt@codeblueprint.co.uk>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: linux-efi@vger.kernel.org
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Thanks Ingo
> 
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks - mind picking it up into your tree? I only did minimal testing and don't 
want to interfere with your patch flow either.

Thanks,

	Ingo
