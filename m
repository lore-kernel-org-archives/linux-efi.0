Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6521E39A06D;
	Mon, 14 Sep 2026 18:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411090; cv=none; b=ruw7DOWQhXGjLYVZ3/2QljdHNHEJqOtqyemo22nsEMqGITSKhcx+4WmVe+ocTEB147nc7ZQKUgu/UuboY0/mOhRDUu5jQJpjPos9EZ48KHTLi0Nc4FKYaptga/K7jnqGYzxElvgIaGstAUntL+mxjMkeoPbIjoFBwcZEqlLq+Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411090; c=relaxed/simple;
	bh=buo+TV4B9A9ue04d3G5s3ntT0h/OLrZvRPQ+pXGsoVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUzdnurV65MFbOXLBKxKauP4+Fc+e/TBlOQtFos+yvvw2cHxdQTYjRFKlvhBavPZooP4BwlmGftzfIXH8HOG4KFUmNVOzO47q9oujbFW9TuIXwVfqs4jms4aVu/xAYNwurJfARNohH2L8tjoDMscoj1jxzQbOLpx2k+E2mwY8Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGHNSAzR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGHNSAzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0713A1F00893;
	Mon, 14 Sep 2026 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411081;
	bh=Z4o56JwkEFW73boPUFtrcKj3thXmqi1LZKtly3vu1cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGHNSAzR/YhH3QxWKSpLNHwFdrKTCQM++s4yVnSlTjpF5i0eKHg87SWTJS+60Jz6O
	 tmd2pV1U9ekBH9l7e1TB26XBFYY95/AeNM6M+abVf2wXus84n+3nw/BnoVaaZFjdBx
	 Z+EEynR3KHL8940RmbcPqrPx1iIsaeLWq++uK8z9E703MistGlNSU9AFtPZGysg/EO
	 NB7SKar172Fc+bdrEHyaVuwD5rOoYj09bbgJl+NWYJZfKGgnJj1jPbQoiULfZyrYbe
	 IPPb4MwDvV9sfDVUuSFtPwvAAd+ZqpTzW5YpMDHphkO184NNB0+5XcktIC/58Efx2q
	 8R0tB+TXRJqhQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH 2/3] x86/boot: Move unaccepted memory handling out of the decompressor
Date: Mon, 14 Sep 2026 20:37:48 +0200
Message-ID: <20260914183745.37538-7-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914183745.37538-5-ardb@kernel.org>
References: <20260914183745.37538-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5848; i=ardb@kernel.org; h=from:subject; bh=buo+TV4B9A9ue04d3G5s3ntT0h/OLrZvRPQ+pXGsoVI=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuF3c/iOyf69Vw8uI/N/aa/MfteQeRJ95K8nnX/EyO1N x08a/yqo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzE+i0jw/JJfrGeLsFepx71 M36V3WxxgW12rvHh6UIF+84wm1kv3c7wP+HCpktyPm+FS1uk/lZGLE7e5Cup9bbP46uts8qH1Zv 9WAA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

arch_accept_memory() is an arch-specific hook that is required by the
EFI stub when processing memory that the firmware reports to the OS as
EFI_UNACCEPTED_MEMORY.

This hook is called after ExitBootServices() has been called, as before
that point, the EFI memory map may get updated behind the back of the
running EFI stub, making it difficult to get a stable view on it while
iterating over the entries.

Currently, the x86 version of this hook is implemented in its
decompressor rather than in the EFI stub itself, in a manner that is
problematic: when an error occurs, it calls the decompressor's error()
routine, but without having gone through the decompressor initialization
code. This means it will resort to direct port I/O rather than the
hypercall based interface that TDX guests would use otherwise.

Conceptually, code that is only called from the EFI stub, and never by
the decompressor when doing legacy boot, belongs in the EFI stub and not
in the decompressor.

So move it into the x86-specific EFI stub code, replacing the error() on
the TDX path with tdx_panic(), and dropping the error() when no CC
support is detected - the kernel can decide what to do in this case
after it has booted.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/mem.c          | 42 --------------------
 arch/x86/boot/compressed/sev.h          |  2 -
 arch/x86/include/asm/sev.h              |  2 +
 drivers/firmware/efi/libstub/x86-stub.c | 40 +++++++++++++++++++
 4 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/arch/x86/boot/compressed/mem.c b/arch/x86/boot/compressed/mem.c
