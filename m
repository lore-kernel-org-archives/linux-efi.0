From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 5/5] efi/bgrt: Skip efi_bgrt_init in case of non-efi boot
Date: Fri, 26 May 2017 12:36:51 +0100
Message-ID: <20170526113652.21339-6-matt@codeblueprint.co.uk>
References: <20170526113652.21339-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170526113652.21339-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Sabrina Dubroca <sd@queasysnail.net>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Dave Young <dyoung@redhat.com>

Sabrina Dubroca reported an early panic below, it was introduced by
commit 7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init
code"). The cause is on this machine even for legacy boot firmware still
provide the ACPI BGRT table which should be EFI only. Thus the garbage
bgrt data caused the efi_bgrt_init panic.

Add a checking to skip efi_bgrt_init in case non EFI booting solves this
problem.

BUG: unable to handle kernel paging request at ffffffffff240001
IP: efi_bgrt_init+0xdc/0x134
PGD 1ac0c067
PUD 1ac0e067
PMD 1aee9067
PTE 9380701800000163

Oops: 0009 [#1] SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 4.10.0-rc5-00116-g7b0a911 #19
Hardware name: Hewlett-Packard HP Z220 CMT Workstation/1790, BIOS K51 v01.02 05/03/2012
task: ffffffff9fc10500 task.stack: ffffffff9fc00000
RIP: 0010:efi_bgrt_init+0xdc/0x134
RSP: 0000:ffffffff9fc03d58 EFLAGS: 00010082
RAX: ffffffffff240001 RBX: 0000000000000000 RCX: 1380701800000006
RDX: 8000000000000163 RSI: 9380701800000163 RDI: 00000000000005be
RBP: ffffffff9fc03d70 R08: 1380701800001000 R09: 0000000000000002
R10: 000000000002d000 R11: ffff98a3dedd2fc6 R12: ffffffff9f9f22b6
R13: ffffffff9ff49480 R14: 0000000000000010 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff9fd20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff240001 CR3: 000000001ac09000 CR4: 00000000000406b0
Call Trace:
 ? acpi_parse_ioapic+0x98/0x98
 acpi_parse_bgrt+0x9/0xd
 acpi_table_parse+0x7a/0xa9
 acpi_boot_init+0x3c7/0x4f9
 ? acpi_parse_x2apic+0x74/0x74
 ? acpi_parse_x2apic_nmi+0x46/0x46
 setup_arch+0xb4b/0xc6f
 ? printk+0x52/0x6e
 start_kernel+0xb2/0x47b
 ? early_idt_handler_array+0x120/0x120
 x86_64_start_reservations+0x24/0x26
 x86_64_start_kernel+0xf7/0x11a
 start_cpu+0x14/0x14
Code: 48 c7 c7 10 16 a0 9f e8 4e 94 40 ff eb 62 be 06 00 00 00 e8 f9 ff 00 00 48 85 c0 75 0e 48
c7 c7 40 16 a0 9f e8 31 94 40 ff eb 45 <66> 44 8b 20 be 06 00 00 00 48 89 c7 8b 58 02 e8 87 00
01 00 66
RIP: efi_bgrt_init+0xdc/0x134 RSP: ffffffff9fc03d58
CR2: ffffffffff240001
---[ end trace f68728a0d3053b52 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
---[ end Kernel panic - not syncing: Attempted to kill the idle task!

Fixes: 7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
Signed-off-by: Dave Young <dyoung@redhat.com>
Tested-by: Sabrina Dubroca <sd@queasysnail.net>
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>

Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efi-bgrt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index 04ca8764f0c0..8bf27323f7a3 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 	if (acpi_disabled)
 		return;
 
+	if (!efi_enabled(EFI_BOOT))
+		return;
+
 	if (table->length < sizeof(bgrt_tab)) {
 		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
 		       table->length, sizeof(bgrt_tab));
-- 
2.12.2
