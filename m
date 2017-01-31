From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 09/10] efi/x86: Add debug code to print cooked memmap
Date: Tue, 31 Jan 2017 13:21:41 +0000
Message-ID: <1485868902-20401-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Dave Young <dyoung@redhat.com>

It is not obvious if the reserved boot area are added correctly, add a
efi_print_memmap to print the new memmap.

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Reviewed-by: Nicolai Stange <nicstange@gmail.com>
Tested-by: Nicolai Stange <nicstange@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/platform/efi/efi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d4becfc5145..565dff3c9a12 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -955,6 +955,11 @@ static void __init __efi_enter_virtual_mode(void)
 		return;
 	}
 
+	if (efi_enabled(EFI_DBG)) {
+		pr_info("EFI runtime memory map:\n");
+		efi_print_memmap();
+	}
+
 	BUG_ON(!efi.systab);
 
 	if (efi_setup_page_tables(pa, 1 << pg_shift)) {
-- 
2.7.4
