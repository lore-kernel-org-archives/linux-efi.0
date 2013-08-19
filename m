From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 17:17:21 +0200
Message-ID: <20130819151721.GA5223@pd.tnic>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376900735.2322.26.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> Hm. It would be really useful to have a kernel build option which
> *disables* all the workarounds we've ever put in for broken firmware.

Yeah, cool!

I wonder if we could reach a high double-digit percentage of machines
not booting/barfing on such a clean kernel.

While at it, can we please replace the fw with coreboot? :-)

> Every deviation from the spec (or common sense), however minor, should
> show up as a clear failure. Even the ones we *have* been able to work
> around, because we still want them *fixed*.
> 
> And there's a school of thought that says we should brick as many
> Samsung machines as possible,

Yep, and there's the rooted secure boot asus f*ckup which we should also
advertize while booting, enabling people to use it:

https://www.blackhat.com/us-13/archives.html#Bulygin

/me LOLs ominously...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
