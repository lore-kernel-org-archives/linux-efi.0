From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: map the entire UEFI vendor string before
 reading it
Date: Mon, 27 Jul 2015 14:16:20 +0200
Message-ID: <CAKv+Gu9KpSNQD9-tDtat13++M=DB+k+dkEken170XFE3y1i_CA@mail.gmail.com>
References: <1437915540-7553-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150727121455.GF29945@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727121455.GF29945-M2fw3Uu6cmfZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27 July 2015 at 14:14, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> On Sun, Jul 26, 2015 at 02:59:00PM +0200, Ard Biesheuvel wrote:
>> At boot, the UTF-16 UEFI vendor string is copied from the system
>> table into a char array with a size of 100 bytes. However, this
>> size of 100 bytes is also used for memremapping() the source,
>> which may not be sufficient if the vendor string exceeds 50
>> UTF-16 characters, and the placement of the vendor string inside
>> a 4 KB page happens to leave the end unmapped.
>>
>> So use the correct '100 * sizeof(efi_char16_t)' for the size of
>> the mapping.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>> Hello Catalin,
>>
>> I think this should go into v4.2 with a cc: stable.
>
> If it's cc stable, do you have a Fixes: tag? (it saves me some
> searching).
>

Ah sure, I forgot.

Fixes: f84d02755f5a ("arm64: add EFI runtime services")
