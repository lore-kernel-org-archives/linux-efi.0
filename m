From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v7 06/36] x86/mm: Add Secure Memory Encryption (SME)
 support
Date: Wed, 21 Jun 2017 08:26:44 -0500
Message-ID: <efa51470-5d8f-6883-b9da-f2face12ea22@amd.com>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net>
 <20170616185054.18967.52228.stgit@tlendack-t1.amdoffice.net>
 <alpine.DEB.2.20.1706202244480.2157@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.20.1706202244480.2157@nanos>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, xen-devel@lists.xen.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave Young <dyoung@redhat.com>, Rik van Riel <riel@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracl>
List-Id: linux-efi@vger.kernel.org

On 6/20/2017 3:49 PM, Thomas Gleixner wrote:
> On Fri, 16 Jun 2017, Tom Lendacky wrote:
>>   
>> +config ARCH_HAS_MEM_ENCRYPT
>> +	def_bool y
>> +	depends on X86
> 
> That one is silly. The config switch is in the x86 KConfig file, so X86 is
> on. If you intended to move this to some generic place outside of
> x86/Kconfig then this should be
> 
> config ARCH_HAS_MEM_ENCRYPT
> 	bool
> 
> and x86/Kconfig should have
> 
>      	select ARCH_HAS_MEM_ENCRYPT
> 
> and that should be selected by AMD_MEM_ENCRYPT

This is used for deciding whether to include the asm/mem_encrypt.h file
so it needs to be on whether AMD_MEM_ENCRYPT is configured or not. I'll
leave it in the x86/Kconfig file and remove the depends on line.

Thanks,
Tom

> 
>> +config AMD_MEM_ENCRYPT
>> +	bool "AMD Secure Memory Encryption (SME) support"
>> +	depends on X86_64 && CPU_SUP_AMD
>> +	---help---
>> +	  Say yes to enable support for the encryption of system memory.
>> +	  This requires an AMD processor that supports Secure Memory
>> +	  Encryption (SME).
> 
> Thanks,
> 
> 	tglx
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
