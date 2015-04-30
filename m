From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 2/3] firmware_class: split out transaction helpers
Date: Thu, 30 Apr 2015 07:39:58 -0700
Message-ID: <1430404798.2167.5.camel@HansenPartnership.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
	 <1430349052.2189.41.camel@HansenPartnership.com>
	 <20150430131120.GB17936@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150430131120.GB17936@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-efi@vger.kernel.org, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-04-30 at 15:11 +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 29, 2015 at 04:10:52PM -0700, James Bottomley wrote:
> > From: James Bottomley <JBottomley@Odin.com>
> > 
> > The firmware class contains code to manage an arbitrary sized buffer for
> > discrete read and write operations.  We need precisely this ability to update
> > firmware capsule files (and likely for other transactions as well), so split
> > out the capability into a library helper
> > 
> > Signed-off-by: James Bottomley <JBottomley@Odin.com>
> > ---
> >  drivers/base/firmware_class.c      | 117 ++++---------------------------
> >  include/linux/transaction_helper.h |  26 +++++++
> >  lib/Makefile                       |   2 +-
> >  lib/transaction_helper.c           | 137 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 179 insertions(+), 103 deletions(-)
> >  create mode 100644 include/linux/transaction_helper.h
> >  create mode 100644 lib/transaction_helper.c
> 
> Interesting, do you think there are other places that can use this
> "transaction_helper" library?

Certainly, everywhere binary attributes are used for more than a page of
data, I think.  Certainly things like the PPC nvram dump read stuff and
probably a few other architecture specific bin files for nvram.  I
imagine there'll be a long series of janatorial patches if people are
interested.

>   And a bit more documentation would be
> nice, but on the whole, no objection from me.

Yes, that's why it's an RFC.I wanted to show the plan in code, get all
the modification suggestions and then do the proper implementation.
Docs come after the API is agreed.

James
