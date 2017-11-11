From: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Sat, 11 Nov 2017 02:32:40 +0000
Message-ID: <20171111023240.2398ca55@alans-desktop>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
        <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
        <14219.1509660259@warthog.procyon.org.uk>
        <1509660641.3416.24.camel@linux.vnet.ibm.com>
        <20171107230700.GJ22894@wotan.suse.de>
        <20171108061551.GD7859@linaro.org>
        <20171108194626.GQ22894@wotan.suse.de>
        <20171109014841.GF7859@linaro.org>
        <1510193857.4484.95.camel@linux.vnet.ibm.com>
        <20171109044619.GG7859@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109044619.GG7859-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> My assumption here is:
> 1) there are some less important and so security-insensitive firmwares,
>    by which I mean that such firmwares won't be expected to be signed in
>    terms of vulnerability or integrity.
>    (I can't give you examples though.)
> 2) firmware's signature will be presented separately from the firmware
>    blob itself. Say, "firmware.bin.p7s" for "firmware.bin"

For x86 at least any firmware on any system modern enough to support
'secure' boot should already be signed. The only major exception is
likely to be for things like random USB widgets.

Even things like input controller firmware loaded over i2c or spi
is usually signed because you could do fun things with input faking
otherwise.

The other usual exception is FPGAs, but since the point of an FPGA is
usually the fact it *can* be reprogrammed it's not clear that signing
FPGA firmware makes sense unless it is designed to be fixed function.

You can't subvert the bus protocols on the x86 FPGA I am aware of as
those bits are signed (or hard IP), but without IOMMU I am not sure FPGA
and 'secure' boot is completely compatible.

Alan
