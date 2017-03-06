From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Mon, 6 Mar 2017 11:38:46 +0800
Message-ID: <8d020d81-d697-f05e-dbce-3a5a02c7c7db@huawei.com>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
 <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org>
 <df6ba5dc-d93f-925a-46bf-1e1e209d17f3@huawei.com> <58B43092.6040401@arm.com>
 <3df82a7b-1a32-e2d7-ae78-7132a4eab1a0@huawei.com> <58B57941.3000703@arm.com>
 <4ff98823-d6f0-eb2e-4b98-f6d5e255f6c3@huawei.com>
 <6d0fa5a5-bcbf-38b8-45ac-d645220ee9e2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <6d0fa5a5-bcbf-38b8-45ac-d645220ee9e2@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Tyler Baicar <tbaicar@codeaurora.org>, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, punit.agrawal@arm.com, john.garry@huawei.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi Marc,

On 2017/3/2 17:39, Marc Zyngier wrote:
> On 01/03/17 02:31, Xiongfeng Wang wrote:
> 
> [lot of things]
> 
>> If an SEA is injected into guest OS, the guest OS will jump to the SEA
>> exception entry when the context switched to guest OS. And the CPSR and
>> FAR_EL1 are recovered according to the content of vcpu. Then the guest
>> OS can signal a process or panic. If another guest process read the
>> error data, another SEA will be generated and it will be single too.
>>
>> Without QEMU involved, the drawback is that no APEI table can be mocked
>> up in guest OS, and no memory_failure() will be called. So the memory of
>> error data will be released into buddy system and assigned to another
>> process. If the error was caused by instantaneous radiation or
>> electromagnetic, the memory is usable again if it is written with a
>> correct data. If the memory has wore out and a correct data is written,
>> the ECC error may occurs again with high possibility. Before a 2-bit ECC
>> error is reported, much more 1-bit errors will be reported. This is
>> report to host os, the host os can determine the memory node has worn
>> out and hot-plug out the memory node, and guest os may be terminated if
>> its memory data can't be migrated.
>>
>> Of course, it is better to get QEMU involved, so the memory_failure can
>> be executed in guest OS. But before that implemented, can we add SEA
>> injection in kvm_handle_guest_abort()?
> 
> No. I will strongly object to that. This is a platform decision to
> forward SEAs, not an architectural one. The core KVM code is only
> concerned about implementing the ARM architecture, and not something
> that is firmware dependent.
> 
Thanks for the reply!
I'm not sure if there exists some misunderstanding here. I was saying
that APEI stuff is not included in the core KVM code, but SEA injection
can be included, just like the SEI injection in the core KVM code. Yes,
APEI is firmware dependent, but I think SEA is not. And the processing
for SEA doesn't depend on whether APEI is implemented.


Thanks,

Wang Xiongfeng
.
