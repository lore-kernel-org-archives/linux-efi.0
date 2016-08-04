From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 0/6] Apple device properties
Date: Thu, 4 Aug 2016 15:57:10 +0100
Message-ID: <20160804145710.GL3636@codeblueprint.co.uk>
References: <cover.1469616641.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1469616641.git.lukas@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, Pierre Moreau <pierre.morrow@free.fr>, reverser@put.as, grub-devel@gnu.org, x86@kernel.org, Aleksey Makarov <aleksey.makarov@linaro.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 28 Jul, at 02:25:41AM, Lukas Wunner wrote:
> Apple EFI drivers supply device properties which are needed to support
> Macs optimally.
> 
> This series extends the efistub to retrieve the device properties before
> ExitBootServices is called (patch [1/6]). They are assigned to devices
> in an fs_initcall (patch [5/6]). As a first use case, the Thunderbolt
> driver is amended to take advantage of the Device ROM supplied by EFI
> (patch [6/6]).
> 
> A by-product is a parser for EFI Device Paths which finds the struct
> device corresponding to a given path. This is needed to assign
> properties to their devices (patch [3/6]).
> 
> 
> I've pushed these patches to GitHub where they can be reviewed more
> comfortably with green/red highlighting:
> https://github.com/l1k/linux/commits/apple_properties_v1
> 
> 
> It would be good if one of the resident EFI experts could look over
> patch [1/6] to see if I've made any mistakes that might prevent this
> from working on 32 bit. It was only tested on 64 bit, I don't know
> anyone with an older Mac who could test this.
> 
> Specifically, is the following okay:
> efi_early->call((unsigned long)sys_table->boottime->locate_protocol, ...)

This probably isn't going to work with EFI mixed mode because you
can't jump through pointers at runtime - that's the whole point of the
setup_boot_services*bits() code.

> It would be convenient to have LocateProtocol or LocateHandleBuffer in
> struct efi_config so that they can be called with efi_call_early().
> Would a patch to add those be entertained? Right now we only offer
> LocateHandle and HandleProtocol, which is somewhat cumbersome and
> needs more code as the setup_pci() functions show.

Yes, go for it. Doing this would make it work with EFI mixed mode too.
