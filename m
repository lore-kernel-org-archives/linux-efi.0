From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] x86, boot: Explicitly include autoconf.h for hostprogs
Date: Fri, 12 Oct 2012 11:19:59 +0100
Message-ID: <1350037199-2995-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The hostprogs need access to the CONFIG_* symbols found in
include/generated/autoconf.h. commit abbf1590 ("UAPI: Partition the
header include path sets and add uapi/ header directories") replaced
$(LINUXINCLUDE) with $(USERINCLUDE) which doesn't contain the
necessary include paths.

This has the undesirable effect of breaking the EFI boot stub because
the #ifdef CONFIG_EFI_STUB code in arch/x86/boot/tools/build.c is
never compiled.

It should also be noted that because $(USERINCLUDE) isn't exported by
the top-level Makefile it's actually empty in arch/x86/boot/Makefile.

Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

Linus, I expected this fix to go through -tip but Ingo explained that
the offending commit (abbf1590) doesn't exist in -tip yet, which is
why I'm sending this directly to you.

 arch/x86/boot/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index ce03476..ccce0ed 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,7 +37,8 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOST_EXTRACFLAGS += -I$(srctree)/tools/include $(USERINCLUDE) \
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include \
+		    -include include/generated/autoconf.h \
 	            -D__EXPORTED_HEADERS__
 
 $(obj)/cpu.o: $(obj)/cpustr.h
-- 
1.7.11.4

--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
