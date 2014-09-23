From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/7] efi_rtc: probe function error out in case no efi
 runtime enabled
Date: Tue, 23 Sep 2014 15:24:26 +0800
Message-ID: <20140923072426.GB3916@darkstar.nay.redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007953-15151-1-git-send-email-dyoung@redhat.com>
 <1411403609.25340.55.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411403609.25340.55.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi, Mark

On 09/22/14 at 12:33pm, Mark Salter wrote:
> On Thu, 2014-08-14 at 17:19 +0800, Dave Young wrote:
> > efi rtc depends on efi runtime services, so if efi runtime services are not
> > usable it should error out.
> > 
> > Without this patch rtc-efi will panic with 'noefi' boot
> 
> Is this still needed after commit da167ad7638759:
> 
>   rtc: ia64: allow other architectures to use EFI RTC
> 
> That should keep efi_rtc_probe from being called if runtime services
> are not available.

If that's the case then this patch should be unnecessary, I have no machine
to test it currently though.

> 
> > 
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/rtc/rtc-efi.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> > index c4c3843..ca2487b 100644
> > --- a/drivers/rtc/rtc-efi.c
> > +++ b/drivers/rtc/rtc-efi.c
> > @@ -191,6 +191,9 @@ static int __init efi_rtc_probe(struct platform_device *dev)
> >  {
> >  	struct rtc_device *rtc;
> >  
> > +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > +		return -ENODEV;
> > +
> >  	rtc = devm_rtc_device_register(&dev->dev, "rtc-efi", &efi_rtc_ops,
> >  					THIS_MODULE);
> >  	if (IS_ERR(rtc))
> 
> 
