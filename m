From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 2/6] ACPI / bus: Make acpi_get_first_physical_node() public
Date: Wed, 17 Aug 2016 02:38:15 +0200
Message-ID: <1821462.QyPXGhZaWJ@vostro.rjw.lan>
References: <cover.1469616641.git.lukas@wunner.de> <a0bb3346635e3bd8caf6cf735ceba684e3fde2fa.1469616641.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <a0bb3346635e3bd8caf6cf735ceba684e3fde2fa.1469616641.git.lukas@wunner.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, Pierre Moreau <pierre.morrow@free.fr>, Aleksey Makarov <aleksey.makarov@linaro.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thursday, July 28, 2016 02:25:41 AM Lukas Wunner wrote:
> Following the fwnode of a device is currently a one-way road: We provide
> ACPI_COMPANION() to obtain the fwnode but there's no (public) method to
> do the reverse. Granted, there may be multiple physical_nodes, but often
> the first one in the list is sufficient.
> 
> A handy function to obtain it was introduced with commit 3b95bd160547
> ("ACPI: introduce a function to find the first physical device"), but
> currently it's only available internally.
> 
> We're about to add an EFI Device Path parser which needs this function.
> Consider the following device path: ACPI(PNP0A03,0)/PCI(28,2)/PCI(0,0)
> The PCI root is encoded as an ACPI device in the path, so the parser
> has to find the corresponding ACPI device, then find its physical node,
> find the PCI bridge in slot 1c (decimal 28), function 2 below it and
> finally find the PCI device in slot 0, function 0.
> 
> To this end, make acpi_get_first_physical_node() public.
> 
> Cc: Aleksey Makarov <aleksey.makarov@linaro.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

ACK

Thanks,
Rafael

