From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 05/17] xen: memory : Add new XENMAPSPACE type
 XENMAPSPACE_dev_mmio
Date: Mon, 8 Feb 2016 11:43:27 +0000
Message-ID: <alpine.DEB.2.02.1602081142360.27008@kaball.uk.xensource.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
 <1454641552-12576-6-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454641552-12576-6-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

On Fri, 5 Feb 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add a new type of Xen map space for Dom0 to map device's MMIO region.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  include/xen/interface/memory.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index 2ecfe4f..9aa8988 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -160,6 +160,7 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mapping_t);
>  #define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another dom,
>  				    * XENMEM_add_to_physmap_range only.
>  				    */
> +#define XENMAPSPACE_dev_mmio     5 /* device mmio region */
>  
>  /*
>   * Sets the GPFN at which a particular page appears in the specified guest's

This patch needs to wait at least until the corresponding Xen patch
(the one which introduces XENMAPSPACE_dev_mmio on the Xen side) is
Acked by one of the Xen maintainers.
