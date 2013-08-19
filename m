From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 10:02:55 -0700
Message-ID: <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
References: <20130816152030.GL2133@tuxdriver.com>
	 <1376900735.2322.26.camel@shinybook.infradead.org>
	 <20130819125507.GA19093@srcf.ucam.org>
	 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
	 <20130819160018.GA22532@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130819160018.GA22532-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-08-19 at 17:00 +0100, Matthew Garrett wrote:
> On Mon, Aug 19, 2013 at 08:22:45AM -0700, James Bottomley wrote:
> > On Mon, 2013-08-19 at 13:55 +0100, Matthew Garrett wrote:
> > > On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> > > 
> > > > Every deviation from the spec (or common sense), however minor, should
> > > > show up as a clear failure. Even the ones we *have* been able to work
> > > > around, because we still want them *fixed*.
> > > 
> > > Why? It's not like we can ever stop carrying that code.
> > 
> > The reason for doing it is that we have a buildable reference
> > implementation that's fully spec compliant we can then make the basis of
> > a test suite for UEFI.
> 
> And why's that a benefit? Nobody's ever going to be able to ship an OS 
> that doesn't implement these workarounds - they're de-facto part of the 
> spec. It'd make more sense to document them officially.

The object of having a test suite conform to the spec is not to
perpetuate the cockups that occurred in round one of the implementation
and to force everyone to pay closer attention to what the spec says.
Otherwise the amount of workarounds is just going to grow without
bounds.

James
