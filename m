From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Mon, 13 Nov 2017 06:49:55 -0500
Message-ID: <1510573795.3404.113.camel@linux.vnet.ibm.com>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <14219.1509660259@warthog.procyon.org.uk>
         <1509660641.3416.24.camel@linux.vnet.ibm.com>
         <20171107230700.GJ22894@wotan.suse.de> <20171108061551.GD7859@linaro.org>
         <20171108194626.GQ22894@wotan.suse.de> <20171109014841.GF7859@linaro.org>
         <1510193857.4484.95.camel@linux.vnet.ibm.com>
         <20171109044619.GG7859@linaro.org> <20171111023240.2398ca55@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171111023240.2398ca55@alans-desktop>
Sender: owner-linux-security-module@vger.kernel.org
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, David Howells <dhowells@redhat.com>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, linux-security-module@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Sat, 2017-11-11 at 02:32 +0000, Alan Cox wrote:
> > My assumption here is:
> > 1) there are some less important and so security-insensitive firmwares,
> >    by which I mean that such firmwares won't be expected to be signed in
> >    terms of vulnerability or integrity.
> >    (I can't give you examples though.)
> > 2) firmware's signature will be presented separately from the firmware
> >    blob itself. Say, "firmware.bin.p7s" for "firmware.bin"
> 
> For x86 at least any firmware on any system modern enough to support
> 'secure' boot should already be signed. The only major exception is
> likely to be for things like random USB widgets.

Does this mean that the firmware signature is contained within the
firmware?  On Linux, is anything verifying this signature?  Or is this
the hw verifying the firmware's signature?

> Even things like input controller firmware loaded over i2c or spi
> is usually signed because you could do fun things with input faking
> otherwise.
> 
> The other usual exception is FPGAs, but since the point of an FPGA is
> usually the fact it *can* be reprogrammed it's not clear that signing
> FPGA firmware makes sense unless it is designed to be fixed function.
> 
> You can't subvert the bus protocols on the x86 FPGA I am aware of as
> those bits are signed (or hard IP), but without IOMMU I am not sure FPGA
> and 'secure' boot is completely compatible.

Ok, but why differentiate between "fixed" and research/development
FPGA functions?  In both cases, the FPGA firmware would need to be
signed locally.  Wouldn't this be similar to kernel developers
building their own kernels and signing the kernel modules?

Mimi

