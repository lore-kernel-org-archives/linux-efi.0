From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 1/3] sysfs,kernfs: add flush operation
Date: Thu, 30 Apr 2015 07:52:27 -0700
Message-ID: <1430405547.2167.12.camel@HansenPartnership.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
	 <1430348985.2189.39.camel@HansenPartnership.com>
	 <20150430131159.GC17936@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150430131159.GC17936@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-efi@vger.kernel.org, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-04-30 at 15:11 +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 29, 2015 at 04:09:45PM -0700, James Bottomley wrote:
> > From: James Bottomley <JBottomley@Odin.com>
> > 
> > This is necessary to allow sysfs operations to return error in close (we are
> > using close to initiate and return a possible error from a transaction).
> > 
> > Signed-off-by: James Bottomley <JBottomley@Odin.com>
> 
> Are there any side-affects now that we have a flush() call for binary
> files that the vfs will act differently from not defining one at all?

See answer to Andy, but basically, no, VFS flush is only used to tidy up
before close.

To be honest, it might be nice if fsync *would* issue a transaction
because I think having a multi-transaction API with write/fsync/write is
not such a bad thing.  It turns out that fsync and fdatasync do have a
VFS op, but it's ->fsync() not ->flush(), so we have the option to wire
this up if anyone finds a use case.

> if not, no objection to me for this change.

Thanks,

James

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
