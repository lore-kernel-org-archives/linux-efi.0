From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 28 Feb 2017 13:21:05 +0000
Message-ID: <58B57941.3000703@arm.com>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
 <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org>
 <df6ba5dc-d93f-925a-46bf-1e1e209d17f3@huawei.com> <58B43092.6040401@arm.com>
 <3df82a7b-1a32-e2d7-ae78-7132a4eab1a0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <3df82a7b-1a32-e2d7-ae78-7132a4eab1a0@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Tyler Baicar <tbaicar@codeaurora.org>, will.deacon@arm.com, linux@armlinux.org.uk, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, robert.moore@intel.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi,

On 28/02/17 06:25, Xiongfeng Wang wrote:
> On 2017/2/27 21:58, James Morse wrote:
>> On 25/02/17 07:15, Xiongfeng Wang wrote:
>>> Can we inject an sea into the guest, so that the guest can kill the
>>> application which causes the error if the guest won't be terminated
>>> later. I'm not sure whether ghes_handle_memory_failure() called in
>>> ghes_do_proc() will kill the qemu process. I think it only kill user
>>> processes marked with PF_MCE_PROCESS & PF_MCE_EARLY.
>>
>> My understanding is the pages will get unmapped and recovered where possible
>> (e.g. re-read from disk), the user space process will get SIGBUS/SIGSEV when it
>> next tries to access that page, which could be some time later.
>> These flags in find_early_kill_thread() are a way to make the memory-failure
>> code signal the process early, before it does any recovery. The 'MCE' makes me
>> think its x86 specific.
>> (early and late are described more in [0])
>>
>>
>> Guests are a special case as QEMU may never access the faulty memory itself, so
>> it won't receive the 'late' signal. It looks like ARM/arm64 KVM lacks support
>> for KVM_PFN_ERR_HWPOISON which sends SIGBUS from KVM's fault-handling code. I
>> have patches to add support for this which I intend to send at rc1.
>>
>> [0] suggests 'KVM qemu' sets these MCE flags to take the 'early' path, but given
>> x86s KVM_PFN_ERR_HWPOISON, this may be out of date.
>>
>>
>> Either way, once QEMU gets a signal indicating the virtual address, it can
>> generate its own APEI CPER records and use the KVM APIs to mock up an
>> Synchronous External Abort, (or inject an IRQ or run the vcpu waiting for the
>> guest's polling thread to come round, whichever was described to the guest via
>> the HEST/GHES tables).
>>
>> We can't hand the APEI CPER records we have in the kernel to the guest, as they
>> hold a host physical address, and maybe a host virtual address. We don't know
>> where in guest memory we could write new APEI CPER records as these locations
>> have to be reserved in the guests-UEFI memory map, and only QEMU knows where
>> they are.
>>
>> To deliver RAS events to a guest we have to get QEMU involved.

> I have another idea about the handling procedure of SEA. Can we divide
> the SEA handing procedure into two procedures? The first procedure does
> the more urgent work, including sending SIGBUS to user process or panic,
> just as PATCH 04/10 does.

How do we know which user processes to signal? (There may be more than one - we
need a memory address to find them).
How do we know if this error is serious and we should panic?
This information is in the APEI CPER records.


> The second procedure does the APEI analysis
> work, including calling memory_failure. The second procedure is executed
> when actual errors detected in memory, such as a 2-bit ECC error is
> detected  on memory read or write, in which case, a fault handling
> interrupt is generated by the memory controller, as RAS Extension
> specification says.

You are splitting the APEI notification and the processing of records. One has
to happen immediately after the other because we want to contain the error.


> We can route this fault handling interrupt into EL3. After BIOS has
> filled the HEST table, it can notify OS with an IRQ. And the second
> procedure is executed in the IRQ handler. The notification type of
> HEST/GHES tables is GSIV.
> 
> When uncorrectable data error is detected on write data, a fault
> handling interrupt is generated, and no SEA is generated,

This sounds more like ACPI's firmware first error handling. Yes errors should be
routed to EL3 where firmware can do some platform-specific work, then describe
them to the host OS via CPER records.
By doing this, you could prevent a hardware-generated External Abort reaching
the host OS, but you still need to notify the OS via one of the mechanisms in
'18.3.2.9 Hardware Error Notification'.

If the error is synchronous (we read a bad page of memory instead of it being
detected on background DRAM scrub) we need to notify the OS synchronously. Using
SEA would be a firmware-generated External Abort delivered to EL2/EL1.

However the notification is done it needs to match one of the GHES records in
the HEST, so firmware has to decide which notification methods it will use
before we boot the OS.


> In ARM/arm64 KVM situation, when an SEA takes place, an SEA is injected
> into guest os directly in kvm_handle_guest_abort(). And the guest os can
> execute the first procedure.

What can the guest do with this? Without the APEI CPER records it doesn't know
what happened. Was it unrecoverable memory corruption? In which case killing the
running task is a start... Which memory ranges should we mark as unusable? Maybe
it was something more catastrophic for the running CPU, in which case we should
panic().


> When the host OS executes the second procedure and analyses the HEST
> table, it sends SIGBUS to qemu process in memory_failure(). And the qemu
> process can mock up a HEST table with IPA of the error data. Then the
> qemu process can notify the guest OS with an IRQ, and the second
> procedure is executed in guest OS. Is this idea reasonable?

So we tell the guest something happened, and it should wait a while to find out
what... I don't think this will work. It is best to not run the guest until Qemu
has done its work and called VCPU_RUN again. This way we only notify the guest
once the records are available for processing. This is how APEI's firmware-first
works between the host OS and EL3, it should be the same between a guest and
QEMU (which plays the part of firmware for the guest).


Can you share more details of the problem you are trying to solve? I don't think
we can get RAS support in a guest 'for free', somewhere along the line we need
support from Qemu.


Thanks,

James
