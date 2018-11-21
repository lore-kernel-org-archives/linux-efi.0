From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 28/59] efi/libstub/arm64: Use hidden attribute for struct screen_info reference
Date: Wed, 21 Nov 2018 20:06:43 +0100
Message-ID: <20181121183509.360799865@linuxfoundation.org>
References: <20181121183508.262873520@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121183508.262873520@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-efi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 760b61d76da6d6a99eb245ab61abf71ca5415cea upstream.

To prevent the compiler from emitting absolute references to screen_info
when building position independent code, redeclare the symbol with hidden
visibility.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20170818194947.19347-3-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/efi.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -54,6 +54,9 @@ int efi_set_mapping_permissions(struct m
 #define alloc_screen_info(x...)		&screen_info
 #define free_screen_info(x...)
 
+/* redeclare as 'hidden' so the compiler will generate relative references */
+extern struct screen_info screen_info __attribute__((__visibility__("hidden")));
+
 static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
 {
 }
