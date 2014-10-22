From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: set PE/COFF file alignment to 512 bytes
Date: Wed, 22 Oct 2014 10:02:37 +0200
Message-ID: <CAKv+Gu-V-pSDTQuBOV_zK3YvuQoyFC7mXLXs91iQavM0sbytEQ@mail.gmail.com>
References: <1412960335-22905-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141021123526.GH12020@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141021123526.GH12020-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 October 2014 14:35, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Fri, 10 Oct, at 06:58:55PM, Ard Biesheuvel wrote:
>> Change our PE/COFF header to use the minimum file alignment of
>> 512 bytes (0x200), as mandated by the PE/COFF spec v8.3
>>
>> Also update the linker script so that the Image file itself is also a
>> round multiple of FileAlignment.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>
>> Another one from the PE/COFF rabbit hole. I will follow up next week and repost
>> as a coherent series, once I have collected all the feedback.
>
> It appears a though next week never came.
>
> Should I pick up this version and apply ACK tags from the mailing list?
> Or are you planning on sending a larger series?
>
> It sounds like this should be tagged for stable, and placed into the EFI
> urgent queue?
>

I have a couple of patches like this one in my queue, and I don't
think any of them are urgent. These alignment fixes etc are mainly for
full compliance with the various specs, and there are no known issues
being solved by them.

I was going to wait for -rc1 and rebase on top of that, but it appears
your branch hasn't been picked up?

-- 
Ard.
