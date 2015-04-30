From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC 1/3] sysfs,kernfs: add flush operation
Date: Thu, 30 Apr 2015 15:11:59 +0200
Message-ID: <20150430131159.GC17936@kroah.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
 <1430348985.2189.39.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430348985.2189.39.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 29, 2015 at 04:09:45PM -0700, James Bottomley wrote:
> From: James Bottomley <JBottomley@Odin.com>
> 
> This is necessary to allow sysfs operations to return error in close (we are
> using close to initiate and return a possible error from a transaction).
> 
> Signed-off-by: James Bottomley <JBottomley@Odin.com>

Are there any side-affects now that we have a flush() call for binary
files that the vfs will act differently from not defining one at all?

if not, no objection to me for this change.

thanks,

greg k-h
