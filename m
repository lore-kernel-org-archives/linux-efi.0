From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Wed, 28 May 2014 10:51:04 -0500
Message-ID: <20140528155104.GW10771@sgi.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
 <20140528094712.GL2820@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140528094712.GL2820@darkstar.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, "bp@alien8.de" <bp@alien8.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, vgoyal@redhat.com, Alex Thorlton <athorlton@sgi.com>
List-Id: linux-efi@vger.kernel.org

On Wed, May 28, 2014 at 05:47:12PM +0800, Dave Young wrote:
> Add Alex to cc
> 
> > > The 1:1 mapping was required to make kexec + EFI work in the first
> > > instance. If a machine implements the EFI 1:1 mapping, kexec should
> > > work. If it doesn't implement the 1:1 mapping, then it's probably not
> > > going to work, right?
> > > 
> > > The crux of the question: are you trying to fix a regression?
> > > 
> > > If not, then we just need to get SGI UV working with the EFI 1:1
> > > mapping. No?
> 
> Alex is working on a SGI UV fix for 1:1 mapping.
> Question to Alex, if userspace can get the firmware version there might
> be another option that kexec-tools checking the firmware version and
> switch to old noefi way automaticlly. Is it doable?

Userspace can get the firmware version easily, as long as our hwperf
module is installed (as it should be on any supported SGI machine).  The
firmware version can be found in /proc/sgi_uv/bios_version on any
machine where hwperf is loaded.

I don't know if that's really an ideal method for what you're doing, but
that's the only way I know of to get the firmware version in userspace.

A side note, though:  We're going to have to figure out some way to
determine whether or not to apply the old_map quirk on during boot
anyway, so if it's easiest for you to just determine how the original
kernel was booted and key off of that, then I wouldn't worry about
finding a different method to get the firmware version in userspace,
unless there are other reasons for you to do it that way.

- Alex
