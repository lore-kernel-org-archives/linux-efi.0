From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [RFC PATCH v2 06/10] spi: add support for ACPI reconfigure notifications
Date: Thu, 28 Apr 2016 22:37:57 +0300
Message-ID: <CAE1zot+LuQJGrDrEDM2iVv-omz3Sg6k3bavX+5gde8jzrK0pog@mail.gmail.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
	<1461105548-20618-7-git-send-email-octavian.purdila@intel.com>
	<20160428174215.GS3217@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <20160428174215.GS3217@sirena.org.uk>
Sender: linux-i2c-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 28, 2016 at 8:42 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Apr 20, 2016 at 01:39:04AM +0300, Octavian Purdila wrote:
>
>> +     switch (value) {
>> +     case ACPI_RECONFIG_DEVICE_ADD:
>> +             master = acpi_spi_find_master_by_adev(adev->parent);
>> +             if (!master)
>> +                     break;
>> +
>> +             acpi_register_spi_device(master, adev);
>> +             put_device(&master->dev);
>> +             break;
>> +     case ACPI_RECONFIG_DEVICE_REMOVE:
>> +             spi = acpi_spi_find_device_by_adev(adev);
>> +             if (!spi)
>> +                     break;
>
> There's more code here now than I remember but this all looks *really*
> close to the DT code except for the OF_POPULATED flag that we set when
> things are instantiated in DT.  The duplication seems bad but the fact
> that we're missing the flag worries me...  do we have guarantees that
> ACPI won't double register?

We use the adev->flags.visited to check when a device has been already
enumerated, and we skip registering a new SPI slave in that case.
