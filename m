From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 3/7 v2] Cleanup efi_enter_virtual_mode function
Date: Thu, 14 Nov 2013 09:39:55 +0800
Message-ID: <20131114013955.GC4081@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082716.825753041@dhcp-16-126.nay.redhat.com>
 <20131113155017.GB17248@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131113155017.GB17248-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
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
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/13/13 at 03:50pm, Matt Fleming wrote:
> On Tue, 05 Nov, at 04:20:10PM, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > Add two small functions:
> > efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
> > calls them instead of embedding two long for loop.
> > 
> > v1->v2:
> > refresh; coding style fixes.
> > 
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi.c |  107 +++++++++++++++++++++++++-------------------
> >  1 file changed, 63 insertions(+), 44 deletions(-)
> 
> [...]
> 
> > @@ -860,17 +840,59 @@ void __init efi_enter_virtual_mode(void)
> >  			efi.systab = (efi_system_table_t *) (unsigned long) systab;
> >  		}
> >  
> > -		new_memmap = krealloc(new_memmap,
> > -				      (count + 1) * memmap.desc_size,
> > -				      GFP_KERNEL);
> > -		if (!new_memmap)
> > +		*new_memmap = krealloc(*new_memmap,
> > +					(*count + 1) * memmap.desc_size,
> > +					GFP_KERNEL);
> > +		if (!*new_memmap)
> >  			goto err_out;
> >  
> > -		memcpy(new_memmap + (count * memmap.desc_size), md,
> > +		memcpy(*new_memmap + (*count * memmap.desc_size), md,
> >  		       memmap.desc_size);
> > -		count++;
> > +		(*count)++;
> >  	}
> >  
> > +err_out:
> > +	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
> > +}
> 
> You should really return an error value here so that we don't
> dereference 'new_memmap' below if it's NULL. In fact, just return the
> memmap...

Good catch, will do

> 
> > +
> > +	efi_merge_regions();
> > +
> > +	efi_map_regions(&new_memmap, &count);
> > +
> 
> and make sure to check the return value here.

Ok.

> -- 
> Matt Fleming, Intel Open Source Technology Center
