From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v5 12/14] x86: export x86 boot_params to sysfs
Date: Fri, 13 Dec 2013 21:04:12 +0100
Message-ID: <20131213200412.GA12466@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-13-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1386582147-9802-13-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 09, 2013 at 05:42:25PM +0800, Dave Young wrote:
> kexec-tools use boot_params for getting the 1st kernel hardware_subarch,
> the kexec kernel efi runtime support also need read the old efi_info from
> boot_params. Currently it exists in debugfs which is not a good place for
> such infomation. Per HPA, we should avoid of "sploit debugfs".
> 
> In this patch /sys/kernel/boot_params are exported, also the setup_data is
> exported as a subdirectory. kexec-tools is using debugfs for hardware_subarch
> for a long time now so we're not removing it yet.
> 
> Structure is like below:
> 
> /sys/kernel/boot_params
> |__ data                /* boot_params in binary*/
> |__ setup_data
> |   |__ 0               /* the first setup_data node */
> |   |   |__ data        /* setup_data node 0 in binary*/
> |   |   |__ type        /* setup_data type of setup_data node 0, hex string */
> [snip]
> |__ version             /* boot protocal version (in hex, "0x" prefixed)*/
> 
> Changelog:
> Greg: use __ATTR_RO() and group attr.
> Matt and Boris: Documentation improvement, code indentation.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
