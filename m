From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Fri, 1 Dec 2017 09:47:54 +0000
Message-ID: <20171201094754.GD9353@kroah.com>
References: <20171129045927.GA6217@eros>
 <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros>
 <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com>
 <20171130171036.GB31817@kroah.com>
 <CA+55aFwvbR+6e7YrZ3Q+sYzJsRikJEAi1YsA49CQjWgsa7KTWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwvbR+6e7YrZ3Q+sYzJsRikJEAi1YsA49CQjWgsa7KTWQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 30, 2017 at 06:17:47PM -0500, Linus Torvalds wrote:
> On Thu, Nov 30, 2017 at 12:10 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > So changing it to use __ATTR() should fix this remaning leakage up.
> > That is if we even really need to export these values at all.  What does
> > userspace do with them?  Shouldn't they just be in debugfs instead?
> 
> So what I find distasteful here is how sysfs has these "helper" macros
> that are clearly designed to over-share.

That is by design :)

> The __ATTR macro is a lot  more complicated to use than the
> __ATTR_RO/WO/RW macros, but those macros end up giving everybody read
> access (ok, not the WO one)
> 
> So honestly, I think the "helper" functions should be deprecated
> simply because they basically encourage people to make everything
> world-readable.

Almost all information in sysfs is designed to be world-readable.  I
would argue that almost nothing there should be "root only", as sysfs is
not the place for trying to display "private" information at all.  It is
designed to show a representation of the kernel's internal state of
things (device structure, driver options, firmware objects, etc.)  All
of that information should be freely available to everyone (within the
namespace rules.)

To put root-only information in sysfs is not a good idea, which is why
those macros are there, to make it easy to do it right, and hard to
restrict information.  If you need restrictions, you shouldn't be using
sysfs, as it's almost always something for debugging, and that's what
debugfs is for.

thanks,

greg k-h
