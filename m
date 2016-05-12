From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Thu, 12 May 2016 10:22:07 +0800
Message-ID: <5733E8CF.3070004@huawei.com>
References: <1462523526-3172-1-git-send-email-zhaoshenglong@huawei.com> <20160511122730.GU2839@codeblueprint.co.uk> <57333533.2030206@linaro.org> <20160511232444.GY2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160511232444.GY2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, stefano-yd54mjeZNzVBDgjK7y7TUQ@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/5/12 7:24, Matt Fleming wrote:
> On Wed, 11 May, at 09:35:47PM, Shannon Zhao wrote:
>>> > > 
>>> > > Also, why do you need to setup efi.runtime_version here? Isn't that
>>> > > done inside uefi_init()?
>>> > > 
>> > I don't see any codes which setup efi.runtime_version in uefi_init().
>  
> Look in the EFI tree,
> 
>   https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/tree/drivers/firmware/efi/arm-init.c?h=next#n120
> 
Ah, there are some patches in EFI tree introducing this change, but they
are not in kernel matser but I didn't notice this, sorry.

>>> > > Here is how I would have expected this patch to look:
>>> > > 
>>> > >   - Add FDT code to find hypervisor EFI params
>>> > > 
>>> > >   - Force enable EFI_RUNTIME_SERVICES for Xen and call
>>> > >     xen_efi_runtime_setup() inside xen_guest_init()
>>> > > 
>>> > >   - Change arm_enable_runtime_services() to handle the case where
>>> > >     EFI_RUNTIME_SERVICES is already set
>>> > > 
>>> > > Am I misunderstanding some ordering issues?
>> > 
>> > Since xen_guest_init() and arm_enable_runtime_services() are both
>> > early_initcall and the calling order is random I think.
> Urgh, right, I missed that.
> 
>> > And when we call xen_efi_runtime_setup() and setup
>> > efi.runtime_version in xen_guest_init(), the efi.systab might be
>> > NULL. So it needs to map the systanle explicitly before we use
>> > efi.systab.
> Could you explain why you need to copy efi.runtime_version instead of
> letting the existing code in uefi_init() set it up?
> 
> Also, efi.systab isn't used by xen_efi_runtime_setup() as far I can
> see, not sure why you need that either?
As said above, I will rebase this patch on top of the EFI next branch.

Thanks,
-- 
Shannon
