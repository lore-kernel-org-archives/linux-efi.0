From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] efi/arm64: clean up efi_get_fdt_params() interface
Date: Wed, 26 Aug 2015 10:15:03 -0400
Message-ID: <1440598503.13044.1.camel@redhat.com>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
	 <1440595498-30630-4-git-send-email-leif.lindholm@linaro.org>
	 <CAKv+Gu9KwJfr6x8A607CsbAvpLUG2pqLPzcXsqhvmQnrcGy_ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9KwJfr6x8A607CsbAvpLUG2pqLPzcXsqhvmQnrcGy_ug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2015-08-26 at 16:04 +0200, Ard Biesheuvel wrote:
> On 26 August 2015 at 15:24, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> 
> wrote:
> > As we now have a common debug infrastructure between core and arm64 
> > efi,
> > drop the bit of the interface passing verbose output flags around.
> > 
> > Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/arm64/kernel/efi.c    | 2 +-
> >  drivers/firmware/efi/efi.c | 6 ++----
> >  include/linux/efi.h        | 2 +-
> >  3 files changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 612ad5e..ab5eeb6 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -201,7 +201,7 @@ void __init efi_init(void)
> >         struct efi_fdt_params params;
> > 
> 
> Actually, one nit: struct efi_fdt_params has a verbose field that was

No it doesn't. :)

> never used in the first place, but was added [supposedly] to convey
> the same as EFI_DBG that we have now. So I think you should remove
> that as well.
> 
