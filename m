From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH v4 1/6] x86: Page align _end to avoid pfn conversion bugs
Date: Fri, 27 Nov 2015 21:09:30 +0000
Message-ID: <1448658575-17029-2-git-send-email-matt@codeblueprint.co.uk>
References: <1448658575-17029-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448658575-17029-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

Ingo noted that if we can guarantee _end is aligned to PAGE_SIZE we
can automatically avoid bugs along the lines of,

	size = _end - _text >> PAGE_SHIFT

which is missing a call to PFN_ALIGN(). The EFI mixed mode contains
this bug, for example.

_text is already aligned to PAGE_SIZE through the use of
LOAD_PHYSICAL_ADDR, and the BSS and BRK sections are explicitly
aligned in the linker script, so it makes sense to align _end to
match.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 74e4bf11f562..4f1994257a18 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -325,6 +325,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
+	. = ALIGN(PAGE_SIZE);
 	_end = .;
 
         STABS_DEBUG
-- 
2.6.2
