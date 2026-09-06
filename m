Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F48F36493A;
	Sun,  6 Sep 2026 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788731545; cv=none; b=CKXn7sya83NN78GCClHjH8ZW5y8/D94BywlEfLbqfqqMMtVdn/KeLpCmOBWBrJORYGV1V+U074F5qnCqCwAUU3TuQhuj9R2DUv//TKhU4SBbIMbxI7lY8ZGK3DSxER73SDFTW0q3EHJtQXjgQ+vS9wd2arB3B/blt76gHYFAzc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788731545; c=relaxed/simple;
	bh=COFRJy/zJQ0m9l38GFWBKTOV3P+kKoKHgZBuEOIgHIg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kweh7D3HKAxPaTV6QvtV49dJ8AYbixzp08UZwiZM0J2k0PwpiHUx9afOP2P3/Krrk89/ZgzMMrPcsSVvM0FHMGBJD5pa8yOpSoFd2jIPPvVBwjI4ROmcFUGfgGA66QtihoLTUKwoNQpWuGJS335mKnpHwmQ+H5mhH5KsAtQNuZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lf8DJvmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lf8DJvmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB631F00A3A;
	Sun,  6 Sep 2026 21:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788731543;
	bh=G/bF4PiYsJXLDYzkWMR4kTITRNZ8x7pMqo9mEkbN+JE=;
	h=From:Date:Subject:To:Cc;
	b=lf8DJvminp3k64I68cruH8VZz+Ge+mEP+ICgQAWJnHwHJX5V9H7r1GEN60bT++1a8
	 pnIMSrPz4MIc69mls2zi+1My+3erxEkvl8SmNAHQfwC1zASYK834veCokRDvUs7ROt
	 Rt0tqgdkOxnHLLi+3CC5CKKABWXX1GFDs1Ss5Kk4HI6CHXY0lkrbZbl/Ert78LVozE
	 260BpX2w1nH3hH8BpaguLjuKA0JVG/ICnuutl0W12GaULS7R7hORcOtmsdupCPj1YT
	 kyy0E3fUewO//NkmQ5DITpPU+4W+V5a9MDU1jfOXq/JDGeY2s4/uNgk8+cr4KHqypA
	 t5D2RjWc2mzBg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sun, 06 Sep 2026 23:52:11 +0200
Subject: [PATCH v3] efi/libstub: add initial Boot Loader Interface support
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260906-efi_stub_bli-v3-1-e7dc0d6b8fcd@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/12PywrCMBBFf0WydjSJbWNd+R8iktipDvahSRoU8
 d+dKiK6vHc4hzt3EdATBrGa3IXHRIH6jsNiOhH7o+0OCFRxFlrqQhqdAda0C3FwO9cQZMboZSl
 zqXUuGDl7Pl9fus2W85FC7P3tZU9qbD+i/FeUFCgoiwIzky2lMfX6hL7DZtb7gxhNSX/pUi7+a
 M105WrjbKlypcwP/XgP83gZ+L34XiecDQj7vm0prqyv3JyN0JAbpdDZSAlhiLUqWPB4AjVeXbA
 nAQAA
X-Change-ID: 20260724-efi_stub_bli-477289050225
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10439; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=COFRJy/zJQ0m9l38GFWBKTOV3P+kKoKHgZBuEOIgHIg=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFlzH0xK/M/xa6VY/NX7E9dGbzy9WyfITMb89oZXLzqCd
 /hOjvCy7pjIwiDGxWAppsiyrJyTW6Gj0Dvs0F9LmDmsTCBDpEUaGICAhYEvNzGv1EjHSM9U21DP
 EMjQMWLg4hSAqS74ycjwNpU508QyXp/poLLWSbcy1VnPj8U//PQp7XydQbl6Tkk9I8Obio37jp1
 8t//p+Yq7YufDlx3SfD5DSHulTXrfacml8me4AA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

The Boot Loader Interface (BLI) [1] defines EFI variables that expose
boot loader state to the running OS. LoaderInfo identifies the boot
loader, while LoaderDevicePartUUID records the GPT partition UUID of
the partition containing it.

LoaderDevicePartUUID is used, for example, by systemd-gpt-auto-generator
[2] to identify the disk the boot loader was launched from and
automatically detect and mount partitions on it.

GRUB [3] and systemd-boot [4] populate these variables, but when the
kernel is started directly by EFI firmware, there is no conventional
external boot loader to provide them. In that case, because the EFI stub
performs the boot loader role, it should provide the variables itself.

Use LoaderInfo as a sentinel: if it is already set by an earlier boot
stage or cannot be set, bail out. Otherwise, populate the other BLI
variables.

Parse the loaded image device path, extract the GUID signature from its
GPT HD() node and publish it under the Linux loader entry vendor GUID as
the volatile LoaderDevicePartUUID EFI variable.

