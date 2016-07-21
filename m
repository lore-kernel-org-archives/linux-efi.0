From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ESRT failures ... was Re: [PATCH 04/11] efi: Add efi_memmap_init_late()
 for permanent EFI memmap
Date: Thu, 21 Jul 2016 10:44:32 -0400
Message-ID: <5790DFD0.4020806@redhat.com>
References: <57867F32.8040001@redhat.com> <20160721121136.GF26504@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721121136.GF26504-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 07/21/2016 08:11 AM, Matt Fleming wrote:
> 
> efi_mem_desc_lookup() should just return the correct EFI memory
> descriptor now that we have efi_mem_reserve() coming in v4.9.
> 
> What does the EFI memmap (as printed with efi=debug) look like on your
> machine?
> 

[    0.000000] efi: EFI v2.40 by Dell Inc.
[    0.000000] efi:  ESRT=0x8eb1c000  ACPI=0x8efe7000  ACPI 2.0=0x8efe7014
SMBIOS=0x8ef69000

and

[    0.000000] efi: mem249: [Reserved           |   |  |  |  |  |  |  |
|WB|WT|WC|UC] range=[0x000000008d6df000-0x000000008ef69fff] (24MB)

P.
