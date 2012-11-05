From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Mon, 5 Nov 2012 12:07:36 +0000
Message-ID: <20121105120736.33af173b@pyramind.ukuu.org.uk>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	<CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
	<20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
	<CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
	<20121105103031.GA25659@kroah.com>
	<1352116219.14888.262.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <1352116219.14888.262.camel@mfleming-mobl1.ger.corp.intel.com>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, Alessandro Crismani <alessandro.crismani@gmail.com>, Mikhail Bakhterev <mike.bakhterev@gmail.com>, Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

> There is the 'efi_enabled' variable, but it doesn't strictly mean
> "this_is_a_uefi_system()", it actually means "Do we have EFI runtime
> services?". The whole thing is a bit of a mess and I'm planning on
> cleaning it up this week.


As far as I can understand it we should be reserving those areas on a
UEFI booted machine and just marking them as busy so that they are not
available to any drivers to go peering into.

Alan
