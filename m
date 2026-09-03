Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CE54D2ED2;
	Thu,  3 Sep 2026 21:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470413; cv=none; b=Mts0X4ehCEsKABVjHvEBKanon43Daj496ugwpSuneRE7SsgzzMe4OgSNIBcswNi3yKOdbrAUVhpCk5q9LUxruYG+p8I9mF2ZQs+v0ICnW6c5dSNqwn/+tNoMB0qWrCQE0BA3NaYsgKZ4MZl1m+s6ZXIL16j/Etz4YWpdBwc1P5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470413; c=relaxed/simple;
	bh=5rOgo3J+cPKL10Fdeq/jufSLDlsC4ERaa1FBPfvKqQU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Kpw8MvwY3U+c8CcekbDJknJgfbe1VJmlF0rowIbWmtQdEWeKvUbQLO8dUGkaoD1k+8oo3YEhbdyehdeCZFvaKPCColnd6c6E1mWpjKh18YaPCvdYChVdjuBkQJqUPBDhGkpK5fPCRn8HgKPuFuXD8+Aja3WcHiip54Ff+XTlJmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCYbHu8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCYbHu8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9018C1F000E9;
	Thu,  3 Sep 2026 21:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788470397;
	bh=yvFMlaA7BL0FF9XlF9Hw97bokHcmO4OWZNzoGJUjtmk=;
	h=From:Date:Subject:To:Cc;
	b=MCYbHu8zrhedElI58Oi6rzkUkUojnvYUsFB76cz+gkiPBTWbboxdqHaI3cvPXqiyn
	 eRiLkhI7IBX9OgHjAXIHbGQVxYDbooFimlSTDGMOUrFOdfpx40lwfsWNCq05ZXoyPU
	 57bVNuyRu1RYbJYZ9VbhDeLEgiAOdXwFHuwzuWM+gyQw9XH44gPBuVscCTPxMQGB5v
	 QhLH5lufE2U2Z95yP4wn/KyfrhC8rS4v0vC0WPLsSzVVxIy44ogYrQcA3ydwjP9kin
	 ujXTHA3WFBLjTtFpIkh4/Out4EH71cL9PqPuPGFSArAuxpEYEYeV3U2fwi0u3z7eS5
	 ymEFsz5qG/jSw==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Thu, 03 Sep 2026 23:19:34 +0200
Subject: [PATCH v2] efi/libstub: populate LoaderDevicePartUUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1XMwQ6CMAzG8VchPTuzNYOCJ9/DECJaoJEMsiHRk
 L27k8SDx3+b77dBYC8c4JRt4HmVIJNLgYcMbsPV9azknhpQY6EJreJOmrA826YdRVkiLCuda8Q
 c0mT26f3auUudepCwTP6966v5Xn9Q/g+tRhlVFQVbsqUm6s4P9o7H4+R7qGOMHyIE23apAAAA
X-Change-ID: 20260724-efi_stub_bli-477289050225
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9720; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=5rOgo3J+cPKL10Fdeq/jufSLDlsC4ERaa1FBPfvKqQU=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkzn5Sd3pV0n+WSCsMyi+2sjXXzqq9dcdpibeFs5yDxt
 +nd7m6vjoksDGJcDJZiiizLyjm5FToKvcMO/bWEmcPKBDJEWqSBAQhYGPhyE/NKjXSM9Ey1DfUM
 gQwdIwYuTgGY6l9JDP9TYivOJTRvSP3KoJL389tNa5niyo+q/65rRN6/d0A89JQaI8N2Q06vJQE
 qH2pzXGc/6MmcPvN3V5JV2ZPDNnYJd0+r5rIDAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

The Boot Loader Interface [1] defines LoaderDevicePartUUID. That EFI
variable records the GPT partition UUID of the partition containing the
boot loader.

This is used, for example, by systemd-gpt-auto-generator [2] to identify
the disk the boot loader was launched from and automatically detect and
mount partitions on it.

