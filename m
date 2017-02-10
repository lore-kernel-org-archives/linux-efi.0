From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/14] arm64: efi: remove forbidden values from the
 PE/COFF header
Date: Fri, 10 Feb 2017 14:31:31 +0000
Message-ID: <CAKv+Gu8sT2CLquxAdneNSQ+YqasbPM96E3h9NMc0JMCR5Wa+bA@mail.gmail.com>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486554947-3964-6-git-send-email-ard.biesheuvel@linaro.org> <20170210101329.GD28753@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210101329.GD28753@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Laura Abbott <labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 February 2017 at 10:13, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Wed, Feb 08, 2017 at 11:55:38AM +0000, Ard Biesheuvel wrote:
>> Bring the PE/COFF header in line with the PE/COFF spec, by setting
>> NumberOfSymbols to 0, and removing the section alignment flags.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> I take it that in practice EFI implementations don't care about these?

Not at all. I just spotted it when I was cleaning up the header.

> Assuming so:
>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>
> Otherwise, we might want to fix this first, so that we can easily
> backport it.
>

I wouldn't bother
