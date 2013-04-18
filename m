From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 16:42:18 -0700
Message-ID: <517084DA.4090401@zytor.com>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51706E8A.7030909@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51706E8A.7030909-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> 
> "UEI" is Celtic for "We missed DOS so we burned it into your ROMS"
> 
> I love it "maith an fear"
> 
>> There are currently only two situations where we need to map EFI Boot
>> Service regions,
>>
>>    1. To workaround the firmware bug described in 916f676f8
>>    2. To access the ACPI BGRT image
>>
>> but since we haven't seen an i386 implementation that requires either,
>> this simple fix should suffice for now. Item 2. above does still work on
>> i386 provided that the BGRT image is not in highmem.
> 
> Matt, Peter, Josh, Darren.
> 
> Given it's not possible to guarantee someone won't stuff a BGRT into
> EFI_BOOT_MEMORY >= highmem eventually (and indeed the axioms of the
> universe pretty much guarantee eventually it will be so) - I'd suggest
> version 2.
> 

Quite frankly, it is quite likely.

> A kernel parameter - rather than a probe for BGRT - since we anticipate
> BIOS bugs on the way.

Pardon?  Kernel parameter for what?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
