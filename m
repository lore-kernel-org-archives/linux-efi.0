Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C80E37AA78
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570060; cv=none; b=ofp9P5qFvwgJfK9tZPTALdHlSh/nsoMK18Ah3QJqT/Mjf+5MHto/D69Ln11Mgh5PKVshrbi4woKCg5oZNaz/MNStqPdbc656wWJPsRoqiXtskoNP2pReQAH8273KcN7JakWtQG1y7H9bI050FZuCEueoGmoJ8QlRjhBJFsJUbf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570060; c=relaxed/simple;
	bh=Z/PHy8SqOY039ZfzHL4rdkKTKv2Tm1OexHtDCOj+1Zo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rk3EZVg81DJ/M0a69vWlmHTnGmx/dUQ7StpILuAHM5cJKyEMAAaLRZYR1vVZjmo/fHqmR9QNJfB4SSARqiKDYTD/FckuqDRfdMtp2FPlpyCicVbxM6p90+9IYOpu60cZA/sYY3noOhfxk97dy9cxg+l4FfXWihdox9fzaK+nTHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cF5Erw+u; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cF5Erw+u"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4870eda3782so585980f8f.0
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570056; x=1790174856; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZM3fU71DKklu1u+zDqECfkv49Iwpg2mCdspvEHepLy4=;
        b=cF5Erw+umUYbkRqqX+ckgZPQExZ5ps3OIaRic/OBIDjNarU9ARTl1huomfuarlKq7v
         M6l8BLG4EybH1lnR60fYfg8xRbs6jR5f6bRVwD88MXNn7LegqYodWClTWyulS9gwgmae
         XCYndJHVMDhA4pDEjNscx99H+5coI92kYOnTdiPNJt7MGTLEp2LKNM2+G0Nu+zGf6fwu
         YU35UWQMrunMBPMcp8dsfOsY6QYrM/WZwoelTFO7Rjl/ubyhIp5wRrD+Sv7o1jQe1oGr
         UqgQxX8gmN0RI+Qfk+dIgS9kbGqIbpwFhep5ZveR3KgkkA15rTlTxPSB3yPQ2nfq/6n9
         9jDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570056; x=1790174856;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZM3fU71DKklu1u+zDqECfkv49Iwpg2mCdspvEHepLy4=;
        b=F4AzsnTUs6rLlNAwzjpmRTuQaseSwH/MD+o10ERCRuVncrcReOLlkrngORPTuK7rgV
         KDxYkyHo1ePXFrHTi2ISjKA+wJTs43UVU4357rmYtUrNGV/PSNg2hnLomt+hCY/DDZBd
         ZcTo5jY8UvO3wR3TTJuNvvcMghn3Bd6GyotYXhSzaLPUdKYFYAcIjDsnl07BZMCI59pt
         TduUJOxzo0j8Upr8QyfldYfW77cjCRLFpv6za+FnCaPKnKLSkPN3zKmDpkA3E/zBzb5a
         cdlkDpNsXkAwLfmn5wgk9gqEzs6ffehSLewToOV9lKxSPZfEp8PbJlzXaK5KR1Nygfw5
         HqKw==
X-Gm-Message-State: AFuF++myaSgAt0f6fgRYUplj4lSNpRqc+nW8alNL3+RajI07EtEYQ3fL
	Un3NLyzOimAbXIVyYhlYTXpwWHva6y8Z1wboMukieJfy0nn7N1xjORfBf9s0tIXqvC18u5YUjLj
	pHEcwRM3Uea9xb+8f8Qj/GaEi9lhTyrBK6w52ZQhyHx9+NOX0TWVHp4VWwBvHFV8M/HPyiGMYZo
	ea42dyFNlUFZmdatwA/BW68w4WWRc9Og==
X-Received: from wmbf2.prod.google.com ([2002:a05:600c:5942:b0:499:4c8d:551f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b58:b0:49c:fa21:e749
 with SMTP id 5b1f17b1804b1-49eb733e3b5mr35778325e9.31.1789570056169; Wed, 16
 Sep 2026 07:47:36 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:57 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8323; i=ardb@kernel.org;
 h=from:subject; bh=NfkFq12GKt3yz40ChbwrvQeuiqCTEPkRCNxLFhlu1HY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6idLbji1b+ZnEToufergu00R0bPa5zzS2pO1/n8xX
 9FEr+0GHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAip+4y/NOvPpu746Dd90vf
 zpRv25uprXNpqbxQaPXk6+/untJf1DGb4Q+nT5l98nT5yYH3S5kvLjPfZ5S04Eb429OFoo5bP7x yd2YCAA==
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-20-ardb+git@google.com>
Subject: [PATCH v3 9/9] efi/libstub: add initial Boot Loader Interface support
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
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
2.55.0.1032.g73a4cd73de-goog

