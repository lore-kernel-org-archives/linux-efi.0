From: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 2/6] x86, efi: Fix 32-bit EFI handover protocol entry point
Date: Thu, 10 Jan 2013 18:04:24 +0000
Message-ID: <1357841068-6582-2-git-send-email-dwmw2@infradead.org>
References: <1357841068-6582-1-git-send-email-dwmw2@infradead.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357841068-6582-1-git-send-email-dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If the bootloader calls the EFI handover entry point as a standard function
call, then it'll have a return address on the stack. We need to pop that
before calling efi_main(), or the arguments will all be out of position on
the stack.

Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/head_32.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index aa4aaf1..ccb2f4a 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -50,8 +50,10 @@ ENTRY(startup_32)
 	pushl	%eax
 	pushl	%esi
 	pushl	%ecx
+	sub	$0x4, %esp
 
 	.org 0x30,0x90
+	add	$0x4, %esp
 	call	efi_main
 	cmpl	$0, %eax
 	movl	%eax, %esi
-- 
1.8.0.1
