From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked
 down
Date: Fri, 20 Oct 2017 14:33:20 +0800
Message-ID: <20171020063320.GL3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150842465546.7923.6762214527898273559.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi David,

Thanks for you send our this series.

On Thu, Oct 19, 2017 at 03:50:55PM +0100, David Howells wrote:
> If the kernel is locked down, require that all modules have valid
> signatures that we can verify.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I have reviewed and tested this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>

Thanks a lot!
Joey Lee

> ---
> 
>  kernel/module.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index de66ec825992..3d9a3270c179 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2781,7 +2781,8 @@ static int module_sig_check(struct load_info *info, int flags)
>  	}
>  
>  	/* Not having a signature is only an error if we're strict. */
> -	if (err == -ENOKEY && !sig_enforce)
> +	if (err == -ENOKEY && !sig_enforce &&
> +	    !kernel_is_locked_down("Loading of unsigned modules"))
>  		err = 0;
>  
>  	return err;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
