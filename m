From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/mm, efi: Check for valid image type
Date: Wed, 29 Jul 2015 17:37:52 +0800
Message-ID: <20150729093752.GF31695@dhcp-128-89.nay.redhat.com>
References: <1437579164-20176-1-git-send-email-bigeasy@linutronix.de>
 <20150728205157.GD2773@codeblueprint.co.uk>
 <20150729001034.GD8671@cloud>
 <55B88F3B.2000902@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B88F3B.2000902-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

> 
> >  As you pointed out above, a wild pointer could cause a
> > WARN from early_ioremap.  We need to never follow the pointer in the
> > first place after a kexec, unless we have some way to know that it's
> > actually valid.
> 
> So you assume that the information from ACPI is always correct then?
> The pointer is correct, the information it points to is no longer.
> 
> If we run always under EFI then it looks like the variable efi_setup
> which is checked in efi_enter_virtual_mode() is 0 during normal boot
> and != 0 on kexec entry. This hint is set via setup_data / SETUP_EFI
> since commit 1fec053369 ("x86/efi: Pass necessary EFI data for kexec
> via setup_data"). So maybe we could use this to check if we run under
> kexec or not.

Not sure if BGRT is useful in kexec kernel, it seems not worth to copy
it between kernels.

IMO just return in case if (efi_setup) is true make sense.

Thanks
Dave
