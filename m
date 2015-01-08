From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 5/8] arm64/efi: set EFI_ALLOC_ALIGN to 64 KB
Date: Thu,  8 Jan 2015 18:48:31 +0000
Message-ID: <1420742914-2404-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com, will.deacon@arm.com, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org, dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Set EFI_ALLOC_ALIGN to 64 KB so that all allocations done by the stub
are naturally compatible with a 64 KB granule kernel.

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/efi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a34fd3b12e2b..71291253114f 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -44,4 +44,6 @@ extern void efi_idmap_init(void);
 
 #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
 
+#define EFI_ALLOC_ALIGN		SZ_64K
+
 #endif /* _ASM_EFI_H */
-- 
1.8.3.2
