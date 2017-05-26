From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 17/32] x86/mm: Add support to access boot related data
 in the clear
Date: Fri, 26 May 2017 11:22:36 -0500
Message-ID: <4c2ef3ba-2940-3330-d362-5b2b0d812c6f@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211921.10190.1537.stgit@tlendack-t1.amdoffice.net>
 <20170515183517.mb4k2gp2qobbuvtm@pd.tnic>
 <20170518195051.GA5651@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170518195051.GA5651@codeblueprint.co.uk>
Sender: owner-linux-mm@kvack.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>
List-Id: linux-efi@vger.kernel.org

On 5/18/2017 2:50 PM, Matt Fleming wrote:
> On Mon, 15 May, at 08:35:17PM, Borislav Petkov wrote:
>> On Tue, Apr 18, 2017 at 04:19:21PM -0500, Tom Lendacky wrote:
>>
>>> +		paddr = boot_params.efi_info.efi_memmap_hi;
>>> +		paddr <<= 32;
>>> +		paddr |= boot_params.efi_info.efi_memmap;
>>> +		if (phys_addr == paddr)
>>> +			return true;
>>> +
>>> +		paddr = boot_params.efi_info.efi_systab_hi;
>>> +		paddr <<= 32;
>>> +		paddr |= boot_params.efi_info.efi_systab;
>>
>> So those two above look like could be two global vars which are
>> initialized somewhere in the EFI init path:
>>
>> efi_memmap_phys and efi_systab_phys or so.
>>
>> Matt ?
>>
>> And then you won't need to create that paddr each time on the fly. I
>> mean, it's not a lot of instructions but still...
>
> We should already have the physical memmap address available in
> 'efi.memmap.phys_map'.

Unfortunately memremap_is_efi_data() is called before the efi structure
gets initialized, so I can't use that value.

>
> And the physical address of the system table should be in
> 'efi_phys.systab'. See efi_init().

In addition to the same issue as efi.memmap.phys_map, efi_phys has
the __initdata attribute so it will be released/freed which will cause
problems in checks performed afterwards.

Thanks,
Tom

>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
