From: "Zhang, Jonathan Zhixiong" <zjzhang@codeaurora.org>
Subject: Re: [PATCH V9 0/5] map GHES memory region according to EFI memory map
Date: Thu, 6 Aug 2015 06:47:23 -0700
Message-ID: <55C3656B.5090808@codeaurora.org>
References: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
 <20150803112658.GE10501@arm.com> <20150803162354.GQ2725@codeblueprint.co.uk>
 <20150804042552.GG31787@nazgul.tnic> <55C0DD30.9070800@codeaurora.org>
 <20150805092125.GB4332@codeblueprint.co.uk> <55C232BC.1010107@codeaurora.org>
 <20150805161000.GE4332@codeblueprint.co.uk>
 <20150805161325.GF4332@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20150805161325.GF4332@codeblueprint.co.uk>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@alien8.de>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "tony.luck@gmail.com" <tony.luck@gmail.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "fu.wei@linaro.org" <fu.wei@linaro.org>, "al.stone@linaro.org" <al.stone@linaro.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "ying.huang@intel.com" <ying.huang@intel.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.>
List-Id: linux-efi@vger.kernel.org



On 8/5/2015 9:13 AM, Matt Fleming wrote:
> On Wed, 05 Aug, at 05:10:00PM, Matt Fleming wrote:
>> On Wed, 05 Aug, at 08:58:52AM, Zhang, Jonathan Zhixiong wrote:
>>>
>>> Yes, absolutely. It has been in my mind, sorry I was tied up in the last
>>> few days. I wonder what I may missed, I certainly do x86 build test with
>>> versions of the patch set.
>>>
>>> I will try today and report back.
>>
>> No problem.
>>
>> I'd suggest moving the implementation into include/acpi/apei.h and
>> leaving it as static inline instead of implementing it out of line in
>> arch/x86/kernel/acpi/apei.c.
>
> Yeah, I didn't mean include/acpi/apei.h but the architecture-specific
> equivalent.
>
Thank you Matt. It builds well on x86 with default configuration, but
not if APEI feature is turned on. This is my fault.
I just sent a new version of the patch set out.

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
