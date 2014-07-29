From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Tue, 29 Jul 2014 18:24:02 +0200
Message-ID: <2849588.TpFoAMfcUF@wuerfel>
References: <1406630950-32432-1-git-send-email-ard.biesheuvel@linaro.org> <11934363.ljlrQOGpcO@wuerfel> <20140729161852.GC32108@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729161852.GC32108@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tuesday 29 July 2014 17:18:52 Mark Rutland wrote:
> Sorry, I'd misunderstood the problem and my suggestion was nonsense
> deriving from that.
> 
> Having the (__force void *) cast in the call to __flush_dcache_area
> sounds like the right solution to me.

Well, there isn't really a good solution here I think, because you
are not really dealing with an iomem pointer after all, just something
a bit like that, but we don't have a 'memremap' function to do what
you really mean.

	Arnd
