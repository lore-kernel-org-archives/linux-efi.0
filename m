From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Wed, 28 May 2014 10:51:40 -0400
Message-ID: <20140528145140.GN14863@redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140528020935.GB2820-4/PLUo9XfK+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 28, 2014 at 10:09:35AM +0800, Dave Young wrote:

[..]
> > I've only vaguely been following along with the other thread, so please
> > summarise everything again in your patch. Particularly, I need answers
> > to the following questions,
> > 
> >  - Are you trying to fix a kexec/kdump regression?
> 
> Somehow it is a regression.

Well, it is a *regression*. Previously kdump would work with
SGI UV machines as it used "noefi". Now kexec by default thinks that
efi is enabled and 1:1 mappings are in place and that does not work
with SGI UV machines.

So just providing --noefi is not enough. Somebody needs to automatically
figure out that this SGI machine does not contain 1:1 mapping and hence
need to fall back to old mode. --noefi is good for override.

Thanks
Vivek
