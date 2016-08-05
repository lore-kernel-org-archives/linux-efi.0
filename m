From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Fri,  5 Aug 2016 18:59:35 -0500
Message-ID: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Mike Travis <travis@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

This is a simple change to add in the physical mappings as well as the
virtual mappings in efi_map_region_fixed.  The motivation here is to
get access to EFI runtime code that is only available via the 1:1
mappings on a kexec'd kernel.

The added call is essentially the kexec analog of the first __map_region
that Boris put in efi_map_region in commit d2f7cbe7b26a ("x86/efi:
Runtime services virtual mapping").

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/platform/efi/efi_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 459bcbb..b206126 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -363,6 +363,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
  */
 void __init efi_map_region_fixed(efi_memory_desc_t *md)
 {
+	__map_region(md, md->phys_addr);
 	__map_region(md, md->virt_addr);
 }
 
-- 
1.8.5.6
