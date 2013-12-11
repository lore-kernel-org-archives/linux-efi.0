From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v5 01/14] x86/mm: sparse warning fix for early_memremap
Date: Wed, 11 Dec 2013 10:20:25 +0000
Message-ID: <20131211102025.GB19196@console-pimps.org>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-2-git-send-email-dyoung@redhat.com>
 <20131209150521.GE31650@pd.tnic>
 <20131210021221.GA3800@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131210021221.GA3800-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 10 Dec, at 10:12:21AM, Dave Young wrote:
> On 12/09/13 at 04:05pm, Borislav Petkov wrote:
> > On Mon, Dec 09, 2013 at 05:42:14PM +0800, Dave Young wrote:
> > > There's a lot of sparse warnings for code like below:
> > > void *a = early_memremap(phys_addr, size);
> > > 
> > > early_memremap intend to map kernel memory with ioremap facility, the return
> > > pointer should be a kernel ram pointer instead of iomem one.
> > > 
> > > For making the function clearer and supressing sparse warnings this patch
> > > do below two things:
> > > 1. cast to (__force void *) for the return value of early_memremap
> > 
> > I'd guess this is to shut up the __iomem thing? And we're getting that
> > because we're using ioremap, ... hohum...
> 
> Yes, IMHO early_memremap really should not return __iomem pointer since it's
> *memremap*... 

This needs reviewing by at least one of the x86 folks, but it certainly
makes sense to me.

-- 
Matt Fleming, Intel Open Source Technology Center