GRUB [3] and systemd-boot [4] populate it, but when the kernel is
started directly by EFI firmware, there is no conventional external boot
loader to provide the variable. In that case, because the EFI stub
performs the boot loader role, it should provide the variable itself.

Parse the loaded image device path, extract the GUID signature from its
GPT HD() node and publish it under the Linux loader entry vendor GUID as
the volatile LoaderDevicePartUUID EFI variable. Do not overwrite an
existing variable, so a value supplied by an earlier boot stage keeps
precedence.

Install the efi_bli_set_variables() hook in both the generic efi-stub.c
path and the x86-specific x86-stub.c path.

Add CONFIG_EFI_STUB_BLI to make this new feature configurable.

For an x86_64 build using gcc 15.3.0, bloat-o-meter reports the
following difference between builds without and with CONFIG_EFI_STUB_BLI:

  add/remove: 5/0 grow/shrink: 1/0 up/down: 639/0 (639)
  Function                                     old     new   delta
  efi_bli_set_variables                          -     563    +563
  loader_entry_guid                              -      16     +16
  hex                                            -      16     +16
  guid_index                                     -      16     +16
  device_path_guid                               -      16     +16
  efi_stub_entry                              4180    4192     +12
  Total: Before=29223, After=29862, chg +2.19%

[1] The Boot Loader Interface
Link: https://systemd.io/BOOT_LOADER_INTERFACE/

[2] systemd-gpt-auto-generator
Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html

[3] GRUB -- §16.2 bli
Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html

[4] systemd -- systemd-boot UEFI Boot Manager
Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=1#L111

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
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
 drivers/firmware/efi/Kconfig            |  15 +++++
 drivers/firmware/efi/libstub/Makefile   |   2 +
 drivers/firmware/efi/libstub/bli.c      | 114 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c |   1 +
 drivers/firmware/efi/libstub/efistub.h  |   6 ++
 drivers/firmware/efi/libstub/x86-stub.c |   1 +
 6 files changed, 139 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5..eff7c6164096 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -100,6 +100,21 @@ config EFI_ARMSTUB_DTB_LOADER
 	  functionality for bootloaders that do not have such support
 	  this option is necessary.
 
+config EFI_STUB_BLI
+	bool "EFI stub Boot Loader Interface support"
+	depends on EFI_STUB
+	default y
+	help
+	  The Boot Loader Interface defines EFI variables that expose
+	  information about the boot loader to the running OS.
+
+	  Enable this option to let the EFI stub populate the volatile
+	  LoaderDevicePartUUID EFI variable when it is missing. This allows
+	  user space services such as systemd-gpt-auto-generator to discover
+	  partitions on the disk from which the kernel was loaded.
+
+	  If unsure, say Y.
+
 config EFI_BOOTLOADER_CONTROL
 	tristate "EFI Bootloader Control"
 	select UCS2_STRING
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f..000a73a4bc52 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -75,6 +75,8 @@ libfdt-deps			:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c \
 lib-$(CONFIG_EFI_PARAMS_FROM_FDT) += fdt.o \
 				     $(patsubst %.c,lib-%.o,$(libfdt-deps))
 
