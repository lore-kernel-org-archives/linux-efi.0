From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v4 14/28] Add support to access boot related data in
 the clear
Date: Fri, 17 Mar 2017 14:50:14 -0500
Message-ID: <79f1c44e-0138-8b50-8931-723a5d243644@amd.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
 <20170216154508.19244.58580.stgit@tlendack-t1.amdoffice.net>
 <20170308065555.GA11045@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170308065555.GA11045@dhcp-128-65.nay.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S.
 Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Alexander Potapenko <glider@google.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Andrey Ryabinin <aryabinin@virtuozz>
List-Id: linux-efi@vger.kernel.org

On 3/8/2017 12:55 AM, Dave Young wrote:
> On 02/16/17 at 09:45am, Tom Lendacky wrote:
> [snip]
>> + * This function determines if an address should be mapped encrypted.
>> + * Boot setup data, EFI data and E820 areas are checked in making this
>> + * determination.
>> + */
>> +static bool memremap_should_map_encrypted(resource_size_t phys_addr,
>> +					  unsigned long size)
>> +{
>> +	/*
>> +	 * SME is not active, return true:
>> +	 *   - For early_memremap_pgprot_adjust(), returning true or false
>> +	 *     results in the same protection value
>> +	 *   - For arch_memremap_do_ram_remap(), returning true will allow
>> +	 *     the RAM remap to occur instead of falling back to ioremap()
>> +	 */
>> +	if (!sme_active())
>> +		return true;
>
> From the function name shouldn't above be return false?

I've re-worked this so that the check is in a different location and
doesn't cause confusion.

>
>> +
>> +	/* Check if the address is part of the setup data */
>> +	if (memremap_is_setup_data(phys_addr, size))
>> +		return false;
>> +
>> +	/* Check if the address is part of EFI boot/runtime data */
>> +	switch (efi_mem_type(phys_addr)) {
>> +	case EFI_BOOT_SERVICES_DATA:
>> +	case EFI_RUNTIME_SERVICES_DATA:
>
> Only these two types needed? I'm not sure about this, just bring up the
> question.

I've re-worked this code so that there is a single EFI routine that
checks boot_params.efi_info.efi_memmap/efi_systab, EFI tables and the
EFI memtype.  As for the EFI memtypes, I believe those are the only
ones required.  Some of the other types will be picked up by the e820
checks (ACPI, NVS, etc.).

Thanks,
Tom

>
>> +		return false;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	/* Check if the address is outside kernel usable area */
>> +	switch (e820__get_entry_type(phys_addr, phys_addr + size - 1)) {
>> +	case E820_TYPE_RESERVED:
>> +	case E820_TYPE_ACPI:
>> +	case E820_TYPE_NVS:
>> +	case E820_TYPE_UNUSABLE:
>> +		return false;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>
> Thanks
> Dave
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
