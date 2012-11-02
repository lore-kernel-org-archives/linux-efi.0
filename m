From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 11:52:47 -0400
Message-ID: <20121102155247.GH3300@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <20121031150201.GA12394@srcf.ucam.org>
 <20121102153047.GF3300@redhat.com>
 <20121102154248.GA7681@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121102154248.GA7681-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 02, 2012 at 03:42:48PM +0000, Matthew Garrett wrote:
> On Fri, Nov 02, 2012 at 11:30:48AM -0400, Vivek Goyal wrote:
> 
> > "crash" utility has module which allows reading kernel memory. So leaking
> > this private key will be easier then you are thinking it to be.
> 
> That's not upstream, right?

Yes, checked with Dave, it is not upstream. Well, still it is a concern
for distro kernel.

So if we keep private key in kernel, looks like we shall have to disable
one more feature in secureboot mode.

Thanks
Vivek
