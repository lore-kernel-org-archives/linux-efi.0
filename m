From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/5] efi: Capsule update support and pstore backend
Date: Wed, 16 Oct 2013 14:52:25 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131016141939.GA28684-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> Where by "May not function correctly" you mean "May crash the system"? 
> I'm a little uneasy having this run by default if enabled, even if it's 
> disabled by default in the config.

There's also an "either/or" choice between using efi-capsule with pstore, and the
traditional kexec/kdump method for getting a memory dump from a crash.  We
have to go through a reset to save the capsule - but we don't want a reset for
kexec.   Perhaps we can pass the reset parameters through the kexec path to
the new kernel to make it do the right kind of reset ... but the value of the capsule
dump is minimal if kdump managed to dump everything.

Bottom line: users need to make an informed choice to use efi-capsule + pstore.

-Tony
