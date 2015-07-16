From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 08/16] x86/efi: Carrying swsusp key by setup data
Date: Thu, 16 Jul 2015 22:25:22 +0800
Message-ID: <1437056730-15247-9-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

For forwarding swsusp key from EFI stub to boot kernel, this patch
allocates setup data for carrying swsusp key, size and the status
of efi operating.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/eboot.c      | 29 +++++++++++++++++++++++++----
 arch/x86/include/uapi/asm/bootparam.h |  1 +
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 97b356f..5e1476e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1392,19 +1392,23 @@ free_mem_map:
 
 static void setup_swsusp_keys(struct boot_params *params)
 {
-	unsigned long key_size, attributes;
+	struct setup_data *setup_data, *swsusp_setup_data;
 	struct swsusp_keys *swsusp_keys;
+	int size = 0;
+	unsigned long key_size, attributes;
 	efi_status_t status;
 
 	/* Allocate setup_data to carry keys */
+	size = sizeof(struct setup_data) + sizeof(struct swsusp_keys);
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				sizeof(struct swsusp_keys), &swsusp_keys);
+				size, &swsusp_setup_data);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for swsusp_keys\n");
 		return;
 	}
 
-	memset(swsusp_keys, 0, sizeof(struct swsusp_keys));
+	memset(swsusp_setup_data, 0, size);
+	swsusp_keys = (struct swsusp_keys *)swsusp_setup_data->data;
 
 	status = efi_call_early(get_variable, SWSUSP_KEY, &EFI_SWSUSP_GUID,
 				&attributes, &key_size, swsusp_keys->swsusp_key);
@@ -1413,7 +1417,9 @@ static void setup_swsusp_keys(struct boot_params *params)
 		memset(swsusp_keys->swsusp_key, 0, SWSUSP_DIGEST_SIZE);
 		status = efi_call_early(set_variable, SWSUSP_KEY,
 					&EFI_SWSUSP_GUID, attributes, 0, NULL);
-		if (status == EFI_SUCCESS) {
+		if (status)
+			goto clean_fail;
+		else {
 			efi_printk(sys_table, "Cleaned existing swsusp key\n");
 			status = EFI_NOT_FOUND;
 		}
@@ -1433,6 +1439,21 @@ static void setup_swsusp_keys(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			efi_printk(sys_table, "Failed to set swsusp key\n");
 	}
+
+clean_fail:
+	swsusp_setup_data->type = SETUP_SWSUSP_KEYS;
+	swsusp_setup_data->len = sizeof(struct swsusp_keys);
+	swsusp_setup_data->next = 0;
+	swsusp_keys->skey_status = efi_status_to_err(status);
+
+	setup_data = (struct setup_data *)params->hdr.setup_data;
+	while (setup_data && setup_data->next)
+		setup_data = (struct setup_data *)setup_data->next;
+
+	if (setup_data)
+		setup_data->next = (unsigned long)swsusp_setup_data;
+	else
+		params->hdr.setup_data = (unsigned long)swsusp_setup_data;
 }
 #else
 static void setup_swsusp_keys(struct boot_params *params) {}
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index ab456dc..12e0a203 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -7,6 +7,7 @@
 #define SETUP_DTB			2
 #define SETUP_PCI			3
 #define SETUP_EFI			4
+#define SETUP_SWSUSP_KEYS		5
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
-- 
1.8.4.5

