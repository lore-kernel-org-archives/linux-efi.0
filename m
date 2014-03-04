From: Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 12/13] x86/boot: Don't overwrite cr4 when enabling PAE
Date: Tue,  4 Mar 2014 13:14:20 +0000
Message-ID: <1393938861-16797-13-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Some EFI firmware makes use of the FPU during boottime services and
clearing X86_CR4_OSFXSR by overwriting %cr4 causes the firmware to
crash.

Add the PAE bit explicitly instead of trashing the existing contents,
leaving the rest of the bits as the firmware set them.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 37c741b0d2ac..4f40cddd025d 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -113,7 +113,8 @@ ENTRY(startup_32)
 	lgdt	gdt(%ebp)
 
 	/* Enable PAE mode */
-	movl	$(X86_CR4_PAE), %eax
+	movl	%cr4, %eax
+	orl	$X86_CR4_PAE, %eax
 	movl	%eax, %cr4
 
  /*
-- 
1.8.5.3
