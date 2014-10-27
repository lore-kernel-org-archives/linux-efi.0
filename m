From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/10] efi: dmi: add support for SMBIOS 3.0 UEFI
 configuration table
Date: Mon, 27 Oct 2014 16:33:27 +0100
Message-ID: <CAKv+Gu_pSxSrOJ_ttCb2bcyNM+Oho5LcsPYZuRi2+3=Vd0LOcA@mail.gmail.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
	<1413987713-30528-8-git-send-email-ard.biesheuvel@linaro.org>
	<20141027152611.GN12020@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141027152611.GN12020-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yi Li <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27 October 2014 16:26, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Wed, 22 Oct, at 04:21:50PM, Ard Biesheuvel wrote:
>> This adds support to the UEFI side for detecting the presence of
>> a SMBIOS 3.0 64-bit entry point. This allows the actual SMBIOS
>> structure table to reside at a physical offset over 4 GB, which
>> cannot be supported by the legacy SMBIOS 32-bit entry point.
>>
>> Since the firmware can legally provide both entry points, store
>> the SMBIOS 3.0 entry point in a separate variable, and let the
>> DMI decoding layer decide which one will be used.
>>
>> Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>
>> Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/efi.c | 4 ++++
>>  include/linux/efi.h        | 6 +++++-
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> Looks like you might also need to change driver/xen/efi.c to set
> EFI_INVALID_TABLE_ADDR for the new table address?
>

You're quite right. Will add it in v2

-- 
Ard.
