From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
Date: Wed, 23 Jan 2013 07:52:12 +0000
Message-ID: <1358927532.2496.24.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org>
	 <1358800838-10459-2-git-send-email-matt@console-pimps.org>
	 <50FDA81B.9090602@zytor.com>
	 <1358802778.2496.11.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1358914581.3151.6.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358914581.3151.6.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Gardner <rtg.canonical-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Langasek <steve.langasek-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-01-23 at 04:16 +0000, Ben Hutchings wrote:
> On Mon, 2013-01-21 at 21:12 +0000, Matt Fleming wrote:
> [...]
> > From 92e73f936e40a8c6562e47425d434a4e62d2b8e2 Mon Sep 17 00:00:00 2001
> > From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Date: Wed, 14 Nov 2012 09:42:35 +0000
> > Subject: [PATCH] efi: Make 'efi_enabled' a function to query EFI facilities
> > 
> > Originally 'efi_enabled' indicated whether a kernel was booted from
> > EFI firmware. Over time its semantics have changed, and it now
> > indicates whether or not we are booted on an EFI machine with
> > bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.
> > 
> > The immediate motivation for this patch is the bug report at,
> > 
> >     https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557
> > 
> > which details how running a platform driver on an EFI machine that is
> > designed to run under BIOS can cause the machine to become
> > bricked. Also, the following report,
> > 
> >     https://bugzilla.kernel.org/show_bug.cgi?id=47121
> > 
> > details how running said driver can also cause Machine Check
> > Exceptions. Drivers need a new means of detecting whether they're
> > running on an EFI machine, as sadly the expression,
> > 
> >     if (!efi_enabled)
> > 
> > hasn't been a sufficient condition for quite some time.
> [...]
> 
> This patch maps the old efi_enabled flag to efi_enabled(EFI_BOOT).  Your
> second patch adds a test for efi_enabled(EFI_BOOT) to the samsung-laptop
> driver.  So the samsung-laptop driver could be fixed by adding a check
> for the old flag; it doesn't depend on the addition of new flags at all.
> The changes elsewhere may well be important, but the cited motivation
> here just doesn't make sense.

If we instead check for the old flag then the samsung-laptop driver
would run if booting a 32-bit kernel with 64-bit EFI firmware, or vice
versa, because efi_enabled == 0 in that case.

It's not sufficient to just check the old flag, the samsung-laptop
driver really can't be allowed to run at all if booting from EFI, and
the old flag doesn't provide us with that guarantee.

-- 
Matt Fleming, Intel Open Source Technology Center
