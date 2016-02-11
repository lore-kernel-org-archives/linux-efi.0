From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/7] ARM/efi minor fixes + stub pre-boot compat checks
Date: Thu, 11 Feb 2016 17:18:12 +0100
Message-ID: <CAKv+Gu-kZrcLYhF7i0u8F2TOMqEVKp==jNoBc+Rfk61cwSkDhQ@mail.gmail.com>
References: <1454601030-9093-1-git-send-email-ard.biesheuvel@linaro.org>
	<20160211161621.GM4134@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160211161621.GM4134-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "Suzuki K. Poulose" <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11 February 2016 at 17:16, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 04 Feb, at 04:50:23PM, Ard Biesheuvel wrote:
>> I merged two EFI/ARM related series, whose v1's I sent out last week:
>>
>> Changes since v1:
>> - added various tags from various people
>> - new patch #3 to undefine __init
>>
>> @Matt: are you happy with all of this going through the arm64 tree? I don't
>> think it clashes with anything else we've got queued up for v4.6 in tip/efi/core
>
> How come this is going through the arm64 tree? Are there other patch
> series that this depends on or that depend on it?
>
> If it makes the most sense to take it through that tree, then I'm fine
> with it but I'd like to hear a rationale.

I simply thought it would be most convenient, since it touches
ARM-specific files only. But if you feel it should go via the EFI tree
instead, that is also fine by me.

Thanks,
Ard.
