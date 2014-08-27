From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Date: Wed, 27 Aug 2014 11:50:25 -0700
Message-ID: <CAE9FiQXRZ8j-d=qOji7D_mBeSurXbwMz52UYgd1C04ihV9K0NA@mail.gmail.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<53FD01D0.8020203@zytor.com>
	<CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
	<53FE1A2B.80204@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53FE1A2B.80204-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 27, 2014 at 10:49 AM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> On 08/26/2014 03:05 PM, Yinghai Lu wrote:
> This does, however, suggest at least two possible solutions:
>
> 1. We can read the initramfs into a temporary buffer and memcpy() it to
> the target.
>
> 2. We might be able to align the initramfs buffer to a 512-byte section
> and then round up the size.
>
> The 512 bytes here is probably a hardware sector, I'm not sure how this
> will play on 4K-hard-sectored media, although those are few and far between.

efi_high_alloc() already round up the buffer size with EFI_PAGE_SIZE
(it is 4KiB now), and the buffer is aligned to EFI_PAGE_SIZE.

Yinghai
