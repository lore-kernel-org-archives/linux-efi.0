From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: handle potential failure to remap memory map
Date: Fri, 16 Jan 2015 16:23:35 +0000
Message-ID: <20150116162334.GJ13634@e104818-lin.cambridge.arm.com>
References: <1421323266-30973-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150115164010.GK16217@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150115164010.GK16217@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 15, 2015 at 04:40:11PM +0000, Mark Rutland wrote:
> On Thu, Jan 15, 2015 at 12:01:06PM +0000, Ard Biesheuvel wrote:
> > When remapping the UEFI memory map using ioremap_cache(), we
> > have to deal with potential failure. Note that, even if the
> > common case is for ioremap_cache() to return the existing linear
> > mapping of the memory map, we cannot rely on that to be always the
> > case, e.g., in the presence of a mem= kernel parameter.
> > 
> > At the same time, remove a stale comment and move the memmap code
> > together.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> 
> This should probably be picked up before my mem= patch, which I will be
> resending shortly. I'll mention that when posting.
> 
> I guess Catalin should pick this up given the other portions are in the
> arm64 tree, and this falls under arch/arm64.

I picked both up. Thanks.

-- 
Catalin
