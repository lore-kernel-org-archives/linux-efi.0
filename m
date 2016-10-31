From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V4 10/10] arm64: KVM: add guest SEA support
Date: Mon, 31 Oct 2016 16:36:33 -0600
Message-ID: <85443ee1-9981-c7e8-fe88-a3aac48c3e80@codeaurora.org>
References: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
 <1477071013-29563-11-git-send-email-tbaicar@codeaurora.org>
 <20161031100206.GX1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161031100206.GX1041@n2100.armlinux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.comha
List-Id: linux-efi@vger.kernel.org

Hello Russell,

On 10/31/2016 4:02 AM, Russell King - ARM Linux wrote:
> The subject line on this patch is misleading - it's not only ARM64
> specific...
Thank you for the feedback!

I only put ARM64 in the subject line because this patch only really adds 
guest SEA support for the ARM64 KVM code. The ARM code had to be edited 
since both the ARM and ARM64 KVM code use arch/arm/kvm/mmu.c. I can 
change the subject line to "arm/arm64: KVM: add guest SEA support" if 
you think that is better.
> On Fri, Oct 21, 2016 at 11:30:13AM -0600, Tyler Baicar wrote:
>> diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
>> index a3d61ad..86e1faa 100644
>> --- a/arch/arm/include/asm/system_misc.h
>> +++ b/arch/arm/include/asm/system_misc.h
>> @@ -24,4 +24,9 @@ extern unsigned int user_debug;
>>   
>>   #endif /* !__ASSEMBLY__ */
>>   
>> +inline int handle_guest_sea(unsigned long addr, unsigned int esr)
> This needs to be static.
I'll make this static.

Thanks,
Tyler
>> +{
>> +	return -1;
>> +}
>> +
>>   #endif /* __ASM_ARM_SYSTEM_MISC_H */

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
