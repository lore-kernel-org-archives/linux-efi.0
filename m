Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABA5233938;
	Fri, 24 Jul 2026 23:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784934732; cv=none; b=BsHzgN3RIuuhp4wJtYf7jR3igbdbrdMHtPL6VF6DdPEj3Z6Z//ExWEapJ6HAG0O/Dq3D4QWHI6H0EvAH/MG2TIebnNf3hS84FC73KY6f/4AEBjXvMu1B/00RT2wxTcXoURFhpy8tkGp5XITqSMPS1yfNWdXo3i+8M8rAbmU2zqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784934732; c=relaxed/simple;
	bh=kj581GKAsg7r/ZPuFRCZsTCJhPby+PYDqXbukRl1ax0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lqvAEoSHbI7JlmIkCr7TG/qfK2n9FfL2XeVjuD1vyoYC/AdE19zNMOQfZdr2K+5A++YCZ4T+hFLosjBMATnidtmRJU992M8nB6/noPEs17PvdjQtn9OAiKZk3JyHggoAtQPb8bQvrA8Erm+J3lFbO08cI36CdtzP+TecPdw4kCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJm496uz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJm496uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FED1F000E9;
	Fri, 24 Jul 2026 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784934730;
	bh=UTSFUW4C0rbxoCHWLqb7KFOoAcgQUCT+6z5FRIdim6g=;
	h=From:Date:Subject:To:Cc;
	b=cJm496uzJZM7NLNPcGIUKvf0p0q9O/SSShBss+i/i38zCYRbazpFLtvTMUJUVjmHu
	 lNaktzOCZlBGKvfoK3/dXM14p7VOo8zOgNgVxLlTw/TQkJmK2Ngs+WRAU2XVEfQQlO
	 CfTyWTPYhb1zfMG3InVvu9NZQj7KZKqpJjkzJrDn2JU+gZM+Crlz2vSL+P3VcZyqAJ
	 XT2xC4WIk/XrIHQbqLZ3zmg988hJxQb+04FZZt+vfqh53Y9OVB5ATYe8R8xXkL5qdE
	 MsIdnQKYJGJhwYAhA59I7rXRcyqJ0b8cmJuOtMKNXIBJJtn5eL11D5UaRqfw/agCBS
	 SKf3Cat9qL3BA==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sat, 25 Jul 2026 01:11:55 +0200
Subject: [PATCH] efi/libstub: populate LoaderDevicePartUUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260725-efi_stub_bli-v1-1-966e4748077f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDcyMT3dS0zPjiktKk+KScTF0Tc3MjC0sDUwMjI1MloJaCIqB0Bdi46Nj
 aWgBl7rpfXgAAAA==
X-Change-ID: 20260724-efi_stub_bli-477289050225
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8283; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=kj581GKAsg7r/ZPuFRCZsTCJhPby+PYDqXbukRl1ax0=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFnJH123H89Z5zt9wotJfFsCijoPFuuVaa9cV3BRbYrWN
 SmFRJ5XHRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1d8qGf5HHH+UsrTswKfYTd/zmyZnm/Eov0y32bkh+7POJYf6r9oXGf67HV42M/z
 Ws+miqw59E5FaeviQdsZv5Vvf7p0U/u8V6ynABwA=
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

The Boot Loader Interface [1] defines LoaderDevicePartUUID. That
variable contains the GPT partition UUID of the device path from which
the boot loader was loaded.

This is used for example by systemd-gpt-auto-generator [2] to identify
the disk the boot loader was launched from and automatically detect and
mount partitions on it.

GRUB populates it [3], but most EFI firmware implementations do not.
Because of that, the variable is missing when booting the kernel from
the EFI stub.

Read the loaded image device path, extract the GUID signature from its
GPT HD() device path node and publish it as LoaderDevicePartUUID under
the Linux loader entry vendor GUID. Do not overwrite an existing
variable, so a boot loader supplied value keeps precedence.

Use a volatile variable with boot-service and runtime access so the
value remains available to user space services such as systemd, without
persisting stale boot state across resets.

Install the efi_bli_set_variables() hook in both the generic efi-stub.c
path and the x86-specific x86-stub.c path.

[1] The Boot Loader Interface
Link: https://systemd.io/BOOT_LOADER_INTERFACE/

[2] systemd-gpt-auto-generator
Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html

