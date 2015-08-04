From: "Zhang, Jonathan Zhixiong" <zjzhang@codeaurora.org>
Subject: Re: [PATCH V9 0/5] map GHES memory region according to EFI memory map
Date: Tue, 4 Aug 2015 08:41:36 -0700
Message-ID: <55C0DD30.9070800@codeaurora.org>
References: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
 <20150803112658.GE10501@arm.com> <20150803162354.GQ2725@codeblueprint.co.uk>
 <20150804042552.GG31787@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150804042552.GG31787@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Will Deacon <will.deacon@arm.com>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "tony.luck@gmail.com" <tony.luck@gmail.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "fu.wei@linaro.org" <fu.wei@linaro.org>, "al.stone@linaro.org" <al.stone@linaro.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "ying.huang@intel.com" <ying.huang@intel.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-arm-msm@vger.kerne
List-Id: linux-efi@vger.kernel.org


On 8/3/2015 9:25 PM, Borislav Petkov wrote:
> On Mon, Aug 03, 2015 at 05:23:54PM +0100, Matt Fleming wrote:
>> Rafael, Boris?
>
> The ghes.c change looks fine I guess. The whole patchset makes sense
> now, with the arch bits extracted. So
>
> Acked-by: Borislav Petkov <bp@suse.de>
Thank you Boris/Matt/Will for the support.

>
> However, we probably should work towards adhering to EFI memory
> attributes on x86, long term, as we talked. But that's a future thing.
>
> Thanks.
>

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
