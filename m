From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [patch 1/7 v2] Add function efi_remap_region for remapping to
 saved virt address
Date: Fri, 15 Nov 2013 16:02:05 -0700
Message-ID: <1384556525.1791.4.camel@misato.fc.hp.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
	 <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131105082715.502723229-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-11-05 at 16:20 +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Kexec kernel will use saved runtime virtual mapping, so add a
> new function efi_remap_region to remapping it directly without
> calculate the virt addr from efi_va.
> 
> The md is passed in from 1st kernel, the virtual addr is
> saved in md->virt_addr.

 :

> +/*
> + * kexec kernel will use efi_map_region_fixed to map efi
> + * runtime memory ranges. md->virt_addr is the original virtual
> + * address which had been mapped in kexec 1st kernel.
> + */
> +void __init efi_map_region_fixed(efi_memory_desc_t *md)

Can you simply use __map_region() instead of creating this function?
Both functions seem to do the same thing.  (In __map_region(), size and
end are not used.)

Thanks,
-Toshi
