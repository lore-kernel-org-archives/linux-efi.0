From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure notifications
Date: Fri, 1 Apr 2016 21:26:38 +0200
Message-ID: <CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
	<20160331172935.GL2350@sirena.org.uk>
	<CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
	<20160401140856.GW2350@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <20160401140856.GW2350@sirena.org.uk>
Sender: linux-i2c-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 1, 2016 at 4:08 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Apr 01, 2016 at 01:54:28PM +0300, Octavian Purdila wrote:
>
>> I probably don't fully understand your question, but I don't see a way
>> of how we can create a new SPI device from generic ACPI code. For
>> example, in acpi_spi_add_device() we need the spi_master node so that
>> we can allocate the spi device.
>
> Right, but the same applies to initial enumeration so we also have to
> manually instantiate ACPI devices on startup.  Why do we need to do
> that?
>
>> The handling is identical because we don't have yet have a way to
>> identify what where the new nodes added when a new ACPI table /
>> overlay has been loaded, so we have to rescan the ACPI namespace under
>> each controller.
>
> That's not the point.  The point is that since the handling is identical
> why are we handling it through exactly the same code?

I think that during the initial enumeration the controller driver's
probe walks the children and creates device objects for them.  When a
table is loaded later, the controller driver has been probed already
and there needs to be a way to trigger a walk over the (new) children
from it.

Or a hook somewhere around acpi_platform_notify() is needed.
