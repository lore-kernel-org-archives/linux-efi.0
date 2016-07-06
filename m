From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v5 2/8] acpi: fix enumeration (visited) flags for bus
 rescans
Date: Wed, 6 Jul 2016 18:03:17 +0300
Message-ID: <20160706150317.GH23527@lahna.fi.intel.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-3-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-3-git-send-email-octavian.purdila@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 01, 2016 at 11:19:06PM +0300, Octavian Purdila wrote:
> If the ACPI tables changes as a result of a dinamically loaded table and
> a bus rescan is required the enumeration/visited flag are not
> consistent.
> 
> I2C/SPI are not directly enumerated in acpi_bus_attach(), however the
> visited flag is set. This makes it impossible to check if an ACPI device
> has already been enumerated by the I2C and SPI subsystems. To fix this
> issue we only set the visited flags if the device is not I2C or SPI.
> 
> With this change we also need to remove setting visited to false from
> acpi_bus_attach(), otherwise if we rescan already enumerated I2C/SPI
> devices we try to re-enumerate them.
> 
> Note that I2C/SPI devices can be enumerated either via a scan handler
> (when using PRP0001) or via regular device_attach(). In either case
> the flow goes through acpi_default_enumeration() which makes it the
> ideal place to mark the ACPI device as enumerated.

Hmm, this somehow fails to enumerate PRP0001 devices.

I'm adding following SSDT to my initrd and the resulting device is never
enumerated on SPI bus (it exists in /sys/bus/acpi/devices). If I use
normal ACPI IDs (non-PRP0001) then it works fine.

/*
 * Minnowboard MAX
 *
 * http://wiki.minnowboard.org/MinnowBoard_MAX
 *
 * This adds Atmel AT25 compatible serial EEPROM to the SPI host controller
 * available on Minnowboard MAX low speed connector.
 */
DefinitionBlock ("at25.aml", "SSDT", 5, "INTEL", "AT25", 1)
{
    External (_SB_.SPI1, DeviceObj)

    Scope (\_SB.SPI1)
    {
        Device (EEP0) {
            Name (_HID, "PRP0001")
            Name (_DDN, "Atmel AT25 compatible EEPROM")
            Name (_CRS, ResourceTemplate () {
                SpiSerialBus (
                    1,                      // Chip select
                    PolarityLow,            // Chip select is active low
                    FourWireMode,           // Full duplex
                    8,                      // Bits per word is 8 (byte)
                    ControllerInitiated,    // Don't care
                    1000000,                // Initial bus speed is 1MHz
                    ClockPolarityLow,       // SPI mode 0
                    ClockPhaseFirst,        // SPI mode 0
                    "\\_SB.SPI1",           // SPI host controller
                    0                       // Must be 0
                )
            })

            /*
             * See Documentation/devicetree/bindings/eeprom/at25.txt for
             * more information about these bindings.
             */
            Name (_DSD, Package () {
                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                Package () {
                    Package () {"compatible", Package () {"atmel,at25"}},
                    Package () {"size", 1024},
                    Package () {"pagesize", 32},
                    Package () {"address-width", 16},
                }
            })
        }
    }
}
