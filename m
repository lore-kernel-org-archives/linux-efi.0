From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH V2 1/3] efi: arch, x86: arch, ia64: move
 efi_mem_attributes()
Date: Fri, 5 Jun 2015 10:23:17 +0100
Message-ID: <20150605092317.GE6826@codeblueprint.co.uk>
References: <1433185940-24770-1-git-send-email-zjzhang@codeaurora.org>
 <1433185940-24770-2-git-send-email-zjzhang@codeaurora.org>
 <20150602133647.GC6826@codeblueprint.co.uk>
 <556E45AA.9050802@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <556E45AA.9050802@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: "Zhang, Jonathan Zhixiong" <zjzhang@codeaurora.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, leif.lindholm@linaro.org, al.stone@linaro.org, fu.wei@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org, Tony Luck <tony.luck@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 02 Jun, at 05:09:14PM, Zhang, Jonathan Zhixiong wrote:
> Thank you for the feedback, Matt.
> 
> Given that IA64 does not set EFI_MEMMAP, it appears to me there
> are following options:
> A. Keep status quota and copy x86's efi_mem_attributes() code
> to arm64.

Let's avoid this option.

> B. In efi subsystem, provide week default efi_mem_attributes().
> In the mean time, IA64 continues to have its own implementation.

While I'm not a huge fan of using __weak this makes the most sense to me
because the alternative is to rename either the ia64 or x86
implementation and that just seems silly.

> C. Add EFI_MEMMAP support (and related bits) in IA64.

C. isn't an option because the ia64 memory map doesn't work the same way
as x86 and arm64.
 
> Which option do you prefer? Once there is a consensus, I am
> willing to submit patch accordingly for review.

Let's go with B. but please provide a comment above the weak
implementation explaining *why* it's declared as weak and that any new
architecture probably doesn't want to override it. Explain that the ia64
EFI memory map is special.

-- 
Matt Fleming, Intel Open Source Technology Center
