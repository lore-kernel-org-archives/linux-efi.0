From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V5 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Mon, 28 May 2018 19:21:01 -0700
Message-ID: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Problem statement:
------------------
Presently, efi_runtime_services() silently switch %cr3 from swapper_pgd
to efi_pgd. As a consequence, kernel code that runs in efi_pgd (e.g.,
perf code via an NMI) will have incorrect user space mappings[1]. This
could lead to otherwise unexpected access errors and, worse, unauthorized
access to firmware code and data.

Detailed discussion of problem statement:
-----------------------------------------
As this switch is not propagated to other kernel subsystems; they will
wrongly assume that swapper_pgd is still in use and it can lead to
following issues:

1. If kernel code tries to access user space addresses while in efi_pgd,
it could lead to unauthorized accesses to firmware code/data.
(e.g: <__>/copy_from_user_nmi()).
[This could also be disastrous if the frame pointer happens to point at
MMIO in the EFI runtime mappings] - Mark Rutland.

An example of a subsystem that could touch user space while in efi_pgd is
perf. Assume that we are in efi_pgd, a user could use perf to profile
some user data and depending on the address the user is trying to
profile, two things could happen.
1. If the mappings are absent, perf fails to profile.
2. If efi_pgd does have mappings for the requested address (these
  mappings are erroneous), perf profiles firmware code/data. If the
  address is MMIO'ed, perf could have potentially changed some device state.

The culprit in both the cases is, EFI subsystem swapping out pgd and not
perf. Because, EFI subsystem has broken the *general assumption* that
all other subsystems rely on - "user space might be valid and nobody has
switched %cr3".

Solutions:
----------
There are two ways to fix this issue:
1. Educate about pgd change to *all* the subsystems that could
   potentially access user space while in efi_pgd.
  On x86, AFAIK, it could happen only when some one touches user space
  from the back of an NMI (a quick audit on <__>/copy_from_user_nmi,
  showed perf and oprofile). On arm, it could happen from multiple
  places as arm runs efi_runtime_services() interrupts enabled (ARM folks,
  please comment on this as I might be wrong); whereas x86 runs
  efi_runtime_services() interrupts disabled.

  I think, this solution isn't holistic because
  a. Any other subsystem might well do the same, if not now, in future.
  b. Also, this solution looks simpler on x86 but not true if it's the
    same for arm (ARM folks, please comment on this as I might be wrong).
  c. This solution looks like a work around rather than addressing the issue.

2. Running efi_runtime_services() in kthread context.
  This makes sense because efi_pgd doesn't have user space and kthread
  by definition means that user space is not valid. Any kernel code that
  tries to touch user space while in kthread is buggy in itself. If so,
  it should be an easy fix in the other subsystem. This also take us one
  step closer to long awaiting proposal of Andy - Running EFI at CPL 3.

What does this patch set do?
----------------------------
Introduce efi_rts_wq (EFI runtime services work queue).
When a user process requests the kernel to execute any efi_runtime_service(),
kernel queues the work to efi_rts_wq, a kthread comes along, switches to
efi_pgd and executes efi_runtime_service() in kthread context. IOW, this
patch set adds support to the EFI subsystem to handle all calls to
efi_runtime_services() using a work queue (which in turn uses kthread).

How running efi_runtime_services() in kthread fixes above discussed issues?
---------------------------------------------------------------------------
If we run efi_runtime_services() in kthread context and if perf
checks for it, we could get both the above scenarios correct by perf
aborting the profiling. Not only perf, but any subsystem that tries to
touch user space should first check for kthread context and if so,
should abort.

Q. If we still need check for kthread context in other subsystems that
access user space, what does this patch set fix?
A. This patch set makes sure that EFI subsystem is not at fault.
Without this patch set the blame is upon EFI subsystem, because it's the
one that changed pgd and hasn't communicated this change to everyone and
hence broke the general assumption. Running efi_runtime_services() in
kthread means explicitly communicating that user space is invalid, now 
it's the responsibility of other subsystem to make sure that it's
running in right context.

