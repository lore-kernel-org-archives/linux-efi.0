From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 06/10] x86/asm/efi: Fix asmvalidate warnings for efi_stub_64.S
Date: Wed, 10 Jun 2015 07:06:14 -0500
Message-ID: <3e1d9ce523b3174a49b4317cd8b1b85dfd0c319a.1433937132.git.jpoimboe@redhat.com>
References: <cover.1433937132.git.jpoimboe@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433937132.git.jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Fix the following asmvalidate warnings:

   asmvalidate: arch/x86/platform/efi/efi_stub_64.o: efi_call(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/boot/compressed/efi_stub_64.o: efi_call(): missing FP_SAVE/RESTORE macros

efi_call() is a non-leaf callable function, so save/restore the frame
pointer with FP_SAVE/RESTORE.

Signed-off-by: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/x86/platform/efi/efi_stub_64.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 86d0f9e..0ca6bfb 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -11,6 +11,7 @@
 #include <asm/msr.h>
 #include <asm/processor-flags.h>
 #include <asm/page_types.h>
+#include <asm/func.h>
 
 #define SAVE_XMM			\
 	mov %rsp, %rax;			\
@@ -74,6 +75,7 @@
 	.endm
 
 ENTRY(efi_call)
+	FP_SAVE
 	SAVE_XMM
 	mov (%rsp), %rax
 	mov 8(%rax), %rax
@@ -88,6 +90,7 @@ ENTRY(efi_call)
 	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
+	FP_RESTORE
 	ret
 ENDPROC(efi_call)
 
-- 
2.1.0
