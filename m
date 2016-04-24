From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCHv2 6/6] efi/runtime-wrappers: detect FW irq flag corruption
Date: Sun, 24 Apr 2016 22:17:49 +0100
Message-ID: <20160424211749.GN2829@codeblueprint.co.uk>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
 <1461333083-15529-7-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461333083-15529-7-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 22 Apr, at 02:51:23PM, Mark Rutland wrote:
> The UEFI spec allows runtime services to be called with interrupts
> masked or unmasked, and if a runtime service function needs to mask
> interrupts, it must restore the mask to its original state before
> returning (i.e. from the PoV of the OS, this does not change across a
> call). Firmware should never unmask exceptions, as these may then be
> taken by the OS unexpectedly.
> 
> Unfortunately, some firmware has been seen to unmask IRQs (and
> potentially other maskable exceptions) across runtime services calls,
> leaving irq flags corrupted after returning from a runtime services
> function call. This may be detected by the IRQ tracing code, but often
> goes unnoticed, leaving a potentially disastrous bug hidden.
> 
> This patch detects when the irq flags are corrupted by an EFI runtime
> services call, logging the call and specific corruption to the console.
> While restoring the expected value of the flags is insufficient to avoid
> problems, we do so to avoid redundant warnings from elsewhere (e.g. IRQ
> tracing).
> 
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> I'm not sure about the LOCKDEP_NOW_UNRELIABLE here. If FW unmasks IRQs there's
> the potential for deadlock, but arguably by the time we've detected the flag
> corruption the danger has passed. I'm erring on the side of caution here
> setting it, but perhaps that's not the best idea?

I think it makes sense to leave it as-is, not least to guard against
future changes we make to the kernel side that might have lockdep side
effects when this bug is triggered.
