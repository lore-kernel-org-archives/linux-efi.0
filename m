From: Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 01/13] x86/boot: Cleanup header.S by removing some #ifdefs
Date: Tue,  4 Mar 2014 13:14:09 +0000
Message-ID: <1393938861-16797-2-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

handover_offset is now filled out by build.c. Don't set a default value
as it will be overwritten anyway.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/header.S | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index ec3b8ba68096..d69d96653325 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -426,13 +426,7 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 #define INIT_SIZE VO_INIT_SIZE
 #endif
 init_size:		.long INIT_SIZE		# kernel initialization size
-handover_offset:
-#ifdef CONFIG_EFI_STUB
-  			.long 0x30		# offset to the handover
-						# protocol entry point
-#else
-			.long 0
-#endif
+handover_offset:	.long 0			# Filled in by build.c
 
 # End of setup header #####################################################
 
-- 
1.8.5.3
