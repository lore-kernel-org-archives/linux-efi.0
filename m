From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Mon, 4 Dec 2017 11:11:06 +0100
Message-ID: <20171204101106.GA28006@kroah.com>
References: <20171201094846.GE9353@kroah.com>
 <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171202222244.GA3799@codeblueprint.co.uk>
 <20171204020216.GA2436@dhcp-128-65.nay.redhat.com>
 <20171204073642.GC19596@kroah.com>
 <20171204092928.GA4421@dhcp-128-65.nay.redhat.com>
 <20171204093430.GA6463@kroah.com>
 <CAKv+Gu8iOF1BCpZEVRwT=_6FbXsK0ve7fiWKA5R0D5x2P5MavA@mail.gmail.com>
 <20171204095936.GA10547@kroah.com>
 <CAKv+Gu9_BC=rHPRWBJXtg=Sn2TmPL21wYCS50a_ff_eav3nSOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9_BC=rHPRWBJXtg=Sn2TmPL21wYCS50a_ff_eav3nSOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Young <dyoung@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 04, 2017 at 10:03:19AM +0000, Ard Biesheuvel wrote:
> On 4 December 2017 at 09:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Dec 04, 2017 at 09:48:37AM +0000, Ard Biesheuvel wrote:
> >> On 4 December 2017 at 09:34, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > On Mon, Dec 04, 2017 at 05:29:28PM +0800, Dave Young wrote:
> >> >> On 12/04/17 at 08:36am, Greg Kroah-Hartman wrote:
> >> >> > On Mon, Dec 04, 2017 at 10:02:16AM +0800, Dave Young wrote:
> >> >> > > +#define __ATTR_IRUSR(_name) {                                            \
> >> >> > > + .attr   = { .name = __stringify(_name), .mode = S_IRUSR },      \
> >> >> > > + .show   = _name##_show,                                         \
> >> >> > > +}
> >> >> >
> >> >> > Ick, no, as others, including Linus, have said, using IRUSER is a pain
> >> >> > in the ass to try to look up and remember what it is...
> >> >> >
> >> >> > Just use __ATTR() please, it should be fine for what you need to do,
> >> >> > which is special-case a sysfs attribute.
> >> >>
> >> >> Hmm, I was hesitating to do that because it needs either long code
> >> >> (over 80 chars) or some driver internal macros.
> >> >>
> >> >> There is already same issue in dmi-sysfs.c, it uses an internal macro
> >> >> DMI_SYSFS_ATTR for 0400 attr.  I did not search all the kernel code,
> >> >> there might be more for such special cases. Maybe we can add some
> >> >> comment in sysfs.h to mention this is for some special case?
> >> >>
> >> >> I can do something similar as dmi sysfs code though.
> >> >
> >> > Hm, let me look at this this afternoon when I get through some stable
> >> > patches, it shouldn't be that complex to need a whole new macro...
> >> >
> >>
> >> But wasn't that the whole point? That there is a macro that does what
> >> you don't want (__ATTR_RO) and none that does what you do want?
> >
> > my point is that __ATTR() should work for you as-is...
> 
> Well, not entirely.
> 
> Not sure if the runtime-map code is doing anything wrong here, but it defines
> 
> struct map_attribute {
>     struct attribute attr;
>     ssize_t (*show)(struct efi_runtime_map_entry *entry, char *buf);
> };
> 
> and uses __ATTR_RO() to emit initializers for it. __ATTR() initializes
> the .store member as well, which does not exists, and so it cannot be
> used directly.
> 
> So we should either add a .store member that is always NULL, or we
> should add our own

You should add a .store member that is always null, as you are getting
away with a nice hack by relying on that not being present :)

> #define __ATTR_0400(_name) { \
> .attr = { .name = __stringify(_name), .mode = 0400 }, \
> .show = _name##_show, \
> }
> 
> that does not set .store at all.

Creating a new macro for every different mode value you are wanting to
use seems a bit overkill, just use __ATTR() as is please.  You are
already using it in other efi files today:
	drivers/firmware/efi/efi.c
	drivers/firmware/efi/esrt.c
thanks,

greg k-h
