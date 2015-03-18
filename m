From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 13/19] x86, kaslr: Introduce struct slot_area to manage randomization slot info
Date: Wed, 18 Mar 2015 00:28:20 -0700
Message-ID: <1426663706-23979-14-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Kernel is expected to be randomly reloaded anywhere in the whole
physical memory area, it could be near 64T at most. In this case
there could be about 4*1024*1024 randomization slots. Hence the
old slot array will cost too much memory and also not efficient
to store the slot information one by one into slot array.

Here introduce struct slot_area to manage randomization slot info
in one contiguous memory area excluding the avoid area. slot_areas
is used to store all slot area info. Since setup_data is a linked
list, could contain many datas by pointer to point one by one,
excluding them will split RAM memory into many smaller areas, here
only take the first 100 slot areas if too many of them.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/boot/compressed/aslr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index f8d095d..33693c1 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -219,8 +219,20 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 
 static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
 			   CONFIG_PHYSICAL_ALIGN];
+
+struct slot_area {
+	unsigned long addr;
+	int num;
+};
+
+#define MAX_SLOT_AREA 100
+
+static struct slot_area slot_areas[MAX_SLOT_AREA];
+
 static unsigned long slot_max;
 
+static unsigned long slot_area_index;
+
 static void slots_append(unsigned long addr)
 {
 	/* Overflowing the slots list should be impossible. */
-- 
1.8.4.5
