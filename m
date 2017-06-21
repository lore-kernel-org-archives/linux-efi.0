From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 25/36] swiotlb: Add warnings for use of bounce buffers
 with SME
Date: Wed, 21 Jun 2017 12:50:26 +0200
Message-ID: <20170621105026.lcbtkklaenyi2wqe@pd.tnic>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net>
 <20170616185435.18967.26665.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170616185435.18967.26665.stgit@tlendack-t1.amdoffice.net>
Sender: linux-arch-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, xen-devel@lists.xen.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave Young <dy>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 16, 2017 at 01:54:36PM -0500, Tom Lendacky wrote:
> Add warnings to let the user know when bounce buffers are being used for
> DMA when SME is active.  Since the bounce buffers are not in encrypted
> memory, these notifications are to allow the user to determine some
> appropriate action - if necessary.  Actions can range from utilizing an
> IOMMU, replacing the device with another device that can support 64-bit
> DMA, ignoring the message if the device isn't used much, etc.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  include/linux/dma-mapping.h |   11 +++++++++++
>  include/linux/mem_encrypt.h |    8 ++++++++
>  lib/swiotlb.c               |    3 +++
>  3 files changed, 22 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 4f3eece..ee2307e 100644
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
> +	/* Since mask is unsigned, this can only be true if SME is active */
> +	if (mask < sme_dma_mask())
> +		dev_warn(dev, "SME is active, device will require DMA bounce buffers\n");
> +
>  	*dev->dma_mask = mask;
>  	return 0;
>  }
> @@ -596,6 +602,11 @@ static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
>  {
>  	if (!dma_supported(dev, mask))
>  		return -EIO;
> +
> +	/* Since mask is unsigned, this can only be true if SME is active */
> +	if (mask < sme_dma_mask())
> +		dev_warn(dev, "SME is active, device will require DMA bounce buffers\n");

Looks to me like those two checks above need to be a:

void sme_check_mask(struct device *dev, u64 mask)
{
        if (!sme_me_mask)
                return;

        /* Since mask is unsigned, this can only be true if SME is active */
        if (mask < (((u64)sme_me_mask << 1) - 1))
                dev_warn(dev, "SME is active, device will require DMA bounce buffers\n");
}

which gets called and sme_dma_mask() is not really needed.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
