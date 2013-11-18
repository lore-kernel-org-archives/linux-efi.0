From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/7 v2] Add function efi_remap_region for remapping to
 saved virt address
Date: Mon, 18 Nov 2013 17:37:49 +0800
Message-ID: <20131118093749.GA16381@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
 <1384556525.1791.4.camel@misato.fc.hp.com>
 <20131118020939.GB4025@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131118020939.GB4025-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/18/13 at 10:09am, Dave Young wrote:
> On 11/15/13 at 04:02pm, Toshi Kani wrote:
> > On Tue, 2013-11-05 at 16:20 +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > > Kexec kernel will use saved runtime virtual mapping, so add a
> > > new function efi_remap_region to remapping it directly without
> > > calculate the virt addr from efi_va.
> > > 
> > > The md is passed in from 1st kernel, the virtual addr is
> > > saved in md->virt_addr.
> > 
> >  :
> > 
> > > +/*
> > > + * kexec kernel will use efi_map_region_fixed to map efi
> > > + * runtime memory ranges. md->virt_addr is the original virtual
> > > + * address which had been mapped in kexec 1st kernel.
> > > + */
> > > +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> > 
> > Can you simply use __map_region() instead of creating this function?
> > Both functions seem to do the same thing.  (In __map_region(), size and
> > end are not used.)
> 
> Matt also suggest to reuse __map_region in another apply, will do.

Will remove the unused variables in another patch.

--
Thanks
Dave
