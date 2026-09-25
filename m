Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3BA472521;
	Fri, 25 Sep 2026 07:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322725; cv=none; b=YZXmGbTMbt/SDg5W5Qg/ZRRf7OVMB+OWCHVxcWSQvIfSx1JsgAEDk+1U1ii85vbJaTfBlfJU7x2MQTt/tTP2vKSPA7Fd8Cb4o1Zx8azja9jDLbZdL/3YHBXdCrJdbO9sq1T1ZuoFvHjCIVaH+bPw1azmtxHUjP5EhmXsJfrnxow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322725; c=relaxed/simple;
	bh=71mGxAzLcQPoNeORpGuq8IqoDwiJDyUGD/Ks++Ev8Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhlHPw3apOllF0xfkfGqtEessiT1s0bFmoMC76YjjKMaCySbzvDo0rb14lYDHJIcxzybq8VhFKwVzN2k9rMTUr7lnJO8A0yiStOluVdKsZKZ7YYlbFTvEC+Hkz+rWH/+3oYkNNGYbH+D5LJHeETcOmqtg96KdGWD9Roj8zfYbhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2syX2Mo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2syX2Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6141F000FF;
	Fri, 25 Sep 2026 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322724;
	bh=9YY5Gywu/GZ0CW+bb3YA7j7g0CCf7ew/7WGXkzNuqGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2syX2Mox5sq7+fM+k341dG3u8WXVLimWZysbqQ3cSwDwjttVWA5XvlhiwXD5GAoO
	 g4QpBPpv9pvTgYEeiOVYP4elsCJJbVNYkd8lAG4fFvXbaEA743/+lVEPpOVYUFfuOD
	 MFsx0TnM6DPo3b51hQK/Q9Gh9OVU+X2hLgrePmWPrePFWVXF88Emy9MEp77LZ9okHo
	 z1znVEl11IqJGgY/r00im/M7fF8ElUeEuHO6YbAdZXeIuGDA2PO8z1Oiwo8l72k0JQ
	 cSML3JQ0GmpkDDAcgSV4BkoHdqwgql8RYIPTG0m+7LOKe8fBLhbMcWdJPAusO3bKIt
	 9lFHdI9HMBBrg==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 2/3] x86/boot: Move unaccepted memory handling out of the decompressor
Date: Fri, 25 Sep 2026 09:51:40 +0200
Message-ID: <20260925075137.44298-7-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925075137.44298-5-ardb@kernel.org>
References: <20260925075137.44298-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6435; i=ardb@kernel.org; h=from:subject; bh=71mGxAzLcQPoNeORpGuq8IqoDwiJDyUGD/Ks++Ev8Po=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGLK2aXCxlndqb14Yt83DYtIzA7870/TD5qvs+jD5bMoFo 51sBRe+d0xlYRDmZJAVU2TZqZzT/dpF9J2+QmUOzBxWJpAhDFycAjCRC9yMdYZ7zn1tF/c+fqd8 3ua/hzOTvT9PbZ6mdOTzvk31lVwcYQJ/OpbfXC++Q0GaI2daac4xBcaGm4rFOScn99ZlH3u7ZKu g4vT0jSm8vMair9KEW6PPzGeOcvyVd+bQT8VVE/LP6sSKve0FAA==
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
 drivers/firmware/efi/libstub/x86-stub.c | 39 ++++++++++++++++++
 4 files changed, 41 insertions(+), 44 deletions(-)

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
index 9e7a077c445d..4b5db43cc0b1 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -517,6 +517,7 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
+bool early_is_sevsnp_guest(void);
 int prepare_pte_enc(struct pte_enc_desc *d);
 void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot);
 void snp_kexec_finish(void);
@@ -626,6 +627,7 @@ static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
+static inline bool early_is_sevsnp_guest(void) { return false; }
 static inline int prepare_pte_enc(struct pte_enc_desc *d) { return 0; }
 static inline void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot) { }
 static inline void snp_kexec_finish(void) { }
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8..80556a7e7552 100644
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
@@ -1068,3 +1070,40 @@ void efi64_stub_entry(efi_handle_t handle, efi_system_table_t *sys_table_arg,
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
+		u32 eax = TDX_CPUID_LEAF_ID, sig[3] = {};
+
+		native_cpuid(&eax, &sig[0], &sig[2], &sig[1]);
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
2.53.0

