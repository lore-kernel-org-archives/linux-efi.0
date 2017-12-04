From: Dave Young <dyoung@redhat.com>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Mon, 4 Dec 2017 17:29:28 +0800
Message-ID: <20171204092928.GA4421@dhcp-128-65.nay.redhat.com>
References: <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com>
 <20171130171036.GB31817@kroah.com>
 <CAKv+Gu_KF+BzFGaqYo1ZZAj9j+HkUogAksDFAkBDELU7m1XcPw@mail.gmail.com>
 <20171201094846.GE9353@kroah.com>
 <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171202222244.GA3799@codeblueprint.co.uk>
 <20171204020216.GA2436@dhcp-128-65.nay.redhat.com>
 <20171204073642.GC19596@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171204073642.GC19596@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 12/04/17 at 08:36am, Greg Kroah-Hartman wrote:
> On Mon, Dec 04, 2017 at 10:02:16AM +0800, Dave Young wrote:
> > +#define __ATTR_IRUSR(_name) {						\
> > +	.attr   = { .name = __stringify(_name), .mode = S_IRUSR },	\
> > +	.show   = _name##_show,						\
> > +}
> 
> Ick, no, as others, including Linus, have said, using IRUSER is a pain
> in the ass to try to look up and remember what it is...
> 
> Just use __ATTR() please, it should be fine for what you need to do,
> which is special-case a sysfs attribute.

Hmm, I was hesitating to do that because it needs either long code
(over 80 chars) or some driver internal macros.

There is already same issue in dmi-sysfs.c, it uses an internal macro
DMI_SYSFS_ATTR for 0400 attr.  I did not search all the kernel code,
there might be more for such special cases. Maybe we can add some
comment in sysfs.h to mention this is for some special case?

I can do something similar as dmi sysfs code though.

> 
> thanks,
> 
> greg k-h

Thanks
Dave
