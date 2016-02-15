From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access
 ESRT table in memory
Date: Mon, 15 Feb 2016 10:45:52 -0500
Message-ID: <20160215154551.GA785@redhat.com>
References: <1455535953-5056-1-git-send-email-ard.biesheuvel@linaro.org>
 <1455535953-5056-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455535953-5056-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 15, 2016 at 12:32:32PM +0100, Ard Biesheuvel wrote:
> On ARM and arm64, ioremap() and memremap() are not interchangeable like
> on x86, and the use of ioremap() on ordinary RAM is typically flagged
> as an error if the memory region being mapped is also covered by the
> linear mapping, since that would lead to aliases with conflicting
> cacheability attributes.
> 
> Since what we are dealing with is not an I/O region with side effects,
> using ioremap() here is arguably incorrect anyway, so let's replace
> it with memremap instead. Also add a missing unmap on the success path,
> and drop a memblock_remove() call which does not belong here, this far
> into the boot sequence.
> 
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Works on my test box and appears to be correct:

Tested-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/firmware/efi/esrt.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index 22c5285f7705..f096a0a26dbd 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -16,6 +16,7 @@
>  #include <linux/device.h>
>  #include <linux/efi.h>
>  #include <linux/init.h>
> +#include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/kobject.h>
>  #include <linux/list.h>
> @@ -385,15 +386,15 @@ static void cleanup_entry_list(void)
>  static int __init esrt_sysfs_init(void)
>  {
>  	int error;
> -	struct efi_system_resource_table __iomem *ioesrt;
> +	struct efi_system_resource_table *memesrt;
>  
>  	pr_debug("esrt-sysfs: loading.\n");
>  	if (!esrt_data || !esrt_data_size)
>  		return -ENOSYS;
>  
> -	ioesrt = ioremap(esrt_data, esrt_data_size);
> -	if (!ioesrt) {
> -		pr_err("ioremap(%pa, %zu) failed.\n", &esrt_data,
> +	memesrt = memremap(esrt_data, esrt_data_size, MEMREMAP_WB);
> +	if (!memesrt) {
> +		pr_err("memremap(%pa, %zu, MEMREMAP_WB) failed.\n", &esrt_data,
>  		       esrt_data_size);
>  		return -ENOMEM;
>  	}
> @@ -401,11 +402,12 @@ static int __init esrt_sysfs_init(void)
>  	esrt = kmalloc(esrt_data_size, GFP_KERNEL);
>  	if (!esrt) {
>  		pr_err("kmalloc failed. (wanted %zu bytes)\n", esrt_data_size);
> -		iounmap(ioesrt);
> +		memunmap(memesrt);
>  		return -ENOMEM;
>  	}
>  
> -	memcpy_fromio(esrt, ioesrt, esrt_data_size);
> +	memcpy(esrt, memesrt, esrt_data_size);
> +	memunmap(memesrt);
>  
>  	esrt_kobj = kobject_create_and_add("esrt", efi_kobj);
>  	if (!esrt_kobj) {
> @@ -432,8 +434,6 @@ static int __init esrt_sysfs_init(void)
>  	if (error)
>  		goto err_cleanup_list;
>  
> -	memblock_remove(esrt_data, esrt_data_size);
> -
>  	pr_debug("esrt-sysfs: loaded.\n");
>  
>  	return 0;
> -- 
> 2.5.0
> 
