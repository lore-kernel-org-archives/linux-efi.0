From: Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [4.2.y-ckt stable] Patch "MAINTAINERS: Remove asterisk from EFI directory names" has been added to the 4.2.y-ckt tree
Date: Mon,  9 May 2016 12:44:03 -0700
Message-ID: <1462823043-6696-1-git-send-email-kamal@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, kernel-team-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    MAINTAINERS: Remove asterisk from EFI directory names

to the linux-4.2.y-queue branch of the 4.2.y-ckt extended stable tree 
which can be found at:

    https://git.launchpad.net/~canonical-kernel/linux/+git/linux-stable-ckt/log/?h=linux-4.2.y-queue

This patch is scheduled to be released in version 4.2.8-ckt10.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 4.2.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

---8<------------------------------------------------------------

>From 9b6a54c9e51a5d4535540a82023b9aff160ea6d3 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Date: Tue, 3 May 2016 20:29:39 +0100
Subject: MAINTAINERS: Remove asterisk from EFI directory names

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
Signed-off-by: Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab4384f..fb1c3fa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3941,8 +3941,8 @@ F:	Documentation/efi-stub.txt
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
