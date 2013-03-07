From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: Problem mounting efivarfs in 3.9
Date: Thu, 7 Mar 2013 09:09:41 -0600
Message-ID: <20130307150941.GB24233@thinkpad-t410>
References: <20130307145601.GA24233@thinkpad-t410>
 <1362668558.15011.203.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1362668558.15011.203.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 07, 2013 at 03:02:38PM +0000, Matt Fleming wrote:
> On Thu, 2013-03-07 at 08:56 -0600, Seth Forshee wrote:
> > Hi Matt,
> > 
> > I found myself unable to mount efivarfs on one of my machines in 3.9.
> > This is due to your patch to be more aggressive about validating
> > filenames. This machine had some crash dumps from pstore, which start
> > with "dump-type". However now efivars expects the guid to follow the
> > first '-' character, despite the fact that the efivars pstore code is
> > creating the file names starting with dump-type. Since these names fail
> > the validation the mount fails.
> 
> A patch to allow pstore names is in the pull request I sent to Peter and
> Ingo yesterday,
> 
> 	http://marc.info/?l=linux-kernel&m=136258373231608&w=2

Great. Thanks!

Seth
