From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure notifications
Date: Mon, 4 Apr 2016 13:25:56 +0300
Message-ID: <CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
	<20160331172935.GL2350@sirena.org.uk>
	<CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
	<20160401140856.GW2350@sirena.org.uk>
	<CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
	<20160402162449.GB2350@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <20160402162449.GB2350@sirena.org.uk>
Sender: linux-i2c-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Sat, Apr 2, 2016 at 7:24 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Apr 01, 2016 at 09:26:38PM +0200, Rafael J. Wysocki wrote:
>> On Fri, Apr 1, 2016 at 4:08 PM, Mark Brown <broonie@kernel.org> wrote:
>
>> > That's not the point.  The point is that since the handling is identical
>> > why are we handling it through exactly the same code?
>
>> I think that during the initial enumeration the controller driver's
>> probe walks the children and creates device objects for them.  When a
>> table is loaded later, the controller driver has been probed already
>> and there needs to be a way to trigger a walk over the (new) children
>> from it.
>
>> Or a hook somewhere around acpi_platform_notify() is needed.
>
> What I don't understand is why the flow on inital probe isn't simply to
> register the controller which then triggers the walk of the children.
> That way any bus that supports initial probe also supports hotplug
> without needing to go and manually add a second code path.

Do you mean register the notifier per controller instead of per
subsystem? Either way we need changes at the subsystem level and I
choose to follow the device tree implementation for consistency.

The other reason is that (pending other ACPICA changes) we can add
other notification events in the future such as node added or removed
(just like device tree), and in that case the probe and hotplug
handling would be different (and a bit more efficient).
