From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Thu, 29 May 2014 10:08:37 +0800
Message-ID: <20140529020837.GB2068@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527133411.GG10994@redhat.com>
 <20140528021359.GC2820@darkstar.nay.redhat.com>
 <20140528124029.GF14863@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140528124029.GF14863-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 05/28/14 at 08:40am, Vivek Goyal wrote:
> On Wed, May 28, 2014 at 10:13:59AM +0800, Dave Young wrote:
> > On 05/27/14 at 09:34am, Vivek Goyal wrote:
> > > On Mon, May 26, 2014 at 04:39:35PM +0800, Dave Young wrote:
> > > > 
> > > > For efi=old_map and any old_map quirks like SGI UV in current
> > > > tree kexec/kdump will fail because it depends on the new 1:1 mapping.
> > > > 
> > > > Thus export the mapping method to sysfs so kexec tools can switch
> > > > to original way to boot.
> > > > 
> > > > Since we have efi.flags for all efi facilities so let's just export the
> > > > efi.flags itself, it maybe useful for other arches and use cases.
> > > > 
> > > 
> > > Does it require any documentation in Documentation/ABI/..
> > 
> > Yes, it's necessary. Will do in next version.
> > 
> > I'm still discussing with Matt, exporting efi.flags seems not a good way
> > because they are more internal interfaces. 
> > 
> > Probably I should export only a file 'old_map' instead.
> 
> How does /sys/firmware/efi/runtime-map/* look like with old mapping? Can't
> we look at it and figure out if it is 1:1 or not.

There's phys_addr and virt_addr, (virt_addr - phys_addr) will always be
-64G for 1:1 map, ioremapped addresses space is different.

So this is a good idea, we can do this way to avoid more ABI.

Thanks
Dave
