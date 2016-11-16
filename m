From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/16] efi: Get the secure boot status
Date: Wed, 16 Nov 2016 21:47:31 +0000
Message-ID: <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Get the firmware's secure-boot status in the kernel boot wrapper and stash
it somewhere that the main kernel image can find.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/x86/zero-page.txt       |    2 ++
 arch/x86/boot/compressed/eboot.c      |   35 +++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h |    3 ++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index 95a4d34af3fd..b8527c6b7646 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -31,6 +31,8 @@ Offset	Proto	Name		Meaning
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
 				(below)
+1EB/001	ALL     kbd_status      Numlock is enabled
+1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
 1EF/001	ALL	sentinel	Used to detect broken bootloaders
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index cc69e37548db..17b376596c96 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -12,6 +12,7 @@
 #include <asm/efi.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
+#include <asm/bootparam_utils.h>
 
 #include "../string.h"
 #include "eboot.h"
@@ -537,6 +538,36 @@ static void setup_efi_pci(struct boot_params *params)
 	efi_call_early(free_pool, pci_handle);
 }
 
+static int get_secure_boot(void)
+{
+	u8 sb, setup;
+	unsigned long datasize = sizeof(sb);
+	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
+	efi_status_t status;
+
+	status = efi_early->call((unsigned long)sys_table->runtime->get_variable,
+				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
+
+	if (status != EFI_SUCCESS)
+		return 0;
+
+	if (sb == 0)
+		return 0;
+
+
+	status = efi_early->call((unsigned long)sys_table->runtime->get_variable,
+				L"SetupMode", &var_guid, NULL, &datasize,
+				&setup);
+
+	if (status != EFI_SUCCESS)
+		return 0;
+
+	if (setup == 1)
+		return 0;
+
+	return 1;
+}
+
 static efi_status_t
 setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 {
@@ -1094,6 +1125,10 @@ struct boot_params *efi_main(struct efi_config *c,
 	else
 		setup_boot_services32(efi_early);
 
+	sanitize_boot_params(boot_params);
+
+	boot_params->secure_boot = get_secure_boot();
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c18ce67495fa..2b3e5427097b 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -134,7 +134,8 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad5[3];					/* 0x1ec */
+	__u8  secure_boot;				/* 0x1ec */
+	__u8  _pad5[2];					/* 0x1ed */
 	/*
 	 * The sentinel is set to a nonzero value (0xff) in header.S.
 	 *

