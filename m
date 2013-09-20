From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Fri, 20 Sep 2013 16:28:59 +0100
Message-ID: <20130920152859.GC21381@console-pimps.org>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379525333-4373-1-git-send-email-bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 18 Sep, at 07:28:53PM, Bart Kuivenhoven wrote:
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

Just to be clear, you haven't witnessed a triple fault, correct?

> This patch fixes this by clearing the interrupt bit before the lidt
> instruction.

I think we can go even further than this and get rid of all of the IDT
code in the EFI boot stub. The kernel maintains its own IDT anyway.

-- 
Matt Fleming, Intel Open Source Technology Center
