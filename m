From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] efi: move some sysfs files to be read-only by root
Date: Wed, 6 Dec 2017 07:30:52 +0100
Message-ID: <20171206063052.GC20995@kroah.com>
References: <20171205101343.GA5416@kroah.com>
 <20171205205041.GE11064@eros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171205205041.GE11064@eros>
Sender: linux-kernel-owner@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 06, 2017 at 07:50:41AM +1100, Tobin C. Harding wrote:
> On Tue, Dec 05, 2017 at 11:13:43AM +0100, Greg Kroah-Hartman wrote:
> > Thanks to the scripts/leaking_addresses.pl script, it was found that
> > some EFI values should not be readable by non-root users.
> > 
> > So make them root-only, and to do that, add a __ATTR_RO_MODE() macro to
> > make this easier, and use it in other places at the same time.
> > 
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Tested-by: Dave Young <dyoung@redhat.com>
> > Cc: Matt Fleming <matt@codeblueprint.co.uk>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/firmware/efi/efi.c         |    3 +--
> >  drivers/firmware/efi/esrt.c        |   15 ++++++---------
> >  drivers/firmware/efi/runtime-map.c |   10 +++++-----
> >  include/linux/sysfs.h              |    5 +++++
> >  4 files changed, 17 insertions(+), 16 deletions(-)
> > 
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -143,8 +143,7 @@ static ssize_t systab_show(struct kobjec
> >  	return str - buf;
> >  }
> 
> Greg, do you add the CC's here in the commit log for a technical reason?
> Is it so that future investigation that leads to this commit can see who
> to involve in any further discussion?

They came from the output of scripts/get_maintainer.pl on who I should
be sending the patch to, and who should hopefully review it.

> As an example, for the patch that added the %p hashing should I have
> CC'd Jason A. Donenfeld since he was the brains behind the SipHash
> stuff and gave loads of suggestions/direction?

If you want to.  It's also a good way for me to track who the patch gets
sent to when doing multiple versions of a patch series.  git send-email
picks those up and sends the patch to them as well, making it easier on
the developer instead of having to remember a long --cc= list of
addresses.

thanks,

greg k-h