Install the efi_bli_set_variables() hook in both the generic efi-stub.c
path and the x86-specific x86-stub.c path.

[1] The Boot Loader Interface
Link: https://systemd.io/BOOT_LOADER_INTERFACE/

[2] systemd-gpt-auto-generator
Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html

[3] GRUB -- §16.2 bli
Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html

[4] systemd -- systemd-boot UEFI Boot Manager
Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=1#L102

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
Changes in v3:

  - Populate LoaderInfo in addition to LoaderDevicePartUUID.

  - Use LoaderInfo as the provider-level sentinel before setting BLI variables.

  - Drop CONFIG_EFI_STUB_BLI and enable the feature unconditionally.

  - Use the libstub %pUl formatter instead of local GUID string conversion.

  - Mode type definitions to efi.h and add enums for the EFI HD()
    partition format and signature type fields.

  - Reintroduce the NULL check on image to resolve the sashiko finding:
    https://sashiko.dev/#/patchset/20260903-efi_stub_bli-v2-1-dbf7ba915117%40kernel.org

- Link to v2: https://patch.msgid.link/20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org

Changes in v2:

  - Add CONFIG_EFI_STUB_BLI to make the BLI feature optional.

  - Use static storage for GUID initializers. This reduces the size by
    about 10% compared to v1.

  - Remove the redundant NULL check on image.

  - Move the nibble-to-ASCII-hex conversion out of efi_bli_guid_to_str()
    into the new efi_bli_nibble_to_hex().

  - Rename variables to be closer to the EFI specification.

Link to v1: https://lore.kernel.org/r/20260725-efi_stub_bli-v1-1-966e4748077f@kernel.org
---
This patch depends on series "efi/libstub: Avoid UTF-16 conversion
busywork" from Ard.

Link: https://lore.kernel.org/all/20260906130817.1151961-9-ardb@kernel.org/
Link: https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=efi-libstub-native-utf16

Bloat-o-meter results on drivers/firmware/efi/libstub/lib.a before and
after this patch on x86_64 with gcc 15.3.0:

  add/remove: 4/0 grow/shrink: 1/0 up/down: 770/0 (770)
  Function                                     old     new   delta
  efi_bli_set_variables                          -     636    +636
  loader_info                                    -      90     +90
  loader_entry_guid                              -      16     +16
  device_path_guid                               -      16     +16
  efi_stub_entry                              4180    4192     +12
  Total: Before=29436, After=30206, chg +2.62%
---
 drivers/firmware/efi/libstub/Makefile   |  2 +-
 drivers/firmware/efi/libstub/bli.c      | 87 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c |  1 +
 drivers/firmware/efi/libstub/efistub.h  |  2 +
 drivers/firmware/efi/libstub/x86-stub.c |  1 +
 include/linux/efi.h                     | 22 +++++++++
 6 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 12c0c7deb5cb..c3cb0779b2ce 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -63,7 +63,7 @@ KBUILD_CFLAGS_KERNEL := $(filter-out -fdata-sections, $(KBUILD_CFLAGS_KERNEL))
 
 KBUILD_AFLAGS			:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
-lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
+lib-y				:= bli.o efi-stub-helper.o gop.o secureboot.o tpm.o \
 				   file.o mem.o random.o randomalloc.o pci.o \
 				   skip_spaces.o lib-cmdline.o lib-ctype.o \
 				   alignedmem.o printk.o vsprintf.o \
