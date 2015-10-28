From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] [v2] arm64: efi: make sure vmlinux load address aligned
 on 2MB
Date: Wed, 28 Oct 2015 13:12:36 -0500
Message-ID: <56311014.9020400@codeaurora.org>
References: <1446053844-27281-1-git-send-email-timur@codeaurora.org>
 <20151028180836.GB26777@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151028180836.GB26777@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/28/2015 01:08 PM, Mark Rutland wrote:

> arm64: efi: ensure kernel is loaded at correct address
>
> The kernel image needs to be loaded text_offset_bytes from a 2M-aligned
> base, per Documentation/arm64/booting.txt. If loaded at the wrong offset
> modulo 2M, __create_page_tables will create incorrect page tables.
>
> The EFI stub implicitly assumes that dram_base (i.e. the lowest address
> with a EFI_MEMORY_WB attribute) is 2M-aligned, and tries to load the
> kernel at dram_base + TEXT_OFFSET. If dram_base is not 2M-aligned, the
> kernel will be loaded at the wrong offset from 2M.

Thanks, I'll use that.  I messed up a couple other things, so I need to 
send out a v3 anyway.

>> -		*image_addr = *reserve_addr = dram_base + TEXT_OFFSET;
>> +		*image_addr = *reserve_addr =
>> +			round_up(dram_base, SZ_2M) + TEXT_OFFSET;
>
> We also need to fix the test for whether we need to relocate the kernel:
> (*image_addr != (dram_base + TEXT_OFFSET)).
>
> When dram_base is not 2M aligned, that is broken, and it's been broken
> since it was introduced in commit 3c7f255039a2ad6e ("arm64: efi: add EFI
> stub") in v3.16.
>
> It's a bit hideous to fix the general case, though, it seems.

Um, so I should I do something more in my v3 patch, or is this a change 
for a different patch?

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
