From: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] x86, efi: remove attribute check from setup_efi_pci
Date: Tue, 29 Jan 2013 17:52:24 +0100
Message-ID: <5107FE48.7080402@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

It looks like the original commit that copied the rom contents from efi always copied
the rom, and the fixup in setup_efi_pci from commit 886d751a2ea99a160
("x86, efi: correct precedence of operators in setup_efi_pci") broke that.

This resulted in macbook pro's no longer finding the rom images, and thus not being able to use the radeon card any more.

The solution is to just remove the check for now, and always copy the rom if available.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 18e329c..ce06324 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -302,9 +302,6 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			continue;
 
-		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
-			continue;
-
 		if (!pci->romimage || !pci->romsize)
 			continue;
 
