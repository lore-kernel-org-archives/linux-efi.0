From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Thu, 12 May 2016 00:24:44 +0100
Message-ID: <20160511232444.GY2839@codeblueprint.co.uk>
References: <1462523526-3172-1-git-send-email-zhaoshenglong@huawei.com>
 <20160511122730.GU2839@codeblueprint.co.uk>
 <57333533.2030206@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57333533.2030206@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, sstabellini@kernel.org, stefano@aporeto.com, julien.grall@arm.com, ard.biesheuvel@linaro.org, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

On Wed, 11 May, at 09:35:47PM, Shannon Zhao wrote:
> > 
> > Also, why do you need to setup efi.runtime_version here? Isn't that
> > done inside uefi_init()?
> > 
> I don't see any codes which setup efi.runtime_version in uefi_init().
 
Look in the EFI tree,

  https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/tree/drivers/firmware/efi/arm-init.c?h=next#n120

> > Here is how I would have expected this patch to look:
> > 
> >   - Add FDT code to find hypervisor EFI params
> > 
> >   - Force enable EFI_RUNTIME_SERVICES for Xen and call
> >     xen_efi_runtime_setup() inside xen_guest_init()
> > 
> >   - Change arm_enable_runtime_services() to handle the case where
> >     EFI_RUNTIME_SERVICES is already set
> > 
> > Am I misunderstanding some ordering issues?
> 
> Since xen_guest_init() and arm_enable_runtime_services() are both
> early_initcall and the calling order is random I think.

Urgh, right, I missed that.

> And when we call xen_efi_runtime_setup() and setup
> efi.runtime_version in xen_guest_init(), the efi.systab might be
> NULL. So it needs to map the systanle explicitly before we use
> efi.systab.

Could you explain why you need to copy efi.runtime_version instead of
letting the existing code in uefi_init() set it up?

Also, efi.systab isn't used by xen_efi_runtime_setup() as far I can
see, not sure why you need that either?
