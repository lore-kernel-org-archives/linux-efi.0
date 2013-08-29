From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 08/10] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Thu, 29 Aug 2013 14:10:52 -0400
Message-ID: <20130829181052.GA8697@redhat.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
 <1376933171-9854-9-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376933171-9854-9-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 01:26:09PM -0400, Matthew Garrett wrote:
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that module signing enforcement is meant to prevent. It makes
> sense to disable kexec in this situation.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/kexec.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f7b55..1a7690f 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -32,6 +32,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/swap.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/module.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -1645,6 +1646,9 @@ int kernel_kexec(void)
>  		goto Unlock;
>  	}
>  
> +	if (secure_modules())
> +		return -EPERM;
> +

Hi Matthew, 

Why do disallow this at run time. To me denying this at kexec_load() time
sounds better. Otherwise a user will think that I loaded crash kernel
successfully and when crash actually happens, we never capture the
crash dump.

Thanks
Vivek
