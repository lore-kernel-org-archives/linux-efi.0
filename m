From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [added to the 4.1 stable tree] MAINTAINERS: Remove asterisk from EFI directory names
Date: Thu, 19 May 2016 00:19:39 -0400
Message-ID: <1463631606-32540-40-git-send-email-sasha.levin@oracle.com>
References: <1463631606-32540-1-git-send-email-sasha.levin@oracle.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463631606-32540-1-git-send-email-sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

This patch has been added to the 4.1 stable tree. If you have any
objections, please let us know.

===============

[ Upstream commit e8dfe6d8f6762d515fcd4f30577f7bfcf7659887 ]

Mark reported that having asterisks on the end of directory names
confuses get_maintainer.pl when it encounters subdirectories, and that
my name does not appear when run on drivers/firmware/efi/libstub.

Reported-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/1462303781-8686-2-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b51c8a..a1d127a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3772,8 +3772,8 @@ F:	Documentation/efi-stub.txt
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
2.5.0
