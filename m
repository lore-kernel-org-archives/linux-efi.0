From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Date: Thu, 17 Oct 2013 12:55:14 +0100
Message-ID: <20131017115514.GE10834@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131016141939.GA28684-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 16 Oct, at 03:19:39PM, Matthew Garrett wrote:
> On Wed, Oct 16, 2013 at 02:51:00PM +0100, Matt Fleming wrote:
> 
> > +	  Many EFI machines have buggy implementations of the UpdateCapsule()
> > +	  runtime service. This option will enable code that may not function
> > +	  correctly with your firmware.
> 
> Where by "May not function correctly" you mean "May crash the system"? 

Bingo.

> I'm a little uneasy having this run by default if enabled, even if it's 
> disabled by default in the config.

What would be the canonical way to enable this feature then? Have a file
along the lines of /sys/kernel/debug/capsule_enable, where a user would
be required to,

  echo 1 > /sys/kernel/debug/capsule_enable

to turn on the functionality?

-- 
Matt Fleming, Intel Open Source Technology Center
