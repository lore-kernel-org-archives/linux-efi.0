From: Dave Young <dyoung@redhat.com>
Subject: [PATCH] x86/efi: fix boot panic because of invalid bgrt image address
Date: Thu, 8 Jun 2017 13:32:39 +0800
Message-ID: <20170608053239.GA31232@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, tripleshiftone@gmail.com
List-Id: linux-efi@vger.kernel.org

Maniaxx <tripleshiftone@gmail.com> reported kernel boot panic similar to below:
(emulated the panic with using same invalid phys addr in a uefi vm)
There are also a bug in bugzilla.kernel.org:
https://bugzilla.kernel.org/show_bug.cgi?id=195633

This happens after below commit:
7b0a911 efi/x86: Move the EFI BGRT init code to early init code

The root cause is the firmware on those machines provides invalid bgrt
image addresses.

With original efi bgrt code we initialize bgrt late
and use ioremap to map the image address. In ioremap code we check the 
address is a valid physical address or not before really map it.  

With current new efi bgrt code we moved the initialization to early code
so we switch to early_memremap which does not check the phys_addr like
ioremap does. This lead to the early kernel panics.

Fix this by checking the image physical address, if it is not within
any EFI_BOOT_SERVICES_DATA areas then we just bail out. It is stronger
then the original ioremap checking, according to spec the BGRT data
should fall into EFI_BOOT_SERVICES_DATA.

[    0.000000] BUG: unable to handle kernel paging request at ffffffffff280001
[    0.000000] IP: efi_bgrt_init+0xfb/0x153
[    0.000000] PGD 6e00b067 
[    0.000000] P4D 6e00b067 
[    0.000000] PUD 6e00d067 
[    0.000000] PMD 6e221067 
[    0.000000] PTE 8a08e01800000163
[    0.000000] 
[    0.000000] Oops: 0009 [#1] SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.12.0-rc4+ #135
[    0.000000] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.000000] task: ffffffff9840f4c0 task.stack: ffffffff98400000
[    0.000000] RIP: 0010:efi_bgrt_init+0xfb/0x153
[    0.000000] RSP: 0000:ffffffff98403d50 EFLAGS: 00010082
[    0.000000] RAX: ffffffffff280001 RBX: 0000000000000000 RCX: 0000000000000006
[    0.000000] RDX: 0a08e01800001000 RSI: 8a08e01800000163 RDI: 000000000000057e
[    0.000000] RBP: ffffffff98403d68 R08: 0000000000000041 R09: 0000000000000002
[    0.000000] R10: 0000000000000000 R11: ffff8c063cff8fc6 R12: ffffffff981d1fb2
[    0.000000] R13: ffffffff986b4fa0 R14: 0000000000000010 R15: 0000000000000000
[    0.000000] FS:  0000000000000000(0000) GS:ffffffff984db000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: ffffffffff280001 CR3: 000000006e00a000 CR4: 00000000000406b0
[    0.000000] Call Trace:
[    0.000000]  ? bgrt_init+0xbc/0xbc
[    0.000000]  acpi_parse_bgrt+0xe/0x12
[    0.000000]  acpi_table_parse+0x89/0xb8
[    0.000000]  acpi_boot_init+0x445/0x4e2
[    0.000000]  ? acpi_parse_x2apic+0x79/0x79
[    0.000000]  ? dmi_ignore_irq0_timer_override+0x33/0x33
[    0.000000]  setup_arch+0xb63/0xc82
[    0.000000]  ? early_idt_handler_array+0x120/0x120
[    0.000000]  start_kernel+0xb7/0x443
[    0.000000]  ? early_idt_handler_array+0x120/0x120
[    0.000000]  x86_64_start_reservations+0x29/0x2b
[    0.000000]  x86_64_start_kernel+0x154/0x177
[    0.000000]  secondary_startup_64+0x9f/0x9f
[    0.000000] Code: 3f ff eb 6c 48 bf 01 00 00 00 18 e0 08 0a be 06 00 00 00 e8 ef 2b fe ff 48 85 c0 75 0e 48 c7 c7 88 09 22 98 e8 e1 31 3f ff eb 45 <66> 44 8b 20 be 06 00 00 00 48 89 c7 8b 58 02 e8 91 2c fe ff 66 
[    0.000000] RIP: efi_bgrt_init+0xfb/0x153 RSP: ffffffff98403d50
[    0.000000] CR2: ffffffffff280001
[    0.000000] ---[ end trace 9843d3b7cbcab26a ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!

Fixes: 7b0a911 efi/x86: Move the EFI BGRT init code to early init code
Reported-by: Maniaxx <tripleshiftone@gmail.com>
Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/firmware/efi/efi-bgrt.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- linux.orig/drivers/firmware/efi/efi-bgrt.c
+++ linux/drivers/firmware/efi/efi-bgrt.c
@@ -27,6 +27,31 @@ struct bmp_header {
 	u32 size;
 } __packed;
 
+static bool efi_bgrt_addr_valid(u64 addr)
+{
+	efi_memory_desc_t *md;
+
+	if (!efi_enabled(EFI_MEMMAP)) {
+		pr_err("EFI_MEMMAP is not enabled.\n");
+		return true;
+	}
+
+	for_each_efi_memory_desc(md) {
+		u64 size;
+		u64 end;
+
+		if (md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		size = md->num_pages << EFI_PAGE_SHIFT;
+		end = md->phys_addr + size;
+		if (addr >= md->phys_addr && addr < end)
+			return true;
+	}
+
+	return false;
+}
+
 void __init efi_bgrt_init(struct acpi_table_header *table)
 {
 	void *image;
@@ -65,6 +90,10 @@ void __init efi_bgrt_init(struct acpi_ta
 		goto out;
 	}
 
+	if (!efi_bgrt_addr_valid(bgrt->image_address)) {
+		pr_notice("Ignoring BGRT: invalid image address\n");
+		goto out;
+	}
 	image = early_memremap(bgrt->image_address, sizeof(bmp_header));
 	if (!image) {
 		pr_notice("Ignoring BGRT: failed to map image header memory\n");
