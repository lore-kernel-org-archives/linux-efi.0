From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] efi/arm64: handle missing virtual mapping for UEFI
 System Table
Date: Fri, 4 Jul 2014 18:01:10 +0100
Message-ID: <20140704170110.GM16404@arm.com>
References: <1404487509-26084-1-git-send-email-ard.biesheuvel@linaro.org>
 <1404492756.19665.57.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404492756.19665.57.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 04, 2014 at 05:52:36PM +0100, Mark Salter wrote:
> On Fri, 2014-07-04 at 17:25 +0200, Ard Biesheuvel wrote:
> > If we cannot resolve the virtual address of the UEFI System Table, its physical
> > offset must be missing from the virtual memory map, and there is really no point
> > in proceeding with installing the virtual memory map and the runtime services
> > dispatch table. So back out gracefully.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> 
> Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks. Do I take this patch or Matt already has other EFI patches to
push? If the latter:

Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
