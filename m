From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH 11/13] xen/hvm/params: Add a new dilivery type for
 event-channel in HVM_PARAM_CALLBACK_IRQ
Date: Fri, 20 Nov 2015 17:07:24 +0000
Message-ID: <alpine.DEB.2.02.1511201706070.1107@kaball.uk.xensource.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-12-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-12-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 17 Nov 2015, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Add a new dilivery type:

delivery

> val[63:56] == 3: val[15:8] is flag: val[7:0] is a PPI.
> To the flag, bit 0 stands the interrupt mode is edge(1) or level(0) and
> bit 1 stands the interrupt polarity is active low(1) or high(0).
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  include/xen/interface/hvm/params.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
> index a6c7991..550688a 100644
> --- a/include/xen/interface/hvm/params.h
> +++ b/include/xen/interface/hvm/params.h
> @@ -34,6 +34,11 @@
>   *                  Domain = val[47:32], Bus  = val[31:16],
>   *                  DevFn  = val[15: 8], IntX = val[ 1: 0]
>   * val[63:56] == 2: val[7:0] is a vector number.
> + * val[63:56] == 3: val[15:8] is flag of event-channel interrupt:
> + *                      bit 0: interrupt is edge(1) or level(0) triggered
> + *                      bit 1: interrupt is active low(1) or high(0)
> + *                  val[7:0] is PPI number used by event-channel.
> + *                  This is only used by ARM/ARM64.
>   * If val == 0 then CPU0 event-channel notifications are not delivered.
>   */
>  #define HVM_PARAM_CALLBACK_IRQ 0
> -- 
> 2.1.0
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
