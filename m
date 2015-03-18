From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 14/19] x86, kaslr: Add two functions which will be used later
Date: Wed, 18 Mar 2015 00:28:21 -0700
Message-ID: <1426663706-23979-15-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

Add two functions mem_min_overlap() and store_slot_info() which will be
used later.

Given a memory region mem_min_overlap will iterate all avoid region to
find the first one which overlap with it.

store_slot_info() calculates the slot info of passed in region and
store it into slot_areas[].

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 33693c1..37dce4f 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -217,6 +217,40 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 	return false;
 }
 
+static unsigned long
+mem_min_overlap(struct mem_vector *img, struct mem_vector *out)
+{
+	int i;
+	struct setup_data *ptr;
+	unsigned long min = img->start + img->size;
+
+	for (i = 0; i < MEM_AVOID_MAX; i++) {
+		if (mem_overlaps(img, &mem_avoid[i]) &&
+			(mem_avoid[i].start < min)) {
+			*out = mem_avoid[i];
+			min = mem_avoid[i].start;
+		}
+	}
+
+	/* Check all entries in the setup_data linked list. */
+	ptr = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
+	while (ptr) {
+		struct mem_vector avoid;
+
+		avoid.start = (unsigned long)ptr;
+		avoid.size = sizeof(*ptr) + ptr->len;
+
+		if (mem_overlaps(img, &avoid) && (avoid.start < min)) {
+			*out = avoid;
+			min = avoid.start;
+		}
+
+		ptr = (struct setup_data *)(unsigned long)ptr->next;
+	}
+
+	return min;
+}
+
 static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
 			   CONFIG_PHYSICAL_ALIGN];
 
@@ -233,6 +267,23 @@ static unsigned long slot_max;
 
 static unsigned long slot_area_index;
 
+static void store_slot_info(struct mem_vector *region, unsigned long image_size)
+{
+	struct slot_area slot_area;
+
+	slot_area.addr = region->start;
+	if (image_size <= CONFIG_PHYSICAL_ALIGN)
+		slot_area.num = region->size / CONFIG_PHYSICAL_ALIGN;
+	else
+		slot_area.num = (region->size - image_size) /
+				CONFIG_PHYSICAL_ALIGN + 1;
+
+	if (slot_area.num > 0) {
+		slot_areas[slot_area_index++] = slot_area;
+		slot_max += slot_area.num;
+	}
+}
+
 static void slots_append(unsigned long addr)
 {
 	/* Overflowing the slots list should be impossible. */
-- 
1.8.4.5
