From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Thu, 29 May 2014 10:37:59 +0800
Message-ID: <20140529023759.GF2068@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
 <20140528094712.GL2820@darkstar.nay.redhat.com>
 <20140528155104.GW10771@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140528155104.GW10771-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> > Question to Alex, if userspace can get the firmware version there might
> > be another option that kexec-tools checking the firmware version and
> > switch to old noefi way automaticlly. Is it doable?
> 
> Userspace can get the firmware version easily, as long as our hwperf
> module is installed (as it should be on any supported SGI machine).  The
> firmware version can be found in /proc/sgi_uv/bios_version on any
> machine where hwperf is loaded.
> 
> I don't know if that's really an ideal method for what you're doing, but
> that's the only way I know of to get the firmware version in userspace.
> 
> A side note, though:  We're going to have to figure out some way to
> determine whether or not to apply the old_map quirk on during boot
> anyway, so if it's easiest for you to just determine how the original
> kernel was booted and key off of that, then I wouldn't worry about
> finding a different method to get the firmware version in userspace,
> unless there are other reasons for you to do it that way.

I'm dropping the idea to check firmware version in user space, your kernel
fix to automaticlly select mapping method based on firmware version is still
needed.

I'm tending to use the idea from Vivek in kexec-tools to check the virt addr
in /sys/firmware/efi/runtime-map/*/virt_addr

Thanks
Dave
