From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH] x86/efi: Fix kexec kernel panic when efi=old_map is enabled
Date: Mon,  8 May 2017 12:25:23 -0700
Message-ID: <1494271523-17331-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Borislav Petkov <bp@alien8.de>, Ricardo Neri <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Booting kexec kernel with "efi=old_map" in kernel command line hits
kernel panic as shown below.

[    0.001000] BUG: unable to handle kernel paging request at ffff88007fe78070
[    0.001000] IP: virt_efi_set_variable.part.7+0x63/0x1b0
[    0.001000] PGD 7ea28067
[    0.001000] PUD 7ea2b067
[    0.001000] PMD 7ea2d067
[    0.001000] PTE 0
[    0.001000]
[    0.001000] Oops: 0000 [#1] SMP
[    0.001000] Modules linked in:
[    0.001000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc2-yocto-standard+ #229
[    0.001000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[    0.001000] task: ffffffff82022500 task.stack: ffffffff82000000
[    0.001000] RIP: 0010:virt_efi_set_variable.part.7+0x63/0x1b0
[    0.001000] RSP: 0000:ffffffff82003dc0 EFLAGS: 00010246
[    0.001000] RAX: ffff88007fe78018 RBX: ffffffff82050300 RCX: 0000000000000007
[    0.001000] RDX: ffffffff82003e50 RSI: ffffffff82050300 RDI: ffffffff82050300
[    0.001000] RBP: ffffffff82003e08 R08: 0000000000000000 R09: 0000000000000000
[    0.001000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff82003e50
[    0.001000] R13: 0000000000000007 R14: 0000000000000246 R15: 0000000000000000
[    0.001000] FS:  0000000000000000(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
[    0.001000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.001000] CR2: ffff88007fe78070 CR3: 000000007da1d000 CR4: 00000000000006b0
[    0.001000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.001000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    0.001000] Call Trace:
[    0.001000]  virt_efi_set_variable+0x5d/0x70
[    0.001000]  efi_delete_dummy_variable+0x7a/0x80
[    0.001000]  efi_enter_virtual_mode+0x3f6/0x4a7
[    0.001000]  start_kernel+0x375/0x400
[    0.001000]  x86_64_start_reservations+0x2a/0x2c
[    0.001000]  x86_64_start_kernel+0x168/0x176
[    0.001000]  start_cpu+0x14/0x14
[    0.001000] Code: 04 b0 84 ff 80 3d c5 56 b3 00 00 4c 8b 44 24 08 75
6b 9c 41 5e 48 8b 05 9c 78 99 00 4d 89 c1 48 89 de 4d 89 f8 44 89 e9 4c
89 e2 <48> 8b 40 58 48 8b 78 58 e8 b0 2d 88 ff 48 c7 c6 b6 1d f4 81 4c
[    0.001000] RIP: virt_efi_set_variable.part.7+0x63/0x1b0 RSP: ffffffff82003dc0
[    0.001000] CR2: ffff88007fe78070
[    0.001000] ---[ end trace 0000000000000000 ]---
[    0.001000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.001000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!

This happens because efi=old_map doesn't use efi_pgd but rather it uses
kernel's pgd. We don't hit the same panic in a regular kernel because
it uses old_map_region() and not __map_region().

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
---
 arch/x86/platform/efi/efi_64.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 4e043a8c8556..76e1cd6b74dd 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -320,6 +320,9 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 	unsigned long pfn;
 	pgd_t *pgd = efi_pgd;
 
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		pgd = swapper_pg_dir;
+
 	if (!(md->attribute & EFI_MEMORY_WB))
 		flags |= _PAGE_PCD;
 
-- 
2.1.4