Testing:
--------
Tested using LUV (Linux UEFI Validation) for x86_64, x86_32 and arm64
(qemu only). Will appreciate the effort if someone could test the
patches on real ARM/ARM64 machines.
LUV: https://01.org/linux-uefi-validation

Credits:
--------
Thanks to Ricardo, Dan, Miguel, Mark, Peter Z and Ard for reviews and
suggestions. Thanks to Boris and Andy for making me think through/help
on what I am addressing with this patch set.

Please feel free to pour in your comments and concerns.

Note:
-----
Patches are based on Linus's kernel v4.17-rc7

[1] Backup: Detailing efi_pgd:
------------------------------
efi_pgd has mappings for EFI Runtime Code/Data (on x86, plus EFI Boot time
Code/Data) regions. Due to the nature of these mappings, they fall
in user space address ranges and they are not the same as swapper.

[On arm64, the EFI mappings are in the VA range usually used for user
space. The two halves of the address space are managed by separate
tables, TTBR0 and TTBR1. We always map the kernel in TTBR1, and we map
user space or EFI runtime mappings in TTBR0.] - Mark Rutland

Changes from V4 to V5:
----------------------
1. As suggested by Ard, don't use efi_rts_wq for non-blocking variants.
  Non-blocking variants are supposed to not block and using workqueue
  exactly does the opposite, hence refrain from using it.
2. Use non-blocking variants in efi_delete_dummy_variable(). Use of
  blocking variants means that we have to call efi_delete_dummy_variable()
  after efi_rts_wq has been created.
3. Remove in_atomic() check in set_variable<>() and query_variable_info<>().
  Any caller wishing to use set_variable() and query_variable_info() in
  atomic context should use their non-blocking variants.

Changes from V3 to V4:
----------------------
1. As suggested by Peter, use completions instead of flush_work() as the
  former is cheaper
2. Call efi_delete_dummy_variable() from efisubsys_init(). Sorry! Ard,
  wasn't able to find a better alternative to keep this change local to
  arch/x86.

Changes from V2 to V3:
----------------------
1. Rewrite the cover letter to clearly state the problem. What we are
  fixing and what we are not fixing.
2. Make efi_delete_dummy_variable() change local to x86.
3. Avoid using BUG(), instead, print error message and exit gracefully.
4. Move struct efi_runtime_work to runtime-wrappers.c file.
5. Give enum a name (efi_rts_ids) and use it in efi_runtime_work.
6. Add Naresh (maintainer of LUV for ARM) and Miguel to the CC list.

Changes from V1 to V2:
----------------------
1. Remove unnecessary include of asm/efi.h file - Fixes build error on
  ia64, reported by 0-day
2. Use enum to identify efi_runtime_services()
3. Use alloc_ordered_workqueue() to create efi_rts_wq as
  create_workqueue() is scheduled for depreciation.
4. Make efi_call_rts() static, as it has no callers outside
  runtime-wrappers.c
5. Use BUG(), when we are unable to queue work or unable to identify
  requested efi_runtime_service() - Because these two situations should
  *never* happen.

Sai Praneeth (3):
  x86/efi: Make efi_delete_dummy_variable() use    
    set_variable_nonblocking() instead of set_variable()
  efi: Create efi_rts_wq and efi_queue_work() to invoke all    
    efi_runtime_services()
  efi: Use efi_rts_wq to invoke EFI Runtime Services

 arch/x86/platform/efi/quirks.c          |  11 +-
 drivers/firmware/efi/efi.c              |  14 ++
 drivers/firmware/efi/runtime-wrappers.c | 218 +++++++++++++++++++++++++++++---
 include/linux/efi.h                     |   3 +
 4 files changed, 224 insertions(+), 22 deletions(-)

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Naresh Bhat <naresh.bhat@linaro.org>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

-- 
2.7.4
