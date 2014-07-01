From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 15/15] kexec: Support kexec/kdump on EFI systems
Date: Tue, 1 Jul 2014 20:46:05 +0100
Message-ID: <20140701194605.GJ7539@console-pimps.org>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-16-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403814824-7587-16-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Jun, at 04:33:44PM, Vivek Goyal wrote:
> This patch does two thigns. It passes EFI run time mappings to second
> kernel in bootparams efi_info. Second kernel parse this info and create
> new mappings in second kernel. That means mappings in first and second
> kernel will be same. This paves the way to enable EFI in kexec kernel.
> 
> This patch also prepares and passes EFI setup data through bootparams.
> This contains bunch of information about various tables and their
> addresses.
> 
> These information gathering and passing has been written along the lines
> of what current kexec-tools is doing to make kexec work with UEFI.
> 
> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/kernel/kexec-bzimage64.c  | 146 ++++++++++++++++++++++++++++++++++---
>  drivers/firmware/efi/runtime-map.c |  21 ++++++
>  include/linux/efi.h                |  19 +++++
>  3 files changed, 174 insertions(+), 12 deletions(-)

[...]

> diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
> index 97cdd16..40f2213 100644
> --- a/drivers/firmware/efi/runtime-map.c
> +++ b/drivers/firmware/efi/runtime-map.c
> @@ -138,6 +138,27 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
>  	return entry;
>  }
>  
> +int get_efi_runtime_map_size(void)
> +{
> +	return nr_efi_runtime_map * efi_memdesc_size;
> +}
> +
> +int get_efi_runtime_map_desc_size(void)
> +{
> +	return efi_memdesc_size;
> +}
> +
> +int efi_runtime_map_copy(void *buf, size_t bufsz)
> +{
> +	size_t sz = get_efi_runtime_map_size();
> +
> +	if (sz > bufsz)
> +		sz = bufsz;
> +
> +	memcpy(buf, efi_runtime_map, sz);
> +	return 0;
> +}

Could we prefix these with efi_, e.g. efi_get_runtime_map_size() ?

-- 
Matt Fleming, Intel Open Source Technology Center
