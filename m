Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B5B552946
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954971; cv=none; b=h68gVy+wo6n9B/3SkV9lm8uxs2WSFTCd5d6fwdKDvjh74YFtvzDju6A8zVzLr4fpmNKXYqNqt8lwGSn3YRGfhiIpSMrwH4SQUAFv5EZ5S0LTardbYsxKhRYCLHbSPYqKPGV7iVB0XswnkCFdyhPPtEBe/mZP0OSTgetDjQDxTqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954971; c=relaxed/simple;
	bh=pRW4HEecg9x05VlvvNHWyO+Xj06f//HTE1CvA11M7fI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OKUISPmZ8mHEbIRZfpZgnJQgrYV50VJccBiTpE2nITEVt5XDPWtoDm+33YmTcYeviIssB++fAPAR3Pn68B3EhSvorEC8IZ3JkDRjI8tpEzpx3SYzKbhVPJiXrEto1ng56cR0coGmzwWEU1mQgWu1mcz0G2ZPrRKyVi4M+QhNfcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DpyRsEZA; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DpyRsEZA"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48436db95e1so4065350f8f.0
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954967; x=1789559767; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=M1PgB2C5uHj9PbLGcmV0eg0x/me0oU1kp6bOAlQo5bk=;
        b=DpyRsEZAKKHhuwEhn6S7VedCpwlLL6ZQAhyPdLp7bU/VvT6hst7tfEimQPDcJYtFBW
         qZo6icMSjOSADZIslGj771L2SPR50Nv1Pod413m70+0E/n9WE0EEGzGqiDX35dD/f8TA
         5gQ1cTmM/CnAFKSmNcXabv3XXf9OGl+VWWlqS4jZxoNlTr/tGY4CKNd1Wl42lR2spiOV
         ZpMwHQHy5Ij1Vnnr1lbolVbJ9l1+NPnzusahrPeB3VNb508sstgo6B7p2loQToX6vYXK
         k6uguxkfq00LhuGabJXOupquDBUdLn6dKSev08V/lMZGHKB7yr6jv/1NzPKpHBKoc9Ue
         SY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954967; x=1789559767;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M1PgB2C5uHj9PbLGcmV0eg0x/me0oU1kp6bOAlQo5bk=;
        b=dZwbT7qex0lmHmmkyCu7flixflSAJrahlnHeEttpWvrMRGmnJ52IopV758Ip7dOK38
         wG9/euQPY8clcXAC1zPb4qO+z98t1DctRvDfdfhX3iCoLq8PniUR/VDl+ieUD8EorDPS
         XqENOcD1z5m/KTdI5i3x4fam9h2vdnVszXwU/BzIGv+IuSJGStxm46OZZFPSqX4st6vG
         t61hv/r210IUjXN4rp9w3MXCYIfW0RXBdUV+IA2qRgj3MJ801CXI10m1In/GpzcdCsAM
         i4it1V0qpuERL3eTL4TWGJ6ePJNRO+vsPuDxcFEJuu6vf9BNVNqFkchmqqH/pffGY9i+
         ESFg==
X-Gm-Message-State: AFuF++ltSkOwdX7lgBJkAcbEMrrOopIricfuCaWEP59OSvM37cdXoSe9
	wmu+/uCg0Ru15lnOdjTD/qF/gPzjoPDFXgovSHusmJ/FJ7fpz7dafC0GACp7BXIdplFcGa08raS
	E+DFWO/oqpegGphwaI+kcmDtIFmyxrQhO5diprlPKbqyadS9qh1tHaKT6joP2w/fyoSIjpVd234
	KopHU9kSNQvgq4o3iyEX6Zc1OAEJWG5Q==
X-Received: from wmbeu9.prod.google.com ([2002:a05:600c:81c9:b0:49c:ce06:6657])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:81c8:b0:49d:1f10:8b9f
 with SMTP id 5b1f17b1804b1-49d1f109802mr48575265e9.7.1788954966686; Wed, 09
 Sep 2026 04:56:06 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:41 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8323; i=ardb@kernel.org;
 h=from:subject; bh=4dLVPZyjs94kAN2Ujs1pKn8L7TMMSfHm0tBktF2p2CE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp90qeZldv7k9n70TizgX+3jvH/3sKcYFLqs18hvk7
 0468OlFRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIJQeG/6FvuRTO6qQnb2f7
 6ypy2OeV7pJipxROq/snZOvuCzlKazL801mZtUnO7XZhsues9fLnc534VnxePPvJrGbz3vLJ+9X PMwAA
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-22-ardb+git@google.com>
Subject: [PATCH v2 10/10] efi/libstub: add initial Boot Loader Interface support
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vincent Mailhol <mailhol@kernel.org>

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
Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-a=
uto-generator.html

[3] GRUB -- =C2=A716.2 bli
Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodul=
e.html

[4] systemd -- systemd-boot UEFI Boot Manager
Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=3D1#L=
102

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
[ardb: - constify 'image' pointer parameter
       - pass efi_guid_t* to efi_snprintf()]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile   |  2 +-
 drivers/firmware/efi/libstub/bli.c      | 87 ++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c |  1 +
 drivers/firmware/efi/libstub/efistub.h  |  2 +
 drivers/firmware/efi/libstub/x86-stub.c |  1 +
 include/linux/efi.h                     | 22 +++++
 6 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/l=
