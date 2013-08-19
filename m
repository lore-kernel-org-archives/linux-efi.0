From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 08:22:45 -0700
Message-ID: <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
References: <20130816152030.GL2133@tuxdriver.com>
	 <1376900735.2322.26.camel@shinybook.infradead.org>
	 <20130819125507.GA19093@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130819125507.GA19093-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-08-19 at 13:55 +0100, Matthew Garrett wrote:
> On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> 
> > Every deviation from the spec (or common sense), however minor, should
> > show up as a clear failure. Even the ones we *have* been able to work
> > around, because we still want them *fixed*.
> 
> Why? It's not like we can ever stop carrying that code.

The reason for doing it is that we have a buildable reference
implementation that's fully spec compliant we can then make the basis of
a test suite for UEFI.

I am worried about it from another angle, though: history has shown
we're not very good at maintaining configurations which we don't really
use ... since every distro will turn this off (or the workarounds on),
it's going to be a bit of work for someone to make sure it still
functions.

James
