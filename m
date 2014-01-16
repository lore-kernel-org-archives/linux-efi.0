From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Date: Thu, 16 Jan 2014 14:46:28 +0800
Message-ID: <20140116064627.GC6356@dhcp-16-126.nay.redhat.com>
References: <20140113122320.GA1900@darkstar.nay.redhat.com>
 <52D3FCAA.7070004@linux.intel.com>
 <20140114014003.GB4327@dhcp-16-126.nay.redhat.com>
 <52D57F75.7060308@zytor.com>
 <20140115011609.GD23767@dhcp-16-126.nay.redhat.com>
 <52D6970D.3050701@zytor.com>
 <20140116014457.GA3807@dhcp-16-126.nay.redhat.com>
 <52D746D9.7030206@linux.intel.com>
 <20140116030343.GF3807@dhcp-16-126.nay.redhat.com>
 <52D75A55.2080503@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52D75A55.2080503-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/15/14 at 08:04pm, H. Peter Anvin wrote:
> On 01/15/2014 07:03 PM, Dave Young wrote:
> >>
> >> making something harder to grep and less standardized is hardly cleaner
> >> and these things compile to nothing for non-modules.
> > 
> > It's not nothing, just very small increasement:
> >    text	   data	    bss	    dec	    hex	filename
> > 7636121	1391824	9355264	18383209	1188169	vmlinux
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 7636113	1391824	9355264	18383201	1188161	vmlinux
> > 
> > I do not want to insist on this minor problem, if you want please keep it.
> > 
> 
> Now *that* we can fix by making these macros expand to nothing if you
> are compiling for a nonmodule, right?  That will benefit code that
> legitimately can compile as a module but is configured "y", too.

I'm not sure expanding to nothing is a good fix.

For built-in module we still can retrieve the module info in userspace via
/usr/sbin/modinfo, if we expand the Macros to nothing then userspace will
not see thus infomation anymore.

Another advantage of built-in module is it has module specific parameters which
should not necessary a generic kernel parameter.

If the *module* is really a nonmodule, IMHO it should add the information to
or add other macros macros instead of reuse the MODULE_*.

BTW, for macros in this file, for a nonmodule "license GPL" is unnecessary at all.

Thanks
Dave
