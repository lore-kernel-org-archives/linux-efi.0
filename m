From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch 2/6] x86 efi: reserve boot service fix
Date: Sun, 27 Oct 2013 20:30:58 +0000
Message-ID: <20131027203058.GE1982@console-pimps.org>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.924386710@dhcp-16-126.nay.redhat.com>
 <20131027105009.GA21868@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131027105009.GA21868-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, 27 Oct, at 11:50:09AM, Borislav Petkov wrote:
> On Sun, Oct 27, 2013 at 11:47:15AM +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > Current code check boot service region with kernel text region by: 
> > start+size >= __pa_symbol(_text)
> > The end of the above region should be start + size - 1 instead.
> > 
> > I see this problem in ovmf + Fedora 19 grub boot:
> > text start: 1000000 md start: 800000 md size: 800000
> > 
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> Btw, Matt, this being a bugfix and all, shouldn't it be tagged for
> stable?

Well that depends. Dave, am I correct in thinking that you only noticed
this bug when writing kexec support? I'm inclined not to bother with a
stable tag if no one has ever noticed any fallout from this bug until
now.

-- 
Matt Fleming, Intel Open Source Technology Center
