From: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [RESEND PATCH v4 2/2] arm64: Add software workaround for Falkor
 erratum 1041
Date: Mon, 11 Dec 2017 16:26:04 -0600
Message-ID: <39cc5f8d-be16-c437-28f8-1bc8601757af@codeaurora.org>
References: <1512957823-18064-1-git-send-email-shankerd@codeaurora.org>
 <1512957823-18064-2-git-send-email-shankerd@codeaurora.org>
 <20171211104558.pm3lijsdfg2xhj7h@lakrids.cambridge.arm.com>
Reply-To: shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171211104558.pm3lijsdfg2xhj7h-agMKViyK24J5pKCnmE3YQBJ8xKzm50AiAL8bYrjMMd8@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Thanks Mark, I'll post v5 patch without alternatives. 


On 12/11/2017 04:45 AM, Mark Rutland wrote:
> Hi,
> 
> On Sun, Dec 10, 2017 at 08:03:43PM -0600, Shanker Donthineni wrote:
>> +/**
>> + * Errata workaround prior to disable MMU. Insert an ISB immediately prior
>> + * to executing the MSR that will change SCTLR_ELn[M] from a value of 1 to 0.
>> + */
>> +	.macro pre_disable_mmu_workaround
>> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_E1041
>> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1041
>> +	isb
>> +alternative_else_nop_endif
>> +#endif
>> +	.endm
> 
> There's really no need for this to be an alternative. It makes the
> kernel larger and more complex due to all the altinstr data and probing
> code.
> 
> As Will suggested last time [1], please just use the ifdef, and always
> compile-in the extra ISB if CONFIG_QCOM_FALKOR_ERRATUM_E1041 is
> selected. Get rid of the alternatives and probing code.
> 
> All you need here is:
> 
> 	/*
> 	 * Some Falkor parts make errant speculative instruction fetches
> 	 * when SCTLR_ELx.M is cleared. An ISB before the write to
> 	 * SCTLR_ELx prevents this.
> 	 */
> 	.macro pre_disable_mmu_workaround
> #ifdef
> 	isb
> #endif
> 	.endm
> 
>> +
>> +	.macro pre_disable_mmu_early_workaround
>> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_E1041
>> +	isb
>> +#endif
>> +	.endm
>> +
> 
> ... and we don't need a special early variant.
> 
> Thanks,
> Mark.
> 
> [1] https://lkml.kernel.org/r/20171201112457.GE18083-5wv7dgnIgG8@public.gmane.org
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
