From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: fix pointer type errors in fdt_uefi_find_params()
Date: Wed, 18 Jun 2014 12:53:31 +0200
Message-ID: <CAKv+Gu_T8VtNHBnYM=hHBbWdY-ZJ+f2xp8+yRWM_vVB2DOLRWQ@mail.gmail.com>
References: <1402671299-22493-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140618090245.GC24049@console-pimps.org>
	<CAKv+Gu-PKHx8Z64W0v2jA8p2w6whewhgVdYaQyBfJRZrPSFLyA@mail.gmail.com>
	<20140618092845.GE24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140618092845.GE24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 June 2014 11:28, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Wed, 18 Jun, at 11:06:09AM, Ard Biesheuvel wrote:
>>
>> You say potato, I say po-tah-to?
>> But seriously, whichever you prefer ...
>
> $ git grep "const void" | wc -l
> 4441
>
> $ git grep "void const" | wc -l
> 50
>
> I say potato, you say "tasty carbohydrate ball"
>
> But yeah, it's not a big deal and I can fix this up when applying.
>

Actually, it appears I messed up the subject line too:
s/fdt_uefi_find_params/fdt_find_uefi_params/

Cheers,
Ard.
