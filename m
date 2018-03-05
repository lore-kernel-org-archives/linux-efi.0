From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 0/3] Use efi_rts_workqueue to invoke EFI Runtime Services
Date: Mon,  5 Mar 2018 15:23:07 -0800
Message-ID: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee@vger.kernel.org, Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

This patch set is an outcome of the discussion at
https://lkml.org/lkml/2017/8/21/607

Presently, efi_runtime_services() are executed by firmware in process
context. To execute efi_runtime_service(), kernel switches the page
directory from swapper_pgd to efi_pgd. However, efi_pgd doesn't have any
user space mappings. A potential issue could be, for instance, an NMI
interrupt (like perf) trying to profile some user data while in efi_pgd.

A solution for this issue could be to use kthread to run
efi_runtime_service(). When a user/kernel thread requests to execute
efi_runtime_service(), kernel off-loads this work to kthread which in
turn uses efi_pgd. Anything that tries to touch user space addresses
while in kthread is terminally broken. This patch set adds support to
the efi subsystem to handle all calls to efi_runtime_services() using a
work queue (which in turn uses kthread).

Implementation summary:
-----------------------
1. When a user/kernel thread requests to execute efi_runtime_service(),
enqueue work to a work queue, efi_rts_workqueue.
2. The caller thread waits until the work is finished because it's
dependent on the return status of efi_runtime_service() and, in specific
cases, the arguments populated by efi_runtime_service(). Some
efi_runtime_services() takes a pointer to buffer as an argument and
fills up the buffer with requested data. For instance, efi_get_variable()
and efi_get_next_variable(). Hence, the caller process cannot just post
the work and get going, it has to wait for results from firmware.

Caveat: efi_rts_workqueue to run efi_runtime_services() shouldn't be used
while in atomic, because caller thread might sleep. Presently, pstore
code doesn't use efi_rts_workqueue.

Tested using LUV (Linux UEFI Validation) for x86_64 and x86_32. Builds
fine for arm and arm64. Will appreciate the effort if someone could test
the patches on real ARM/ARM64 machines.
LUV: https://01.org/linux-uefi-validation

Thanks to Ricardo and Dan for initial reviews and suggestions. Please
feel free to pour in your comments and concerns.
Note: Patches are based on Linus's kernel v4.16-rc4

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
  x86/efi: Call efi_delete_dummy_variable() during efi subsystem    
    initialization
  efi: Introduce efi_rts_workqueue and some infrastructure to invoke all
        efi_runtime_services()
  efi: Use efi_rts_workqueue to invoke EFI Runtime Services

 arch/x86/include/asm/efi.h              |   1 -
 arch/x86/platform/efi/efi.c             |   6 -
 drivers/firmware/efi/efi.c              |  21 +++
 drivers/firmware/efi/runtime-wrappers.c | 229 +++++++++++++++++++++++++++++---
 include/linux/efi.h                     |  23 ++++
 5 files changed, 253 insertions(+), 27 deletions(-)

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peter.zijlstra@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>

-- 
2.7.4
