From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 10:38:46 -0700
Message-ID: <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
References: <20130816152030.GL2133@tuxdriver.com>
	 <1376900735.2322.26.camel@shinybook.infradead.org>
	 <20130819125507.GA19093@srcf.ucam.org>
	 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
	 <20130819160018.GA22532@srcf.ucam.org>
	 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
	 <20130819172139.GA24393@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130819172139.GA24393@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Woodhouse <dwmw2@infradead.org>, "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-08-19 at 18:21 +0100, Matthew Garrett wrote:
> On Mon, Aug 19, 2013 at 10:02:55AM -0700, James Bottomley wrote:
> 
> > The object of having a test suite conform to the spec is not to
> > perpetuate the cockups that occurred in round one of the implementation
> > and to force everyone to pay closer attention to what the spec says.
> > Otherwise the amount of workarounds is just going to grow without
> > bounds.
> 
> There's a benefit in having a test suite that prevents new errors from 
> being introduced, but there's no benefit in failing on errors that we 
> have to work around anyway. We have the code. We're never going to be 
> able to remove the code.

It's not about us removing the code, it's about us having an accurate
compliance test.  There are two reasons for having a fully correct
compliance test

     1. Our work arounds have unintended consequences which have knock
        on effects which mean that you don't know if a test failure is
        real or an unintended consequence of a work around.
     2. New features in specs tend to build on previous features, so
        we're going to have a hard time constructing accurate tests for
        layered features where we've done a work around for the base
        feature.

James
