From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 06/10] spi: add support for ACPI reconfigure notifications
Date: Wed, 4 May 2016 18:04:45 +0300
Message-ID: <CAE1zotJ1FKNdxCqV_XRUJrFB-fqHpBr54rj3C65ZM80h7=t3DQ@mail.gmail.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
	<1461105548-20618-7-git-send-email-octavian.purdila@intel.com>
	<20160428174215.GS3217@sirena.org.uk>
	<CAE1zot+LuQJGrDrEDM2iVv-omz3Sg6k3bavX+5gde8jzrK0pog@mail.gmail.com>
	<20160503121954.GQ6292@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503121954.GQ6292-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, May 3, 2016 at 3:19 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Apr 28, 2016 at 10:37:57PM +0300, Octavian Purdila wrote:
>> On Thu, Apr 28, 2016 at 8:42 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>> > There's more code here now than I remember but this all looks *really*
>> > close to the DT code except for the OF_POPULATED flag that we set when
>> > things are instantiated in DT.  The duplication seems bad but the fact
>> > that we're missing the flag worries me...  do we have guarantees that
>> > ACPI won't double register?
>
>> We use the adev->flags.visited to check when a device has been already
>> enumerated, and we skip registering a new SPI slave in that case.
>
> OK, but the fact that I need to know that isn't exactly thrilling -
> that's really the issue with the not quite duplication here.  It's not
> just if the code works but also the maintainability.

I agree that this is unfortunate. I could not find a common path for
both device tree and ACPI. Perhaps when we remove of_node from struct
device and move to fwnode we could remove some duplication.

I can add a couple of comments around  acpi_device_enumerated() and
adev->flags.visited = true; to make it clear that we won't double
enumerate. Will that help?
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
