From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/9] efi/x86: add missing NULL initialization in UGA draw protocol discovery
Date: Fri, 20 Jul 2018 10:47:22 +0900
Message-ID: <20180720014726.24031-6-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

The UGA draw protocol discovery routine looks for a EFI handle that has
both the UGA draw protocol and the PCI I/O protocol installed. It checks
for the latter by calling handle_protocol() and pass it a PCI I/O
protocol pointer variable by reference, but fails to initialize it to
NULL, which means the non-NULL check later on in the code could produce
false positives, given that the return code of the handle_protocol() call
is ignored entirely. So add the missing initialization.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ac8e442db71f..92b573fd239c 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -359,6 +359,7 @@ setup_uga(struct screen_info *si, efi_guid_t *uga_proto, unsigned long size)
 		if (status != EFI_SUCCESS)
 			continue;
 
+		pciio = NULL;
 		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
 
 		status = efi_call_proto(efi_uga_draw_protocol, get_mode, uga,
-- 
2.17.1
