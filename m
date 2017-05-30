From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 32/32] x86/mm: Add support to make use of Secure Memory
 Encryption
Date: Tue, 30 May 2017 10:46:22 -0500
Message-ID: <097e89ec-45a4-3a54-d005-9e7dc436436e@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418212223.10190.85121.stgit@tlendack-t1.amdoffice.net>
 <c29edaff-24f2-ee9b-4142-bdbf8c42083f@amd.com>
 <20170519113005.3f5kwzg4pgh7j6a5@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170519113005.3f5kwzg4pgh7j6a5@pd.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@>
List-Id: linux-efi@vger.kernel.org

On 5/19/2017 6:30 AM, Borislav Petkov wrote:
> On Fri, Apr 21, 2017 at 01:56:13PM -0500, Tom Lendacky wrote:
>> On 4/18/2017 4:22 PM, Tom Lendacky wrote:
>>> Add support to check if SME has been enabled and if memory encryption
>>> should be activated (checking of command line option based on the
>>> configuration of the default state).  If memory encryption is to be
>>> activated, then the encryption mask is set and the kernel is encrypted
>>> "in place."
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>   arch/x86/kernel/head_64.S |    1 +
>>>   arch/x86/mm/mem_encrypt.c |   83 +++++++++++++++++++++++++++++++++++++++++++--
>>>   2 files changed, 80 insertions(+), 4 deletions(-)
>>>
>>
>> ...
>>
>>>
>>> -unsigned long __init sme_enable(void)
>>> +unsigned long __init sme_enable(struct boot_params *bp)
>>>   {
>>> +	const char *cmdline_ptr, *cmdline_arg, *cmdline_on, *cmdline_off;
>>> +	unsigned int eax, ebx, ecx, edx;
>>> +	unsigned long me_mask;
>>> +	bool active_by_default;
>>> +	char buffer[16];
>>
>> So it turns out that when KASLR is enabled (CONFIG_RAMDOMIZE_BASE=y)
>> the stack-protector support causes issues with this function because
> 
> What issues?

The stack protection support makes use of the gs segment register and
at this point not everything is setup properly to allow it to work,
so it segfaults.

Thanks,
Tom

> 
>> it is called so early. I can get past it by adding:
>>
>> CFLAGS_mem_encrypt.o := $(nostackp)
>>
>> in the arch/x86/mm/Makefile, but that obviously eliminates the support
>> for the whole file.  Would it be better to split out the sme_enable()
>> and other boot routines into a separate file or just apply the
>> $(nostackp) to the whole file?
> 
> Josh might have a better idea here... CCed.
> 
