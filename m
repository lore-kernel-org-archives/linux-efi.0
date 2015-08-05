From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH V9 0/5] map GHES memory region according to EFI memory map
Date: Wed, 5 Aug 2015 17:10:00 +0100
Message-ID: <20150805161000.GE4332@codeblueprint.co.uk>
References: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
 <20150803112658.GE10501@arm.com>
 <20150803162354.GQ2725@codeblueprint.co.uk>
 <20150804042552.GG31787@nazgul.tnic>
 <55C0DD30.9070800@codeaurora.org>
 <20150805092125.GB4332@codeblueprint.co.uk>
 <55C232BC.1010107@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55C232BC.1010107@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang, Jonathan Zhixiong" <zjzhang@codeaurora.org>
Cc: Borislav Petkov <bp@alien8.de>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "tony.luck@gmail.com" <tony.luck@gmail.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "fu.wei@linaro.org" <fu.wei@linaro.org>, "al.stone@linaro.org" <al.stone@linaro.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "ying.huang@intel.com" <ying.huang@intel.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.>
List-Id: linux-efi@vger.kernel.org

On Wed, 05 Aug, at 08:58:52AM, Zhang, Jonathan Zhixiong wrote:
> 
> Yes, absolutely. It has been in my mind, sorry I was tied up in the last
> few days. I wonder what I may missed, I certainly do x86 build test with
> versions of the patch set.
> 
> I will try today and report back.

No problem.

I'd suggest moving the implementation into include/acpi/apei.h and
leaving it as static inline instead of implementing it out of line in
arch/x86/kernel/acpi/apei.c.

-- 
Matt Fleming, Intel Open Source Technology Center
