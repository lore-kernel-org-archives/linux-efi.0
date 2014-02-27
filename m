From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 12/13] x86/boot: Don't overwrite cr4 when enabling PAE
Date: Thu, 27 Feb 2014 19:50:59 +0000
Message-ID: <1393530660-12692-13-git-send-email-matt@console-pimps.org>
References: <1393530660-12692-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393530660-12692-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some EFI firmware makes use of the FPU during boottime services and
clearing X86_CR4_OSFXSR by overwriting %cr4 causes the firmware to
crash.

Add the PAE bit explicitly instead of trashing the existing contents,
leaving the rest of the bits as the firmware set them.

Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
