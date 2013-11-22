From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 9/9 v3] x86: export x86 boot_params to sysfs
Date: Fri, 22 Nov 2013 10:45:06 +0800
Message-ID: <20131122024506.GB3874@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061757.030007746@dhcp-16-126.nay.redhat.com>
 <20131121164554.GB15083@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131121164554.GB15083-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/21/13 at 08:45am, Greg KH wrote:
> > +static struct kobj_attribute boot_params_version_attr =
> > +	__ATTR(version, S_IRUGO, boot_params_version_show, NULL);
> 
> __ATTR_RO() please.

Will do

> 
> > +static struct kobj_attribute type_attr =
> > +		__ATTR(type, S_IRUGO, setup_data_type_show, NULL);
> 
> __ATTR_RO() here too.

Will do

[snip]
> > +
> > +	ret = get_setup_data_size(nr, &size);
> > +	if (ret)
> > +		goto out_kobj;
> > +
> > +	data_attr.size = size;
> > +	ret = sysfs_create_bin_file(kobj, &data_attr);
> > +	if (ret)
> > +		goto out_file;
> > +	*kobjp = kobj;
> 
> You just raced with userspace (creating and announcing the kobject and
> then, afterward, at some later point in time, created the sysfs files.
> Please use the groups option to create the files properly before
> announcing the kobject to userspace.

Will do

[snip]
> > +		goto out_boot_params_kobj;
> > +	ret = sysfs_create_bin_file(boot_params_kobj,
> > +				      &boot_params_data_attr);
> > +	if (ret)
> > +		goto out_create_file;
> > +
> > +	ret = create_setup_data_nodes(boot_params_kobj);
> > +	if (ret)
> > +		goto out_create_bin;
> > +
> > +	return 0;
> 
> Same race condition here as well.  Use a groups structure please.
> 

Will use group attributes

Thanks for review
Dave
