From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] efi/arm64: fix potential NULL dereference of efi.systab
Date: Fri, 4 Jul 2014 15:54:19 +0200
Message-ID: <CAKv+Gu_VJZuzio8oyDA4OKwaeZj3J4WY_kX4s-_zhs1rk35b7A@mail.gmail.com>
References: <1404295802-28030-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140704133844.GG16404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140704133844.GG16404-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 July 2014 15:38, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> On Wed, Jul 02, 2014 at 11:10:01AM +0100, Ard Biesheuvel wrote:
>> We assign efi.systab using efi_lookup_mapped_addr(), and test for !NULL, but
>> then go on an dereference it anyway.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Thanks. I applied this one (the other patch needs to go in via a
> different route).
>

Eh, actually, I proposed a v2 based on Mark's feedback, but I now see
that I accidentally removed you from the To list.

http://marc.info/?l=linux-arm-kernel&m=140446911506688&w=2

-- 
Ard.
