From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: set PE/COFF file alignment to 512 bytes
Date: Thu, 16 Oct 2014 18:06:35 +0200
Message-ID: <CAKv+Gu_Ky6jUe-Br2E_nThA9ZKYUM2VbuhkRiHwviHh_8hbO-A@mail.gmail.com>
References: <1412960335-22905-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAFECyb8zwUwXAThPVOHNxZGzD6e=WVq4JMZdofNwztnw4YgYwA@mail.gmail.com>
	<20141016135239.GG14343@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141016135239.GG14343-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 October 2014 15:52, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Fri, 10 Oct, at 10:07:48AM, Roy Franz wrote:
>> On Fri, Oct 10, 2014 at 9:58 AM, Ard Biesheuvel
>> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > Change our PE/COFF header to use the minimum file alignment of
>> > 512 bytes (0x200), as mandated by the PE/COFF spec v8.3
>> >
>> > Also update the linker script so that the Image file itself is also a
>> > round multiple of FileAlignment.
>> >
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > ---
>>
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Whut? Is there some patch authorship madness going on here?
>
> Who wrote the patch?
>

I wrote the patch, and I suppose Roy meant to ack it.

Roy?

-- 
Ard.
