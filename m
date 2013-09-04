From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH V3 06/11] Restrict /dev/mem and /dev/kmem when module
 loading is restricted
Date: Wed, 4 Sep 2013 10:47:19 +1000 (EST)
Message-ID: <alpine.LRH.2.02.1309041047110.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-7-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378252218-18798-7-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> Allowing users to write to address space makes it possible for the kernel
> to be subverted, avoiding module loading restrictions. Prevent this when
> any restrictions have been imposed on loading modules.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>


Reviewed-by: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>



> ---
>  drivers/char/mem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 1af8664..61406c8 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -159,6 +159,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
>  	unsigned long copied;
>  	void *ptr;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	if (!valid_phys_addr_range(p, count))
>  		return -EFAULT;
>  
> @@ -497,6 +500,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
>  	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
>  	int err = 0;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	if (p < (unsigned long) high_memory) {
>  		unsigned long to_write = min_t(unsigned long, count,
>  					       (unsigned long)high_memory - p);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
