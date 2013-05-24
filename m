From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 24 May 2013 12:40:27 +0100
Message-ID: <20130524114027.GN14575@console-pimps.org>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130524110911.GA32220@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130524110911.GA32220-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 24 May, at 01:09:11PM, Borislav Petkov wrote:
> What do you mean, map boot time functions 1:1 too?

Yep, that's what I meant.

-- 
Matt Fleming, Intel Open Source Technology Center
