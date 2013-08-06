From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/7] Add EFI stub for ARM
Date: Mon, 5 Aug 2013 17:06:17 -0700
Message-ID: <CAFECyb-WciwMu0MBmZ8LzkaM=VxnaOH5e9V5f_AP3ZbLA9CW9A@mail.gmail.com>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
	<1375478948-22562-7-git-send-email-roy.franz@linaro.org>
	<20130805141149.GB2755@localhost.localdomain>
	<20130805153318.GL18151@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130805153318.GL18151-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 5, 2013 at 8:33 AM, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Aug 05, 2013 at 03:11:49PM +0100, Dave Martin wrote:
>> > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
>> > index 75189f1..4c70b9e 100644
>> > --- a/arch/arm/boot/compressed/head.S
>> > +++ b/arch/arm/boot/compressed/head.S
>> > @@ -122,19 +122,106 @@
>> >             .arm                            @ Always enter in ARM state
>> >  start:
>> >             .type   start,#function
>> > -           .rept   7
>> > +#ifdef CONFIG_EFI_STUB
>> > +           @ Magic MSDOS signature for PE/COFF + ADD opcode
>> > +           .word   0x62805a4d
>>
>> What about BE32?
>
> The ARM bindings for UEFI specify that the processor must be in
> little-endian mode.
>
>> In that case, the instruction is a coprocessor load, that loads from a
>> random address to a coprocessor that almost certainly doesn't exist.
>> This will probably fault.
>>
>> Since BE32 is only for older platforms (<v6) and this is not easily
>> solvable, it might be sensible to make the EFI stub support depend on
>> !CPU_ENDIAN_BE32.
>
> Well, it would make more sense to make EFI_STUB depend on EFI and
> EFI depend on !CPU_ENDIAN_BE32. Which is something I can add to
> my next set of general ARM UEFI patches. Thanks.
> /
>     Leif

I had EFI_STUB depend on EFI at one point during my development, but took
it out because there was no actual dependency (the stub will work fine without
other EFI features.)  The features will most likely be used together,
but I wasn't
sure if we would want to enforce this with a config dependency.  I
don't care one
way or the other, I'd just like the dependencies to be correct and
follow best practices.

Thanks,
Roy
