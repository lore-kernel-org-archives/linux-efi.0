From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Thu, 23 Apr 2015 07:09:47 -0700
Message-ID: <1429798187.2170.3.camel@HansenPartnership.com>
References: <20150415131906.GC21491@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
	 <20150417134924.GB19794@kroah.com>
	 <20150417143640.GB3671@codeblueprint.co.uk>
	 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
	 <20150420144323.GA7261@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
	 <20150421075620.GA11000@kroah.com>
	 <1429665679.2207.44.camel@HansenPartnership.com>
	 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
	 <20150422132734.GB12062@redhat.com>
	 <1429715913.2195.22.camel@HansenPartnership.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC1259B@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2CC1259B@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ming Lei <ming.lei@canonical.com>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-04-23 at 08:30 +0000, Kweh, Hock Leong wrote:
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > Sent: Wednesday, April 22, 2015 11:19 PM
> > 
> > 
> > Yes, I think we've all agreed we can do it ... it's now a question of whether we
> > can stomach the ick factor of actually initiating a transaction in close ... I'm still
> > feeling queasy.
> 
> The file "close" here can I understand that the file system will call the "release"
> function at the file_operations struct?
> http://lxr.free-electrons.com/source/include/linux/fs.h#L1538
> 
> So, James you are meaning that we could initiating the update transaction
> inside the f_ops->release() and return the error code if update failed in this
> function?

Well, that's what I was thinking.  However the return value of ->release
doesn't get propagated in sys_close (or indeed anywhere ... no idea why
it returns an int) thanks to the task work additions, so we'd actually
have to use the operation whose value is propagated in sys_close() which
turns out to be flush.

James
