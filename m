From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 1/5] efi/runtime-wrappers: detect FW irq flag corruption
Date: Mon, 25 Apr 2016 16:18:41 +0200
Message-ID: <CAKv+Gu8yH4u0-DNezUTk5b1DQJdEaH4RxR7YMQcwmkuRmEaNEw@mail.gmail.com>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
	<1461591994-14918-2-git-send-email-mark.rutland@arm.com>
	<571E25B1.8070305@arm.com>
	<20160425141557.GA2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425141557.GA2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 April 2016 at 16:15, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 25 Apr, at 03:12:01PM, Robin Murphy wrote:
>> >+static void efi_call_virt_check_flags(unsigned long flags, const char *call)
>> >+{
>> >+    unsigned long cur_flags;
>> >+    bool mismatch;
>> >+
>> >+    local_save_flags(cur_flags);
>> >+
>> >+    mismatch = !!((cur_flags ^ flags) & ARCH_EFI_IRQ_FLAGS_MASK);
>>
>> nit: the assignment itself is already a conversion to bool, so the
>> excitement is redundant here.
>
> This was intentional. I asked Mark to make this change so that it's
> explicit for the developer that we're performing the type conversion.

But replacing an implicit boolean cast with an explicit one makes
little sense, no? Don't we simply want '!= 0' here if you need a
boolean expression?
