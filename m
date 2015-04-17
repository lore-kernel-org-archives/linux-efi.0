From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Fri, 17 Apr 2015 15:36:40 +0100
Message-ID: <20150417143640.GB3671@codeblueprint.co.uk>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
 <20150417134924.GB19794@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150417134924.GB19794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Ming Lei <ming.lei@canonical.com>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Fri, 17 Apr, at 03:49:24PM, Greg KH wrote:
> 
> Not really, the kernel namespace is what matters at that point in time.
> 
> And maybe it does matter, I haven't thought through all of the issues.
> But passing a path from userspace, to the kernel, to have the kernel
> turn around again and use that path is full of nasty consequences at
> times due to namespaces, let's avoid all of that please.

Oh crap. The namespace issue is a good point and not something I'd
thought of at all.

At this point, I think we've really run out of objections to Andy's
suggestion of implementing this as a misc device, right?

The concern I had about userspace tooling can partly be addressed by
including the source in tools/ in the kernel tree. So provided we do
that, I'm happy enough to see this implemented as a misc device because
the other options we've explored just haven't panned out.

Objections?

-- 
Matt Fleming, Intel Open Source Technology Center
