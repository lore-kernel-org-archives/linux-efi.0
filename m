From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/2] x86/efi: Only map RAM into EFI page tables if in mixed-mode
Date: Tue, 20 Sep 2016 15:48:29 +0100
Message-ID: <20160920144829.30873-3-matt@codeblueprint.co.uk>
References: <20160920144829.30873-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920144829.30873-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Douglas Hatch <doug.hatch@hpe.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Scott J Norton <scott.norton@hpe.com>, stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Waiman Long <waiman.long@hpe.com>
List-Id: linux-efi@vger.kernel.org

Waiman reported that booting with CONFIG_EFI_MIXED enabled on his
multi-terabyte HP machine results in boot crashes, because the EFI
region mapping functions loop forever while trying to map those
regions describing RAM.

While this patch doesn't fix the underlying hang, there's really no
reason to map EFI_CONVENTIONAL_MEMORY regions into the EFI page tables
when mixed-mode is not in use at runtime.

Reported-by: Waiman Long <waiman.long@hpe.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Ts'o <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Scott J Norton <scott.norton@hpe.com>
Cc: Douglas Hatch <doug.hatch@hpe.com>
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 677e29e29473..8dd3784eb075 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -245,7 +245,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	 * text and allocate a new stack because we can't rely on the
 	 * stack pointer being < 4GB.
 	 */
-	if (!IS_ENABLED(CONFIG_EFI_MIXED))
+	if (!IS_ENABLED(CONFIG_EFI_MIXED) || efi_is_native())
 		return 0;
 
 	/*
-- 
2.9.3
