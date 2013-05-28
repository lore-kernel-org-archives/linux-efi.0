From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Tue, 28 May 2013 11:50:41 +0100
Message-ID: <20130528105041.GP14575@console-pimps.org>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130524200539.GA3322@sgi.com>
 <1369426255.2217.9.camel@x230>
 <20130524204937.GB3322@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130524204937.GB3322-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 24 May, at 03:49:38PM, Russ Anderson wrote:
> Why does the kernel still try to create /sys/firmware/efivars/
> entries in the original failure even though efi_call_phys4()
> failed?  Or does it always try to create those entries
> and GetNextVariable() blows up in the original failure
> but not in my experiment?

CONFIG_EFI_VARS will try to create /sys/firmware/efivars even without
the additional info from the early EFI boot variable code. The early
variable code is only a heuristic that is supposed to improve the
anti-bricking algorithm in the EFI variable code.

-- 
Matt Fleming, Intel Open Source Technology Center
