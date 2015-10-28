From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] arm64: efi: make sure vmlinux load address aligned on
 2MBytes
Date: Wed, 28 Oct 2015 16:02:23 -0500
Message-ID: <563137DF.1040908@codeaurora.org>
References: <1445981041-8774-1-git-send-email-timur@codeaurora.org>
 <CAKv+Gu_ivkemFva-Fu0E24mQqE-m0jPWBzo5OZAr7cyM08hqug@mail.gmail.com>
 <563101DD.8080508@codeaurora.org> <20151028172619.GA26777@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151028172619.GA26777@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/28/2015 12:26 PM, Mark Rutland wrote:
>> >This does make the kernel boot, but we suspect that there may be
>> >another problem.  We need to investigate it, but we have a suspicion
>> >that the EFI stub is trying to allocate from the Runtime Data block,
>> >and the alignment adjustment "fixes" the problem by moving the
>> >pointer to Conventional Memory.
> I don't follow. EFI_BOOT_SERVICES.AllocatePages() should only give us
> pages which are available, so it shouldn't ever return pages which are
> runtime data -- it would fail and we'd fall back to efi_low_alloc().
>
> Could you elaborate?

So we're still debugging this internally, but it turns out that 
dram_base is equal to 0x4000820000, which also happens to be the start 
of a Runtime Data block:

   0x004000820000-0x00400085ffff [Runtime Data       |RUN|XP|  |  | 
|WB|WT|WC|UC]

I think this is not supposed to happen.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