[3] GRUB -- §16.2 bli
Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
Here is a bit of extra context around this patch. I recently installed
coreboot on my machine with edk2 as the payload. After booting the
kernel directly from the EFI stub instead of booting it from GRUB, I
noticed that some partitions which were previously mounted automatically
were not mounted anymore.

Upon investigation, I found that those partitions were mounted
automatically using DPS [4]. DPS needs the LoaderDevicePartUUID EFI
variable, which was set by GRUB but not by edk2.

I first proposed a series to add that variable in edk2 [5]. The change
was not well received because BLI is perceived as too specific to Linux
systems. Upon reflection, I concluded that the kernel EFI stub is the
best location to implement it because it resolves the problem for EFI
firmware implementations in one place.

[4] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

[5] MdeModulePkg/UefiBootManagerLib: Expose the LoaderDevicePartUUID
    EFI variable
Link: https://github.com/tianocore/edk2/pull/12763
---
 drivers/firmware/efi/libstub/Makefile   |   2 +-
 drivers/firmware/efi/libstub/bli.c      | 111 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c |   1 +
 drivers/firmware/efi/libstub/efistub.h  |   2 +
 drivers/firmware/efi/libstub/x86-stub.c |   1 +
 5 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f..a4b12e80246b 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -63,7 +63,7 @@ KBUILD_CFLAGS_KERNEL := $(filter-out -fdata-sections, $(KBUILD_CFLAGS_KERNEL))
 
 KBUILD_AFLAGS			:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
-lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
+lib-y				:= bli.o efi-stub-helper.o gop.o secureboot.o tpm.o \
 				   file.o mem.o random.o randomalloc.o pci.o \
 				   skip_spaces.o lib-cmdline.o lib-ctype.o \
 				   alignedmem.o printk.o vsprintf.o
diff --git a/drivers/firmware/efi/libstub/bli.c b/drivers/firmware/efi/libstub/bli.c
new file mode 100644
index 000000000000..41178b1f9061
--- /dev/null
+++ b/drivers/firmware/efi/libstub/bli.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/efi.h>
+#include <linux/errno.h>
+#include <linux/unaligned.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
+
+struct efi_hd_dev_path {
+	struct efi_generic_dev_path header;
+	u32 partition_number;
+	u64 partition_start;
+	u64 partition_size;
+	efi_guid_t signature;
+	u8 mbr_type;
+	u8 signature_type;
+} __packed;
+
+#define EFI_HD_MBR_TYPE_GPT	2
+#define EFI_HD_SIGNATURE_GUID	2
+
+static void efi_bli_guid_to_str(const efi_guid_t *guid, efi_char16_t *out)
+{
+	static const u8 guid_index[UUID_SIZE] = {
+		3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15,
+	};
+	static const char hex[] = "0123456789abcdef";
+
+	for (int i = 0; i < ARRAY_SIZE(guid_index); i++) {
+		u8 byte = guid->b[guid_index[i]];
+
+		*out++ = hex[byte >> 4];
+		*out++ = hex[byte & 0xf];
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
+static int efi_dev_path_part_uuid(const efi_device_path_protocol_t *path,
+				   efi_char16_t *partuuid)
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
+		if (hd_node->mbr_type != EFI_HD_MBR_TYPE_GPT ||
+		    hd_node->signature_type != EFI_HD_SIGNATURE_GUID)
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
+	efi_guid_t device_path_guid = EFI_DEVICE_PATH_PROTOCOL_GUID;
+	efi_char16_t partuuid[UUID_STRING_LEN + 1];
+	efi_device_path_protocol_t *path;
+	unsigned long size = 0;
+
+	if (!image)
+		return;
+
+	if (get_efi_var(L"LoaderDevicePartUUID", &LINUX_EFI_LOADER_ENTRY_GUID,
+			NULL, &size, NULL) != EFI_NOT_FOUND)
+		return;
+
+	if (efi_bs_call(handle_protocol, efi_table_attr(image, device_handle),
+			&device_path_guid, (void **)&path) != EFI_SUCCESS)
+		return;
+
+	if (efi_dev_path_part_uuid(path, partuuid))
+		return;
+
+	set_efi_var(L"LoaderDevicePartUUID", &LINUX_EFI_LOADER_ENTRY_GUID,
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
index fd91fc15ec81..d1dffc1d3358 100644
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
 

---
base-commit: b4c1bfc231521b627214bf654417bfef3721da79
change-id: 20260724-efi_stub_bli-477289050225

Best regards,
-- 
Vincent Mailhol <mailhol@kernel.org>

