From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Date: Mon, 23 Dec 2013 10:06:48 +0800
Message-ID: <20131223020648.GA3760@dhcp-16-126.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
 <20131221145348.GC29501@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131221145348.GC29501-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> > +		if (data)
> > +			early_memunmap(data, sizeof(*data));
> >  #ifdef CONFIG_X86_32
> >  		if (tmp >> 32) {
> >  			pr_err("EFI data located above 4GB, disabling EFI.\n");
> 
> This isn't correct, and means we now won't trigger this pr_err() if
> booting a CONFIG_X86_32 kernel with EFI_64BIT and where the ->fw_vendor,
> ->runtime or ->tables pointer is above 4GB - you've mixed up systab and
> systab64. I've fixed this up like so when applying this patch,

You are right, I missed this 32bit tmp value, thanks for taking care of this.

Thanks
Dave
