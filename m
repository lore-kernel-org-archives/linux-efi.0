From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] efi: efi_guid_t must be 64-bit aligned
Date: Sat, 15 Dec 2018 22:18:08 +0100
Message-ID: <20181215211808.16837-1-xypron.glpk@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
List-Id: linux-efi@vger.kernel.org

The UEFI Specification Version 2.7 Errata A defines:

"EFI_GUID
128-bit buffer containing a unique identifier value.
Unless otherwise specified, aligned on a 64-bit boundary."

Before this patch efi_guid_t was 8-bit aligned.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 845174e113ce..c1a1931238c5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -48,7 +48,7 @@ typedef u16 efi_char16_t;		/* UNICODE character */
 typedef u64 efi_physical_addr_t;
 typedef void *efi_handle_t;
 
-typedef guid_t efi_guid_t;
+typedef guid_t efi_guid_t __aligned(8);
 
 #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
 	GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
-- 
2.19.2
