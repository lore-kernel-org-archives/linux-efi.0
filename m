From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 4/4] efi/x86: add debug code to print cooked memmap
Date: Thu, 12 Jan 2017 17:41:22 +0800
Message-ID: <20170112094215.016194745@redhat.com>
References: <20170112094118.815108042@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=efi-print-memmap-after-merge-ranges.patch
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dyoung@redhat.com, x86@kernel.org, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

It is not obvious if the reserved boot area are added correctly, add a
efi_print_memmap to print the new memmap.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-x86.orig/arch/x86/platform/efi/efi.c
+++ linux-x86/arch/x86/platform/efi/efi.c
@@ -873,6 +873,11 @@ static void __init __efi_enter_virtual_m
 		return;
 	}
 
+	if (efi_enabled(EFI_DBG)) {
+		pr_info("EFI runtime memory map:\n");
+		efi_print_memmap();
+	}
+
 	BUG_ON(!efi.systab);
 
 	if (efi_setup_page_tables(pa, 1 << pg_shift)) {
