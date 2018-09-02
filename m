From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 5/6] x86/mm: If in_atomic(), allocate pages without sleeping
Date: Sun,  2 Sep 2018 02:46:33 -0700
Message-ID: <1535881594-25469-6-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ricardo.neri@intel.com, matt@codeblueprint.co.uk, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

A page fault occurs when any EFI Runtime Service tries to reference a
memory region which it shouldn't. If the illegally accessed region
is EFI_BOOT_SERVICES_<CODE/DATA>, the efi specific page fault handler
fixes it up by dynamically creating VA->PA mappings using
efi_map_region().

Originally, efi_map_region() and hence the functionality of creating
mappings for efi regions was intended to be used *only* during boot time
(please note __init modifier) and hence when called during runtime (i.e.
from efi page fault handler), the page allocators complain. Calling
efi_map_region() during runtime complains because "gfp_allowed_mask"
value changes from boot time to runtime (GFP_BOOT_MASK to
__GFP_BITS_MASK). During boot, even though efi_map_region() calls
alloc_<pte/pmd>_page with GFP_KERNEL, the page allocator doesn't
complain because "__GFP_RECLAIM" flag is cleared by "gfp_allowed_mask",
but during runtime it isn't cleared and hence prints below stack trace.

BUG: sleeping function called from invalid context at mm/page_alloc.c:4320
in_atomic(): 1, irqs_disabled(): 1, pid: 2022, name: fwts
1 lock held by fwts/2022:
irq event stamp: 45714
hardirqs last  enabled at (45713): [<ffffffff81c00a54>] restore_regs_and_return_to_kernel+0x0/0x2c
hardirqs last disabled at (45714): [<ffffffff81c0112c>] error_entry+0x7c/0x100
softirqs last  enabled at (44732): [<ffffffff81e00387>] __do_softirq+0x387/0x49a
softirqs last disabled at (44707): [<ffffffff8106fabb>] irq_exit+0xbb/0xc0
CPU: 0 PID: 2022 Comm: fwts Not tainted 4.17.0-rc4-efitest+ #405
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
Call Trace:
dump_stack+0x5e/0x8b
___might_sleep+0x20c/0x240
__alloc_pages_nodemask+0xc2/0x330
get_zeroed_page+0x12/0x40
alloc_pmd_page+0x13/0x50
populate_pmd+0xc0/0x2e0
? __lock_acquire+0x439/0x740
__cpa_process_fault+0x2e1/0x5d0
__change_page_attr_set_clr+0x7c3/0xcd0
? console_unlock+0x34d/0x660
? kernel_map_pages_in_pgd+0x8c/0x160
kernel_map_pages_in_pgd+0x8c/0x160
? printk+0x43/0x4b
? __map_region+0x3c/0x60
__map_region+0x3c/0x60
efi_map_region+0x83/0xd0
efi_illegal_accesses_fixup+0x1ca/0x1e0
no_context+0x112/0x390
__do_page_fault+0xc7/0x4f0
page_fault+0x1e/0x30
RIP: 0010:0xfffffffeffc7ccf1
RSP: 0018:ffffc9000075bbf0 EFLAGS: 00010282
RAX: 0000000000000048 RBX: ffffc9000075be10 RCX: ffffc9000075bad0
RDX: 00000000000003f8 RSI: ffffc9000075be10 RDI: fffffffeffc7cccf
RBP: ffffc9000075bdc8 R08: 0000000000000048 R09: 0000000000000048
R10: 00000000000003fd R11: 00000000000003f8 R12: ffff880032a92d80
R13: 0000000000000003 R14: 00007ffcf1eb9d50 R15: 0000000000000000
? efi_call+0xd1/0x160
? __lock_acquire+0x439/0x740
? _raw_spin_unlock+0x24/0x30
? virt_efi_get_next_high_mono_count+0x77/0xf0
? efi_test_ioctl+0x1ab/0xc20
? selinux_file_ioctl+0x122/0x1c0
? do_vfs_ioctl+0x92/0x6b0
? do_vfs_ioctl+0x92/0x6b0
? security_file_ioctl+0x3c/0x50
? selinux_capable+0x20/0x20
? ksys_ioctl+0x66/0x70
? __x64_sys_ioctl+0x16/0x20
? do_syscall_64+0x50/0x170
? entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix the above warning by conditionally changing the allocation from
GFP_KERNEL to GFP_ATOMIC, so that efi page fault handler could use
efi_map_region() during runtime. This change shouldn't effect any other
generic page allocations because this allocation is used only by efi
functions [1].

[1] Comment in __cpa_process_fault() at arch/x86/mm/pageattr.c

if (cpa->pgd) {
	/*
	 * Right now, we only execute this code path when mapping
	 * the EFI virtual memory map regions, no other users
	 * provide a ->pgd value. This may change in the future.
	 */
	return populate_pgd(cpa, vaddr);
}

Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/mm/pageattr.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 3bded76e8d5c..1b28a333c8ce 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -926,7 +926,13 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 
 static int alloc_pte_page(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte;
+
+	if (in_atomic())
+		pte = (pte_t *)get_zeroed_page(GFP_ATOMIC);
+	else
+		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+
 	if (!pte)
 		return -1;
 
@@ -936,7 +942,13 @@ static int alloc_pte_page(pmd_t *pmd)
 
 static int alloc_pmd_page(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	pmd_t *pmd;
+
+	if (in_atomic())
+		pmd = (pmd_t *)get_zeroed_page(GFP_ATOMIC);
+	else
+		pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+
 	if (!pmd)
 		return -1;
 
-- 
2.7.4
