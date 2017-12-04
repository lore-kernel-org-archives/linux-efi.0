From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Mon, 4 Dec 2017 15:00:12 +0100
Message-ID: <20171204140012.GA8744@kroah.com>
References: <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171202222244.GA3799@codeblueprint.co.uk>
 <20171204020216.GA2436@dhcp-128-65.nay.redhat.com>
 <20171204073642.GC19596@kroah.com>
 <20171204092928.GA4421@dhcp-128-65.nay.redhat.com>
 <20171204093430.GA6463@kroah.com>
 <CAKv+Gu8iOF1BCpZEVRwT=_6FbXsK0ve7fiWKA5R0D5x2P5MavA@mail.gmail.com>
 <20171204095936.GA10547@kroah.com>
 <CAKv+Gu9_BC=rHPRWBJXtg=Sn2TmPL21wYCS50a_ff_eav3nSOA@mail.gmail.com>
 <d455baafa3d44669a774c7d555c01416@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d455baafa3d44669a774c7d555c01416-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: 'Ard Biesheuvel' <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 04, 2017 at 12:51:13PM +0000, David Laight wrote:
> From: Ard Biesheuvel
> > Sent: 04 December 2017 10:03
> ...
> > and uses __ATTR_RO() to emit initializers for it. __ATTR() initializes
> > the .store member as well, which does not exists, and so it cannot be
> > used directly.
> > 
> > So we should either add a .store member that is always NULL, or we
> > should add our own
> > 
> > #define __ATTR_0400(_name) { \
> > .attr = { .name = __stringify(_name), .mode = 0400 }, \
> > .show = _name##_show, \
> > }
> 
> What about an __ATTR_RO_MODE(name, mode) that doesn't set the .store member.
> Even if the mode allowed write, writes wouldn't happen.

Ah, that might work, could you convert the other users of __ATTR() in
the efi code to use it as well?

thanks,

greg k-h
