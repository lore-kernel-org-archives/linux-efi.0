From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: efi/apple-properties: Checking error handling in
 unmarshal_devices()
Date: Wed, 14 Feb 2018 09:21:00 +0100
Message-ID: <af278523-44af-3483-8503-10ec93f7a6c6@users.sourceforge.net>
References: <145f8fac-9297-b362-d89f-886632e2507f@users.sourceforge.net>
 <20180213184033.GA24299@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20180213184033.GA24299@wunner.de>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>, linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

> While the allocator does print an error when allocations fail,
> it may not be immediately apparent to the user what the
> *consequences* are.  In this case, the consequence is that the
> device properties will not be available for consumption by
> drivers and they may fail to probe or behave in entirely
> unexpected ways.

Would it make sense to indicate such a questionable software situation
be any return code?


> Hence I deliberately printed an error message here so that the user
> can make the connection between erratic behavior of drivers later on
> and the memory allocation error here.

Do you find this terse message really sufficient?

Can the mentioned properties be required for the desired system configuration?

Regards,
Markus
