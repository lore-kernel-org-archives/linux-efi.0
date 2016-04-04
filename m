From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure notifications
Date: Mon, 4 Apr 2016 22:34:56 +0300
Message-ID: <CAE1zot+ESGBEYeUbLTreKfkc-6B45uQq3PWhhRfBo1AWd-7Vxw@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
	<20160331172935.GL2350@sirena.org.uk>
	<CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
	<20160401140856.GW2350@sirena.org.uk>
	<CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
	<20160402162449.GB2350@sirena.org.uk>
	<CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
	<20160404160327.GH2350@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160404160327.GH2350@sirena.org.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 4, 2016 at 7:03 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Apr 04, 2016 at 01:25:56PM +0300, Octavian Purdila wrote:
>> On Sat, Apr 2, 2016 at 7:24 PM, Mark Brown <broonie@kernel.org> wrote:
>
>> > What I don't understand is why the flow on inital probe isn't simply to
>> > register the controller which then triggers the walk of the children.
>> > That way any bus that supports initial probe also supports hotplug
>> > without needing to go and manually add a second code path.
>
>> Do you mean register the notifier per controller instead of per
>> subsystem? Either way we need changes at the subsystem level and I
>> choose to follow the device tree implementation for consistency.
>
> No!  I mean use the exact same callback you've got now for everything.
>
>> The other reason is that (pending other ACPICA changes) we can add
>> other notification events in the future such as node added or removed
>> (just like device tree), and in that case the probe and hotplug
>> handling would be different (and a bit more efficient).
>
> Why is probe different to hotplug?  We don't need to do that in the
> normal driver model.

There might be some confusion with the term, I am referring to slave
hotplug, not controller hotplug.

The way I see it, there are two logical operations: probe of a
controller and the associated enumeration of the SPI slaves for that
bus and "hotplug" of new SPI slaves and the enumeration of those
particular slaves.

When we probe the controller we search DT/ACPI and enumerate all the
slaves for *that* controller.

When a slave hotplug happens for device tree we get a device node
notification and we can instantiate the SPI slave based on that info.
In case of ACPI, (at this point) we get a global callback and in that
callback we need to iterate through *all* controllers.
