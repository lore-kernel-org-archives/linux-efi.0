From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v5 2/8] acpi: fix enumeration (visited) flags for bus rescans
Date: Wed, 06 Jul 2016 23:09:44 +0200
Message-ID: <31239967.dEXrvihxAE@vostro.rjw.lan>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com> <20160706150317.GH23527@lahna.fi.intel.com> <CAE1zotJg+bCUD+q_cbiO1=abx1PJbUdWVr03uutwR081iG4G1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE1zotJg+bCUD+q_cbiO1=abx1PJbUdWVr03uutwR081iG4G1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>, Leonard Crestez <leonard.crestez@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wednesday, July 06, 2016 06:37:46 PM Octavian Purdila wrote:
> On Wed, Jul 6, 2016 at 6:03 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Fri, Jul 01, 2016 at 11:19:06PM +0300, Octavian Purdila wrote:
> >> If the ACPI tables changes as a result of a dinamically loaded table and
> >> a bus rescan is required the enumeration/visited flag are not
> >> consistent.
> >>
> >> I2C/SPI are not directly enumerated in acpi_bus_attach(), however the
> >> visited flag is set. This makes it impossible to check if an ACPI device
> >> has already been enumerated by the I2C and SPI subsystems. To fix this
> >> issue we only set the visited flags if the device is not I2C or SPI.
> >>
> >> With this change we also need to remove setting visited to false from
> >> acpi_bus_attach(), otherwise if we rescan already enumerated I2C/SPI
> >> devices we try to re-enumerate them.
> >>
> >> Note that I2C/SPI devices can be enumerated either via a scan handler
> >> (when using PRP0001) or via regular device_attach(). In either case
> >> the flow goes through acpi_default_enumeration() which makes it the
> >> ideal place to mark the ACPI device as enumerated.
> >
> > Hmm, this somehow fails to enumerate PRP0001 devices.
> >
> > I'm adding following SSDT to my initrd and the resulting device is never
> > enumerated on SPI bus (it exists in /sys/bus/acpi/devices). If I use
> > normal ACPI IDs (non-PRP0001) then it works fine.
> >
> 
> I specifically tested with PRP0001 via initrd with I2C, I am not sure
> why it does not work on SPI. I'll give it a try tomorrow when I have
> access to my setup.

OK, I'll wait for this test to conclude before applying the series, then. :-)

Thanks,
Rafael
