From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 04/10] arm64: add EFI little endian constants to
 linker script
Date: Wed, 30 Jul 2014 16:21:47 +0200
Message-ID: <CAKv+Gu8haTMur6GXVPMyLO_7Z2idQqXi978LqLD=HgkySvd2CQ@mail.gmail.com>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
	<1405955785-13477-5-git-send-email-ard.biesheuvel@linaro.org>
	<20140730141805.GA15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140730141805.GA15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Victor Kamensky <victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 30 July 2014 16:18, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 21 Jul, at 05:16:19PM, Ard Biesheuvel wrote:
>> Similar to how text offset and kernel size are mangled to produce little
>> endian constants for the Image header regardless of the endianness of the
>> kernel, this adds a number of constants used in the EFI PE/COFF header which
>> can only be calculated (and byte swapped) by the linker.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/image.h | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> Where is this file? I can't find it in Linus' tree.
>

Apologies, I failed to mention that this series depends on arm64 for-next/core

https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/log/?h=for-next/core

-- 
Ard.
