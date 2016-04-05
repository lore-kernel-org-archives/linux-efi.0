From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure notifications
Date: Tue, 5 Apr 2016 14:49:13 +0300
Message-ID: <CAE1zot+wvU_he-6cFQi1np9X1=FcXWoF-mbxYDRYUkyOT+7nyQ@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
	<20160331172935.GL2350@sirena.org.uk>
	<CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
	<20160401140856.GW2350@sirena.org.uk>
	<CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
	<20160402162449.GB2350@sirena.org.uk>
	<CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
	<20160404160327.GH2350@sirena.org.uk>
	<CAE1zot+ESGBEYeUbLTreKfkc-6B45uQq3PWhhRfBo1AWd-7Vxw@mail.gmail.com>
	<CAJZ5v0gV8N6zgVrwtRFaY98Wv1HsoKs+4=U-s_V29FSpCdFW3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZ5v0gV8N6zgVrwtRFaY98Wv1HsoKs+4=U-s_V29FSpCdFW3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 5, 2016 at 12:18 AM, Rafael J. Wysocki <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Apr 4, 2016 at 9:34 PM, Octavian Purdila
> <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On Mon, Apr 4, 2016 at 7:03 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> On Mon, Apr 04, 2016 at 01:25:56PM +0300, Octavian Purdila wrote:
>>>> On Sat, Apr 2, 2016 at 7:24 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>
>>>> > What I don't understand is why the flow on inital probe isn't simply to
>>>> > register the controller which then triggers the walk of the children.
>>>> > That way any bus that supports initial probe also supports hotplug
>>>> > without needing to go and manually add a second code path.
>>>
>>>> Do you mean register the notifier per controller instead of per
>>>> subsystem? Either way we need changes at the subsystem level and I
>>>> choose to follow the device tree implementation for consistency.
>>>
>>> No!  I mean use the exact same callback you've got now for everything.
>>>
>>>> The other reason is that (pending other ACPICA changes) we can add
>>>> other notification events in the future such as node added or removed
>>>> (just like device tree), and in that case the probe and hotplug
>>>> handling would be different (and a bit more efficient).
>>>
>>> Why is probe different to hotplug?  We don't need to do that in the
>>> normal driver model.
>>
>> There might be some confusion with the term, I am referring to slave
>> hotplug, not controller hotplug.
>>
>> The way I see it, there are two logical operations: probe of a
>> controller and the associated enumeration of the SPI slaves for that
>> bus and "hotplug" of new SPI slaves and the enumeration of those
>> particular slaves.
>>
>> When we probe the controller we search DT/ACPI and enumerate all the
>> slaves for *that* controller.
>>
>> When a slave hotplug happens for device tree we get a device node
>> notification and we can instantiate the SPI slave based on that info.
>> In case of ACPI, (at this point) we get a global callback and in that
>> callback we need to iterate through *all* controllers.
>
> Is that really necessary?
>
> The namespace rescan could notify the parent of a new node in
> acpi_default_enumeration(), couldn't it?

We could do that, with some complexity, but I am not sure if it is
worth it - see below. And in either case I still don't see how we can
avoid two enumeration paths: one from the probe of the controller ->
spi_register_master() -> acpi_register_spi_devices()  and one from the
notification handler -> acpi_register_spi_devices(). Both will end up
are calling the same enumeration function but there are still two
paths.

Even right now, in the case of dynamic DT, we have the two enumeration paths.

If we really want to have a single path for ACPI enumeration we could
do that by using an ACPI SPI bridge driver or scan handlers after
extending the matching mechanisms. But we would still need to modify
the SPI subsystem and I don't think its worth it just to save a call
to acpi_register_spi_devices() from spi_register_master().

Now for parent notification complexity: in the case of SPI we can
easily to this because current ACPI SPI enumeration supports only
direct children as slaves. However, on I2C we can have an unrelated
node as a slave - that is why the I2C scanning searches the whole
namespaces for references to a particular i2c_adapter. So, we would
need to retrieve the parent node from the namespace node information
which means that we will do SPI specific stuff in ACPI generic code. I
don't think it is a big issue, because we already treat SPI / I2C
special, right?

Once we have the parent handle we would still have to iterate through
all controllers to get the spi_master matching the ACPI handle. It is
a bit more efficient then global notification, but probably won't
matter in practice.
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
