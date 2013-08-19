From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 17:00:18 +0100
Message-ID: <20130819160018.GA22532@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 08:22:45AM -0700, James Bottomley wrote:
> On Mon, 2013-08-19 at 13:55 +0100, Matthew Garrett wrote:
> > On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> > 
> > > Every deviation from the spec (or common sense), however minor, should
> > > show up as a clear failure. Even the ones we *have* been able to work
> > > around, because we still want them *fixed*.
> > 
> > Why? It's not like we can ever stop carrying that code.
> 
> The reason for doing it is that we have a buildable reference
> implementation that's fully spec compliant we can then make the basis of
> a test suite for UEFI.

And why's that a benefit? Nobody's ever going to be able to ship an OS 
that doesn't implement these workarounds - they're de-facto part of the 
spec. It'd make more sense to document them officially.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
