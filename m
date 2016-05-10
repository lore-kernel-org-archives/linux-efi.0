From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.19.y-ckt 40/54] MAINTAINERS: Remove asterisk from EFI directory names
Date: Mon,  9 May 2016 17:04:59 -0700
Message-ID: <1462838713-31343-41-git-send-email-kamal@canonical.com>
References: <1462838713-31343-1-git-send-email-kamal@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462838713-31343-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
List-Id: linux-efi@vger.kernel.org

3.19.8-ckt21 -stable review patch.  If anyone has any objections, please let me know.

---8<------------------------------------------------------------

From: Matt Fleming <matt@codeblueprint.co.uk>

commit e8dfe6d8f6762d515fcd4f30577f7bfcf7659887 upstream.

Mark reported that having asterisks on the end of directory names
confuses get_maintainer.pl when it encounters subdirectories, and that
my name does not appear when run on drivers/firmware/efi/libstub.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/1462303781-8686-2-git-send-email-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 808ee80..5a9f241 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3658,8 +3658,8 @@ F:	Documentation/efi-stub.txt
 F:	arch/ia64/kernel/efi.c
 F:	arch/x86/boot/compressed/eboot.[ch]
 F:	arch/x86/include/asm/efi.h
-F:	arch/x86/platform/efi/*
-F:	drivers/firmware/efi/*
+F:	arch/x86/platform/efi/
+F:	drivers/firmware/efi/
 F:	include/linux/efi*.h
 
 EFI VARIABLE FILESYSTEM
-- 
2.7.4
