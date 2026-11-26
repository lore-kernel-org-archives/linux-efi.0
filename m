Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795733073;
	b=rTS8Y1gR3gdqSOhtnjHAxZret2KVe2Mo/x95N7BGXbUKwy7Mip1n8oURVm/0l7U/2Ckk
	 gggzRNpWOdTiCbXtPCc1DnktKOMXn7Kx1biO1AzOxkAC3UXh4iwrCBYp3q8bbk+iCXknN
	 q5et2xDBaZJpRx7IkF/JiPndn2KssFUD+JHI9zKamZUt8ZYTZcpf5YV/jx1q7sZH63sNX
	 Y6M2ay40pbK/wcLhQLy2vIPSxk9BkyNMBsYmyW2r3gWZ0drrbRJXtb1SdQP/dhvJ+exTi
	 GkBeVPmCxQtOVq6mFQBieU4GW5F87Ps1OBp/VmGEA9MDkGxrvTtZrJshbMp5fFYcLVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795733073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=usEhFjzK0EuLfSMr+NYDnhNGDxV0hluIN7e+58uBfVI=;
	b=UXNVbaqsR9MKDMeQbMZuLyNr2RVqKodXavaQFQVefHZ5QNND5ikHefljIp+qAw9O+yg1
	 xLF+P3NPnkJrTdZa4xeGXOf4/FIzIbgqFvfX/ku98r27Zc+OrQnHIPhh1Fj7TdF7Tel0T
	 LQJPRyN27FHIyWpmLalM5uHR/kaVnco3vHl9mVLsVjmk3X/Ay5fYieP7H02ZXM5cdtBi7
	 R0vqt0RxrttzcT3bnB0Xv4D4Qut8cW76M7gVIFL3mw/eITy/TwZmPidCqFXP6+wF641U8
	 Qjp52xSb3VUKQaz5vhFfUT/HS+OIgnZEfbQ+zPPOm8xyLAD26qOX7/JL6D9tqTlj6XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U4b5tPXU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9AC606A31C;
	Thu, 26 Nov 2026 22:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U4b5tPXU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3841C1F000C1;
	Thu, 26 Nov 2026 22:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795733073;
	bh=usEhFjzK0EuLfSMr+NYDnhNGDxV0hluIN7e+58uBfVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4b5tPXUR0rOi93+uX8DX+nQczPUcU9jgjG07WLeB0uA0tU8quCsCLFDbJLtJl0Yx
	 Tl//LPYOgRLfUeM8XRvRJgjXgboYt5bELAyNfF73kHnheiQsOt9ClRnK92feJLsKaU
	 exlZdRuppnfytnhyP8JHOcyc/5LquuT44Gfc8Jcb+voOloe4Sz8MaEa6EXV6Zudo3s
	 9qkgwlk/Ta5apTqhCbkOn/8pesNJgYXZZ26KxvfRD166r3tptp+SYFmPqqh87dozUQ
	 hPSzlG3Hmd4X7OIPQ/LAMiaekRJ/qoNn2HMN4uAWp6onKP7jz3r3tI8eRclRc66LKK
	 tsJj7mFY/djfQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	linux-kbuild@vger.kernel.org
Subject: [PATCH 2/2] efi/zboot: Use ZSTD frame header for uncompressed payload size
Date: Thu, 26 Nov 2026 23:44:03 +0100
Message-ID: <20261126224400.10147-6-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126224400.10147-4-ardb@kernel.org>
References: <20261126224400.10147-4-ardb@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6127; i=ardb@kernel.org; h=from:subject; bh=8Sge2kx0RxFdWp6lGbl2lWCzY+WMsbz9TK44hS5/PtQ=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZtjm9m7WbamzHs2cbeHfttR2/My4vnkl0/04k+x1F93+ vZxXrhJRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiI4WKGPzxJf/cZflXvk8p7 7cb4r4FrU69g04EQu8PtC5+v4JnoFcPIcG/mGvXkwyxun70bRf7ZfFyzaFmPqVF79N29wa7fIv/ 28gMA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Pass --stream-size to zstd in cmd_zstd22 so the uncompressed content
size is recorded in the ZSTD frame header even when compressing from a
pipe, switch EFI zboot from zstd22_with_size to zstd22, and use
zstd_get_frame_header() in the ZSTD decompressor to obtain the
uncompressed allocation size.

This avoids corrupting the embedded ZSTD stream with a 4-byte trailing
size word from the perspective of standard zstd tooling, removes the
ZBOOT_SIZE_LEN adjustment from the zboot header, and makes reading the
trailing 32-bit uncompressed size specific to the GZIP decompressor
(where ISIZE is part of the format).

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile.zboot          |  8 +-------
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  5 +++--
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c | 17 ++++++++++++++---
 drivers/firmware/efi/libstub/zboot-header.S          |  2 +-
 drivers/firmware/efi/libstub/zboot.lds               |  1 -
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmware/efi/libstub/Makefile.zboot
index 52baacf3e9d94..1cd3a6ed7f223 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -12,16 +12,11 @@ quiet_cmd_copy_and_pad = PAD     $@
 $(obj)/vmlinux.bin: $(obj)/$(EFI_ZBOOT_PAYLOAD) FORCE
 	$(call if_changed,copy_and_pad)
 
-# in GZIP, the appended le32 carrying the uncompressed size is part of the
-# format, but in other cases, we just append it at the end for convenience,
-# causing the original tools to complain when checking image integrity.
 comp-type-y				:= gzip
 zboot-method-y				:= gzip
