From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v4 25/28] x86: Access the setup data through sysfs
	decrypted
Date: Wed, 8 Mar 2017 15:09:34 +0800
Message-ID: <20170308070934.GC11045@dhcp-128-65.nay.redhat.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
	<20170216154738.19244.37908.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170216154738.19244.37908.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/16/17 at 09:47am, Tom Lendacky wrote:
> Use memremap() to map the setup data.  This will make the appropriate
> decision as to whether a RAM remapping can be done or if a fallback to
> ioremap_cache() is needed (similar to the setup data debugfs support).
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/kernel/ksysfs.c |   27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
> index 4afc67f..d653b3e 100644
> --- a/arch/x86/kernel/ksysfs.c
> +++ b/arch/x86/kernel/ksysfs.c
> @@ -16,6 +16,7 @@
>  #include <linux/stat.h>
>  #include <linux/slab.h>
>  #include <linux/mm.h>
> +#include <linux/io.h>
>  
>  #include <asm/io.h>
>  #include <asm/setup.h>
> @@ -79,12 +80,12 @@ static int get_setup_data_paddr(int nr, u64 *paddr)
>  			*paddr = pa_data;
>  			return 0;
>  		}
> -		data = ioremap_cache(pa_data, sizeof(*data));
> +		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
>  		if (!data)
>  			return -ENOMEM;
>  
>  		pa_data = data->next;
> -		iounmap(data);
> +		memunmap(data);
>  		i++;
>  	}
>  	return -EINVAL;
> @@ -97,17 +98,17 @@ static int __init get_setup_data_size(int nr, size_t *size)
>  	u64 pa_data = boot_params.hdr.setup_data;
>  
>  	while (pa_data) {
> -		data = ioremap_cache(pa_data, sizeof(*data));
> +		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
>  		if (!data)
>  			return -ENOMEM;
>  		if (nr == i) {
>  			*size = data->len;
> -			iounmap(data);
> +			memunmap(data);
>  			return 0;
>  		}
>  
>  		pa_data = data->next;
> -		iounmap(data);
> +		memunmap(data);
>  		i++;
>  	}
>  	return -EINVAL;
> @@ -127,12 +128,12 @@ static ssize_t type_show(struct kobject *kobj,
>  	ret = get_setup_data_paddr(nr, &paddr);
>  	if (ret)
>  		return ret;
> -	data = ioremap_cache(paddr, sizeof(*data));
> +	data = memremap(paddr, sizeof(*data), MEMREMAP_WB);
>  	if (!data)
>  		return -ENOMEM;
>  
>  	ret = sprintf(buf, "0x%x\n", data->type);
> -	iounmap(data);
> +	memunmap(data);
>  	return ret;
>  }
>  
> @@ -154,7 +155,7 @@ static ssize_t setup_data_data_read(struct file *fp,
>  	ret = get_setup_data_paddr(nr, &paddr);
>  	if (ret)
>  		return ret;
> -	data = ioremap_cache(paddr, sizeof(*data));
> +	data = memremap(paddr, sizeof(*data), MEMREMAP_WB);
>  	if (!data)
>  		return -ENOMEM;
>  
> @@ -170,15 +171,15 @@ static ssize_t setup_data_data_read(struct file *fp,
>  		goto out;
>  
>  	ret = count;
> -	p = ioremap_cache(paddr + sizeof(*data), data->len);
> +	p = memremap(paddr + sizeof(*data), data->len, MEMREMAP_WB);
>  	if (!p) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
>  	memcpy(buf, p + off, count);
> -	iounmap(p);
> +	memunmap(p);
>  out:
> -	iounmap(data);
> +	memunmap(data);
>  	return ret;
>  }
>  
> @@ -250,13 +251,13 @@ static int __init get_setup_data_total_num(u64 pa_data, int *nr)
>  	*nr = 0;
>  	while (pa_data) {
>  		*nr += 1;
> -		data = ioremap_cache(pa_data, sizeof(*data));
> +		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
>  		if (!data) {
>  			ret = -ENOMEM;
>  			goto out;
>  		}
>  		pa_data = data->next;
> -		iounmap(data);
> +		memunmap(data);
>  	}
>  
>  out:
> 

It would be better that these cleanup patches are sent separately.

Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Dave