index 0e9f84ab4bdc..1721af3a8039 100644
--- a/arch/x86/boot/compressed/mem.c
+++ b/arch/x86/boot/compressed/mem.c
@@ -2,48 +2,6 @@
 
 #include "error.h"
 #include "misc.h"
-#include "tdx.h"
-#include "sev.h"
-#include <asm/shared/tdx.h>
-
-/*
- * accept_memory() and process_unaccepted_memory() called from EFI stub which
- * runs before decompressor and its early_tdx_detect().
- *
- * Enumerate TDX directly from the early users.
- */
-static bool early_is_tdx_guest(void)
-{
-	static bool once;
-	static bool is_tdx;
-
-	if (!IS_ENABLED(CONFIG_INTEL_TDX_GUEST))
-		return false;
-
-	if (!once) {
-		u32 eax, sig[3];
-
-		cpuid_count(TDX_CPUID_LEAF_ID, 0, &eax,
-			    &sig[0], &sig[2],  &sig[1]);
-		is_tdx = !memcmp(TDX_IDENT, sig, sizeof(sig));
-		once = true;
-	}
-
-	return is_tdx;
-}
-
-void arch_accept_memory(phys_addr_t start, phys_addr_t end)
-{
-	/* Platform-specific memory-acceptance call goes here */
-	if (early_is_tdx_guest()) {
-		if (!tdx_accept_memory(start, end))
-			panic("TDX: Failed to accept memory\n");
-	} else if (early_is_sevsnp_guest()) {
-		snp_accept_memory(start, end);
-	} else {
-		error("Cannot accept memory: unknown platform\n");
-	}
-}
 
 bool init_unaccepted_memory(void)
 {
diff --git a/arch/x86/boot/compressed/sev.h b/arch/x86/boot/compressed/sev.h
index 22637b416b46..62e50c2e71ed 100644
--- a/arch/x86/boot/compressed/sev.h
+++ b/arch/x86/boot/compressed/sev.h
@@ -14,7 +14,6 @@
 
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 sev_get_status(void);
-bool early_is_sevsnp_guest(void);
 
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
@@ -37,7 +36,6 @@ static inline void sev_es_wr_ghcb_msr(u64 val)
 
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 sev_get_status(void) { return 0; }
-static inline bool early_is_sevsnp_guest(void) { return false; }
 
 #endif
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9e7a077c445d..843bf463d14d 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -464,6 +464,8 @@ static __always_inline void sev_es_nmi_complete(void)
 extern int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd);
 extern void sev_enable(struct boot_params *bp);
 
+bool early_is_sevsnp_guest(void);
+
 /*
  * RMPADJUST modifies the RMP permissions of a page of a lesser-
  * privileged (numerically higher) VMPL.
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8..5009623e4a37 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/stddef.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/efi.h>
 #include <asm/e820/types.h>
 #include <asm/setup.h>
@@ -17,6 +18,7 @@
 #include <asm/boot.h>
 #include <asm/kaslr.h>
 #include <asm/sev.h>
+#include <asm/shared/tdx.h>
 
 #include "efistub.h"
 #include "x86-stub.h"
@@ -1068,3 +1070,41 @@ void efi64_stub_entry(efi_handle_t handle, efi_system_table_t *sys_table_arg,
 		      struct boot_params *boot_params);
 #endif
 #endif
+
+#ifdef CONFIG_UNACCEPTED_MEMORY
+/*
+ * process_unaccepted_memory() is called after ExitBootServices(), and so these
+ * memory acceptance routines cannot rely on EFI protocols for detecting the
+ * presence of TDX or SEV-SNP, or emit any kind of output if any error
+ * conditions are detected.
+ */
+static bool early_is_tdx_guest(void)
+{
+	static bool once;
+	static bool is_tdx;
+
+	if (!IS_ENABLED(CONFIG_INTEL_TDX_GUEST))
+		return false;
+
+	if (!once) {
+		u32 eax, sig[3];
+
+		cpuid_count(TDX_CPUID_LEAF_ID, 0, &eax,
+			    &sig[0], &sig[2],  &sig[1]);
+		is_tdx = !memcmp(TDX_IDENT, sig, sizeof(sig));
+		once = true;
+	}
+
+	return is_tdx;
+}
+
+void arch_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	if (early_is_tdx_guest()) {
+		if (!tdx_accept_memory(start, end))
+			tdx_panic("Failed to accept memory");
+	} else if (early_is_sevsnp_guest()) {
+		snp_accept_memory(start, end);
+	}
+}
+#endif
-- 
2.47.3

