From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] efi: implement generic support for the Memory
 Attributes table
Date: Wed, 13 Apr 2016 12:24:59 +0200
Message-ID: <CAKv+Gu9VO+TMq__mcBYWqGmBDajAL6WLipjLNtekL5f3kF111w@mail.gmail.com>
References: <1459355933-13529-1-git-send-email-ard.biesheuvel@linaro.org>
	<1459355933-13529-5-git-send-email-ard.biesheuvel@linaro.org>
	<20160408155608.GQ2701@codeblueprint.co.uk>
	<CAKv+Gu-TMb0MTnzXXjczvxaWvZphu7M1-MMdjCrZ7A2CvCc2WQ@mail.gmail.com>
	<20160412195727.GG2829@codeblueprint.co.uk>
	<CAKv+Gu-bLN16YKei3togReQBNo+ScQVf7ek2NJEZAEyii2JEcw@mail.gmail.com>
	<20160413102408.GL2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160413102408.GL2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 13 April 2016 at 12:24, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 13 Apr, at 10:29:23AM, Ard Biesheuvel wrote:
>>
>> I think it is implied by the spec that this table and the one returned
>> by GetMemoryMap() use mutually compatible definitions of
>> EFI_MEMORY_DESCRIPTOR. However, since our definition of the struct
>> type is based on version 1, we should perhaps add a check for that
>> separately
>
> That makes sense. Could you send a patch for that on top of 'next'
> (I've dropped the desc_size check now)?
>

OK