+lib-$(CONFIG_EFI_STUB_BLI)	+= bli.o
+
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
diff --git a/drivers/firmware/efi/libstub/bli.c b/drivers/firmware/efi/libstub/bli.c
new file mode 100644
index 000000000000..d54eb42729a7
--- /dev/null
+++ b/drivers/firmware/efi/libstub/bli.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/efi.h>
+#include <linux/errno.h>
+#include <linux/unaligned.h>
+
+#include "efistub.h"
+
+struct efi_hd_dev_path {
+	struct efi_generic_dev_path header;
+	u32 partition_number;
+	u64 partition_start;
+	u64 partition_size;
+	efi_guid_t signature;
+	u8 partition_format;
+	u8 signature_type;
+} __packed;
+
+#define EFI_HD_PARTITION_FORMAT_GPT	2
+#define EFI_HD_SIGNATURE_TYPE_GUID	2
+
+static efi_char16_t efi_bli_nibble_to_hex(u8 nibble)
+{
+	static const char hex[16] __nonstring = "0123456789abcdef";
+
+	return hex[nibble];
+}
+
+static void efi_bli_guid_to_str(const efi_guid_t *guid, efi_char16_t *out)
+{
+	static const u8 guid_index[UUID_SIZE] = {
+		3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15,
+	};
+
+	for (int i = 0; i < ARRAY_SIZE(guid_index); i++) {
+		u8 byte = guid->b[guid_index[i]];
+
+		*out++ = efi_bli_nibble_to_hex(byte >> 4);
+		*out++ = efi_bli_nibble_to_hex(byte & 0xf);
+
+		switch (i) {
+		case 3:
+		case 5:
+		case 7:
+		case 9:
+			*out++ = L'-';
+		}
+	}
+
+	*out = L'\0';
+}
+
+static int efi_bli_dev_path_part_uuid(const efi_device_path_protocol_t *path,
+				      efi_char16_t *partuuid)
+{
+	const efi_device_path_protocol_t *node;
+	const struct efi_hd_dev_path *hd_node;
+	u16 node_len;
+
+	for (node = path;
+	     node->type != EFI_DEV_END_PATH && node->type != EFI_DEV_END_PATH2;
+	     node = (const void *)node + node_len) {
+		node_len = get_unaligned_le16(&node->length);
+
+		if (node_len < sizeof(*node))
+			return -EINVAL;
+
+		if (node->type != EFI_DEV_MEDIA ||
+		    node->sub_type != EFI_DEV_MEDIA_HARD_DRIVE)
+			continue;
+
+		if (node_len < sizeof(*hd_node))
+			return -EINVAL;
+
+		hd_node = (const struct efi_hd_dev_path *)node;
+		if (hd_node->partition_format != EFI_HD_PARTITION_FORMAT_GPT ||
+		    hd_node->signature_type != EFI_HD_SIGNATURE_TYPE_GUID)
+			continue;
+
+		efi_bli_guid_to_str(&hd_node->signature, partuuid);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static void efi_bli_populate_loader_part_uuid(efi_loaded_image_t *image)
+{
+	static efi_guid_t device_path_guid = EFI_DEVICE_PATH_PROTOCOL_GUID;
+	static efi_guid_t loader_entry_guid = LINUX_EFI_LOADER_ENTRY_GUID;
+	efi_char16_t partuuid[UUID_STRING_LEN + 1];
+	unsigned long size = 0;
+	void *path;
+
+	if (get_efi_var(L"LoaderDevicePartUUID", &loader_entry_guid,
+			NULL, &size, NULL) != EFI_NOT_FOUND)
+		return;
+
+	if (efi_bs_call(handle_protocol, efi_table_attr(image, device_handle),
+			&device_path_guid, &path) != EFI_SUCCESS)
+		return;
+
+	if (efi_bli_dev_path_part_uuid(path, partuuid))
+		return;
+
+	set_efi_var(L"LoaderDevicePartUUID", &loader_entry_guid,
+		    EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+		    sizeof(partuuid), partuuid);
+}
+
+void efi_bli_set_variables(efi_loaded_image_t *image)
+{
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
index fd91fc15ec81..a4f961ea43a8 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1072,6 +1072,12 @@ efi_status_t efi_random_alloc(unsigned long size, unsigned long align,
 			      int memory_type, unsigned long alloc_min,
 			      unsigned long alloc_max);
 
+#ifdef CONFIG_EFI_STUB_BLI
+void efi_bli_set_variables(efi_loaded_image_t *image);
+#else
+static inline void efi_bli_set_variables(efi_loaded_image_t *image) { }
+#endif
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
 

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260724-efi_stub_bli-477289050225

Best regards,
--  
Vincent Mailhol <mailhol@kernel.org>

