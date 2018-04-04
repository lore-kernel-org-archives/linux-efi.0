From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH] x86: Use boot_cpu_has() instead of this_cpu_has() in build_cr3_noflush()
Date: Wed,  4 Apr 2018 12:34:19 -0700
Message-ID: <1522870459-7432-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

When the platform supports PCID and if CONFIG_DEBUG_VM is enabled,
build_cr3_noflush() (called via switch_mm()) does a sanity check to see
if X86_FEATURE_PCID is set. Presently, build_cr3_noflush() uses
"this_cpu_has(X86_FEATURE_PCID)" to perform the check but this_cpu_has()
works only after SMP is initialized (i.e. per cpu cpu_info's should be
populated) and this happens to be very late in the boot process (during
rest_init).

As efi_runtime_services() are called during (early) kernel boot time
and run time, modify build_cr3_noflush() to use boot_cpu_has() all the
time. As suggested by Dave, this should be OK because all cpu's have
same capabilities anyways (for x86).

Without this change we see below warning during kernel boot.

WARNING: CPU: 0 PID: 0 at arch/x86/include/asm/tlbflush.h:134
load_new_mm_cr3+0x114/0x170
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.16.0-02277-gbc16d4052f1a #1
Hardware name: System manufacturer System Product Name/Z170-K, BIOS 3301
02/08/2017
RIP: 0010:load_new_mm_cr3+0x114/0x170
RSP: 0000:ffffffff9b203e38 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffff9b26f5a0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff9b20a000
RBP: ffffffff9b203e90 R08: 0000000000000000 R09: 000000000f63eb29
R10: ffffffff9b203ea8 R11: 00000000c3292018 R12: 0000000000000000
R13: ffffffff9b2e1180 R14: 000000000001ee80 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff968df6c00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff968df6fff000 CR3: 00000004261e6002 CR4: 00000000000606b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
switch_mm_irqs_off+0x267/0x590
switch_mm+0xe/0x20
efi_switch_mm+0x3e/0x50
efi_enter_virtual_mode+0x43f/0x4da
start_kernel+0x3bf/0x458
secondary_startup_64+0xa5/0xb0

Dave also suggested that we put a warning in this_cpu_has() if it's used
early in the boot process. This is still work in progress as it effects
MCE.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>
---
 arch/x86/include/asm/tlbflush.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 84137c22fdfa..42e040859067 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -131,7 +131,12 @@ static inline unsigned long build_cr3(pgd_t *pgd, u16 asid)
 static inline unsigned long build_cr3_noflush(pgd_t *pgd, u16 asid)
 {
 	VM_WARN_ON_ONCE(asid > MAX_ASID_AVAILABLE);
-	VM_WARN_ON_ONCE(!this_cpu_has(X86_FEATURE_PCID));
+	/*
+	 * Use boot_cpu_has() instead of this_cpu_has() as this function
+	 * might be called during early boot. This should work even after
+	 * boot because all cpu's have same capabilities anyways.
+	 */
+	VM_WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_PCID));
 	return __sme_pa(pgd) | kern_pcid(asid) | CR3_NOFLUSH;
 }
 
-- 
2.7.4
