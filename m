From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] [v2] arm64: efi: make sure vmlinux load address aligned
 on 2MB
Date: Thu, 29 Oct 2015 09:54:09 -0500
Message-ID: <56323311.8050708@codeaurora.org>
References: <1446053844-27281-1-git-send-email-timur@codeaurora.org>
 <20151028180836.GB26777@leverpostej> <56311014.9020400@codeaurora.org>
 <20151028182139.GC26777@leverpostej>
 <CAKv+Gu-76knWJ+ffAemeR7sBBtVB68pmZNPGQZRZKhmnd21F9A@mail.gmail.com>
 <20151029134333.GE28221@leverpostej>
 <CAKv+Gu8yFYv7GNvsOzUD1UQaXZ0AeXByahq3XjodrCtOGRGfgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8yFYv7GNvsOzUD1UQaXZ0AeXByahq3XjodrCtOGRGfgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/29/2015 08:48 AM, Ard Biesheuvel wrote:
>> >There is another (existing) problem I spotted, in that we'll sometimes
>> >move the kernel to a worse address. If the kernel was loaded at a valid
>> >address (i.e. image_addr % SZ_2MB == TEXT_OFFSET), but not at the
>> >preferred offset, we try to relocate it, even if it's already at the
>> >lowest possible address.
>> >

> Indeed. Unlikely to occur in practice, since UEFI mostly allocates top
> down, but it would indeed be better to drop the new allocation and
> simply use the existing one if it is not an improvement.

So you're saying that if we modify our UEFI so that it always loads the 
kernel at dram_base + TEXT_OFFSET, then one day in the future the kernel 
will skip the relocation?

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
