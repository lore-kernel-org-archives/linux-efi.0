From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Mon, 6 Mar 2017 09:28:50 +0800
Message-ID: <CAMj-D2CepweZ4y38-U=XX3V8xsKs2vnxGz6RyRTtjA0CcitFAg@mail.gmail.com>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
 <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org>
 <df6ba5dc-d93f-925a-46bf-1e1e209d17f3@huawei.com> <58B43092.6040401@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <58B43092.6040401@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Tyler Baicar <tbaicar@codeaurora.org>, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, Xiongfeng Wang <wangxiongfeng2@huawei.com>, Fu Wei <fu.wei@linaro.org>, zjzhang@codeaurora.org, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, Len Brown <lenb@kernel.org>, harba@codeaurora.org, john.garry@huawei.com, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, rostedt@goodmis.org, nkaje@codeaurora.org, Sandeepa Prabhu <sandeepa.s.prabhu@gmail.com>, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, Hanjun Guo <hanj>
List-Id: linux-efi@vger.kernel.org

Hi James,


> Hi Wang Xiongfeng,
>
> On 25/02/17 07:15, Xiongfeng Wang wrote:
>> On 2017/2/22 5:22, Tyler Baicar wrote:
>>> Currently external aborts are unsupported by the guest abort
>>> handling. Add handling for SEAs so that the host kernel reports
>>> SEAs which occur in the guest kernel.
>
>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>> index a5265ed..04f1dd50 100644
>>> --- a/arch/arm/kvm/mmu.c
>>> +++ b/arch/arm/kvm/mmu.c
>>> @@ -1444,8 +1445,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>>
>>>      /* Check the stage-2 fault is trans. fault or write fault */
>>>      fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>>> -    if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>>> -        fault_status != FSC_ACCESS) {
>>> +
>>> +    /* The host kernel will handle the synchronous external abort. There
>>> +     * is no need to pass the error into the guest.
>>> +     */
>
>> Can we inject an sea into the guest, so that the guest can kill the
>> application which causes the error if the guest won't be terminated
>> later. I'm not sure whether ghes_handle_memory_failure() called in
>> ghes_do_proc() will kill the qemu process. I think it only kill user
>> processes marked with PF_MCE_PROCESS & PF_MCE_EARLY.
>
> My understanding is the pages will get unmapped and recovered where possible
> (e.g. re-read from disk), the user space process will get SIGBUS/SIGSEV when it
> next tries to access that page, which could be some time later.
> These flags in find_early_kill_thread() are a way to make the memory-failure
> code signal the process early, before it does any recovery. The 'MCE' makes me
> think its x86 specific.
> (early and late are described more in [0])
>
>
> Guests are a special case as QEMU may never access the faulty memory itself, so
> it won't receive the 'late' signal. It looks like ARM/arm64 KVM lacks support
> for KVM_PFN_ERR_HWPOISON which sends SIGBUS from KVM's fault-handling code. I
> have patches to add support for this which I intend to send at rc1.

could you push this patch to opensource?


>
> [0] suggests 'KVM qemu' sets these MCE flags to take the 'early' path, but given
> x86s KVM_PFN_ERR_HWPOISON, this may be out of date.
>
>
> Either way, once QEMU gets a signal indicating the virtual address, it can
> generate its own APEI CPER records and use the KVM APIs to mock up an
> Synchronous External Abort, (or inject an IRQ or run the vcpu waiting for the
> guest's polling thread to come round, whichever was described to the guest via
> the HEST/GHES tables).
>
> We can't hand the APEI CPER records we have in the kernel to the guest, as they
> hold a host physical address, and maybe a host virtual address. We don't know
> where in guest memory we could write new APEI CPER records as these locations
> have to be reserved in the guests-UEFI memory map, and only QEMU knows where
> they are.
>
> To deliver RAS events to a guest we have to get QEMU involved.
>
>
> Thanks,
>
> James
>
>
> [0] https://www.kernel.org/doc/Documentation/vm/hwpoison.txt
>
