From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] efi/apple-properties: Delete an error message for a
 failed memory allocation in unmarshal_devices()
Date: Tue, 13 Feb 2018 10:50:48 -0800
Message-ID: <1518547848.22190.50.camel@perches.com>
References: <145f8fac-9297-b362-d89f-886632e2507f@users.sourceforge.net>
         <20180213184033.GA24299@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20180213184033.GA24299@wunner.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>, SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2018-02-13 at 19:40 +0100, Lukas Wunner wrote:
> On Tue, Feb 13, 2018 at 06:00:26PM +0100, SF Markus Elfring wrote:
> > --- a/drivers/firmware/efi/apple-properties.c
> You didn't cc me on your submission even though I'm the author of
> 99% of this file.  Please make an effort prior to submission to
> identify interested parties.

If you want to receive patches for this file, even
if you are not a maintainer or an upstream path,
you should add yourself as a reviewer to the
MAINTAINERS file like:

APPLE EFI PROPERTIES
R:	Lukas Wunner <lukas@wunner.de>
F:	drivers/firmware/efi/apple-properties.c

