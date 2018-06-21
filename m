From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v6 1/3] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Thu, 21 Jun 2018 09:23:22 -0700
Message-ID: <20180621162324.36656-2-ndesaulniers@google.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621162324.36656-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@redhat.com, tglx@linutronix.de
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com, acme@redhat.com, pombredanne@nexb.com, aryabinin@virtuozzo.com, kstewart@linuxfoundation.org, boris.ostrovsky@oracle.com, jan.kiszka@siemens.com, rostedt@goodmis.org, kirill.shutemov@linux.intel.com, ard.biesheuvel@linaro.org, akataria@vmware.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@l
List-Id: linux-efi@vger.kernel.org

Functions marked extern inline do not emit an externally visible
function when the gnu89 C standard is used. Some KBUILD Makefiles
overwrite KBUILD_CFLAGS. This is an issue for GCC 5.1+ users as without
an explicit C standard specified, the default is gnu11. Since c99, the
semantics of extern inline have changed such that an externally visible
function is always emitted. This can lead to multiple definition errors
of extern inline functions at link time of compilation units whose build
files have removed an explicit C standard compiler flag for users of GCC
5.1+ or Clang.

Acked-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Suggested-by: Joe Perches <joe@perches.com>
---
 include/linux/compiler-gcc.h | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index b4bf73f5e38f..c7cfca4ba02b 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -65,6 +65,18 @@
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 #endif
 
+/*
+ * Feature detection for gnu_inline (gnu89 extern inline semantics). Either
+ * __GNUC_STDC_INLINE__ is defined (not using gnu89 extern inline semantics,
+ * and we opt in to the gnu89 semantics), or __GNUC_STDC_INLINE__ is not
+ * defined so the gnu89 semantics are the default.
+ */
+#ifdef __GNUC_STDC_INLINE__
+#define __gnu_inline	__attribute__((gnu_inline))
+#else
+#define __gnu_inline
+#endif
+
 /*
  * Force always-inline if the user requests it so via the .config,
  * or if gcc is too old.
@@ -72,19 +84,22 @@
  * -Wunused-function.  This turns out to avoid the need for complex #ifdef
  * directives.  Suppress the warning in clang as well by using "unused"
  * function attribute, which is redundant but not harmful for gcc.
+ * Prefer gnu_inline, so that extern inline functions do not emit an
+ * externally visible function. This makes extern inline behave as per gnu89
+ * semantics rather than c99. This prevents multiple symbol definition errors
+ * of extern inline functions at link time.
+ * A lot of inline functions can cause havoc with function tracing.
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) ||		\
     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
-#define inline inline		__attribute__((always_inline,unused)) notrace
-#define __inline__ __inline__	__attribute__((always_inline,unused)) notrace
-#define __inline __inline	__attribute__((always_inline,unused)) notrace
+#define inline \
+	inline __attribute__((always_inline, unused)) notrace __gnu_inline
 #else
-/* A lot of inline functions can cause havoc with function tracing */
-#define inline inline		__attribute__((unused)) notrace
-#define __inline__ __inline__	__attribute__((unused)) notrace
-#define __inline __inline	__attribute__((unused)) notrace
+#define inline inline		__attribute__((unused)) notrace __gnu_inline
 #endif
 
+#define __inline__ inline
+#define __inline inline
 #define __always_inline	inline __attribute__((always_inline))
 #define  noinline	__attribute__((noinline))
 
-- 
2.18.0.rc2.346.g013aa6912e-goog
