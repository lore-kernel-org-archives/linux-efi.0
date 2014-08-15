From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi/arm64: store Runtime Services revision
Date: Fri, 15 Aug 2014 15:55:10 +0200
Message-ID: <CAKv+Gu8Ec+=Trt=cUe3HKd17tSLd6+TY_ki9FRSdD8D+NLvwNA@mail.gmail.com>
References: <1408108964-28650-1-git-send-email-semen.protsenko@linaro.org>
	<CAKv+Gu9ABf9VzMiT-nA1tt8tbjimCZGatiT1ucwcFTnt7qdmfQ@mail.gmail.com>
	<20140815134324.GY15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140815134324.GY15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 August 2014 15:43, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Fri, 15 Aug, at 03:38:48PM, Ard Biesheuvel wrote:
>> On 15 August 2014 15:22, Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > "efi" global data structure contains "runtime_version" field which must
>> > be assigned in order to use it later in Runtime Services virtual calls
>> > (virt_efi_* functions).
>> >
>> > Before this patch "runtime_version" was unassigned (0), so each
>> > Runtime Service virtual call that checks revision would fail.
>> >
>> > Signed-off-by: Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> @Matt, could you take this?
>
> Certainly. Looks like this should go into the 'urgent' queue and be
> tagged for stable?
>

Yes, please (for 3.16)

-- 
Ard.
