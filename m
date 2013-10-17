From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH 5/5] efi: Capsule update support and pstore backend
Date: Thu, 17 Oct 2013 00:06:34 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EF862E@USINDEM103.corp.hds.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D31122-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> There's also an "either/or" choice between using efi-capsule with pstore, and the
> traditional kexec/kdump method for getting a memory dump from a crash.  We
> have to go through a reset to save the capsule - but we don't want a reset for
> kexec.   Perhaps we can pass the reset parameters through the kexec path to
> the new kernel to make it do the right kind of reset ... but the value of the capsule
> dump is minimal if kdump managed to dump everything.

Tony,

I tried to log kmsg into the kexec path months ago.
It was rejected due to the impelementation problem.

But, as Eric said, it should be OK if it is implemented in the kdump kenel.

http://marc.info/?l=linux-kernel&m=136917686732183&w=2

The only problem with kdump here is the implementation in the initial
ram disk.  Fixing the initial ramdisk so it logs to kmsg before it
touches scarier hardware should be the solution.

Seiji
