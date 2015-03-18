From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 11/19] x86, boot: Add checking for memcpy
Date: Wed, 18 Mar 2015 00:28:18 -0700
Message-ID: <1426663706-23979-12-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

parse_elf is using local memcpy to move section to running position.

That memcpy actually only support no overlapping or dest < src.

Add checking in memcpy to find out wrong with future use, at that time
we will need to have backward memcpy for it.

Also put comments in parse_elf about the fact.

Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/misc.c   | 14 +++++++-------
 arch/x86/boot/compressed/misc.h   |  2 ++
 arch/x86/boot/compressed/string.c | 28 ++++++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index f99c9c9..94e283c 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -106,9 +106,6 @@
 #undef memset
 #define memzero(s, n)	memset((s), 0, (n))
 
-
-static void error(char *m);
-
 /*
  * This is set up by the setup-routine at boot-time
  */
@@ -218,7 +215,7 @@ void __putstr(const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-static void error(char *x)
+void error(char *x)
 {
 	error_putstr("\n\n");
 	error_putstr(x);
@@ -353,9 +350,12 @@ static void parse_elf(void *output)
 #else
 			dest = (void *)(phdr->p_paddr);
 #endif
-			memcpy(dest,
-			       output + phdr->p_offset,
-			       phdr->p_filesz);
+			/*
+			 * simple version memcpy only can work when dest is
+			 *   smaller than src or no overlapping.
+			 * Here dest is smaller than src always.
+			 */
+			memcpy(dest, output + phdr->p_offset, phdr->p_filesz);
 			break;
 		default: /* Ignore other PT_* */ break;
 		}
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 98914a0..a7f3826 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -37,6 +37,8 @@ extern struct boot_params *real_mode;		/* Pointer to real-mode data */
 void __putstr(const char *s);
 #define error_putstr(__x)  __putstr(__x)
 
+void error(char *x);
+
 #ifdef CONFIG_X86_VERBOSE_BOOTUP
 
 #define debug_putstr(__x)  __putstr(__x)
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index 00e788b..03805a4 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,7 +1,7 @@
 #include "../string.c"
 
 #ifdef CONFIG_X86_32
-void *memcpy(void *dest, const void *src, size_t n)
+void *__memcpy(void *dest, const void *src, size_t n)
 {
 	int d0, d1, d2;
 	asm volatile(
@@ -15,7 +15,7 @@ void *memcpy(void *dest, const void *src, size_t n)
 	return dest;
 }
 #else
-void *memcpy(void *dest, const void *src, size_t n)
+void *__memcpy(void *dest, const void *src, size_t n)
 {
 	long d0, d1, d2;
 	asm volatile(
@@ -30,6 +30,30 @@ void *memcpy(void *dest, const void *src, size_t n)
 }
 #endif
 
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	unsigned long start_dest, end_dest;
+	unsigned long start_src, end_src;
+	unsigned long max_start, min_end;
+
+	if (dest < src)
+		return __memcpy(dest, src, n);
+
+	start_dest = (unsigned long)dest;
+	end_dest = (unsigned long)dest + n;
+	start_src = (unsigned long)src;
+	end_src = (unsigned long)src + n;
+	max_start = (start_dest > start_src) ?  start_dest : start_src;
+	min_end = (end_dest < end_src) ? end_dest : end_src;
+
+	if (max_start >= min_end)
+		return __memcpy(dest, src, n);
+
+	error("memcpy does not support overlapping with dest > src!\n");
+
+	return dest;
+}
+
 void *memset(void *s, int c, size_t n)
 {
 	int i;
-- 
1.8.4.5
