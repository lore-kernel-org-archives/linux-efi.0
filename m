From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCHv3 0/5] efi: detect erroneous firmware IRQ manipulation
Date: Mon, 25 Apr 2016 17:03:09 +0100
Message-ID: <20160425160309.GD2829@codeblueprint.co.uk>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461591994-14918-1-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 25 Apr, at 02:46:29PM, Mark Rutland wrote:
> Note: this is largely a rework of the final patch from v2 [2], which now has a
> per-arch component (and hence additional patches). The rest of v2 has already
> been picked up, and hence dropped from this posting.
> 
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
> refactoring (patches 1-5 of [2]).
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

Thanks Mark. I've picked up the series and applied it to the v4.7
queue.
