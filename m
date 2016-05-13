From: Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to 3.12-stable] MAINTAINERS: Remove asterisk from EFI directory names
Date: Fri, 13 May 2016 15:09:57 +0200
Message-ID: <1463145007-20409-12-git-send-email-jslaby@suse.cz>
References: <1463145007-20409-1-git-send-email-jslaby@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1463145007-20409-1-git-send-email-jslaby@suse.cz>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt@codeblueprint.co.uk>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 44881abcfb06..b3233331dc0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3165,8 +3165,8 @@ F:	Documentation/x86/efi-stub.txt
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
2.8.2
