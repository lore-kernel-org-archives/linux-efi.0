From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 5/8] arm64/efi: set EFI_ALLOC_ALIGN to 64 KB
Date: Mon, 22 Dec 2014 10:59:01 +0000
Message-ID: <1419245944-2424-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419245944-2424-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Set EFI_ALLOC_ALIGN to 64 KB so that all allocations done by the stub
are naturally compatible with a 64 KB granule kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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
