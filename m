From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V9 0/5] map GHES memory region according to EFI memory map
Date: Mon, 3 Aug 2015 12:26:58 +0100
Message-ID: <20150803112658.GE10501@arm.com>
References: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "tony.luck@gmail.com" <tony.luck@gmail.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "fu.wei@linaro.org" <fu.wei@linaro.org>, "al.stone@linaro.org" <al.stone@linaro.org>, "bp@alien8.de" <bp@alien8.de>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "ying.huang@intel.com" <ying.huang@intel.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-arm-msm@vger.kernel.or
List-Id: linux-efi@vger.kernel.org

Hi Jonathan,

On Thu, Jul 30, 2015 at 10:35:04PM +0100, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
> 
> On a platform with APEI (ACPI Platform Error Interface) enabled, firmware
> updates a memory region with hardware error record using nocache
> attribute. When OS reads the region, since it maps the region with
> cacahed attribute even though EFI memory map defines this region as
> uncached, OS gets stale data and errorneously reports there is no new
> HW error.
> 
> When ghes driver maps the memory region, it uses the cache attribute
> according to EFI memory map, if EFI memory map feature is enabled
> at runtime.
> 
> Since both arch/x86 and arch/ia64 implemented architecture agnostic EFI
> memory map attribue lookup function efi_memattributes(), the code is
> moved from arch/x86 into EFI subsystem and is declared as __weak; archs
> other than ia64 should not override the default implementation.
> 
> V9:
> 1. Rebased to arm64-upstream-14543 of arm64/master.
> 2. Match strict MM type in arch_apei_get_mem_attribute().

I guess this is all going via Matt's tree? I'm happy to take the new
memory type in arch/arm64/ if there's nothing currently queued, but I
suspect it makes more sense for it to stay together.

Will
