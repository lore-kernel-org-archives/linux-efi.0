From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 2/4] efi/arm: defer persistent reservations until after
 paging_init()
Date: Wed, 7 Nov 2018 09:58:27 +0000
Message-ID: <20181107095827.GR30658@n2100.armlinux.org.uk>
References: <20181106113732.16351-1-ard.biesheuvel@linaro.org>
 <20181106113732.16351-3-ard.biesheuvel@linaro.org>
 <CAKv+Gu8OsFb7a5UTovN1yBXtSSY=ZtUBYUvNa_bPmcZGknNYQA@mail.gmail.com>
 <20181106190817.GN30658@n2100.armlinux.org.uk>
 <CAKv+Gu_r38Bk_SZW-5qvtM7cmQ4-09dcFwNz29AyMceucdhadQ@mail.gmail.com>
 <20181106234933.GO30658@n2100.armlinux.org.uk>
 <c0995c05-3e2c-844e-d531-a687b296753a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <c0995c05-3e2c-844e-d531-a687b296753a@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Bhupesh Sharma <bhsharma@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 07, 2018 at 09:51:09AM +0000, Marc Zyngier wrote:
> On 06/11/18 23:49, Russell King - ARM Linux wrote:
> > On Tue, Nov 06, 2018 at 09:06:56PM +0100, Ard Biesheuvel wrote:
> >> On 6 November 2018 at 20:08, Russell King - ARM Linux
> >> <linux@armlinux.org.uk> wrote:
> >>> On Tue, Nov 06, 2018 at 08:02:58PM +0100, Ard Biesheuvel wrote:
> >>>> On 6 November 2018 at 12:37, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >>>>> The new memory EFI reservation feature we introduced to allow memory
> >>>>> reservations to persist across kexec may trigger an unbounded number
> >>>>> of calls to memblock_reserve(). The memblock subsystem can deal with
> >>>>> this fine, but not before memblock resizing is enabled, which we can
> >>>>> only do after paging_init(), when the memory we reallocate the array
> >>>>> into is actually mapped.
> >>>>>
> >>>>> So break out the memreserve table processing into a separate function
> >>>>> and call if after paging_init() on both arm64 and ARM.
> >>>>>
> >>>>> Cc: Russell King <linux@armlinux.org.uk>
> >>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>>>
> >>>> Russell,
> >>>>
> >>>> If you are ok with this patch, may I have your ack please? I would
> >>>> like to send it out before the end of the week.
> >>>
> >>> You're not going to get a quick answer to this, because it needs me to
> >>> investigate what the effect of this change actually is by code review.
> >>> I can't guarantee when I'll get around to that.
> >>>
> >>
> >> Fair enough.
> >>
> >> I will drop the ARM hunk for now then, and we'll fix ARM when you have
> >> more time.
> > 
> > I don't see how you can do that - you're dropping the processing of
> > reserved areas out of the efi_config_parse_tables() path, so that
> > won't happen any more on ARM if you don't apply the ARM hunk.
> 
> The only reason for the whole persistent region thing is to support 
> GICv3 redistributors memory tables across kexec, for those GIC 
> implementations where LPIs cannot be disabled once they have been 
> enabled.
> 
> There is no HW platform that combines 32bit cores and GICv3 (not to 
> mention using EFI). The only existing "platform" is KVM/arm64, which 
> doesn't suffer from the above problem (LPIs can be freely disabled in 
> emulation). So the whole persistent region feature serves no purpose on 
> 32bit ARM.
> 
> The only issue with dropping this hunk is that the memory reservation 
> feature is enabled on 32bit ARM the first place, which can easily be 
> dealt with something along those lines:

So, it was a waste of my time trying to understand what's going on here
with Ard's patch because it shouldn't be present on 32-bit ARM... Grr.

> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 787d7850e064..8bb263c9b99a 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1290,6 +1290,7 @@ config EFI
>  	select EFI_RUNTIME_WRAPPERS
>  	select EFI_STUB
>  	select EFI_ARMSTUB
> +	select EFI_PERSISTENT_RESERVATIONS
>  	default y
>  	help
>  	  This option provides support for runtime services provided
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 89110dfc7127..b728dab9e901 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -198,3 +198,6 @@ config EFI_DEV_PATH_PARSER
>  	bool
>  	depends on ACPI
>  	default n
> +
> +config EFI_PERSISTENT_RESERVATIONS
> +       bool
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 249eb70691b0..2a1903ab6d21 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -962,6 +962,7 @@ bool efi_is_table_address(unsigned long phys_addr)
>  	return false;
>  }
>  
> +#ifdef CONFIG_EFI_PERSISTENT_RESERVATIONS
>  static DEFINE_SPINLOCK(efi_mem_reserve_persistent_lock);
>  
>  int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
> @@ -993,6 +994,12 @@ int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
>  
>  	return 0;
>  }
> +#else
> +int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
> +{
> +	return 0;
> +}
> +#endif
>  
>  #ifdef CONFIG_KEXEC
>  static int update_efi_random_seed(struct notifier_block *nb,
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
