From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 6/6] efi/arm*: add support to dump the EFI page tables
Date: Fri, 22 Apr 2016 18:25:43 +0100
Message-ID: <20160422172513.GV10606@leverpostej>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
 <1461343688-8552-7-git-send-email-ard.biesheuvel@linaro.org>
 <20160422170112.GS10606@leverpostej>
 <CAKv+Gu-abf2g5htQSHA=ETnSfzVExFLwsjs2Kbs8fn86MfFv3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-abf2g5htQSHA=ETnSfzVExFLwsjs2Kbs8fn86MfFv3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 22, 2016 at 07:20:38PM +0200, Ard Biesheuvel wrote:
> On 22 April 2016 at 19:01, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Fri, Apr 22, 2016 at 06:48:08PM +0200, Ard Biesheuvel wrote:

> >> +static struct ptdump_info efi_ptdump_info = {
> >> +     .mm             = &efi_mm,
> >> +     .markers        = efi_addr_markers,
> >> +     .base_addr      = 0,
> >> +     .max_addr       = SZ_1G,
> >> +};
> >
> > I see that max_addr isn't used for arm64, and for ARM it's only used in
> > one place. It doesn't seem great to have that on arm64 given it's
> > unused.
> >
> > Do we actually need max_addr? Is there any reason not to always dump
> > whole tables?
> >
> > I guess you're trying to avoid dumping the kernel VA range on 32-bit?
> 
> Indeed. On ARM, the efi_page_tables dumps its copy of
> kernel_page_tables. If that is OK (the information could potentially
> be useful, I suppose) we can drop the max

I'd argue it's always worth dumping the full tables (dropipng the max).

For instance, we could have some bug that leaves the kernel VA range in
the EFI tables inconsistent with what we expect/require, and having that
exposed would make that clear.

Regardless, arbitrarily limiting the VA range of the arm64 dump doesn't
seem great.

Thanks,
Mark.
