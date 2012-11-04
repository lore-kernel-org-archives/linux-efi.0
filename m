From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Sun, 4 Nov 2012 09:47:13 -0800
Message-ID: <20121104174713.GA28414@elie.Belkin>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org, Alessandro Crismani <alessandro.crismani@gmail.com>, Mikhail Bakhterev <mike.bakhterev@gmail.com>, Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Matt Fleming wrote:

> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -717,7 +717,7 @@ config XO15_EBOOK
> 
>  config SAMSUNG_LAPTOP
>  	tristate "Samsung Laptop driver"
> -	depends on X86
> +	depends on X86 && !EFI

That means distros would just not get the samsung-laptop driver.
Is there a runtime check that could be used instead?

Thanks,
Jonathan