diff --git a/drivers/firmware/efi/libstub/bli.c b/drivers/firmware/efi/libstub/bli.c
new file mode 100644
index 000000000000..ee99c473f03b
--- /dev/null
+++ b/drivers/firmware/efi/libstub/bli.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <generated/utsrelease.h>
+
+#include <linux/efi.h>
+#include <linux/errno.h>
+#include <linux/unaligned.h>
+
+#include "efistub.h"
+
+static efi_guid_t loader_entry_guid = LINUX_EFI_LOADER_ENTRY_GUID;
+
+static const struct efi_hd_dev_path *
+efi_bli_find_hd_node(const struct efi_dev_path *path)
+{
+	const struct efi_dev_path *node;
+	u16 node_len;
+
+	for (node = path;
+	     node->header.type != EFI_DEV_END_PATH &&
+	     node->header.type != EFI_DEV_END_PATH2;
+	     node = (const void *)node + node_len) {
+		node_len = get_unaligned_le16(&node->header.length);
+
+		if (node_len < sizeof(node->header))
+			return NULL;
+
+		if (node->header.type != EFI_DEV_MEDIA ||
+		    node->header.sub_type != EFI_DEV_MEDIA_HARD_DRIVE)
+			continue;
+
+		if (node_len < sizeof(node->hd))
+			return NULL;
+
+		if (node->hd.partition_format != EFI_HD_PARTITION_FORMAT_GPT ||
+		    node->hd.signature_type != EFI_HD_SIGNATURE_TYPE_GUID)
+			continue;
+
+		return &node->hd;
+	}
+
+	return NULL;
+}
+
+static void efi_bli_populate_loader_part_uuid(efi_loaded_image_t *image)
+{
+	static efi_guid_t device_path_guid = EFI_DEVICE_PATH_PROTOCOL_GUID;
+	efi_char16_t partuuid[UUID_STRING_LEN + 1];
+	const struct efi_hd_dev_path *hd_node;
+	const struct efi_dev_path *path;
+
+	if (efi_bs_call(handle_protocol, efi_table_attr(image, device_handle),
+			&device_path_guid, (void **)&path) != EFI_SUCCESS)
+		return;
+
+	hd_node = efi_bli_find_hd_node(path);
+	if (!hd_node)
+		return;
+
+	if (efi_snprintf(partuuid, ARRAY_SIZE(partuuid), "%pUl",
+			 hd_node->signature.b) != UUID_STRING_LEN)
+		return;
+
+	set_efi_var(L"LoaderDevicePartUUID", &loader_entry_guid,
+		    EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+		    sizeof(partuuid), partuuid);
+}
+
+void efi_bli_set_variables(efi_loaded_image_t *image)
+{
+	static efi_char16_t loader_info[] = L"Linux EFI stub " UTS_RELEASE;
+	unsigned long size = 0;
+
+	if (!image)
+		return;
+
+	if (get_efi_var(L"LoaderInfo", &loader_entry_guid,
+			NULL, &size, NULL) != EFI_NOT_FOUND)
+		return;
+
+	if (set_efi_var(L"LoaderInfo", &loader_entry_guid,
+			EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+			sizeof(loader_info), loader_info) != EFI_SUCCESS)
+		return;
+
+	efi_bli_populate_loader_part_uuid(image);
+}
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 42d6073bcd06..2a95f4ea104a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -165,6 +165,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 	dpy = setup_primary_display();
 
 	efi_retrieve_eventlog();
+	efi_bli_set_variables(image);
 
 	/* Ask the firmware to clear memory on unclean shutdown */
 	efi_enable_reset_attack_mitigation();
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 880c1d0c464b..2dbcb8157c95 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1072,6 +1072,8 @@ efi_status_t efi_random_alloc(unsigned long size, unsigned long align,
 			      int memory_type, unsigned long alloc_min,
 			      unsigned long alloc_max);
 
+void efi_bli_set_variables(efi_loaded_image_t *image);
+
 efi_status_t efi_random_get_seed(void);
 
 efi_status_t check_platform_features(void);
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8..b762f7f37f28 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -1014,6 +1014,7 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 	efi_random_get_seed();
 
 	efi_retrieve_eventlog();
+	efi_bli_set_variables(image);
 
 	setup_graphics(boot_params);
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c35446a0b66f..ecb34be37a87 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -957,6 +957,17 @@ extern int efi_status_to_err(efi_status_t status);
 #define   EFI_DEV_END_INSTANCE			0x01
 #define   EFI_DEV_END_ENTIRE			0xFF
 
+enum efi_hd_partition_format {
+	EFI_HD_PARTITION_FORMAT_MBR = 1,
+	EFI_HD_PARTITION_FORMAT_GPT,
+};
+
+enum efi_hd_signature_type {
+	EFI_HD_SIGNATURE_TYPE_NONE,
+	EFI_HD_SIGNATURE_TYPE_MBR,
+	EFI_HD_SIGNATURE_TYPE_GUID,
+};
+
 struct efi_generic_dev_path {
 	u8				type;
 	u8				sub_type;
@@ -988,6 +999,16 @@ struct efi_rel_offset_dev_path {
 	u64				ending_offset;
 } __packed;
 
+struct efi_hd_dev_path {
+	struct efi_generic_dev_path	header;
+	u32				partition_number;
+	u64				partition_start;
+	u64				partition_size;
+	efi_guid_t			signature;
+	u8				partition_format;
+	u8				signature_type;
+} __packed;
+
 struct efi_mem_mapped_dev_path {
 	struct efi_generic_dev_path	header;
 	u32				memory_type;
@@ -1007,6 +1028,7 @@ struct efi_dev_path {
 		struct efi_pci_dev_path		pci;
 		struct efi_vendor_dev_path	vendor;
 		struct efi_rel_offset_dev_path	rel_offset;
+		struct efi_hd_dev_path		hd;
 	};
 } __packed;
 

---
base-commit: 7046b0d50cf479b4122a5b0ab2f03ac07cd0de22
change-id: 20260724-efi_stub_bli-477289050225

Best regards,
--  
Vincent Mailhol <mailhol@kernel.org>

