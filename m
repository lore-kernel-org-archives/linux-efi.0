From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 18/19] x86, kaslr: Remove useless codes
Date: Wed, 18 Mar 2015 00:28:25 -0700
Message-ID: <1426663706-23979-19-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Several auxiliary functions and slots[] are not needed any more since
struct slot_area is used to store the slot info of kaslr now. Hence
remove them in this patch.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/boot/compressed/aslr.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 2f60f41..e3bd2e2 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -115,17 +115,6 @@ struct mem_vector {
 #define MEM_AVOID_MAX 4
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
-static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
-{
-	/* Item at least partially before region. */
-	if (item->start < region->start)
-		return false;
-	/* Item at least partially after region. */
-	if (item->start + item->size > region->start + region->size)
-		return false;
-	return true;
-}
-
 static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 {
 	/* Item one is entirely before item two. */
@@ -251,9 +240,6 @@ mem_min_overlap(struct mem_vector *img, struct mem_vector *out)
 	return min;
 }
 
-static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
-			   CONFIG_PHYSICAL_ALIGN];
-
 struct slot_area {
 	unsigned long addr;
 	int num;
@@ -284,16 +270,6 @@ static void store_slot_info(struct mem_vector *region, unsigned long image_size)
 	}
 }
 
-static void slots_append(unsigned long addr)
-{
-	/* Overflowing the slots list should be impossible. */
-	if (slot_max >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
-			CONFIG_PHYSICAL_ALIGN)
-		return;
-
-	slots[slot_max++] = addr;
-}
-
 static unsigned long slots_fetch_random(void)
 {
 	unsigned long random;
-- 
1.8.4.5
