From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 18:21:39 +0100
Message-ID: <20130819172139.GA24393@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376931775.2069.46.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 10:02:55AM -0700, James Bottomley wrote:

> The object of having a test suite conform to the spec is not to
> perpetuate the cockups that occurred in round one of the implementation
> and to force everyone to pay closer attention to what the spec says.
> Otherwise the amount of workarounds is just going to grow without
> bounds.

There's a benefit in having a test suite that prevents new errors from 
being introduced, but there's no benefit in failing on errors that we 
have to work around anyway. We have the code. We're never going to be 
able to remove the code.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
