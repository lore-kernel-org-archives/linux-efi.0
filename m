From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 22:30:05 +0100
Message-ID: <20130819213005.GA30211@srcf.ucam.org>
References: <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
 <20130819172139.GA24393@srcf.ucam.org>
 <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
 <1376942994.2322.39.camel@shinybook.infradead.org>
 <20130819201952.GA28740@srcf.ucam.org>
 <1376943671.2322.40.camel@shinybook.infradead.org>
 <20130819203937.GA28967@srcf.ucam.org>
 <1376946411.5087.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376946411.5087.2.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 10:06:51PM +0100, David Woodhouse wrote:

> You effectively seem to be suggesting that nothing will ever get better
> on the UEFI side, and the only benefit of the plugfest is that we get to
> see the latest brokenness and try to come up with a workaround for it
> before the consumers are afflicted with it?

Pretty much. There's a decent chance that board vendors already have the 
broken code before we end up testing against it.

> That's a really pessimistic view, and I'd really like us to be a little
> more optimistic. Things can't be, or at least can't *stay*, that bad.
> Surely?

Most vendors don't care about testing against Linux, and we can't make 
them care. What they're more likely to test against is the SCT, and 
extending that to cover a wider range of test cases (such as exhausting 
variable space) is much more likely to result in things being caught 
before anything is shipped - but even then, board vendors are going to 
take IBV code, perform "value add", never run a test suite and just make 
sure it boots Windows.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
