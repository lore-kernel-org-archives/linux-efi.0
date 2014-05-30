From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH]x86 efi: do not export efi runtime map in case old map
Date: Fri, 30 May 2014 14:17:40 +0800
Message-ID: <20140530061740.GC2187@darkstar.nay.redhat.com>
References: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
 <20140530055447.GB2187@darkstar.nay.redhat.com>
 <20140530060810.GA31868@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140530060810.GA31868-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Simon Horman <horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 05/30/14 at 03:08pm, Simon Horman wrote:
> On Fri, May 30, 2014 at 01:54:47PM +0800, Dave Young wrote:
> > Ccing Simon.
> > 
> > Simon, appologize for not ccing you about this kernel patch. I see you have
> > applied the userspace patch for checking sysfs runtime existance.
> > 
> > The userspace patch depends on this patch but it is not harmful even without
> > this kernel patch. So applying the userspace patch before this one is still
> > safe.
> 
> Thanks, I understand.
> 
> If the kernel side ends up being rejected or modified please
> send an update for kexec-tools accordingly.

Sure, will do

Thanks
Dave
