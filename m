From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 04/27] Restrict /dev/mem and /dev/kmem when the kernel is
 locked down
Date: Fri, 20 Oct 2017 14:37:28 +0800
Message-ID: <20171020063728.GM3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842466261.7923.14359746674406637357.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842466261.7923.14359746674406637357.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Hi David,

Thanks for you send out this series.

On Thu, Oct 19, 2017 at 03:51:02PM +0100, David Howells wrote:
> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Allowing users to write to address space makes it possible for the kernel to
> be subverted, avoiding module loading restrictions.  Prevent this when the
> kernel has been locked down.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

I have reviewed and tested this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks a lot!
Joey Lee

> ---
> 
>  drivers/char/mem.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 593a8818aca9..b7c36898b689 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -179,6 +179,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
>  	if (p != *ppos)
>  		return -EFBIG;
>  
> +	if (kernel_is_locked_down("/dev/mem"))
> +		return -EPERM;
> +
>  	if (!valid_phys_addr_range(p, count))
>  		return -EFAULT;
>  
> @@ -540,6 +543,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
>  	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
>  	int err = 0;
>  
> +	if (kernel_is_locked_down("/dev/kmem"))
> +		return -EPERM;
> +
>  	if (p < (unsigned long) high_memory) {
>  		unsigned long to_write = min_t(unsigned long, count,
>  					       (unsigned long)high_memory - p);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
