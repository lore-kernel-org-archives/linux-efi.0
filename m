From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 21:19:52 +0100
Message-ID: <20130819201952.GA28740@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
 <20130819172139.GA24393@srcf.ucam.org>
 <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
 <1376942994.2322.39.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376942994.2322.39.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 09:09:54PM +0100, David Woodhouse wrote:

> Do we really want to declare that we can only use 50% of the available
> NV storage space for *ever* more, just because some muppet thought they
> could squeeze some non-upstream "value add" into their implementation of
> the flash management? You seem to be suggesting that we should
> retrospectively write that limitation into the UEFI spec, which is a
> completely insane suggestion.

We only reserve 3K now, and testing this in the existing UEFI test kit 
would be entirely achievable. Including the ability to remove this check 
from the kernel is just an invitation for someone to build a kernel 
without it and then be surprised when their machine fucks up.

> We absolutely want to be able to draw a line under it and declare that
> any firmware built after $SOMEDATE is expected to be fixed, so we don't
> have to do these stupid workarounds, and we can make full use of the
> available space.

We have no way to guarantee that. Most board vendors don't turn up to 
the plugfests and aren't going to run anything we ship.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
