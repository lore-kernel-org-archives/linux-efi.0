From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Date: Wed, 27 Aug 2014 10:49:31 -0700
Message-ID: <53FE1A2B.80204@zytor.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>	<53FD01D0.8020203@zytor.com> <CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/26/2014 03:05 PM, Yinghai Lu wrote:
> 
> The firmware has bug and can use buffer above 4G to read files.
> and if the file size is 512 bytes alignment, then reading could go through.
> 

File size, or alignment?  Different things.  Again, your patch
description is not just incomplete, but seems to be actively misleading.

This does, however, suggest at least two possible solutions:

1. We can read the initramfs into a temporary buffer and memcpy() it to
the target.

2. We might be able to align the initramfs buffer to a 512-byte section
and then round up the size.

The 512 bytes here is probably a hardware sector, I'm not sure how this
will play on 4K-hard-sectored media, although those are few and far between.

	-hpa
