From: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 3/6] x86, efi: Fix PCI ROM handing in EFI boot stub, in 32-bit mode
Date: Thu, 10 Jan 2013 18:04:25 +0000
Message-ID: <1357841068-6582-3-git-send-email-dwmw2@infradead.org>
References: <1357841068-6582-1-git-send-email-dwmw2@infradead.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357841068-6582-1-git-send-email-dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The 'Attributes' argument to pci->Attributes() function is 64-bit. So
when invoking in 32-bit mode it takes two registers, not just one.

This fixes memory corruption when booting via the 32-bit EFI boot stub.

Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 03d8c9b..685d0b9 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -295,10 +295,15 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (!pci)
 			continue;
 
+#ifdef CONFIG_X86_64
 		status = efi_call_phys4(pci->attributes, pci,
 					EfiPciIoAttributeOperationGet, 0,
 					&attributes);
-
+#else
+		status = efi_call_phys5(pci->attributes, pci,
+					EfiPciIoAttributeOperationGet, 0, 0,
+					&attributes);
+#endif
 		if (status != EFI_SUCCESS)
 			continue;
 
-- 
1.8.0.1
