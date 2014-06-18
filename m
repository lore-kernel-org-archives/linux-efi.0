From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/7] efi: Use early_mem*() instead of early_io*()
Date: Wed, 18 Jun 2014 13:31:56 +0100
Message-ID: <53A186BC.6040107@citrix.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-2-git-send-email-daniel.kiper@oracle.com> <20140618121709.GF24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140618121709.GF24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18/06/14 13:17, Matt Fleming wrote:
> (Pulling in Mark Salter for early_ioremap() knowledge)
> 
> On Fri, 13 Jun, at 07:00:17PM, Daniel Kiper wrote:
>> Use early_mem*() instead of early_io*() because all mapped EFI regions
>> are true RAM not I/O regions. Additionally, I/O family calls do not work
>> correctly under Xen in our case. AIUI, early_io*() maps/unmaps real machine
>> addresses. However, all artificial EFI structures created under Xen live
>> in dom0 memory and should be mapped/unmapped using early_mem*() family
>> calls which map domain memory.
>>
>> Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  arch/x86/platform/efi/efi.c |   42 +++++++++++++++++++++---------------------
>>  drivers/firmware/efi/efi.c  |    4 ++--
>>  2 files changed, 23 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> index 87fc96b..dd1e351 100644
>> --- a/arch/x86/platform/efi/efi.c
>> +++ b/arch/x86/platform/efi/efi.c
>> @@ -427,7 +427,7 @@ void __init efi_unmap_memmap(void)
>>  {
>>  	clear_bit(EFI_MEMMAP, &efi.flags);
>>  	if (memmap.map) {
>> -		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
>> +		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
>>  		memmap.map = NULL;
>>  	}
>>  }
>> @@ -467,12 +467,12 @@ static int __init efi_systab_init(void *phys)
>>  			if (!data)
>>  				return -ENOMEM;
>>  		}
>> -		systab64 = early_ioremap((unsigned long)phys,
>> -					 sizeof(*systab64));
>> +		systab64 = early_memremap((unsigned long)phys,
>> +						sizeof(*systab64));
> 
> Please don't misalign the arguments :-( This makes the diff harder to
> read when all you're doing is changing the function call. You're
> indentation isn't an improvement.
>  
> As Matthew pointed out we may also need to access EFI mapped flash
> devices.
> 
> Now, the only difference between early_memremap() and early_ioremap(),
> at least on x86, is PAGE_KERNEL vs. PAGE_KERNEL_IO, where PAGE_KERNEL_IO
> has the additional _PAGE_BIT_IOMAP bit set in the pte. But that's a
> software bit for x86.

_PAGE_BIT_IOMAP is supposed to be going away...

> So, even though this change should be harmless, it's not clear to me why
> this change is needed. You say "I/O family calls do not work correctly
> under Xen in our case", but could you provide some more explanation as
> to why they don't work correctly?

_PAGE_BIT_IOMAP causes a Xen PV guest to skip the PFN to MFN conversion
when building the PTE.  Using it for RAM will attempt to map the wrong
machine frame.

David
