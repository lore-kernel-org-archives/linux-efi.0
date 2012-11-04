From: Corentin Chary <corentincj@iksaif.net>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Sun, 4 Nov 2012 17:44:05 +0000
Message-ID: <CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, Alessandro Crismani <alessandro.crismani@gmail.com>, Mikhail Bakhterev <mike.bakhterev@gmail.com>, Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sun, Nov 4, 2012 at 5:35 PM, Matt Fleming <matt@console-pimps.org> wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> We've started getting reports of users seeing Machine Check Exceptions
> when booting their Samsung laptops in UEFI mode,
>
>      https://bugzilla.kernel.org/show_bug.cgi?id=47121
>
> This module seems to be the culprit as it's grovelling around in the
> 0xf0000 region which has no mapping in either the e820 or EFI memory
> maps on the affected machines.
>
> Reported-by: Alessandro Crismani <alessandro.crismani@gmail.com>
> Reported-by: Mikhail Bakhterev <mike.bakhterev@gmail.com>
> Tested-by: Patrick H <kernel@feystorm.net>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  drivers/platform/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index c86bae8..0fe5200 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -717,7 +717,7 @@ config XO15_EBOOK
>
>  config SAMSUNG_LAPTOP
>         tristate "Samsung Laptop driver"
> -       depends on X86
> +       depends on X86 && !EFI
>         depends on RFKILL || RFKILL = n
>         depends on BACKLIGHT_CLASS_DEVICE
>         select LEDS_CLASS
> --
> 1.7.11.7
>

Acked-by: Corentin Chary <corentin.chary@gmail.com>

Matthew could you merge this in your tree ? Thanks.

Matt, any idea if SABI doesn't exist on these machines, or is just
mapped somewhere else ?
By any luck, could Samsung tell you how to safely detect SABI aware machines ?

--
Corentin Chary
http://xf.iksaif.net
