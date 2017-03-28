From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V13 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 28 Mar 2017 10:44:48 -0600
Message-ID: <35db9a6e-7ae3-3326-db1c-5cfff9ea27f3@codeaurora.org>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
 <5c7f6092-9358-08ac-5341-2364637c2008@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <5c7f6092-9358-08ac-5341-2364637c2008@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Poulose@arm.com, punit.agrawal@arm
List-Id: linux-efi@vger.kernel.org

Hello,


On 3/28/2017 3:53 AM, gengdongjiu wrote:
> Hi,
>
> On 2017/3/22 6:47, Tyler Baicar wrote:
>> +	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>> +
>> +	/* The host kernel will handle the synchronous external abort. There
>> +	 * is no need to pass the error into the guest.
>> +	 */
>> +	if (is_abort_synchronous(fault_status))
>> +		sea_status = handle_guest_sea((unsigned long)fault_ipa,
>> +				    kvm_vcpu_get_hsr(vcpu));
>>   
>>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>> -	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
>> +	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
>>   		kvm_inject_vabt(vcpu);
>>   		return 1;
>>   	}
>         After the host kernel correctly handle the synchronous external abort, the sea_status
>         will return 0, so the code logical will be continue go-no, whether it is better directly return
>         after correctly handle the SEA? such as below.
>
> 	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
>    		kvm_inject_vabt(vcpu);
>    		return 1;
>    	} else
>                  return 1;
Yes, I will return after successful SEA handling in the next patch set.

Thanks,
Tyler
>
>>   
>> -	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>> -
>>   	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
>>   			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
>>   
>> -	/* Check the stage-2 fault is trans. fault or write fault */
>> -	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>>   	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
