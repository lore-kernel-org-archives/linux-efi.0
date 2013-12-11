From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v5 02/14] efi: use early_memremap and early_memunmap
Date: Wed, 11 Dec 2013 11:32:07 +0000
Message-ID: <20131211113207.GA29980@console-pimps.org>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-3-git-send-email-dyoung@redhat.com>
 <20131211103903.GC19196@console-pimps.org>
 <20131211110227.GK22356@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131211110227.GK22356-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 11 Dec, at 12:02:27PM, Leif Lindholm wrote:
> On Wed, Dec 11, 2013 at 10:39:03AM +0000, Matt Fleming wrote:
> > Leif, Mark, does this patch look OK for ARM? We'd need to introduce a
> > new early_memunmap() function so that things still build, but that
> > should be straight forward. You'd even be able to get rid of the
> > asymmetry in uefi_init() where you map efi.systab with early_memremap()
> > but unmap it with early_iounmap().
> 
> This patch looks splendid for ARM. As long as Mark can get the new
> function into an update to the early_*remap() set, I can include this
> in my next version - which is coming this week.

Great!

Oh and ia64 would also need early_memunmap(). Tony, the original patch
is here,

  http://article.gmane.org/gmane.linux.kernel.kexec/10383

-- 
Matt Fleming, Intel Open Source Technology Center
