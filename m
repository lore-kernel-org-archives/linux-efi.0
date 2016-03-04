From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v5 16/17] FDT: Add a helper to get the subnode by given
 name
Date: Fri, 4 Mar 2016 12:27:08 +0000
Message-ID: <alpine.DEB.2.02.1603041226520.17938@kaball.uk.xensource.com>
References: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com>
 <1457073455-11516-17-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457073455-11516-17-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 4 Mar 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Sometimes it needs to check if there is a subnode of given node in FDT
> by given name. Introduce this helper to get the subnode if it exists.
> 
> CC: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Acked-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>


>  drivers/of/fdt.c       | 13 +++++++++++++
>  include/linux/of_fdt.h |  2 ++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 655f79d..09001db 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -645,6 +645,19 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
>  }
>  
>  /**
> + * of_get_flat_dt_subnode_by_name - get the subnode by given name
> + *
> + * @node: the parent node
> + * @uname: the name of subnode
> + * @return offset of the subnode, or -FDT_ERR_NOTFOUND if there is none
> + */
> +
> +int of_get_flat_dt_subnode_by_name(unsigned long node, const char *uname)
> +{
> +	return fdt_subnode_offset(initial_boot_params, node, uname);
> +}
> +
> +/**
>   * of_get_flat_dt_root - find the root node in the flat blob
>   */
>  unsigned long __init of_get_flat_dt_root(void)
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index df9ef38..fc28162 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -52,6 +52,8 @@ extern char __dtb_end[];
>  extern int of_scan_flat_dt(int (*it)(unsigned long node, const char *uname,
>  				     int depth, void *data),
>  			   void *data);
> +extern int of_get_flat_dt_subnode_by_name(unsigned long node,
> +					  const char *uname);
>  extern const void *of_get_flat_dt_prop(unsigned long node, const char *name,
>  				       int *size);
>  extern int of_flat_dt_is_compatible(unsigned long node, const char *name);
> -- 
> 2.0.4
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