ibstub/Makefile
index 12c0c7deb5cb..564773c89d14 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -66,7 +66,7 @@ KBUILD_AFLAGS			:=3D $(KBUILD_CFLAGS) -D__ASSEMBLY__
 lib-y				:=3D efi-stub-helper.o gop.o secureboot.o tpm.o \
 				   file.o mem.o random.o randomalloc.o pci.o \
 				   skip_spaces.o lib-cmdline.o lib-ctype.o \
-				   alignedmem.o printk.o vsprintf.o \
+				   alignedmem.o printk.o vsprintf.o bli.o \
 				   lib-ucs2_string.o
=20
 # include the stub's libfdt dependencies from lib/ when needed
diff --git a/drivers/firmware/efi/libstub/bli.c b/drivers/firmware/efi/libs=
tub/bli.c
new file mode 100644
index 000000000000..b2407f63b743
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
+static efi_guid_t loader_entry_guid =3D LINUX_EFI_LOADER_ENTRY_GUID;
+
+static const struct efi_hd_dev_path *
+efi_bli_find_hd_node(const struct efi_dev_path *path)
+{
+	const struct efi_dev_path *node;
+	u16 node_len;
+
+	for (node =3D path;
+	     node->header.type !=3D EFI_DEV_END_PATH &&
+	     node->header.type !=3D EFI_DEV_END_PATH2;
+	     node =3D (const void *)node + node_len) {
+		node_len =3D get_unaligned_le16(&node->header.length);
+
+		if (node_len < sizeof(node->header))
+			return NULL;
+
+		if (node->header.type !=3D EFI_DEV_MEDIA ||
+		    node->header.sub_type !=3D EFI_DEV_MEDIA_HARD_DRIVE)
+			continue;
+
+		if (node_len < sizeof(node->hd))
+			return NULL;
+
+		if (node->hd.partition_format !=3D EFI_HD_PARTITION_FORMAT_GPT ||
+		    node->hd.signature_type !=3D EFI_HD_SIGNATURE_TYPE_GUID)
+			continue;
+
+		return &node->hd;
+	}
+
+	return NULL;
+}
+
+static void efi_bli_populate_loader_part_uuid(const efi_loaded_image_t *im=
age)
+{
+	static efi_guid_t device_path_guid =3D EFI_DEVICE_PATH_PROTOCOL_GUID;
+	efi_char16_t partuuid[UUID_STRING_LEN + 1];
+	const struct efi_hd_dev_path *hd_node;
+	const struct efi_dev_path *path;
+
+	if (efi_bs_call(handle_protocol, efi_table_attr(image, device_handle),
+			&device_path_guid, (void **)&path) !=3D EFI_SUCCESS)
+		return;
+
+	hd_node =3D efi_bli_find_hd_node(path);
+	if (!hd_node)
+		return;
+
+	if (efi_snprintf(partuuid, ARRAY_SIZE(partuuid), "%pUl",
+			 &hd_node->signature) !=3D UUID_STRING_LEN)
+		return;
+
+	set_efi_var(L"LoaderDevicePartUUID", &loader_entry_guid,
+		    EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+		    sizeof(partuuid), partuuid);
+}
+
+void efi_bli_set_variables(const efi_loaded_image_t *image)
+{
+	static efi_char16_t loader_info[] =3D L"Linux EFI stub " UTS_RELEASE;
+	unsigned long size =3D 0;
+
+	if (!image)
+		return;
+
+	if (get_efi_var(L"LoaderInfo", &loader_entry_guid,
+			NULL, &size, NULL) !=3D EFI_NOT_FOUND)
+		return;
+
+	if (set_efi_var(L"LoaderInfo", &loader_entry_guid,
+			EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+			sizeof(loader_info), loader_info) !=3D EFI_SUCCESS)
+		return;
+
+	efi_bli_populate_loader_part_uuid(image);
+}
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi=
/libstub/efi-stub.c
index 42d6073bcd06..2a95f4ea104a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -165,6 +165,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 	dpy =3D setup_primary_display();
=20
 	efi_retrieve_eventlog();
+	efi_bli_set_variables(image);
=20
 	/* Ask the firmware to clear memory on unclean shutdown */
 	efi_enable_reset_attack_mitigation();
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/=
libstub/efistub.h
index 880c1d0c464b..4f9e7ae28b6c 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1072,6 +1072,8 @@ efi_status_t efi_random_alloc(unsigned long size, uns=
igned long align,
 			      int memory_type, unsigned long alloc_min,
 			      unsigned long alloc_max);
=20
+void efi_bli_set_variables(const efi_loaded_image_t *image);
+
 efi_status_t efi_random_get_seed(void);
=20
 efi_status_t check_platform_features(void);
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi=
/libstub/x86-stub.c
index cef32e2c82d8..b762f7f37f28 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -1014,6 +1014,7 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 	efi_random_get_seed();
=20
 	efi_retrieve_eventlog();
+	efi_bli_set_variables(image);
=20
 	setup_graphics(boot_params);
=20
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c35446a0b66f..ecb34be37a87 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -957,6 +957,17 @@ extern int efi_status_to_err(efi_status_t status);
 #define   EFI_DEV_END_INSTANCE			0x01
 #define   EFI_DEV_END_ENTIRE			0xFF
=20
+enum efi_hd_partition_format {
+	EFI_HD_PARTITION_FORMAT_MBR =3D 1,
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
=20
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
=20
--=20
2.55.0.1003.g10538fe699-goog

