From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [PATCH 0/6] Apple device properties
Date: Thu, 28 Jul 2016 01:48:56 +0200
Message-ID: <1493376.2sRvJz6u6v@vostro.rjw.lan>
References: <cover.1469616641.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1469616641.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org>, reverser-P1ImLx+pFc0@public.gmane.org, grub-devel-mXXj517/zsQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Aleksey Makarov <aleksey.makarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wednesday, July 27, 2016 01:20:41 PM Lukas Wunner wrote:
> Apple EFI drivers supply device properties which are needed to support
> Macs optimally.
> 
> This series extends the efistub to retrieve the device properties before
> ExitBootServices is called (patch [1/6]). They are assigned to devices
> in an fs_initcall (patch [5/6]). As a first use case, the Thunderbolt
> driver is amended to take advantage of the Device ROM supplied by EFI
> (patch [6/6]).

Can you please CC the whole series to linux-acpi for easier/better review?

Thanks,
Rafael
