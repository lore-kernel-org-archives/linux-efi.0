From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: don't look for chosen@0 node on DT platforms
Date: Tue, 20 Jan 2015 22:42:20 +0000
Message-ID: <20150120224220.GD12079@codeblueprint.co.uk>
References: <1421771678-31812-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421771678-31812-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 20 Jan, at 04:34:38PM, Leif Lindholm wrote:
> Due to some scary special case handling noticed in drivers/of, various
> bits of the ARM* EFI support patches did duplicate looking for @0
> variants of various nodes. Unless on an ancient PPC system, these are
> not in fact required. Most instances have become refactored out along
> the way, this removes the last one.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Thanks Leif. Applied for v3.20.

-- 
Matt Fleming, Intel Open Source Technology Center
