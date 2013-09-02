From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 2 Sep 2013 07:23:10 +0100
Message-ID: <20130902062310.GA28598@console-pimps.org>
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
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 19 Aug, at 09:09:54PM, David Woodhouse wrote:
> 3. Even if we can't *remove* the code, sometimes we can disable it at
> runtime if we detect the BIOS is new enough that it shouldn't be broken.
 
Yes, this is definitely something we should be looking to implement.

It seems likely to me that we're eventually going to start hitting
issues supporting the latest UEFI firmware because of the workarounds
we're currently carrying in the kernel. The EDKII folks are surprised
time and time again to hear of the hoops we jump through in the kernel
to support buggy implementations.

It's only going to be a matter of time until we *have* to disable some
our workarounds in order to boot the most recent incarantions of UEFI.
Not least because carrying these workarounds unconditionally and
indefinitely severely limits our ability to innovate.

-- 
Matt Fleming, Intel Open Source Technology Center
