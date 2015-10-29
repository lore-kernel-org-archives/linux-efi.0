From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] [v2] arm64: efi: make sure vmlinux load address aligned on 2MB
Date: Thu, 29 Oct 2015 16:08:55 +0100
Message-ID: <B00905D7-EF6A-42F7-86AB-7C2FA60E3B51@linaro.org>
References: <1446053844-27281-1-git-send-email-timur@codeaurora.org> <20151028180836.GB26777@leverpostej> <56311014.9020400@codeaurora.org> <20151028182139.GC26777@leverpostej> <CAKv+Gu-76knWJ+ffAemeR7sBBtVB68pmZNPGQZRZKhmnd21F9A@mail.gmail.com> <20151029134333.GE28221@leverpostej> <CAKv+Gu8yFYv7GNvsOzUD1UQaXZ0AeXByahq3XjodrCtOGRGfgQ@mail.gmail.com> <56323311.8050708@codeaurora.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56323311.8050708-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> On 29 okt. 2015, at 15:54, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> 
> On 10/29/2015 08:48 AM, Ard Biesheuvel wrote:
>>> >There is another (existing) problem I spotted, in that we'll sometimes
>>> >move the kernel to a worse address. If the kernel was loaded at a valid
>>> >address (i.e. image_addr % SZ_2MB == TEXT_OFFSET), but not at the
>>> >preferred offset, we try to relocate it, even if it's already at the
>>> >lowest possible address.
>>> >
> 
>> Indeed. Unlikely to occur in practice, since UEFI mostly allocates top
>> down, but it would indeed be better to drop the new allocation and
>> simply use the existing one if it is not an improvement.
> 
> So you're saying that if we modify our UEFI so that it always loads the kernel at dram_base + TEXT_OFFSET, then one day in the future the kernel will skip the relocation?
> 

In fact, it does that already. The case Mark describes is when the Image is correctly aligned, but not at the base of DRAM, and the allocation produced by the firmware turns out to be even higher up in memory than the existing Image. In that particular case, the Image should simply be kept at the original offset, but currently we will prefer the suboptimal reallocation.

> -- 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the
> Code Aurora Forum, a Linux Foundation Collaborative Project.
