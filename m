From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH 3/4] x86/efi: Update comment regarding required phys mapped EFI services
Date: Sun,  7 Sep 2014 19:42:16 +0200
Message-ID: <1410111737-5220-4-git-send-email-minipli@googlemail.com>
References: <1410111737-5220-1-git-send-email-minipli@googlemail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410111737-5220-1-git-send-email-minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 3f4a7836e331 ("x86/efi: Rip out phys_efi_get_time()") left
set_virtual_address_map as the only runtime service needed with a
phys mapping but missed to update the preceding comment. Fix that.

Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 9e43b0f3d891..504174c36a73 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -342,9 +342,9 @@ static int __init efi_runtime_init32(void)
 	}
 
 	/*
-	 * We will only need *early* access to the following two
-	 * EFI runtime services before set_virtual_address_map
-	 * is invoked.
+	 * We will only need *early* access to the SetVirtualAddressMap
+	 * EFI runtime service. All other runtime services will be called
+	 * via the virtual mapping.
 	 */
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
@@ -366,9 +366,9 @@ static int __init efi_runtime_init64(void)
 	}
 
 	/*
-	 * We will only need *early* access to the following two
-	 * EFI runtime services before set_virtual_address_map
-	 * is invoked.
+	 * We will only need *early* access to the SetVirtualAddressMap
+	 * EFI runtime service. All other runtime services will be called
+	 * via the virtual mapping.
 	 */
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
-- 
1.7.10.4
