From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 09/27] uswsusp: Disable when the kernel is locked down
Date: Fri, 20 Oct 2017 14:41:09 +0800
Message-ID: <20171020064109.GQ3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842470227.7923.15293760935442172683.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842470227.7923.15293760935442172683.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:51:42PM +0100, David Howells wrote:
> From: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> uswsusp allows a user process to dump and then restore kernel state, which
> makes it possible to modify the running kernel.  Disable this if the kernel
> is locked down.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-pm@vger.kernel.org

I have reviewed and tested this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks a lot!
Joey Lee

> ---
> 
>  kernel/power/user.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 22df9f7ff672..678ade9decfe 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -52,6 +52,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
>  	if (!hibernation_available())
>  		return -EPERM;
>  
> +	if (kernel_is_locked_down("/dev/snapshot"))
> +		return -EPERM;
> +
>  	lock_system_sleep();
>  
>  	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
