From: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 23:07:06 +0100
Message-ID: <51706E8A.7030909@nexus-software.ie>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516FD24A.3070502-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


>      UEFI stands for "Unified Extensible Firmware Interface", where "Firmware"
>      is an ancient African word meaning "Why do something right when you can
>      do it so wrong that children will weep and brave adults will cower before
>      you", and "UEI" is Celtic for "We missed DOS so we burned it into your
>      ROMs". The UEFI specification provides for runtime services (ie, another
>      way for the operating system to be forced to depend on the firmware) and
>      we rely on these for certain trivial tasks such as setting up the
>      bootloader. But some hardware fails to work if we attempt to use these
>      runtime services from physical mode, and so we have to switch into virtual
>      mode. So far so dreadful.
>

"UEI" is Celtic for "We missed DOS so we burned it into your ROMS"

I love it "maith an fear"

> There are currently only two situations where we need to map EFI Boot
> Service regions,
>
>    1. To workaround the firmware bug described in 916f676f8
>    2. To access the ACPI BGRT image
>
> but since we haven't seen an i386 implementation that requires either,
> this simple fix should suffice for now. Item 2. above does still work on
> i386 provided that the BGRT image is not in highmem.

Matt, Peter, Josh, Darren.

Given it's not possible to guarantee someone won't stuff a BGRT into 
EFI_BOOT_MEMORY >= highmem eventually (and indeed the axioms of the 
universe pretty much guarantee eventually it will be so) - I'd suggest 
version 2.

A kernel parameter - rather than a probe for BGRT - since we anticipate 
BIOS bugs on the way.

Version 2 of the submitted path introduces an early kernel parameter 
"virt_mapboot" - which is true by default (maintaining the current 
behavior of mapping EFI_BOOT_MEMORY by default) - but which can be set 
to false - if your IA32 BIOS is not buggy.

Perhaps it would be better to be optimistic.

Change the behavior of efi_enter_virtual_mode() to do the right thing 
re: the standard and require passing of a parameter to switch on 
work-arounds for non-standards conformant BIOS. Note: this approach 
would break BGRT code - requiring addition of kernel parameters to 
existing systems - which from a user-friendliness POV is probably 
verboten....
