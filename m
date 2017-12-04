From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Mon, 4 Dec 2017 10:39:54 +0800
Message-ID: <20171204023954.GA2909@dhcp-128-65.nay.redhat.com>
References: <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com>
 <20171130171036.GB31817@kroah.com>
 <CAKv+Gu_KF+BzFGaqYo1ZZAj9j+HkUogAksDFAkBDELU7m1XcPw@mail.gmail.com>
 <20171201094846.GE9353@kroah.com>
 <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171202222244.GA3799@codeblueprint.co.uk>
 <20171204020216.GA2436@dhcp-128-65.nay.redhat.com>
 <1512354837.6321.41.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512354837.6321.41.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/03/17 at 06:33pm, Joe Perches wrote:
> On Mon, 2017-12-04 at 10:02 +0800, Dave Young wrote:
> > I think 0400 is good enough for this issue.
> > 
> > Greg, would you like to agree add an extra macro like below?
> []
> > -static struct map_attribute map_type_attr = __ATTR_RO(type);
> > -static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
> > -static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
> > -static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
> > -static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
> > +static struct map_attribute map_type_attr = __ATTR_IRUSR(type);
> > +static struct map_attribute map_phys_addr_attr   = __ATTR_IRUSR(phys_addr);
> > +static struct map_attribute map_virt_addr_attr  = __ATTR_IRUSR(virt_addr);
> > +static struct map_attribute map_num_pages_attr  = __ATTR_IRUSR(num_pages);
> > +static struct map_attribute map_attribute_attr  = __ATTR_IRUSR(attribute);
> >  
> >  /*
> >   * These are default attributes that are added for every memmap entry.
> > --- linux-x86.orig/include/linux/sysfs.h
> > +++ linux-x86/include/linux/sysfs.h
> > @@ -112,6 +112,11 @@ struct attribute_group {
> >  	.store	= _store,						\
> >  }
> >  
> > +#define __ATTR_IRUSR(_name) {					
> 
> I'd much prefer __ATTR_0400(_name)
> 

I'm also fine with above, easier to get the meaning.

Thanks for the suggestion.
Dave
