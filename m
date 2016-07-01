From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: arm64: add debugfs node to dump UEFI runtime page tables
Date: Fri, 1 Jul 2016 15:18:37 +0200
Message-ID: <CAKv+Gu8T5=OKQVXzOToCro-XoLvavHGB6B5kAqPtUE+sepwC1A@mail.gmail.com>
References: <1467280906-31158-1-git-send-email-ard.biesheuvel@linaro.org> <20160630140930.GD20363@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160630140930.GD20363@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 30 June 2016 at 16:09, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Jun 30, 2016 at 12:01:46PM +0200, Ard Biesheuvel wrote:
>> Register the debugfs node 'efi_page_tables' to allow the UEFI runtime
>> page tables to be inspected. Note that ARM does not have 'asm/ptdump.h'
>> [yet] so for now, this is arm64 only.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>
>> This patch could be helpful in assessing the series 'arm64: avoid block
>> entries that we need to split later' that I sent out yesterday.
>
> It's probably worth noting that this is based on the arm64 for-next/core
> branch. I don't know if/how we can orgnise branches for merging this.
>

There's no rush, so Matt can take it for v4.9 I suppose?

>>  drivers/firmware/efi/arm-runtime.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
>> index 17ccf0a8787a..4197a1da013d 100644
>> --- a/drivers/firmware/efi/arm-runtime.c
>> +++ b/drivers/firmware/efi/arm-runtime.c
>> @@ -39,6 +39,26 @@ static struct mm_struct efi_mm = {
>>       .mmlist                 = LIST_HEAD_INIT(efi_mm.mmlist),
>>  };
>>
>> +#ifdef CONFIG_ARM64
>
> If you use CONFIG_ARM64_PTDUMP for the moment, then we won't have some
> unused structs lying around when the feature is unused.
>

I can change that

> Otherwise, I agree that this is a useful debuging feature. FWIW, either
> way:
>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>

Thanks.
