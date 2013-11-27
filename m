From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4 10/12] x86: export x86 boot_params to sysfs
Date: Wed, 27 Nov 2013 11:20:22 +0000
Message-ID: <20131127112022.GE18170@console-pimps.org>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-11-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385445477-9665-11-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Nov, at 01:57:55PM, Dave Young wrote:
> +Users:
> +		Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

"Kexec" please.

> +static ssize_t version_show(struct kobject *kobj,
> +					struct kobj_attribute *attr, char *buf)

This is pretty strange indentation. Usually we prefer to line up the
arguments like you've done elsewhere in this file.

> +{
> +	return sprintf(buf, "0x%04x\n", boot_params.hdr.version);
> +}
> +
> +static struct kobj_attribute boot_params_version_attr = __ATTR_RO(version);
> +
> +static ssize_t boot_params_data_read(struct file *fp, struct kobject *kobj,
> +				     struct bin_attribute *bin_attr,
> +				     char *buf, loff_t off, size_t count)
> +{
> +	memcpy(buf, (void *)&boot_params + off, count);
> +	return count;
> +}

Don't we need some checks here to ensure we don't read past the end of
boot_params?

> +static ssize_t type_show(struct kobject *kobj,
> +					struct kobj_attribute *attr, char *buf)

More whacky indentation.

> +static int __init create_setup_data_node(struct kobject *parent,
> +					struct kobject **kobjp, int nr)

Funky indentation.

-- 
Matt Fleming, Intel Open Source Technology Center
