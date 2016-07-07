From: Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 2/8] acpi: fix enumeration (visited) flags for bus
 rescans
Date: Thu, 7 Jul 2016 12:00:13 +0300
Message-ID: <20160707090013.GK23527@lahna.fi.intel.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <20160706150317.GH23527@lahna.fi.intel.com>
 <CAE1zotJg+bCUD+q_cbiO1=abx1PJbUdWVr03uutwR081iG4G1g@mail.gmail.com>
 <31239967.dEXrvihxAE@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <31239967.dEXrvihxAE-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leonard Crestez <leonard.crestez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 06, 2016 at 11:09:44PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 06, 2016 06:37:46 PM Octavian Purdila wrote:
> > On Wed, Jul 6, 2016 at 6:03 PM, Mika Westerberg
> > <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > > On Fri, Jul 01, 2016 at 11:19:06PM +0300, Octavian Purdila wrote:
> > >> If the ACPI tables changes as a result of a dinamically loaded table and
> > >> a bus rescan is required the enumeration/visited flag are not
> > >> consistent.
> > >>
> > >> I2C/SPI are not directly enumerated in acpi_bus_attach(), however the
> > >> visited flag is set. This makes it impossible to check if an ACPI device
> > >> has already been enumerated by the I2C and SPI subsystems. To fix this
> > >> issue we only set the visited flags if the device is not I2C or SPI.
> > >>
> > >> With this change we also need to remove setting visited to false from
> > >> acpi_bus_attach(), otherwise if we rescan already enumerated I2C/SPI
> > >> devices we try to re-enumerate them.
> > >>
> > >> Note that I2C/SPI devices can be enumerated either via a scan handler
> > >> (when using PRP0001) or via regular device_attach(). In either case
> > >> the flow goes through acpi_default_enumeration() which makes it the
> > >> ideal place to mark the ACPI device as enumerated.
> > >
> > > Hmm, this somehow fails to enumerate PRP0001 devices.
> > >
> > > I'm adding following SSDT to my initrd and the resulting device is never
> > > enumerated on SPI bus (it exists in /sys/bus/acpi/devices). If I use
> > > normal ACPI IDs (non-PRP0001) then it works fine.
> > >
> > 
> > I specifically tested with PRP0001 via initrd with I2C, I am not sure
> > why it does not work on SPI. I'll give it a try tomorrow when I have
> > access to my setup.
> 
> OK, I'll wait for this test to conclude before applying the series, then. :-)

I tested again and it works fine. I probably had an older version of the
series applied or something like that. Now, I'm able to see my AT25 SPI
eeprom successfully probed:

[    7.264705] at25 spi-PRP0001:00: 1 KByte at25 eeprom, pagesize 32

Sorry about the confusion.
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
