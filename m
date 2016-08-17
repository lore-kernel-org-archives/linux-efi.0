From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 4/6] driver core: Don't leak secondary fwnode on device removal
Date: Wed, 17 Aug 2016 02:38:50 +0200
Message-ID: <6868582.iUcUV1Tb36@vostro.rjw.lan>
References: <cover.1469616641.git.lukas@wunner.de> <ef34b0d31d1fb9bc6a48a07d265fd103527b3f30.1469616641.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <ef34b0d31d1fb9bc6a48a07d265fd103527b3f30.1469616641.git.lukas@wunner.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, Pierre Moreau <pierre.morrow@free.fr>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thursday, July 28, 2016 02:25:41 AM Lukas Wunner wrote:
> If device_add_property_set() is called for a device, a secondary fwnode
> is allocated and assigned to the device but currently not freed once the
> device is removed.
> 
> This can be triggered on Apple Macs if a Thunderbolt device is plugged
> in on boot since Apple's NHI EFI driver sets a number of properties for
> that device which are leaked on unplug.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Andreas Noever <andreas.noever@gmail.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

ACK, or I can apply it directly if you want me to do that.

Thanks,
Rafael

