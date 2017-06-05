From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 10/13] efi/capsule: Add support for Quark security header
Date: Mon, 5 Jun 2017 18:11:43 +0200
Message-ID: <20170605161143.3ftptomo6ynh7wau@gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
 <20170602135207.21708-11-ard.biesheuvel@linaro.org>
 <20170605155050.fuhwcjkmmdqc67d2@gmail.com>
 <CAKv+Gu8ByPXuWGNXGhbVrzyBd98r7ib8trGySEsC1FxrqY=38A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8ByPXuWGNXGhbVrzyBd98r7ib8trGySEsC1FxrqY=38A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Jan Kiszka <jan.kiszka@siemens.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> >> +config EFI_CAPSULE_QUIRK_QUARK_CSH
> >> +     boolean "Add support for Quark capsules with non-standard headers"
> >> +     depends on X86 && !64BIT
> >> +     select EFI_CAPSULE_LOADER
> >> +     default y
> >> +     help
> >> +       Add support for processing Quark X1000 EFI capsules, whose header
> >> +       layout deviates from the layout mandated by the UEFI specification.
> >
> > BTW., there's no need to further put this behind a Kconfig option: the quirk seems
> > targeted enough, and the whole point of runtime quirks is so that can be applied
> > safely within generic kernels. Turning them off via Kconfig seems wrong.
> >
> 
> Not entirely: enabling this quirk will remove the ability to select
> EFI_CAPSULE_LOADER as a module. So making it unconditional makes
> EFI_CAPSULE_LOADER builtin-only for 32-bit x86. This is necessary for
> the override of __weak symbols in the generic capsule code to work as
> expected.
> 
> This was a compromise between allowing no capsule loader quirks at
> all, and having an elaborate framework with hooks in various places
> (which invariably ends up parameterizing the wrong things if you have
> only one real world quirk to design your framework around).

Ok, I see - fair enough!

Thanks,

	Ingo
