From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 12/27] x86/msr: Restrict MSR access when the kernel is
 locked down
Date: Fri, 20 Oct 2017 14:43:49 +0800
Message-ID: <20171020064349.GT3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:52:04PM +0100, David Howells wrote:
> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Writing to MSRs should not be allowed if the kernel is locked down, since
> it could lead to execution of arbitrary code in kernel mode.  Based on a
> patch by Kees Cook.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

I have reviewed this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks!
Joey Lee

> cc: x86@kernel.org
> ---
> 
>  arch/x86/kernel/msr.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
> index ef688804f80d..a05a97863286 100644
> --- a/arch/x86/kernel/msr.c
> +++ b/arch/x86/kernel/msr.c
> @@ -84,6 +84,9 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
>  	int err = 0;
>  	ssize_t bytes = 0;
>  
> +	if (kernel_is_locked_down("Direct MSR access"))
> +		return -EPERM;
> +
>  	if (count % 8)
>  		return -EINVAL;	/* Invalid chunk size */
>  
> @@ -131,6 +134,10 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
>  			err = -EBADF;
>  			break;
>  		}
> +		if (kernel_is_locked_down("Direct MSR access")) {
> +			err = -EPERM;
> +			break;
> +		}
>  		if (copy_from_user(&regs, uregs, sizeof regs)) {
>  			err = -EFAULT;
>  			break;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
