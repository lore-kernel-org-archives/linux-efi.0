From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Mon, 4 Dec 2017 10:34:30 +0100
Message-ID: <20171204093430.GA6463@kroah.com>
References: <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com>
 <20171130171036.GB31817@kroah.com>
 <CAKv+Gu_KF+BzFGaqYo1ZZAj9j+HkUogAksDFAkBDELU7m1XcPw@mail.gmail.com>
 <20171201094846.GE9353@kroah.com>
 <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171202222244.GA3799@codeblueprint.co.uk>
 <20171204020216.GA2436@dhcp-128-65.nay.redhat.com>
 <20171204073642.GC19596@kroah.com>
 <20171204092928.GA4421@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171204092928.GA4421-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 04, 2017 at 05:29:28PM +0800, Dave Young wrote:
> On 12/04/17 at 08:36am, Greg Kroah-Hartman wrote:
> > On Mon, Dec 04, 2017 at 10:02:16AM +0800, Dave Young wrote:
> > > +#define __ATTR_IRUSR(_name) {						\
> > > +	.attr   = { .name = __stringify(_name), .mode = S_IRUSR },	\
> > > +	.show   = _name##_show,						\
> > > +}
> > 
> > Ick, no, as others, including Linus, have said, using IRUSER is a pain
> > in the ass to try to look up and remember what it is...
> > 
> > Just use __ATTR() please, it should be fine for what you need to do,
> > which is special-case a sysfs attribute.
> 
> Hmm, I was hesitating to do that because it needs either long code
> (over 80 chars) or some driver internal macros.
> 
> There is already same issue in dmi-sysfs.c, it uses an internal macro
> DMI_SYSFS_ATTR for 0400 attr.  I did not search all the kernel code,
> there might be more for such special cases. Maybe we can add some
> comment in sysfs.h to mention this is for some special case?
> 
> I can do something similar as dmi sysfs code though.

Hm, let me look at this this afternoon when I get through some stable
patches, it shouldn't be that complex to need a whole new macro...

thanks,

greg k-h
