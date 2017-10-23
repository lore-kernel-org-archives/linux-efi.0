From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has
 been set
Date: Mon, 23 Oct 2017 11:54:43 -0400
Message-ID: <1508774083.3639.124.camel@linux.vnet.ibm.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150842468754.7923.10037578333644594134.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-10-19 at 15:51 +0100, David Howells wrote:
> From: Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> When KEXEC_VERIFY_SIG is not enabled, kernel should not loads image
> through kexec_file systemcall if securelevel has been set.

The patch title and description needs to be updated to refer to
lockdown, not securelevel.

As previously mentioned the last time these patches were posted, this
leaves out testing to see if the integrity subsystem is enabled.

Commit 503ceaef8e2e "ima: define a set of appraisal rules requiring
file signatures" was upstreamed.  An additional patch could force
these rules to be added to the custom policy, if lockdown is enabled.
 This and other patches in this series could then check to see if
is_ima_appraise_enabled() is true.

Mimi


> This code was showed in Matthew's patch but not in git:
> https://lkml.org/lkml/2015/3/13/778
> 
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Signed-off-by: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> ---
> 
>  kernel/kexec_file.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 9f48f4412297..ff6523f2dcc2 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -255,6 +255,13 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
>  	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
>  		return -EPERM;
> 
> +	/* Don't permit images to be loaded into trusted kernels if we're not
> +	 * going to verify the signature on them
> +	 */
> +	if (!IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG) &&
> +	    kernel_is_locked_down("kexec of unsigned images"))
> +		return -EPERM;
> +
>  	/* Make sure we have a legal set of flags */
>  	if (flags != (flags & KEXEC_FILE_FLAGS))
>  		return -EINVAL;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
