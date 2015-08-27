From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 2/3] firmware_class: split out transaction helpers
Date: Thu, 27 Aug 2015 09:25:17 -0700
Message-ID: <1440692717.2196.123.camel@HansenPartnership.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
	 <1430349052.2189.41.camel@HansenPartnership.com>
	 <20150827144727.GB3596@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150827144727.GB3596@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-08-27 at 15:47 +0100, Matt Fleming wrote:
> On Wed, 29 Apr, at 04:10:52PM, James Bottomley wrote:
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
> (Sorry, I'm coming to this incredibly late)
> 
> This patch is pretty neat and I wish something like this had existed
> when I originally wrote the EFI capsule patches.
> 
> James, do you have any plans to resubmit this as a non-RFC? If not, do
> you mind if I pick this up and rebase my capsule patches ontop of it?

Sort of, but I was stalled trying to work out how to combine with your
capsule patches.  If you're going to do that work, I can resubmit my
stuff as a patch with all the changes based on the review comments and
then you can do the real work ...

James
