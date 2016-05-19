From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 3.12 42/76] MAINTAINERS: Remove asterisk from EFI directory names
Date: Thu, 19 May 2016 11:08:04 +0200
Message-ID: <ead9e8f5de9c40e39acb4000cae91e66d2fabc6e.1463648873.git.jslaby@suse.cz>
References: <c4ec97c341630e22e546c1a628a3664f17f7ffc8.1463648873.git.jslaby@suse.cz>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c4ec97c341630e22e546c1a628a3664f17f7ffc8.1463648873.git.jslaby-AlSwsSmVLrQ@public.gmane.org>
In-Reply-To: <cover.1463648873.git.jslaby-AlSwsSmVLrQ@public.gmane.org>
References: <cover.1463648873.git.jslaby-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e8dfe6d8f6762d515fcd4f30577f7bfcf7659887 upstream.

Mark reported that having asterisks on the end of directory names
confuses get_maintainer.pl when it encounters subdirectories, and that
my name does not appear when run on drivers/firmware/efi/libstub.

Reported-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/1462303781-8686-2-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
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
