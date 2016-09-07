From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 01/20] x86: Documentation for AMD Secure Memory
 Encryption (SME)
Date: Wed, 7 Sep 2016 09:02:38 -0500
Message-ID: <3fbb0763-5f9f-6ff7-2266-7478fb12642e@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
 <20160822223539.29880.96739.stgit@tlendack-t1.amdoffice.net>
 <20160902085045.GG17338@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160902085045.GG17338@nazgul.tnic>
Sender: linux-doc-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dm
List-Id: linux-efi@vger.kernel.org

On 09/02/2016 03:50 AM, Borislav Petkov wrote:
> On Mon, Aug 22, 2016 at 05:35:39PM -0500, Tom Lendacky wrote:
>> This patch adds a Documenation entry to decribe the AMD Secure Memory
>> Encryption (SME) feature.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  Documentation/x86/amd-memory-encryption.txt |   35 +++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>  create mode 100644 Documentation/x86/amd-memory-encryption.txt
>>
>> diff --git a/Documentation/x86/amd-memory-encryption.txt b/Documentation/x86/amd-memory-encryption.txt
>> new file mode 100644
>> index 0000000..f19c555
>> --- /dev/null
>> +++ b/Documentation/x86/amd-memory-encryption.txt
>> @@ -0,0 +1,35 @@
>> +Secure Memory Encryption (SME) is a feature found on AMD processors.
>> +
>> +SME provides the ability to mark individual pages of memory as encrypted using
>> +the standard x86 page tables.  A page that is marked encrpyted will be
> 
> s/encrpyted/encrypted/

Ugh..  I thought I caught all of these.  Obviously not.  I'll go through
all the patches on this.

> 
>> +automatically decrypted when read from DRAM and encrypted when written to
>> +DRAM.  SME can therefore be used to protect the contents of DRAM from physical
>> +attacks on the system.
>> +
>> +Support for SME can be determined through the CPUID instruction. The CPUID
>> +function 0x8000001f reports information related to SME:
>> +
>> +	0x8000001f[eax]:
>> +		Bit[0] indicates support for SME
>> +	0x8000001f[ebx]:
>> +		Bit[5:0]  pagetable bit number used to enable memory encryption
>> +		Bit[11:6] reduction in physical address space, in bits, when
>> +			  memory encryption is enabled (this only affects system
>> +			  physical addresses, not guest physical addresses)
>> +
>> +If support for SME is present, MSR 0xc00100010 (SYS_CFG) can be used to
>> +determine if SME is enabled and/or to enable memory encryption:
>> +
>> +	0xc0010010:
>> +		Bit[23]   0 = memory encryption features are disabled
>> +			  1 = memory encryption features are enabled
>> +
>> +Linux relies on BIOS to set this bit if BIOS has determined that the reduction
>> +in the physical address space as a result of enabling memory encryption (see
>> +CPUID information above) will not conflict with the address space resource
>> +requirements for the system.  If this bit is not set upon Linux startup then
>> +Linux itself will not set it and memory encryption will not be possible.
>> +
>> +SME support is configurable in the kernel through the AMD_MEM_ENCRYPT config
>> +option.
> 
> " ... is configurable through CONFIG_AMD_MEM_ENCRYPT."

Ok.

> 
>> Additionally, the mem_encrypt=on command line parameter is required
>> +to activate memory encryption.
> 
> I think you want to rewrite the logic here to say that people should use
> the BIOS option and if none is present for whatever reason, resort to
> the alternative "mem_encrypt=on" kernel command line option, no?

Yes, I'll work on rewording this section.

Thanks,
Tom
> 
