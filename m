From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] arm: Add [U]EFI runtime services support
Date: Thu, 17 Oct 2013 12:58:34 -0400
Message-ID: <1382029114.1768.10.camel@deneb.redhat.com>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
	 <1380799481-5470-3-git-send-email-leif.lindholm@linaro.org>
	 <20131017140739.GI10834@console-pimps.org>
	 <20131017143121.GJ1557@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131017143121.GJ1557-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-10-17 at 16:31 +0200, Leif Lindholm wrote:
> On Thu, Oct 17, 2013 at 03:07:39PM +0100, Matt Fleming wrote:
> > > +/*
> > > + * If you need to (temporarily) support buggy firmware.
> > > + */
> > > +#define KEEP_BOOT_SERVICES_REGIONS
> > 
> > Have you seen firmware that requires this? I'm just curious more than
> > anything else.
> 
> Not really.
> I _think_ I saw it on a debug build of a development platform once.
> That coincided with me seeing a post on linux-efi about some laptop
> that broke unless boot services regions were preserved, so I decided
> to put it in there for any future debugging.
>  

I see a fairly consistent segfault when the arm64 kernel calls the
SetVirtualAddressMap function. It doesn't happen when the boot services
regions are included in the mapping. This is with edk2 firmware. I
haven't really dug into where it goes wrong.
