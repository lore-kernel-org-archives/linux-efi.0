Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1632A455604
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 10:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516637; cv=none; b=oTgEaMKbDfgTwvmsCCgCABos/bbM4B3Kp3TDpr2CALwErUrBRYhNHs0xztsuYuyIzdVSv05rRFPjohQHK9Jc+Je5Xj7pQLUU9YcGRvP9lbJEPEH9W2tGCDO1e1nlMxpR2LkgZY1dPQAYVH9tVTeEHz3Ww2ci1olRAVqGVQY8cXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516637; c=relaxed/simple;
	bh=PHW2ypkolV+36MeBrIflBY2kZtvuYhFSqnZa7Us0mSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7KT9JsTI5JyQozKteVAuDPgvLAlfbHdiZi18Xcw9LDir0+Y+iZuyRSVRtqKThRrRudqk8U8GImTjTkfcd7LT5fxWpF8ANONxIPiYWzYLXDyxHzAhAHk0HMYemKjHmquiNwvs6uz7r/YSFFbgCnimGO4/RNWbtqeRRGrJhXo/qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AYLzmbE/; arc=none smtp.client-ip=91.218.175.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AYLzmbE/"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PHW2ypkolV+36MeBrIflBY2kZtvuYhFSqnZa7Us0mSc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516628; v=1; x=1789121428;
 b=AYLzmbE/FGIjqb/RxtzTS+DUSvR0jYavfFzcCkRfshJdUEgZgXhn6WTPep8DaP7n2XdwA43l
 uF6FXivTRhc2Veyw3OUozQ88pX6+XXgimDqqKGuzCl31nBpIXGaWjqwr5rDTl/jKg7ZwV6Mlk3I
 WUckN/ZCqvqkYLWdPEYlL8+o=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b181acf3ff0b524f;
	Fri, 04 Sep 2026 10:10:27 +0000
X-Mizu-Trace-ID: b181acf3ff0b524f
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
Subject: [PATCH v5 2/5] liveupdate: synchronize EFI KHO channel at execution
Date: Fri,  4 Sep 2026 18:08:49 +0800
Message-ID: <20260904100852.26006-3-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

The EFI KHO configuration table is a global channel. Updating it while
a candidate kexec image is still being loaded can leave the channel
pointing at the failed candidate even though the previous image remains
installed. Synchronize it instead from the image selected for execution.

Use the actual scratch payload size rather than its page-aligned segment
size, and propagate update failures before live-update serialization.
Keep clearing the channel for cold and crash images best-effort.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 kernel/crash_core.c                |  7 +++++++
 kernel/kexec_core.c                |  5 +++++
 kernel/kexec_internal.h            |  3 +++
 kernel/liveupdate/kexec_handover.c | 33 ++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..6166ce4203d3 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -138,6 +138,13 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
+			/*
+			 * A crash image carries no KHO state: clear the
+			 * transport so the crash kernel boots cold instead
+			 * of reviving from stale state.
+			 */
+			(void)kho_sync_channel(kexec_crash_image);
+
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d05..147f5b5b23d4 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1146,6 +1146,11 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	/* Synchronize the handover transport with the image being executed. */
+	error = kho_sync_channel(kexec_image);
+	if (error)
+		goto Unlock;
+
 	if (!kexec_image->preserve_context) {
 		error = liveupdate_reboot();
 		if (error)
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 228bb88c018b..4d4c2290e85c 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -46,6 +46,7 @@ struct kexec_buf;
 int kho_locate_mem_hole(struct kexec_buf *kbuf,
 			int (*func)(struct resource *, void *));
 int kho_fill_kimage(struct kimage *image);
+int kho_sync_channel(struct kimage *image);
 #else
 static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 				      int (*func)(struct resource *, void *))
@@ -54,5 +55,7 @@ static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 }
 
 static inline int kho_fill_kimage(struct kimage *image) { return 0; }
+
+static inline int kho_sync_channel(struct kimage *image) { return 0; }
 #endif /* CONFIG_KEXEC_HANDOVER */
 #endif /* LINUX_KEXEC_INTERNAL_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 39f489a258d9..3aa5c66dfc6d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -14,6 +14,7 @@
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
+#include <linux/efi.h>
 #include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -2074,6 +2075,38 @@ int kho_fill_kimage(struct kimage *image)
 	return 0;
 }
 
+/*
+ * Synchronize the handover transport with the image that is about to be
+ * executed.  The EFI config table channel is global, while kexec keeps
+ * separate images for a normal reboot and for crash.  Write the state of the
+ * selected image immediately before it is executed, rather than while a
+ * candidate image is being loaded, so a failed replacement cannot leave the
+ * channel pointing at that failed image.
+ *
+ * An image loaded through the legacy kexec_load() syscall, a crash image, or
+ * an image loaded while KHO is disabled carries no handover state.  Clear the
+ * channel for those images so the next kernel boots cold instead of reviving
+ * from stale state.  Clearing is best-effort because an absent channel cannot
+ * affect a cold boot.
+ */
+int kho_sync_channel(struct kimage *image)
+{
+	int err;
+
+	if (!image->kho.fdt || !image->kho.scratch) {
+		efi_kho_update(0, 0, 0, 0);
+		return 0;
+	}
+
+	err = efi_kho_update(image->kho.fdt, PAGE_SIZE,
+			     image->kho.scratch->mem,
+			     image->kho.scratch->bufsz);
+	if (err)
+		pr_warn("failed to update EFI config table: %d\n", err);
+
+	return err;
+}
+
 static int kho_walk_scratch(struct kexec_buf *kbuf,
 			    int (*func)(struct resource *, void *))
 {
-- 
2.53.0

