From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Wed, 25 Sep 2013 14:12:30 +0100
Message-ID: <20130925131230.GL21381@console-pimps.org>
References: <1379929528-7534-1-git-send-email-bemk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379929528-7534-1-git-send-email-bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 23 Sep, at 11:45:28AM, Bart Kuivenhoven wrote:
> The problem in efi_main was that the idt was cleared before the
> interrupts were disabled.
> 
> The UEFI spec states that interrupts aren't used so this shouldn't be
> too much of a problem. Peripherals however don't necessarily know about
> this and thus might cause interrupts to happen anyway. Even if
> ExitBootServices() has been called.
> 
> This means there is a risk of an interrupt being triggered while the IDT
> register is nullified and the interrupt bit hasn't been cleared,
> allowing for a triple fault.
> 
> This patch disables the interrupt flag, while leaving the existing IDT
> in place. The CPU won't care about the IDT at all as long as the
> interrupt bit is off, so it's safe to leave it in place as nothing will
> ever happen to it.
> 
> Signed-off-by: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)

Applied, thanks Bart!

-- 
Matt Fleming, Intel Open Source Technology Center
