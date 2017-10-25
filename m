From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or WP are set
Date: Wed, 25 Oct 2017 11:14:19 +0100
Message-ID: <20171025101419.26369-3-ard.biesheuvel@linaro.org>
References: <20171025101419.26369-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025101419.26369-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

The UEFI memory map is a bit vague about how to interpret the
EFI_MEMORY_XP attribute when it is combined with EFI_MEMORY_RP and/or
EFI_MEMORY_WP, which have retroactively been redefined as cacheability
attributes rather than permission attributes.

So let's ignore EFI_MEMORY_XP if _RP and/or _WP are also set. In this
case, it is likely that they are being used to describe the capability
of the region (i.e., whether it has the controls to reconfigure it as
non-executable) rather than the nature of the contents of the region
(i.e., whether it contains data that we will never attempt to execute)

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Tested-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 82cd07592519..f85ac58d08a3 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -48,7 +48,9 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 		return pgprot_val(PAGE_KERNEL_ROX);
 
 	/* RW- */
-	if (attr & EFI_MEMORY_XP || type != EFI_RUNTIME_SERVICES_CODE)
+	if (((attr & (EFI_MEMORY_RP | EFI_MEMORY_WP | EFI_MEMORY_XP)) ==
+	     EFI_MEMORY_XP) ||
+	    type != EFI_RUNTIME_SERVICES_CODE)
 		return pgprot_val(PAGE_KERNEL);
 
 	/* RWX */
-- 
2.11.0
