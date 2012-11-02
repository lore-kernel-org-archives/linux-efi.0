From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 14:30:51 -0400
Message-ID: <20121102183051.GO3300@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <20121031150201.GA12394@srcf.ucam.org>
 <20121102153047.GF3300@redhat.com>
 <20121102154248.GA7681@srcf.ucam.org>
 <20121102155247.GH3300@redhat.com>
 <alpine.LNX.2.00.1211021722140.24253@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211021722140.24253@pobox.suse.cz>
Sender: linux-security-module-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 02, 2012 at 05:22:41PM +0100, Jiri Kosina wrote:
> On Fri, 2 Nov 2012, Vivek Goyal wrote:
> 
> > > > "crash" utility has module which allows reading kernel memory. So leaking
> > > > this private key will be easier then you are thinking it to be.
> > > 
> > > That's not upstream, right?
> > 
> > Yes, checked with Dave, it is not upstream. Well, still it is a concern
> > for distro kernel.
> 
> Well, that's about /dev/crash, right?

Yes, I was talking about /dev/crash.

> 
> How about /proc/kcore?

Yes, we will have to lock down /proc/kcore too if we go the private
key solution way.

Thanks
Vivek
