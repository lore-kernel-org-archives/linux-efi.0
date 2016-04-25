From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCHv3 1/5] efi/runtime-wrappers: detect FW irq flag corruption
Date: Mon, 25 Apr 2016 15:33:02 +0100
Message-ID: <571E2A9E.3010407@arm.com>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
 <1461591994-14918-2-git-send-email-mark.rutland@arm.com>
 <571E25B1.8070305@arm.com> <20160425141557.GA2829@codeblueprint.co.uk>
 <CAKv+Gu8yH4u0-DNezUTk5b1DQJdEaH4RxR7YMQcwmkuRmEaNEw@mail.gmail.com>
 <20160425142435.GB2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160425142435.GB2829@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 25/04/16 15:24, Matt Fleming wrote:
> On Mon, 25 Apr, at 04:18:41PM, Ard Biesheuvel wrote:
>> On 25 April 2016 at 16:15, Matt Fleming <matt@codeblueprint.co.uk> wrote:
>>> On Mon, 25 Apr, at 03:12:01PM, Robin Murphy wrote:
>>>>> +static void efi_call_virt_check_flags(unsigned long flags, const char *call)
>>>>> +{
>>>>> +    unsigned long cur_flags;
>>>>> +    bool mismatch;
>>>>> +
>>>>> +    local_save_flags(cur_flags);
>>>>> +
>>>>> +    mismatch = !!((cur_flags ^ flags) & ARCH_EFI_IRQ_FLAGS_MASK);
>>>>
>>>> nit: the assignment itself is already a conversion to bool, so the
>>>> excitement is redundant here.
>>>
>>> This was intentional. I asked Mark to make this change so that it's
>>> explicit for the developer that we're performing the type conversion.
>>
>> But replacing an implicit boolean cast with an explicit one makes
>> little sense, no? Don't we simply want '!= 0' here if you need a
>> boolean expression?
>
> Aha but '!!' is fewer characters to type!!
>
> I'm not that bothered as long as we don't stuff an int into a bool
> without giving the programmer some idea we're doing that. It's not
> about the compiler getting it wrong, more about a developer
> introducing a bug when they change the code in the future.
>
> Unless anyone objects, I'll fix this up to use '!= 0' when I apply it.

Agreed - the belt and braces approach isn't necessarily bad if the cost
of cocking it up is significant, and !=0 is as explicit as you can get.
After all, if Joe Random Hacker can't infer the behaviour from looking 4
lines up to see the variable definition, then I wouldn't count on him
understanding !! either ;)

Thanks,
Robin.

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
