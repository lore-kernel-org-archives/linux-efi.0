From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: [PATCH 4/4] libfdt, kasan: don't instrument libfdt.
Date: Wed, 26 Aug 2015 19:15:07 +0300
Message-ID: <1440605707-8325-5-git-send-email-ryabinin.a.a@gmail.com>
References: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>
List-Id: linux-efi@vger.kernel.org

libfdt is used by EFI code and it runs before we setup early
shadow, so it has to be not instrumented to prevent boot crash.

Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 lib/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index 6897b52..44e1d81 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -165,7 +165,8 @@ obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
 	       fdt_empty_tree.o
 $(foreach file, $(libfdt_files), \
-	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
+	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt) \
+	$(eval KASAN_SANITIZE_$(file) := n))
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
 
 obj-$(CONFIG_RBTREE_TEST) += rbtree_test.o
-- 
2.4.6
