From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v6 2/3] x86/asm: add _ASM_ARG* constants for argument
 registers to <asm/asm.h>
Date: Thu, 21 Jun 2018 09:23:23 -0700
Message-ID: <20180621162324.36656-3-ndesaulniers@google.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621162324.36656-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@redhat.com, tglx@linutronix.de
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com, acme@redhat.com, pombredanne@nexb.com, aryabinin@virtuozzo.com, kstewart@linuxfoundation.org, boris.ostrovsky@oracle.com, jan.kiszka@siemens.com, rostedt@goodmis.org, kirill.shutemov@linux.intel.com, ard.biesheuvel@linaro.org, akataria@vmware.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@l
List-Id: linux-efi@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

i386 and x86-64 uses different registers for arguments; make them
available so we don't have to #ifdef in the actual code.

Native size and specified size (q, l, w, b) versions are provided.

Acked-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/x86/include/asm/asm.h | 59 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 219faaec51df..990770f9e76b 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -46,6 +46,65 @@
 #define _ASM_SI		__ASM_REG(si)
 #define _ASM_DI		__ASM_REG(di)
 
+#ifndef __x86_64__
+/* 32 bit */
+
+#define _ASM_ARG1	_ASM_AX
+#define _ASM_ARG2	_ASM_DX
+#define _ASM_ARG3	_ASM_CX
+
+#define _ASM_ARG1L	eax
+#define _ASM_ARG2L	edx
+#define _ASM_ARG3L	ecx
+
+#define _ASM_ARG1W	ax
+#define _ASM_ARG2W	dx
+#define _ASM_ARG3W	cx
+
+#define _ASM_ARG1B	al
+#define _ASM_ARG2B	dl
+#define _ASM_ARG3B	cl
+
+#else
+/* 64 bit */
+
+#define _ASM_ARG1	_ASM_DI
+#define _ASM_ARG2	_ASM_SI
+#define _ASM_ARG3	_ASM_DX
+#define _ASM_ARG4	_ASM_CX
+#define _ASM_ARG5	r8
+#define _ASM_ARG6	r9
+
+#define _ASM_ARG1Q	rdi
+#define _ASM_ARG2Q	rsi
+#define _ASM_ARG3Q	rdx
+#define _ASM_ARG4Q	rcx
+#define _ASM_ARG5Q	r8
+#define _ASM_ARG6Q	r9
+
+#define _ASM_ARG1L	edi
+#define _ASM_ARG2L	esi
+#define _ASM_ARG3L	edx
+#define _ASM_ARG4L	ecx
+#define _ASM_ARG5L	r8d
+#define _ASM_ARG6L	r9d
+
+#define _ASM_ARG1W	di
+#define _ASM_ARG2W	si
+#define _ASM_ARG3W	dx
+#define _ASM_ARG4W	cx
+#define _ASM_ARG5W	r8w
+#define _ASM_ARG6W	r9w
+
+#define _ASM_ARG1B	dil
+#define _ASM_ARG2B	sil
+#define _ASM_ARG3B	dl
+#define _ASM_ARG4B	cl
+#define _ASM_ARG5B	r8b
+#define _ASM_ARG6B	r9b
+
+#endif
+
 /*
  * Macros to generate condition code outputs from inline assembly,
  * The output operand must be type "bool".
-- 
2.18.0.rc2.346.g013aa6912e-goog
