From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 02/14] efi/libstub: arm64: use hidden attribute for struct screen_info reference
Date: Fri, 18 Aug 2017 20:49:35 +0100
Message-ID: <20170818194947.19347-3-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

To prevent the compiler from emitting absolute references to screen_info
when building position independent code, redeclare the symbol with hidden
visibility.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/efi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8f3043aba873..464ac850c5e2 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -81,6 +81,9 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 #define alloc_screen_info(x...)		&screen_info
 #define free_screen_info(x...)
 
+/* redeclare as 'hidden' so the compiler will generate relative references */
+extern struct screen_info screen_info __attribute__((__visibility__("hidden")));
+
 static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
 {
 }
-- 
2.11.0
