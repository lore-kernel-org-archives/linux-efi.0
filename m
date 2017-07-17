From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v10 37/38] compiler-gcc.h: Introduce __nostackp function attribute
Date: Mon, 17 Jul 2017 16:10:34 -0500
Message-ID: <0576fd5c74440ad0250f16ac6609ecf587812456.1500319216.git.thomas.lendacky@amd.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1500319216.git.thomas.lendacky@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, kasan-dev@googlegroups.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Dave Young <dyoung@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, "Michael S. Tsirkin" <mst@redhat.com>, Brijesh Singh <brijesh.singh>
List-Id: linux-efi@vger.kernel.org

Create a new function attribute, __nostackp, that can used to turn off
stack protection on a per function basis.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 include/linux/compiler-gcc.h | 2 ++
 include/linux/compiler.h     | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cd4bbe8..682063b 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -166,6 +166,8 @@
 
 #if GCC_VERSION >= 40100
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+
+#define __nostackp	__attribute__((__optimize__("no-stack-protector")))
 #endif
 
 #if GCC_VERSION >= 40300
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 219f82f..63cbca1 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -470,6 +470,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 #define __visible
 #endif
 
+#ifndef __nostackp
+#define __nostackp
+#endif
+
 /*
  * Assume alignment of return value.
  */
-- 
1.9.1
