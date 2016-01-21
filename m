From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 4/4] x86/efi: Use proper units in efi_find_mirror()
Date: Thu, 21 Jan 2016 17:22:32 +0200
Message-ID: <1453389752-68175-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

Like in efi_print_mmap() use the proper units when printing sizes.

Currently it's hardcoded to 'MiB', though it might be changed to adaptive
efi_size_format() in the future.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3badc8a..95f70da 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -144,8 +144,8 @@ void __init efi_find_mirror(void)
 		}
 	}
 	if (mirror_size)
-		pr_info("Memory: %lldM/%lldM mirrored memory\n",
-			mirror_size>>20, total_size>>20);
+		pr_info("Memory: %lld MiB/%lld MiB mirrored memory\n",
+			mirror_size >> 20, total_size >> 20);
 }
 
 /*
-- 
2.7.0.rc3
