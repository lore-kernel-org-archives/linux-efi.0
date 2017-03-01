From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Wed, 1 Mar 2017 10:31:41 +0800
Message-ID: <4ff98823-d6f0-eb2e-4b98-f6d5e255f6c3@huawei.com>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
 <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org>
 <df6ba5dc-d93f-925a-46bf-1e1e209d17f3@huawei.com> <58B43092.6040401@arm.com>
 <3df82a7b-1a32-e2d7-ae78-7132a4eab1a0@huawei.com> <58B57941.3000703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <58B57941.3000703@arm.com>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Tyler Baicar <tbaicar@codeaurora.org>, will.deacon@arm.com, linux@armlinux.org.uk, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, robert.moore@intel.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi James,

On 2017/2/28 21:21, James Morse wrote:
> Hi,
> 
> On 28/02/17 06:25, Xiongfeng Wang wrote:
>> On 2017/2/27 21:58, James Morse wrote:
>>> On 25/02/17 07:15, Xiongfeng Wang wrote:
>>>> Can we inject an sea into the guest, so that the guest can kill the
>>>> application which causes the error if the guest won't be terminated
>>>> later. I'm not sure whether ghes_handle_memory_failure() called in
>>>> ghes_do_proc() will kill the qemu process. I think it only kill user
>>>> processes marked with PF_MCE_PROCESS & PF_MCE_EARLY.
>>>
>>> My understanding is the pages will get unmapped and recovered where possible
>>> (e.g. re-read from disk), the user space process will get SIGBUS/SIGSEV when it
>>> next tries to access that page, which could be some time later.
>>> These flags in find_early_kill_thread() are a way to make the memory-failure
>>> code signal the process early, before it does any recovery. The 'MCE' makes me
>>> think its x86 specific.
>>> (early and late are described more in [0])
>>>
>>>
>>> Guests are a special case as QEMU may never access the faulty memory itself, so
>>> it won't receive the 'late' signal. It looks like ARM/arm64 KVM lacks support
>>> for KVM_PFN_ERR_HWPOISON which sends SIGBUS from KVM's fault-handling code. I
>>> have patches to add support for this which I intend to send at rc1.
>>>
>>> [0] suggests 'KVM qemu' sets these MCE flags to take the 'early' path, but given
>>> x86s KVM_PFN_ERR_HWPOISON, this may be out of date.
>>>
>>>
>>> Either way, once QEMU gets a signal indicating the virtual address, it can
>>> generate its own APEI CPER records and use the KVM APIs to mock up an
>>> Synchronous External Abort, (or inject an IRQ or run the vcpu waiting for the
>>> guest's polling thread to come round, whichever was described to the guest via
>>> the HEST/GHES tables).
>>>
>>> We can't hand the APEI CPER records we have in the kernel to the guest, as they
>>> hold a host physical address, and maybe a host virtual address. We don't know
>>> where in guest memory we could write new APEI CPER records as these locations
>>> have to be reserved in the guests-UEFI memory map, and only QEMU knows where
>>> they are.
>>>
>>> To deliver RAS events to a guest we have to get QEMU involved.
> 
>> I have another idea about the handling procedure of SEA. Can we divide
>> the SEA handing procedure into two procedures? The first procedure does
>> the more urgent work, including sending SIGBUS to user process or panic,
>> just as PATCH 04/10 does.
> 
> How do we know which user processes to signal? (There may be more than one - we
> need a memory address to find them).
> How do we know if this error is serious and we should panic?
> This information is in the APEI CPER records.
> 
Since the SEA exception is synchronous, the current user process is the
one to be signaled if the exception is taken from EL0. Certainly, the
error memory may be mapped to several processes. When another process
read that area again, another SEA will be generated, and that process
will be signaled. Also we can get the virtual address of the error data
from FAR_EL1. When the user process is signaled, virtual address is
attached, and the process can register its own signal handler if it can
handle the error according to the virtual address of the error data.