-zboot-size-len-y			:= 0
 
 comp-type-$(CONFIG_KERNEL_ZSTD)		:= zstd
-zboot-method-$(CONFIG_KERNEL_ZSTD)	:= zstd22_with_size
-zboot-size-len-$(CONFIG_KERNEL_ZSTD)	:= 4
+zboot-method-$(CONFIG_KERNEL_ZSTD)	:= zstd22
 
 $(obj)/vmlinuz: $(obj)/vmlinux.bin FORCE
 	+$(call if_changed,$(zboot-method-y))
@@ -37,7 +32,6 @@ aflags-zboot-header-$(EFI_ZBOOT_FORWARD_CFI) := \
 
 AFLAGS_zboot-header.o += -DMACHINE_TYPE=IMAGE_FILE_MACHINE_$(EFI_ZBOOT_MACH_TYPE) \
 			 -DZBOOT_EFI_PATH="\"$(abspath $(obj)/vmlinuz.efi.elf)\"" \
-			 -DZBOOT_SIZE_LEN=$(zboot-size-len-y) \
 			 -DCOMP_TYPE="\"$(comp-type-y)\"" \
 			 $(aflags-zboot-header-y)
 
diff --git a/drivers/firmware/efi/libstub/zboot-decompress-gzip.c b/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
index e97a7e9d3c980..f508816ac26dc 100644
--- a/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
+++ b/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/efi.h>
+#include <linux/unaligned.h>
 #include <linux/zlib.h>
 
 #include <asm/efi.h>
@@ -12,7 +13,6 @@
 #include "inflate.c"
 
 extern unsigned char _gzdata_start[], _gzdata_end[];
-extern u32 __aligned(1) payload_size;
 
 static struct z_stream_s stream;
 
@@ -38,7 +38,8 @@ efi_status_t efi_zboot_decompress_init(unsigned long *alloc_size)
 		goto out;
 	}
 
-	*alloc_size = payload_size;
+	/* the last 4 bytes of a GZIP stream carry the uncompressed size */
+	*alloc_size = get_unaligned_le32(_gzdata_end - 4);
 	return EFI_SUCCESS;
 out:
 	efi_free(zlib_inflate_workspacesize(), (unsigned long)stream.workspace);
diff --git a/drivers/firmware/efi/libstub/zboot-decompress-zstd.c b/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
index bde9d94dd2e3a..8a55a09641370 100644
--- a/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
+++ b/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
@@ -9,21 +9,32 @@
 #include "efistub.h"
 
 extern unsigned char _gzdata_start[], _gzdata_end[];
-extern u32 __aligned(1) payload_size;
 
 static size_t wksp_size;
 static void *wksp;
 
 efi_status_t efi_zboot_decompress_init(unsigned long *alloc_size)
 {
+	zstd_frame_header header;
 	efi_status_t status;
+	size_t ret;
+
+	ret = zstd_get_frame_header(&header, _gzdata_start,
+				    _gzdata_end - _gzdata_start);
+	if (ret != 0 ||
+	    header.frameContentSize == 0 ||
+	    header.frameContentSize == ZSTD_CONTENTSIZE_UNKNOWN ||
+	    header.frameContentSize != (unsigned long)header.frameContentSize) {
+		efi_err("ZSTD-compressed data has an invalid frame header\n");
+		return EFI_LOAD_ERROR;
+	}
 
 	wksp_size = zstd_dctx_workspace_bound();
 	status = efi_allocate_pages(wksp_size, (unsigned long *)&wksp, ULONG_MAX);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	*alloc_size = payload_size;
+	*alloc_size = header.frameContentSize;
 	return EFI_SUCCESS;
 }
 
@@ -34,7 +45,7 @@ efi_status_t efi_zboot_decompress(u8 *out, unsigned long outlen)
 	int retval;
 
 	ret = zstd_decompress_dctx(dctx, out, outlen, _gzdata_start,
-				   _gzdata_end - _gzdata_start - 4);
+				   _gzdata_end - _gzdata_start);
 	efi_free(wksp_size, (unsigned long)wksp);
 
 	retval = zstd_get_error_code(ret);
diff --git a/drivers/firmware/efi/libstub/zboot-header.S b/drivers/firmware/efi/libstub/zboot-header.S
index b6431edd0fc96..e8da65faf8b7b 100644
--- a/drivers/firmware/efi/libstub/zboot-header.S
+++ b/drivers/firmware/efi/libstub/zboot-header.S
@@ -17,7 +17,7 @@ __efistub_efi_zboot_header:
 	.long		IMAGE_DOS_SIGNATURE
 	.ascii		"zimg"					// image type
 	.long		__efistub__gzdata_start - .Ldoshdr	// payload offset
-	.long		__efistub__gzdata_size - ZBOOT_SIZE_LEN	// payload size
+	.long		__efistub__gzdata_size			// payload size
 	.long		0, 0					// reserved
 	.asciz		COMP_TYPE				// compression type
 	.org		.Ldoshdr + 0x38
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index a785c01237497..d7633f5d61c3b 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -17,7 +17,6 @@ SECTIONS
 	.rodata : ALIGN(8) {
 		__efistub__gzdata_start = .;
 		*(.gzdata)
-		__efistub_payload_size = . - 4;
 		__efistub__gzdata_end = .;
 		*(.rodata* .init.rodata* .srodata*)
 
-- 
2.47.3

