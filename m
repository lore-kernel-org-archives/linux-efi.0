From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 1/3] efi: use -std=gnu89 for proper extern inline semantics
Date: Fri,  1 Jun 2018 09:55:48 -0700
Message-ID: <20180601165550.90053-2-ndesaulniers@google.com>
References: <20180601165550.90053-1-ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601165550.90053-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, hpa@zytor.com, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, ndesaulniers@google.com, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-efi@vger.kernel.org

The top level Makefile explicitly sets the C standard used in the kernel
to gnu89. By overriding KBUILD_CFLAGS, the C standard used for this
subdir is now implicit based on compiler and compiler version. GCC
changes this implicit default from gnu89 to gnu11 in v5.1.

This implies that depending on compiler version, parts of the kernel are
being linked together from object files that were compiled with
different C standard compiler flags.

This is problematic for symbols declared as extern inline, as the
semantics have switched since gnu89. See also:
http://blahg.josefsipek.net/?p=529

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index a34e9290a699..97ca53ab2b69 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -7,7 +7,7 @@
 #
 cflags-$(CONFIG_X86_32)		:= -march=i386
 cflags-$(CONFIG_X86_64)		:= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
+cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 -std=gnu89 \
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
 				   -mno-mmx -mno-sse -fshort-wchar
 
-- 
2.17.0.921.gf22659ad46-goog
