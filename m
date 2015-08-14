From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] arm64: apei: implement arch_apei_get_mem_attributes()
Date: Fri, 14 Aug 2015 20:12:20 +0100
Message-ID: <20150814191220.GA7556@codeblueprint.co.uk>
References: <1439396234-22863-1-git-send-email-matt@codeblueprint.co.uk>
 <1439396234-22863-2-git-send-email-matt@codeblueprint.co.uk>
 <20150813082207.GB14610@gmail.com>
 <55CE399F.1030108@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55CE399F.1030108@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang, Jonathan Zhixiong" <zjzhang@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 14 Aug, at 11:55:27AM, Zhang, Jonathan Zhixiong wrote:
> 
> >Also, this doesn't look like a small function - why is it inlined?
> The function grew a bit after its first version. Since it is on the
> fence of not being a small function, I did not change it to out of
> the line. I will move it to arch/arm64/kernel/acpi.c guarded by
> CONFIG_ACPI_APEI instead of having to create a very small new file,
> if there is no opposition.

Please keep Will in the loop (now Cc'd) since he originally suggested
moving this to a header file and marking it static inline.

-- 
Matt Fleming, Intel Open Source Technology Center
