From: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v4 19/28] swiotlb: Add warnings for use of bounce
	buffers with SME
Date: Fri, 17 Feb 2017 10:59:55 -0500
Message-ID: <20170217155955.GK30272@char.us.ORACLE.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
	<20170216154619.19244.76653.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170216154619.19244.76653.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 16, 2017 at 09:46:19AM -0600, Tom Lendacky wrote:
> Add warnings to let the user know when bounce buffers are being used for
> DMA when SME is active.  Since the bounce buffers are not in encrypted
> memory, these notifications are to allow the user to determine some
> appropriate action - if necessary.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/include/asm/mem_encrypt.h |   11 +++++++++++
>  include/linux/dma-mapping.h        |   11 +++++++++++
>  include/linux/mem_encrypt.h        |    6 ++++++
>  lib/swiotlb.c                      |    3 +++
>  4 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 87e816f..5a17f1b 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -26,6 +26,11 @@ static inline bool sme_active(void)
>  	return (sme_me_mask) ? true : false;
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
> @@ -53,6 +58,12 @@ static inline bool sme_active(void)
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
> index 10c5a17..130bef7 100644
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
> @@ -557,6 +558,11 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>  
>  	if (!dev->dma_mask || !dma_supported(dev, mask))
>  		return -EIO;
> +
> +	if (sme_active() && (mask < sme_dma_mask()))
> +		dev_warn(dev,
> +			 "SME is active, device will require DMA bounce buffers\n");

You can make it one line. But I am wondering if you should use
printk_ratelimit as this may fill the console up.

> +
>  	*dev->dma_mask = mask;
>  	return 0;
>  }
> @@ -576,6 +582,11 @@ static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
>  {
>  	if (!dma_supported(dev, mask))
>  		return -EIO;
> +
> +	if (sme_active() && (mask < sme_dma_mask()))
> +		dev_warn(dev,
> +			 "SME is active, device will require DMA bounce buffers\n");

Ditto.
> +
>  	dev->coherent_dma_mask = mask;
>  	return 0;
>  }
> diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
> index 14a7b9f..6829ff1 100644
> --- a/include/linux/mem_encrypt.h
> +++ b/include/linux/mem_encrypt.h
> @@ -28,6 +28,12 @@ static inline bool sme_active(void)
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
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index c463067..aff9353 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -509,6 +509,9 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
>  	if (no_iotlb_memory)
>  		panic("Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
>  
> +	WARN_ONCE(sme_active(),
> +		  "SME is active and system is using DMA bounce buffers\n");

How does that help?

As in what can the user do with this?
> +
>  	mask = dma_get_seg_boundary(hwdev);
>  
>  	tbl_dma_addr &= mask;
> 
