From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 23/32] swiotlb: Add warnings for use of bounce buffers
 with SME
Date: Tue, 16 May 2017 16:52:09 +0200
Message-ID: <20170516145209.ltbmaq3a2teqr2uv@pd.tnic>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418212019.10190.24034.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170418212019.10190.24034.stgit@tlendack-t1.amdoffice.net>
Sender: owner-linux-mm@kvack.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 04:20:19PM -0500, Tom Lendacky wrote:
> Add warnings to let the user know when bounce buffers are being used for
> DMA when SME is active.  Since the bounce buffers are not in encrypted
> memory, these notifications are to allow the user to determine some
> appropriate action - if necessary.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h |   11 +++++++++++
>  include/linux/dma-mapping.h        |   11 +++++++++++
>  include/linux/mem_encrypt.h        |    6 ++++++
>  lib/swiotlb.c                      |    3 +++
>  4 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 0637b4b..b406df2 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -26,6 +26,11 @@ static inline bool sme_active(void)
>  	return !!sme_me_mask;
>  }
>  
> +static inline u64 sme_dma_mask(void)
> +{
> +	return ((u64)sme_me_mask << 1) - 1;
> +}
> +
>  void __init sme_early_encrypt(resource_size_t paddr,
>  			      unsigned long size);
>  void __init sme_early_decrypt(resource_size_t paddr,
> @@ -50,6 +55,12 @@ static inline bool sme_active(void)
>  {
>  	return false;
>  }
> +
> +static inline u64 sme_dma_mask(void)
> +{
> +	return 0ULL;
> +}
> +
>  #endif
>  
>  static inline void __init sme_early_encrypt(resource_size_t paddr,
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 0977317..f825870 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -10,6 +10,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/kmemcheck.h>
>  #include <linux/bug.h>
> +#include <linux/mem_encrypt.h>
>  
>  /**
>   * List of possible attributes associated with a DMA mapping. The semantics
> @@ -577,6 +578,11 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>  
>  	if (!dev->dma_mask || !dma_supported(dev, mask))
>  		return -EIO;
> +
> +	if (sme_active() && (mask < sme_dma_mask()))
> +		dev_warn_ratelimited(dev,
> +				     "SME is active, device will require DMA bounce buffers\n");

Bah, no need to break that line - just let it stick out. Ditto for the
others.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
