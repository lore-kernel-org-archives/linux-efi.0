From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] efi: efi_guid_t must be 64-bit aligned
Date: Mon, 17 Dec 2018 19:02:14 +0100
Message-ID: <20181217180214.9436-3-ard.biesheuvel@linaro.org>
References: <20181217180214.9436-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181217180214.9436-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>, Qian Cai <cai@gmx.us>
List-Id: linux-efi@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

The UEFI Specification Version 2.7 Errata A defines:

"EFI_GUID
128-bit buffer containing a unique identifier value.
Unless otherwise specified, aligned on a 64-bit boundary."

Before this patch efi_guid_t was 8-bit aligned.

Note that this could potentially trigger alignment faults during
EFI runtime services calls on 32-bit ARM, given that it does not
permit load/store double or load/store multiple instructions to
operate on memory addresses that are not 32-bit aligned.

Cc: <stable@vger.kernel.org> # v4.9+, or earlier if possible
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 100ce4a4aff6..e6480c805932 100644
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
2.17.1
