From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or
 WP are set
Date: Fri, 15 Sep 2017 15:50:29 -0700
Message-ID: <CAKv+Gu_YEZAZL7X5oE9nPnoYi31xsrktLoik8_Gt442AsaLhWQ@mail.gmail.com>
References: <20170914193153.18520-1-ard.biesheuvel@linaro.org> <20170915185355.GC3349@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170915185355.GC3349-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 September 2017 at 11:53, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> On 09/14, Ard Biesheuvel wrote:
>> The UEFI memory map is a bit vague about how to interpret the
>> EFI_MEMORY_XP attribute when it is combined with EFI_MEMORY_RP and/or
>> EFI_MEMORY_WP, which have retroactively been redefined as cacheability
>> attributes rather than permission attributes.
>>
>> So let's ignore EFI_MEMORY_XP if _RP and/or _WP are also set. In this
>> case, it is likely that they are being used to describe the capability
>> of the region (i.e., whether it has the controls to reconfigure it as
>> non-executable) rather than the nature of the contents of the region
>> (i.e., whether it contains data that we will never attempt to execute)
>>
>> Cc: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> Reported-by: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> I will test early next week and provide a tested-by. Thanks.
>

Great, thanks.
