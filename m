From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v5 2/8] acpi: fix enumeration (visited) flags for bus
 rescans
Date: Thu, 7 Jul 2016 12:28:21 +0300
Message-ID: <20160707092821.GN23527@lahna.fi.intel.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-3-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-3-git-send-email-octavian.purdila@intel.com>
Sender: linux-i2c-owner@vger.kernel.org
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
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
