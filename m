From: Baoquan He <bhe@redhat.com>
Subject: [PATCH v1 RESEND 2/2] x86/efi: Clean up a minor mistake in code comment
Date: Thu, 23 Mar 2017 11:27:35 +0800
Message-ID: <1490239655-20902-3-git-send-email-bhe@redhat.com>
References: <1490239655-20902-1-git-send-email-bhe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490239655-20902-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Baoquan He <bhe@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

EFI allocate runtime services regions from EFI_VA_START, -4G, down
to -64G, EFI_VA_END. The mechanism was introduced in
commit d2f7cbe7b26a7 ("x86/efi: Runtime services virtual mapping").

Clean it up to avoid confusion.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a4695da..6cbf9e0 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,7 +47,7 @@
 #include <asm/pgalloc.h>
 
 /*
- * We allocate runtime services regions bottom-up, starting from -4G, i.e.
+ * We allocate runtime services regions top-down, starting from -4G, i.e.
  * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
  */
 static u64 efi_va = EFI_VA_START;
-- 
2.5.5
