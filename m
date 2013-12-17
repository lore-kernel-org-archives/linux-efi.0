From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 08/14] efi: export efi runtime memory mapping to sysfs
Date: Tue, 17 Dec 2013 14:13:47 +0800
Message-ID: <20131217061347.GD6751@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-9-git-send-email-dyoung@redhat.com>
 <20131216150929.GA3873@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131216150929.GA3873-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/16/13 at 03:09pm, Matt Fleming wrote:
> On Mon, 16 Dec, at 05:30:29PM, Dave Young wrote:
> > @@ -899,6 +928,11 @@ void __init efi_enter_virtual_mode(void)
> >  		return;
> >  	}
> >  
> > +#ifdef CONFIG_EFI_RUNTIME_MAP
> > +	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
> > +			      boot_params.efi_info.efi_memdesc_size);
> > +#endif
> 
> [...]
> 
> > @@ -167,6 +167,12 @@ static int __init efisubsys_init(void)
> >  		goto err_unregister;
> >  	}
> >  
> > +#ifdef CONFIG_EFI_RUNTIME_MAP
> > +	error = efi_runtime_map_init(efi_kobj);
> > +	if (error)
> > +		goto err_remove_group;
> > +#endif
> 
> [...]
> 
> > @@ -876,4 +876,9 @@ int efivars_sysfs_init(void);
> >  
> >  #endif /* CONFIG_EFI_VARS */
> >  
> > +#ifdef CONFIG_EFI_RUNTIME_MAP
> > +int efi_runtime_map_init(struct kobject *);
> > +void efi_runtime_map_setup(void *, int, u32);
> > +#endif
> 
> I was thinking more along the lines of...

Previously I only call the function conditionally thus there's
compiler warning about "unused function" for the #else

unconditionally call it build will be ok. Will update this patch.
