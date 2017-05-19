From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 23/32] swiotlb: Add warnings for use of bounce buffers
 with SME
Date: Fri, 19 May 2017 14:55:29 -0500
Message-ID: <64f72c46-75df-ce67-e81a-3b85cfe4c7d1@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418212019.10190.24034.stgit@tlendack-t1.amdoffice.net>
 <20170516145209.ltbmaq3a2teqr2uv@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170516145209.ltbmaq3a2teqr2uv@pd.tnic>
Sender: linux-doc-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@>
List-Id: linux-efi@vger.kernel.org

On 5/16/2017 9:52 AM, Borislav Petkov wrote:
> On Tue, Apr 18, 2017 at 04:20:19PM -0500, Tom Lendacky wrote:
>> Add warnings to let the user know when bounce buffers are being used for
>> DMA when SME is active.  Since the bounce buffers are not in encrypted
>> memory, these notifications are to allow the user to determine some
>> appropriate action - if necessary.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/asm/mem_encrypt.h |   11 +++++++++++
>>  include/linux/dma-mapping.h        |   11 +++++++++++
>>  include/linux/mem_encrypt.h        |    6 ++++++
>>  lib/swiotlb.c                      |    3 +++
>>  4 files changed, 31 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
>> index 0637b4b..b406df2 100644
>> --- a/arch/x86/include/asm/mem_encrypt.h
>> +++ b/arch/x86/include/asm/mem_encrypt.h
>> @@ -26,6 +26,11 @@ static inline bool sme_active(void)
>>  	return !!sme_me_mask;
>>  }
>>
>> +static inline u64 sme_dma_mask(void)
>> +{
>> +	return ((u64)sme_me_mask << 1) - 1;
>> +}
>> +
>>  void __init sme_early_encrypt(resource_size_t paddr,
>>  			      unsigned long size);
>>  void __init sme_early_decrypt(resource_size_t paddr,
>> @@ -50,6 +55,12 @@ static inline bool sme_active(void)
>>  {
>>  	return false;
>>  }
>> +
>> +static inline u64 sme_dma_mask(void)
>> +{
>> +	return 0ULL;
>> +}
>> +
>>  #endif
>>
>>  static inline void __init sme_early_encrypt(resource_size_t paddr,
>> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
>> index 0977317..f825870 100644
>> --- a/include/linux/dma-mapping.h
>> +++ b/include/linux/dma-mapping.h
>> @@ -10,6 +10,7 @@
>>  #include <linux/scatterlist.h>
>>  #include <linux/kmemcheck.h>
>>  #include <linux/bug.h>
>> +#include <linux/mem_encrypt.h>
>>
>>  /**
>>   * List of possible attributes associated with a DMA mapping. The semantics
>> @@ -577,6 +578,11 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>>
>>  	if (!dev->dma_mask || !dma_supported(dev, mask))
>>  		return -EIO;
>> +
>> +	if (sme_active() && (mask < sme_dma_mask()))
>> +		dev_warn_ratelimited(dev,
>> +				     "SME is active, device will require DMA bounce buffers\n");
>
> Bah, no need to break that line - just let it stick out. Ditto for the
> others.

Ok.

Thanks,
Tom

>
