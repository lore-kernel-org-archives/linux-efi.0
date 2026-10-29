Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295044;
	b=4PmXIFUGcnRZeUJjOw5gHaEyOYlUIau4c+Tl+IRss+SDLq5B9qor4h05siShbClRsmm7
	 BW+JccTz+SubbhYG9oHTgCv3u+I7uhR9P7tfUxj1AFHW1Y5cbtfKjo2y1yfkdYe9hMEf+
	 TNWEcyxauiZkNQEBVordwznp4x3yI123RnEIf/c+V8jwQg0I30WLWFoJlGksMW43rgs7A
	 zdQScqJ1OvGUQdJeMJqm7+WVMvXM3jRP/HQB2CDxCdGrPRePCLhv1tPBwYv6m/Ps22T8c
	 A8HQZCapfSBEWK0y16nk/2Z7/wVLqXy/RnxHNeM7z4ouDJKuIj2xkee5lWIeX4EMFPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295044;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vSsiRYPYB4jWimWdqbg3QYop0paA6TDT/mhOyO7eWso=;
	b=xTC0n0SAnw7+FE0aHdErVbBIYrxcZ24VZBrq3nmO1w9Db6hbodGRR6ED3RAUr1zIcvKJ
	 aFjPrwASyjDGt7rIkIOfPfHhBtu/zSllZP4uZ0S5VGSkANNxBZLC9eqSBgds94Mt+/ucJ
	 TEDQj0SqrrdCx0lxZvNt7WlvENKATJu6JY5CEn0EUUZOtg369bRxw3+M8PDF4izhlbPYQ
	 r/ebODuzI1Z35iQFaY+3wiark928vIEVlf9+ks8CutyDy1fPZaey6cW8ezLSJCf9o8d7W
	 0b7oNle8MPu207lZU93G+wCxxHSRjGSdbfLhxGp6pVu7qaw/iq1in3ZiX1ELTN60kQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B5G3Iwab;
	arc=none smtp.remote-ip=91.218.175.156
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B80606A31D
	for <linux-efi@vger.kernel.org>; Thu, 29 Oct 2026 17:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72B80606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B5G3Iwab
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0F/90IUVwRzQHSP39TV73suxQSXvMV7pstypaG7hBwQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295041; v=1; x=1793899841;
 b=B5G3IwabBMHPnujE3lciJhtNmLzq0vL6kKgN+B9BoJJRQNzD1JRXGJIjlOnXv7nTmeKwBwit
 Gbst6pkvpR12AG2H3R37QxsGSDImnf24Zd+5JJvSjyvnHwRufy4i5jK/UYVvpcMnjw7sh9D1cD/
 tQCXxYHlRK9WVrKbZvbGIcnk=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 75f3584368055110;
	Thu, 29 Oct 2026 17:30:16 +0000
X-Mizu-Trace-ID: 75f3584368055110
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 2/8] kho: Write KHO state to the EFI table at kexec time
Date: Fri, 30 Oct 2026 02:29:49 +0900
Message-ID: <20261029172956.20791-3-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

On arm64 and riscv, KHO addresses and sizes are passed through /chosen
properties in the boot FDT prepared for each kexec image. On x86, they
are passed through a SETUP_KEXEC_KHO record linked from the image's boot
parameters. These records are per-image, unlike the shared EFI table.

The EFI table is shared. A KHO-enabled normal image and a crash image
can both be loaded, but need different contents: the normal image needs
the KHO addresses, while the crash image needs an empty table. Updating
the table at load time cannot satisfy both.

Write the table in kernel_kexec() and __crash_kexec(), once the image
that will run is known. kho_update_efi_table() fills the table from that
image, or zeroes it if the image has no KHO state, including images
loaded with kexec_load().

Clear the table even with CONFIG_KEXEC_HANDOVER disabled, since the
kernel may have inherited a populated table. This prevents a later
kernel from trying to revive obsolete KHO state.

The table stores the size of the bootmem area list (bufsz), not of its
page-aligned segment, as the FDT and x86 code do. If updating or clearing
the table fails, kernel_kexec() returns before liveupdate_reboot(), so
LUO does not save state that the next kernel would not find.
__crash_kexec() ignores the error so the crash boot can still proceed.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 kernel/crash_core.c                |  6 ++++++
 kernel/kexec_core.c                |  5 +++++
 kernel/kexec_internal.h            |  8 ++++++++
 kernel/liveupdate/kexec_handover.c | 26 ++++++++++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..0f77adc0928b 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -138,6 +138,12 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
+			/*
+			 * A crash image has no KHO state.  Zero the EFI
+			 * table so the crash kernel has no inherited KHO state.
+			 */
+			(void)kho_update_efi_table(kexec_crash_image);
+
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d05..37597091770a 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1146,6 +1146,11 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	/* Write this image's KHO state into the EFI table. */
+	error = kho_update_efi_table(kexec_image);
+	if (error)
+		goto Unlock;
+
 	if (!kexec_image->preserve_context) {
 		error = liveupdate_reboot();
 		if (error)
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 228bb88c018b..cfdd0b158f72 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -2,6 +2,7 @@
 #ifndef LINUX_KEXEC_INTERNAL_H
 #define LINUX_KEXEC_INTERNAL_H
 
+#include <linux/efi.h>
 #include <linux/kexec.h>
 
 struct kexec_segment;
@@ -46,6 +47,7 @@ struct kexec_buf;
 int kho_locate_mem_hole(struct kexec_buf *kbuf,
 			int (*func)(struct resource *, void *));
 int kho_fill_kimage(struct kimage *image);
+int kho_update_efi_table(struct kimage *image);
 #else
 static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 				      int (*func)(struct resource *, void *))
@@ -54,5 +56,11 @@ static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 }
 
 static inline int kho_fill_kimage(struct kimage *image) { return 0; }
+
+static inline int kho_update_efi_table(struct kimage *image)
+{
+	/* The previous kernel may have left KHO state in the EFI table. */
+	return efi_kho_update(0, 0, 0, 0);
+}
 #endif /* CONFIG_KEXEC_HANDOVER */
 #endif /* LINUX_KEXEC_INTERNAL_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9a53d7750367..74c4633f5afc 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/crash_dump.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
+#include <linux/efi.h>
 #include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -2094,6 +2095,31 @@ int kho_fill_kimage(struct kimage *image)
 	return 0;
 }
 
+/*
+ * Write the KHO state of @image into the EFI table, or zero the table if
+ * @image has none.
+ *
+ * There is one table, but the normal and the crash image can both be loaded,
+ * so the table is written just before @image runs rather than at load time.
+ * Crash images, images loaded with kexec_load() and images loaded with KHO
+ * disabled have no KHO state. Zeroing the table for them makes the next
+ * kernel boot without inherited KHO state instead of reading stale addresses.
+ */
+int kho_update_efi_table(struct kimage *image)
+{
+	int err;
+
+	if (!image->kho.fdt || !image->kho.bootmem)
+		return efi_kho_update(0, 0, 0, 0);
+
+	err = efi_kho_update(image->kho.fdt, PAGE_SIZE,
+			     image->kho.bootmem->mem, image->kho.bootmem->bufsz);
+	if (err)
+		pr_warn("failed to update EFI config table: %pe\n", ERR_PTR(err));
+
+	return err;
+}
+
 static int kho_walk_bootmem(struct kexec_buf *kbuf,
 			    int (*func)(struct resource *, void *))
 {
-- 
2.53.0

