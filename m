From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 0/4] efi/arm64: unmap the kernel during runtime service
 calls
Date: Mon, 29 Jan 2018 07:51:41 -0700
Message-ID: <bdba264b-6619-6e9f-2849-d9d82a820ab0@codeaurora.org>
References: <20180125103131.19168-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125103131.19168-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org
Cc: joakim.bech-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 1/25/2018 3:31 AM, Ard Biesheuvel wrote:

> Note that capsule update has been omitted. This is a bit involved, and
> I'd rather get some feedback before burning too many cycles on that. All
> other services should be functional, with the caveat that EFI variable
> names are now limited to 1024 [wide] characters, and UEFI variables
> themselves to 64 KB.
> 

I'm curious, why these limitations?

We don't have any concern about the name length limitation at this time, 
but the variable size one is concerning.

We have a feature which creates a variable greater than 64KB that we 
want to utilize from Linux.  The size limitation would seem to prevent that.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
