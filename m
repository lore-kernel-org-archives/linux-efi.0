From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/24] kexec: Disable at runtime if the kernel is locked
 down
Date: Fri, 7 Apr 2017 11:07:05 +0800
Message-ID: <20170407030705.GB4296@dhcp-128-65.nay.redhat.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142333752.5101.12956279967668146884.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149142333752.5101.12956279967668146884.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/05/17 at 09:15pm, David Howells wrote:
> From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> 
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that lock-down is meant to prevent. It makes sense to disable
> kexec in this situation.
> 
> This does not affect kexec_file_load() which can check for a signature on the
> image to be booted.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> ---
> 
>  kernel/kexec.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 980936a90ee6..46de8e6b42f4 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -194,6 +194,13 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  		return -EPERM;
>  
>  	/*
> +	 * kexec can be used to circumvent module loading restrictions, so
> +	 * prevent loading in that case
> +	 */
> +	if (kernel_is_locked_down())
> +		return -EPERM;
> +
> +	/*
>  	 * Verify we have a legal set of flags
>  	 * This leaves us room for future extensions.
>  	 */
> 
> 
> _______________________________________________
> kexec mailing list
> kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/kexec

Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Dave
