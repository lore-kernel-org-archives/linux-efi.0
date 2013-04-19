From: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode V2
Date: Fri, 19 Apr 2013 12:15:23 +0100
Message-ID: <5171274B.7090500@nexus-software.ie>
References: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419055813.GA16443@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130419055813.GA16443-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 19/04/13 06:58, Greg KH wrote:
>> This patch gives the option to switch off that behavior - if your BIOS
>> has neither BGRT - nor bugs that require mapping of EFI boot code/data
>
> No, never add new boot options, no users, or distros, know to set them.
> Isn't there some way we can dynamically determine this instead?

Peter, Greg.

There are three issues to consider here

1: Some UEFI BIOS is buggy and the EFI_RUNTIME_SERVICES code - actually 
touches EFI_BOOT_MEMORY. Boot memory should be completely untouched 
after an entity calls ExitBootServices() - typically done by an EFI 
aware bootloader before handing off to Linux.

2: Existing code maps EFI_BOOT_MEMORY in arch/x86/platform/efi/efi.c.
Initially it looked to me as though you could probe for ACPI::BGRT - 
look for an ACPI object sometimes stored in EFI_BOOT_MEMORY and use that 
to determine if EFI_BOOT_MEMORY should be mapped. I wasn't aware #1 
above was also a concern. So just probing for something - doesn't appear 
to fly

3: Standards compliant EFI BIOS - like the reference EFI 2.3.1 code we 
have on my project, has neither of the two above problems to work around

So we can.

1. Just silently map EFI_BOOT_MEMORY - even on unbuggy platforms like #3 
- or we can

2. Introduce some sort of intelligence - a parameter somewhere to tell 
the efi_enter_virtual mode if/when to map EFI_BOOT_MEMORY.

3. Just go the suggested route from Josh
#ifdef CONFIG_X86_64
			if (md->type != EFI_BOOT_SERVICES_CODE &&
			    md->type != EFI_BOOT_SERVICES_DATA)
#endif

Option #3 - so long as it doesn't break ia32::BGRT systems works for me.
