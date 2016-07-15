From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access
 ESRT table in memory
Date: Fri, 15 Jul 2016 16:05:53 +0100
Message-ID: <20160715150553.GD2406@codeblueprint.co.uk>
References: <1468263646-28184-1-git-send-email-ard.biesheuvel@linaro.org>
 <1468263646-28184-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468263646-28184-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Jul, at 09:00:45PM, Ard Biesheuvel wrote:
> On ARM and arm64, ioremap() and memremap() are not interchangeable like
> on x86, and the use of ioremap() on ordinary RAM is typically flagged
> as an error if the memory region being mapped is also covered by the
> linear mapping, since that would lead to aliases with conflicting
> cacheability attributes.
> 
> Since what we are dealing with is not an I/O region with side effects,
> using ioremap() here is arguably incorrect anyway, so let's replace
> it with memremap() instead.
> 
> Acked-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/esrt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Looks sensible, thanks Ard, applied.
