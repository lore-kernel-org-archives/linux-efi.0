From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [PATCH 2/6] ACPI / bus: Make acpi_get_first_physical_node() public
Date: Tue, 13 Sep 2016 00:03:17 +0200
Message-ID: <2217381.Z7p9ENgOTx@vostro.rjw.lan>
References: <cover.1469616641.git.lukas@wunner.de> <a0bb3346635e3bd8caf6cf735ceba684e3fde2fa.1469616641.git.lukas@wunner.de> <1821462.QyPXGhZaWJ@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1821462.QyPXGhZaWJ-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org>, Aleksey Makarov <aleksey.makarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wednesday, August 17, 2016 02:38:15 AM Rafael J. Wysocki wrote:
> On Thursday, July 28, 2016 02:25:41 AM Lukas Wunner wrote:
> > Following the fwnode of a device is currently a one-way road: We provide
> > ACPI_COMPANION() to obtain the fwnode but there's no (public) method to
> > do the reverse. Granted, there may be multiple physical_nodes, but often
> > the first one in the list is sufficient.
> > 
> > A handy function to obtain it was introduced with commit 3b95bd160547
> > ("ACPI: introduce a function to find the first physical device"), but
> > currently it's only available internally.
> > 
> > We're about to add an EFI Device Path parser which needs this function.
> > Consider the following device path: ACPI(PNP0A03,0)/PCI(28,2)/PCI(0,0)
> > The PCI root is encoded as an ACPI device in the path, so the parser
> > has to find the corresponding ACPI device, then find its physical node,
> > find the PCI bridge in slot 1c (decimal 28), function 2 below it and
> > finally find the PCI device in slot 0, function 0.
> > 
> > To this end, make acpi_get_first_physical_node() public.
> > 
> > Cc: Aleksey Makarov <aleksey.makarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> 
> ACK

I've applied this one, thanks!

Rafael
