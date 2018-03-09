From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 12/12] efi: make const array 'apple' static
Date: Fri, 9 Mar 2018 09:31:15 +0100
Message-ID: <20180309083115.mvnrtvukc7sqe2i2@gmail.com>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
 <20180308080020.22828-13-ard.biesheuvel@linaro.org>
 <20180309074719.y33xe4bjkjsjsaa3@gmail.com>
 <CAKv+Gu-JmM3F0=XCDZFAkK+6pRgmp=7HK2dhY9La9tKbNYFBEg@mail.gmail.com>
 <20180309080428.atur6wcbb6vtonhz@gmail.com>
 <CAKv+Gu86v9-Cj3bxEPWXCMRnE7S76kGdu7to3cOoLMgTTcH_xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu86v9-Cj3bxEPWXCMRnE7S76kGdu7to3cOoLMgTTcH_xg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Colin Ian King <colin.king@canonical.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On 9 March 2018 at 08:04, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> >> > Also, would it make sense to rename it to something more descriptive like
> >> > "apple_unicode_str[]" or so?
> >> >
> >> > Plus an unicode string literal initializer would be pretty descriptive as well,
> >> > instead of the weird looking character array, i.e. something like:
> >> >
> >> >   static efi_char16_t const apple_unicode_str[] = u"Apple";
> >> >
> >> > ... or so?
> >> >
> >>
> >> is u"xxx" the same as L"xxx"?
> >
> > So "L" literals map to wchar_t, which wide character type is implementation
> > specific IIRC, could be 16-bit or 32-bit wide.
> >
> > u"" literals OTOH are specified by the C11 spec to be char16_t, i.e. 16-bit wide
> > characters - which I assume is the EFI type as well?
> >
> >> In any case, this is for historical reasons: at some point (and I
> >> don't remember the exact details) we had a conflict at link time with
> >> objects using 4 byte wchar_t, so we started using this notation to be
> >> independent of the size of wchar_t. That issue no longer exists so we
> >> should be able to get rid of this.
> >
> > Yes, my guess is that those problems were due to L"xyz" mapping to wchar_t and
> > having a different type in the kernel build and the host build side - but u"xyz"
> > should solve that.
> >
> 
> Excellent!

Please double check the generated code though, all of this is from memory.

> Do you mind taking this patch as is? I will follow up with a patch
> that updates all occurrences of this pattern (we have a few of them),
> i.e., use u"" notation and move them to file scope.

Sure, done!

Thanks,

	Ingo
