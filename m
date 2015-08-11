From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 08/16] x86/efi: Carrying hibernation key by setup data
Date: Tue, 11 Aug 2015 14:16:28 +0800
Message-ID: <1439273796-25359-9-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

For forwarding hibernation key from EFI stub to boot kernel, this patch
allocates setup data for carrying hibernation key, size and the status
of efi operating.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/eboot.c      | 26 +++++++++++++++++++++++---
 arch/x86/include/uapi/asm/bootparam.h |  1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 463aa9b..c838d09 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1394,18 +1394,22 @@ static void setup_hibernation_keys(struct boot_params *params)
 {
 	unsigned long key_size;
 	unsigned long attributes;
+	struct setup_data *setup_data, *hibernation_setup_data;
 	struct hibernation_keys *keys;
+	unsigned long size = 0;
 	efi_status_t status;
 
 	/* Allocate setup_data to carry keys */
+	size = sizeof(struct setup_data) + sizeof(struct hibernation_keys);
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				sizeof(struct hibernation_keys), &keys);
+				size, &hibernation_setup_data);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for hibernation keys\n");
 		return;
 	}
 
-	memset(keys, 0, sizeof(struct hibernation_keys));
+	memset(hibernation_setup_data, 0, size);
+	keys = (struct hibernation_keys *) hibernation_setup_data->data;
 
 	status = efi_call_early(get_variable, HIBERNATION_KEY,
 				&EFI_HIBERNATION_GUID, &attributes,
@@ -1419,7 +1423,8 @@ static void setup_hibernation_keys(struct boot_params *params)
 		if (status == EFI_SUCCESS) {
 			efi_printk(sys_table, "Cleaned existing hibernation key\n");
 			status = EFI_NOT_FOUND;
-		}
+		} else
+			goto clean_fail;
 	}
 
 	if (status != EFI_SUCCESS) {
@@ -1436,6 +1441,21 @@ static void setup_hibernation_keys(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			efi_printk(sys_table, "Failed to set hibernation key\n");
 	}
+
+clean_fail:
+	hibernation_setup_data->type = SETUP_HIBERNATION_KEYS;
+	hibernation_setup_data->len = sizeof(struct hibernation_keys);
+	hibernation_setup_data->next = 0;
+	keys->hkey_status = efi_status_to_err(status);
+
+	setup_data = (struct setup_data *)params->hdr.setup_data;
+	while (setup_data && setup_data->next)
+		setup_data = (struct setup_data *)setup_data->next;
+
+	if (setup_data)
+		setup_data->next = (unsigned long)hibernation_setup_data;
+	else
+		params->hdr.setup_data = (unsigned long)hibernation_setup_data;
 }
 #else
 static void setup_hibernation_keys(struct boot_params *params) {}
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index ab456dc..8c88bc2 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -7,6 +7,7 @@
 #define SETUP_DTB			2
 #define SETUP_PCI			3
 #define SETUP_EFI			4
+#define SETUP_HIBERNATION_KEYS		5
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
-- 
2.1.4

