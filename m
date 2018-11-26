From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 18/70] efi/libstub/arm64: Force hidden visibility for section markers
Date: Mon, 26 Nov 2018 11:50:33 +0100
Message-ID: <20181126105048.599872098@linuxfoundation.org>
References: <20181126105046.722096341@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126105046.722096341@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-efi@vger.kernel.org

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 0426a4e68f18d75515414361de9e3e1445d2644e upstream.

To prevent the compiler from emitting absolute references to the section
markers when running in PIC mode, override the visibility to 'hidden' for
all contents of asm/sections.h

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20170818194947.19347-4-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[nc: Fix conflict due to lack of commit 42b55734030c1 in linux-4.4.y]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -9,9 +9,17 @@
  * published by the Free Software Foundation.
  *
  */
+
+/*
+ * To prevent the compiler from emitting GOT-indirected (and thus absolute)
+ * references to the section markers, override their visibility as 'hidden'
+ */
+#pragma GCC visibility push(hidden)
+#include <asm/sections.h>
+#pragma GCC visibility pop
+
 #include <linux/efi.h>
 #include <asm/efi.h>
-#include <asm/sections.h>
 
 efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 					unsigned long *image_addr,
