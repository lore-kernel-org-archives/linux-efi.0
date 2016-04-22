From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 0/6] efi: detect erroneous firmware IRQ manipulation
Date: Fri, 22 Apr 2016 16:12:59 +0200
Message-ID: <CAKv+Gu8FGpZK4yDito2jKTbjuyE2jojj5tZhCa2qUwKdWL9+ng@mail.gmail.com>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461333083-15529-1-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 April 2016 at 15:51, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> Some firmware erroneously unmask IRQs (and potentially other architecture
> specific exceptions) during runtime services functions, in violation of both
> common sense and the UEFI specification. This can result in a number of issues
> if said exceptions are taken when they are expected to be masked, and
> additionally can confuse IRQ tracing if the original mask state is not
> restored prior to returning from firmware.
>
> In practice it's difficult to check that firmware never unmasks exceptions, but
> we can at least check that the IRQ flags are at least consistent upon entry to
> and return from a runtime services function call. This series implements said
> check in the shared EFI runtime wrappers code, after an initial round of
> refactoring such that this can be generic.
>
> I have left ia64 as-is, without this check, as ia64 doesn't currently use the
> generic runtime wrappers, has many special cases for the runtime calls which
> don't fit well with the generic code, and I don't expect a new, buggy ia64
> firmware to appear soon.
>
> The first time corruption of the IRQ flags is detected, we dump a stack trace,
> and set TAINT_FIRMWARE_WORKAROUND. Additionally, and in all subsequent cases,
> we log (with ratelimiting) the specific corruption of the flags, and restore
> the expected flags to avoid redundant warnings elsewhere.
>
> Since v1 [1]:
> * Fix thinko: s/local_irq_save/local_save_flags/
> * Remove ifdefs after conversion
> * Remove reundant semicolon from x86 patch
> * Move efi_call_virt_check_flags before first use
> * Add Acked-bys and Reviewed-bys
>
> Ard, I assume that your Reviewed-by still stands for the final patch, even
> though efi_call_virt_check_flags moved. Please shout if that's not the case!
>

No, that's fine. Thanks for respinning so quickly.

> Hopefully you're also happy to extend that to the new patch removing the
> ifdefs once they become superfluous.
>

Matt: in case your review bandwidth is limited atm, I'd much prefer
this series making v4.7 than the GOP stuff or the other stuff i have
been posting over the past weeks.

Thanks,
Ard.
