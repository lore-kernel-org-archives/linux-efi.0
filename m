From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 4/6] driver core: Don't leak secondary fwnode on device removal
Date: Tue, 13 Sep 2016 00:03:38 +0200
Message-ID: <2138721.OSYGqcTspe@vostro.rjw.lan>
References: <cover.1469616641.git.lukas@wunner.de> <6868582.iUcUV1Tb36@vostro.rjw.lan> <20160830090325.GA25024@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160830090325.GA25024@wunner.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, Pierre Moreau <pierre.morrow@free.fr>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tuesday, August 30, 2016 11:03:25 AM Lukas Wunner wrote:
> On Wed, Aug 17, 2016 at 02:38:50AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, July 28, 2016 02:25:41 AM Lukas Wunner wrote:
> > > If device_add_property_set() is called for a device, a secondary fwnode
> > > is allocated and assigned to the device but currently not freed once the
> > > device is removed.
> > > 
> > > This can be triggered on Apple Macs if a Thunderbolt device is plugged
> > > in on boot since Apple's NHI EFI driver sets a number of properties for
> > > that device which are leaked on unplug.
> > > 
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Cc: Andreas Noever <andreas.noever@gmail.com>
> > > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > 
> > ACK, or I can apply it directly if you want me to do that.
> 
> Yes, if you could apply it directly I'd be grateful.

Applied.

Thanks,
Rafael

