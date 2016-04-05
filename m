From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure notifications
Date: Tue, 5 Apr 2016 22:16:16 +0300
Message-ID: <CAE1zotL7X+di4rHecRW_G-45wUPbbNb9jvn3C_zjD4XttZ4v3w@mail.gmail.com>
References: <20160331172935.GL2350@sirena.org.uk>
	<CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
	<20160401140856.GW2350@sirena.org.uk>
	<CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
	<20160402162449.GB2350@sirena.org.uk>
	<CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
	<20160404160327.GH2350@sirena.org.uk>
	<CAE1zot+ESGBEYeUbLTreKfkc-6B45uQq3PWhhRfBo1AWd-7Vxw@mail.gmail.com>
	<CAJZ5v0gV8N6zgVrwtRFaY98Wv1HsoKs+4=U-s_V29FSpCdFW3g@mail.gmail.com>
	<CAE1zot+wvU_he-6cFQi1np9X1=FcXWoF-mbxYDRYUkyOT+7nyQ@mail.gmail.com>
	<20160405183255.GH1924@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160405183255.GH1924-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 5, 2016 at 9:32 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Apr 05, 2016 at 02:49:13PM +0300, Octavian Purdila wrote:
>
>> If we really want to have a single path for ACPI enumeration we could
>> do that by using an ACPI SPI bridge driver or scan handlers after
>> extending the matching mechanisms. But we would still need to modify
>> the SPI subsystem and I don't think its worth it just to save a call
>> to acpi_register_spi_devices() from spi_register_master().
>
> It's not specifically for SPI, it's the fact that you're asking every
> single bus type which might be described in ACPI to handle both hotplug
> and coldplug paths separately.  Given that the code that's being added
> just seems like trivial boilerplate it seems like we're doing this
> wrong, we should be factoring this out so there's nothing bus types can
> get wrong.
>

AFAICS this is exactly the same case for DT: one code path for
coldplug and one for hotplug.

Which makes me think that it is not possible to have a single path for
both, or maybe its not worth it. Do I miss something obvious?
