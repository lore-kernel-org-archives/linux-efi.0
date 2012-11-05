From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Mon, 05 Nov 2012 12:12:42 +0000
Message-ID: <1352117562.14888.277.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	 <CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
	 <20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, Alessandro Crismani <alessandro.crismani@gmail.com>, Mikhail Bakhterev <mike.bakhterev@gmail.com>, Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sun, 2012-11-04 at 19:37 +0000, Alan Cox wrote:
> > Acked-by: Corentin Chary <corentin.chary@gmail.com>
> 
> This is totally bogus and prevents users build a kernel which can work in
> either mode. As such its a regression.
> 
> Do the detection check at runtime. If it was booted via EFI then don't
> grovel in places you shouldn't. Indeed its possible EFI should reserve
> those memory regions ?

The kernel would have to reserve the gaps in the memory mappings since
there is no mapping in the EFI memory map for 0xf0000. There is no
support for that currently AFAIK.

-- 
Matt Fleming, Intel Open Source Technology Center
