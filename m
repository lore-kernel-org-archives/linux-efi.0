From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Date: Mon, 30 Dec 2013 09:38:01 +0800
Message-ID: <20131230013801.GA3827@dhcp-16-126.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
 <20131221160416.GD29501@console-pimps.org>
 <20131223020958.GB3760@dhcp-16-126.nay.redhat.com>
 <20131223080741.GB28919@console-pimps.org>
 <20131225031259.GB6333@dhcp-16-126.nay.redhat.com>
 <20131225033205.GC6333@dhcp-16-126.nay.redhat.com>
 <20131229130546.GA2618@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131229130546.GA2618-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/29/13 at 01:05pm, Matt Fleming wrote:
> On Wed, 25 Dec, at 11:32:05AM, Dave Young wrote:
> > 
> > Matt, if you want to remove the map[0] please fold below one line
> > patch? I have no strong opinion.
> > 
> > Index: linux/arch/x86/include/asm/efi.h
> > ===================================================================
> > --- linux.orig/arch/x86/include/asm/efi.h
> > +++ linux/arch/x86/include/asm/efi.h
> > @@ -139,7 +139,6 @@ struct efi_setup_data {
> >  	u64 tables;
> >  	u64 smbios;
> >  	u64 reserved[8];
> > -	efi_memory_desc_t map[0];
> >  };
> >  
> >  extern u64 efi_setup;
> 
> Thanks Dave, I will fold this in. I would suggest updating your
> kexec-tools patches so that the two structures are in sync.

Sure, since it is removed in kernel I will update kexec-tools.

Thanks
Dave
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
