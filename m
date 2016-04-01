From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure notifications
Date: Fri, 1 Apr 2016 13:54:28 +0300
Message-ID: <CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
	<20160331172935.GL2350@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160331172935.GL2350@sirena.org.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 31, 2016 at 8:29 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Mar 31, 2016 at 12:37:02PM +0300, Octavian Purdila wrote:
>
>> +#if IS_ENABLED(CONFIG_ACPI)
>> +static int acpi_spi_table_load(struct device *dev, const void *data)
>> +{
>> +     struct spi_master *master = container_of(dev, struct spi_master, dev);
>> +
>> +     acpi_register_spi_devices(master);
>> +     return 0;
>> +}
>
> Why do we have a separate code path for this coompared to the initial
> startup?  The handling appears to be identical so it seems we should
> drive this from the ACPI code so we don't have to add this to every
> single bus with ACPI bindings.

Hi Mark,

I probably don't fully understand your question, but I don't see a way
of how we can create a new SPI device from generic ACPI code. For
example, in acpi_spi_add_device() we need the spi_master node so that
we can allocate the spi device.

The handling is identical because we don't have yet have a way to
identify what where the new nodes added when a new ACPI table /
overlay has been loaded, so we have to rescan the ACPI namespace under
each controller.