We can determine where the exception is taken from according to CPSR
stored in the stack. And if the exception is taken from EL1, the error
is in the kernel space now, and we are going to consume it, so we need
to panic now.
> 
>> The second procedure does the APEI analysis
>> work, including calling memory_failure. The second procedure is executed
>> when actual errors detected in memory, such as a 2-bit ECC error is
>> detected  on memory read or write, in which case, a fault handling
>> interrupt is generated by the memory controller, as RAS Extension
>> specification says.
> 
> You are splitting the APEI notification and the processing of records. One has
> to happen immediately after the other because we want to contain the error.
> 
My understanding is that processing of records is not so urgent since
the process access the error data has been killed (The first procedure
is executed in SEA exception handler). Other codes won't access the
error data, so the error won't be consumed and propagated.
> 
>> We can route this fault handling interrupt into EL3. After BIOS has
>> filled the HEST table, it can notify OS with an IRQ. And the second
>> procedure is executed in the IRQ handler. The notification type of
>> HEST/GHES tables is GSIV.
>>
>> When uncorrectable data error is detected on write data, a fault
>> handling interrupt is generated, and no SEA is generated,
> 
> This sounds more like ACPI's firmware first error handling. Yes errors should be
> routed to EL3 where firmware can do some platform-specific work, then describe
> them to the host OS via CPER records.

Yes , I'm saying the ACPI's firmware first error handling.

> By doing this, you could prevent a hardware-generated External Abort reaching
> the host OS, but you still need to notify the OS via one of the mechanisms in
> '18.3.2.9 Hardware Error Notification'.

Yes, the BIOS will notify OS with GSIV notify type, which will rely on
Shiju's patch 'acpi: apei: handle GSIV notification type'

> 
> If the error is synchronous (we read a bad page of memory instead of it being
> detected on background DRAM scrub) we need to notify the OS synchronously. Using
> SEA would be a firmware-generated External Abort delivered to EL2/EL1.

Yes, the first procedure is executed in SEA exception handler and is
synchronous. The second procedure won't access the error data and is not
so urgent, so it may not need to be synchronous.
> 
> However the notification is done it needs to match one of the GHES records in
> the HEST, so firmware has to decide which notification methods it will use
> before we boot the OS.
> 
> 
>> In ARM/arm64 KVM situation, when an SEA takes place, an SEA is injected
>> into guest os directly in kvm_handle_guest_abort(). And the guest os can
>> execute the first procedure.
> 
> What can the guest do with this? Without the APEI CPER records it doesn't know
> what happened. Was it unrecoverable memory corruption? In which case killing the
> running task is a start... Which memory ranges should we mark as unusable? Maybe
> it was something more catastrophic for the running CPU, in which case we should
> panic().
> 
If an SEA is injected into guest OS, the guest OS will jump to the SEA
exception entry when the context switched to guest OS. And the CPSR and
FAR_EL1 are recovered according to the content of vcpu. Then the guest
OS can signal a process or panic. If another guest process read the
error data, another SEA will be generated and it will be single too.

Without QEMU involved, the drawback is that no APEI table can be mocked
up in guest OS, and no memory_failure() will be called. So the memory of
error data will be released into buddy system and assigned to another
process. If the error was caused by instantaneous radiation or
electromagnetic, the memory is usable again if it is written with a
correct data. If the memory has wore out and a correct data is written,
the ECC error may occurs again with high possibility. Before a 2-bit ECC
error is reported, much more 1-bit errors will be reported. This is
report to host os, the host os can determine the memory node has worn
out and hot-plug out the memory node, and guest os may be terminated if
its memory data can't be migrated.

Of course, it is better to get QEMU involved, so the memory_failure can
be executed in guest OS. But before that implemented, can we add SEA
injection in kvm_handle_guest_abort()?
> 
>> When the host OS executes the second procedure and analyses the HEST
>> table, it sends SIGBUS to qemu process in memory_failure(). And the qemu
>> process can mock up a HEST table with IPA of the error data. Then the
>> qemu process can notify the guest OS with an IRQ, and the second
>> procedure is executed in guest OS. Is this idea reasonable?
> 
> So we tell the guest something happened, and it should wait a while to find out
> what... I don't think this will work. It is best to not run the guest until Qemu
> has done its work and called VCPU_RUN again. This way we only notify the guest
> once the records are available for processing. This is how APEI's firmware-first
> works between the host OS and EL3, it should be the same between a guest and
> QEMU (which plays the part of firmware for the guest).
> 
> 
> Can you share more details of the problem you are trying to solve? I don't think
> we can get RAS support in a guest 'for free', somewhere along the line we need
> support from Qemu.
> 


Thanks,

Wang Xiongfeng

.
