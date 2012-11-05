From: Corentin Chary <corentincj@iksaif.net>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Mon, 5 Nov 2012 09:12:01 +0000
Message-ID: <CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	<CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
	<20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, Alessandro Crismani <alessandro.crismani@gmail.com>, Mikhail Bakhterev <mike.bakhterev@gmail.com>, Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sun, Nov 4, 2012 at 7:37 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Acked-by: Corentin Chary <corentin.chary@gmail.com>
>
> This is totally bogus and prevents users build a kernel which can work in
> either mode. As such its a regression.

Arg.. Sorry for that, I didn't realized that CONFIG_EFI=y was not
something rare these days.

> Do the detection check at runtime. If it was booted via EFI then don't
> grovel in places you shouldn't. Indeed its possible EFI should reserve
> those memory regions ?

I wonder how the windows driver works in this case.. Maybe they use
something completly different, and the SABI interface is still there
because nobody removed/disabled it ? In this case it's probably not a
good idea to use it on these machines since the implementation is
likely to be completly broken.

--
Corentin Chary
http://xf.iksaif.net
