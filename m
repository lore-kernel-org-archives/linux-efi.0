From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v3 09/17] xen/hvm/params: Add a new delivery type for
 event-channel in HVM_PARAM_CALLBACK_IRQ
Date: Mon, 25 Jan 2016 15:08:33 +0000
Message-ID: <alpine.DEB.2.02.1601251508130.9687@kaball.uk.xensource.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
 <1453519184-11908-10-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453519184-11908-10-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

On Sat, 23 Jan 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add a new delivery type:
> val[63:56] == 3: val[15:8] is flag: val[7:0] is a PPI.
> To the flag, bit 0 stands the interrupt mode is edge(1) or level(0) and
> bit 1 stands the interrupt polarity is active low(1) or high(0).
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  include/xen/interface/hvm/params.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
> index 70ad208..5dd629f 100644
> --- a/include/xen/interface/hvm/params.h
> +++ b/include/xen/interface/hvm/params.h
> @@ -53,6 +53,15 @@
>   * if this delivery method is available.
>   */
>  
> +#define HVM_PARAM_CALLBACK_TYPE_EVENT    3
> +/*
> + * val[15:8] is flag of event-channel interrupt:
> + *  bit 0: interrupt is edge(1) or level(0) triggered
> + *  bit 1: interrupt is active low(1) or high(0)
> + * val[7:0] is PPI number used by event-channel.
> + * This is only used by ARM/ARM64.
> + */
> +
>  #define HVM_PARAM_STORE_PFN    1
>  #define HVM_PARAM_STORE_EVTCHN 2
>  
> -- 
> 2.0.4
> 
> 
