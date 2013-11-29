From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Date: Fri, 29 Nov 2013 17:46:52 +0800
Message-ID: <20131129094652.GK4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
 <20131126220448.GB18170@console-pimps.org>
 <20131127045237.GC11852@dhcp-16-126.nay.redhat.com>
 <20131127101747.GC18170@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131127101747.GC18170-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
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
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/27/13 at 10:17am, Matt Fleming wrote:
> On Wed, 27 Nov, at 12:52:37PM, Dave Young wrote:
> > To make it more readable, I will change them like below:
> > 
> > p = efi_runtime_map;
> > md = efi_setup->map;
> > for (i = 0; i < nr_efi_runtime_map; i++) {
> > 	[...]
> > 	md += 1;
> > }
>  
> Actually, md++ is the canonical way to write this.

Ok.

> 
> > > 
> > > > +		efi_map_region_fixed(md);
> > > > +		size = md->num_pages << PAGE_SHIFT;
> > > > +		end = md->phys_addr + size;
> > > > +
> > > > +		systab = (u64) (unsigned long) efi_phys.systab;
> > > > +		if (md->phys_addr <= systab && systab < end) {
> > > > +			systab += md->virt_addr - md->phys_addr;
> > > > +			efi.systab =
> > > > +				(efi_system_table_t *) (unsigned long) systab;
> > > > +		}
> > > > +		if (efi_runtime_map) {
> > > > +			memcpy(p, md, memmap.desc_size);
> > > > +			p += memmap.desc_size;
> > > > +		}
> > > 
> > > Is this if () needed? Is it possible to enter the loop and have
> > > 'efi_runtime_map' be NULL?
> > 
> > Yes, it is needed. if efi_runtime_map kmalloc fails I only print error, do not
> > return so kernel can still boot, just kexec on efi will not work that has been
> > put in the error message.
>  
> OK. On second thought, is there any way to turn the above code into a
> call to efi_save_runtime_map()? Because you've basically duplicated that
> code and I can definitely envisage the two code paths fragmenting over
> time, e.g. when someone makes changes to one but not the other.

OK, will consider to reuse the function.

Thanks
Dave
