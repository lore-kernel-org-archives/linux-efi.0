From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] fix setup_efi_pci()
Date: Fri, 25 Jan 2013 07:41:06 +0000
Message-ID: <5102452202000078000B9755@nat28.tlf.novell.com>
References: <50F94F9202000078000B74EE@nat28.tlf.novell.com>
 <1359051621.2496.95.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359051621.2496.95.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 24.01.13 at 19:20, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, 2013-01-18 at 12:35 +0000, Jan Beulich wrote:
>> This fixes two issues:
>> - wrong memory type used for allocation intended to persist post-boot
> 
> [...]
> 
>> @@ -311,7 +311,7 @@ static efi_status_t setup_efi_pci(struct
>>  		size = pci->romsize + sizeof(*rom);
>>  
>>  		status = efi_call_phys3(sys_table->boottime->allocate_pool,
>> -				EFI_LOADER_DATA, size, &rom);
>> +					EFI_RUNTIME_SERVICES_DATA, size, &rom);
>>  
>>  		if (status != EFI_SUCCESS)
>>  			continue;
> 
> I'm curious why you made this change. No one should be stealing that
> region of memory because that's all handled in parse_e820_ext() - it's
> marked as off limits wrt memory for the kernel's use. And the firmware
> certainly shouldn't start touching it.

According to my reading of do_add_efi_memmap(), EFI_LOADER_DATA
gets treated the same as EFI_CONVENTIONAL_MEMORY, i.e. gets
marked as available for allocation. That's also how I'd expect things
to be. I don't think parse_e820_ext() matters here at all.

> Have you witnessed some case where things explode without your change?

No, I didn't. I merely spotted this when evaluating the code for
porting over to Xen.

Jan
