From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Date: Thu, 17 Oct 2013 13:05:19 +0100
Message-ID: <20131017120519.GF10834@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D31122-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 16 Oct, at 02:52:25PM, Luck, Tony wrote:
> > Where by "May not function correctly" you mean "May crash the system"? 
> > I'm a little uneasy having this run by default if enabled, even if it's 
> > disabled by default in the config.
> 
> There's also an "either/or" choice between using efi-capsule with pstore, and the
> traditional kexec/kdump method for getting a memory dump from a crash.  We
> have to go through a reset to save the capsule - but we don't want a reset for
> kexec.   Perhaps we can pass the reset parameters through the kexec path to
> the new kernel to make it do the right kind of reset ... but the value of the capsule
> dump is minimal if kdump managed to dump everything.
 
I admit that using kexec with the EFI capsule + pstore code is not
something I'd considered. Though as you say, if you manage to jump to
your crash kernel I'm not sure how much use the capsule would be.

-- 
Matt Fleming, Intel Open Source Technology Center
