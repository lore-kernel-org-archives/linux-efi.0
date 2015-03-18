From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 17/19] x86, kaslr: Add support of kernel physical address randomization above 4G
Date: Wed, 18 Mar 2015 00:28:24 -0700
Message-ID: <1426663706-23979-18-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

In kaslr implementation mechanism, mainly process_e820_entry and
slots_fetch_random do the job. process_e820_entry is responsible
for storing the slot information. slots_fetch_random takes care
of fetching slot information. In this patch, for adding support
of kernel physical address randomization above 4G, both of these
two functions are changed based on the new slot_area data structure.

Now kernel can be reloaded and decompressed anywhere of the whole
physical memory, even near 64T at most.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c | 68 ++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index ae0aed9..2f60f41 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -296,27 +296,40 @@ static void slots_append(unsigned long addr)
 
 static unsigned long slots_fetch_random(void)
 {
+	unsigned long random;
+	int i;
+
 	/* Handle case of no slots stored. */
 	if (slot_max == 0)
 		return 0;
 
-	return slots[get_random_long() % slot_max];
+	random = get_random_long() % slot_max;
+
+	for (i = 0; i < slot_area_index; i++) {
+		if (random >= slot_areas[i].num) {
+			random -= slot_areas[i].num;
+			continue;
+		}
+		return slot_areas[i].addr + random * CONFIG_PHYSICAL_ALIGN;
+	}
+
+	if (i == slot_area_index)
+		debug_putstr("Something wrong happened in slots_fetch_random()...\n");
+	return 0;
 }
 
 static void process_e820_entry(struct e820entry *entry,
 			       unsigned long minimum,
 			       unsigned long image_size)
 {
-	struct mem_vector region, img;
+	struct mem_vector region, out;
+	struct slot_area slot_area;
+	unsigned long min, start_orig;
 
 	/* Skip non-RAM entries. */
 	if (entry->type != E820_RAM)
 		return;
 
-	/* Ignore entries entirely above our maximum. */
-	if (entry->addr >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
-		return;
-
 	/* Ignore entries entirely below our minimum. */
 	if (entry->addr + entry->size < minimum)
 		return;
@@ -324,10 +337,17 @@ static void process_e820_entry(struct e820entry *entry,
 	region.start = entry->addr;
 	region.size = entry->size;
 
+repeat:
+	start_orig = region.start;
+
 	/* Potentially raise address to minimum location. */
 	if (region.start < minimum)
 		region.start = minimum;
 
+	/* Return if slot area array is full */
+	if (slot_area_index == MAX_SLOT_AREA)
+		return;
+
 	/* Potentially raise address to meet alignment requirements. */
 	region.start = ALIGN(region.start, CONFIG_PHYSICAL_ALIGN);
 
@@ -336,20 +356,30 @@ static void process_e820_entry(struct e820entry *entry,
 		return;
 
 	/* Reduce size by any delta from the original address. */
-	region.size -= region.start - entry->addr;
+	region.size -= region.start - start_orig;
 
-	/* Reduce maximum size to fit end of image within maximum limit. */
-	if (region.start + region.size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
-		region.size = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - region.start;
+	/* Return if region can't contain decompressed kernel */
+	if (region.size < image_size)
+		return;
 
-	/* Walk each aligned slot and check for avoided areas. */
-	for (img.start = region.start, img.size = image_size ;
-	     mem_contains(&region, &img) ;
-	     img.start += CONFIG_PHYSICAL_ALIGN) {
-		if (mem_avoid_overlap(&img))
-			continue;
-		slots_append(img.start);
+	if (!mem_avoid_overlap(&region)) {
+		store_slot_info(&region, image_size);
+		return;
 	}
+
+	min = mem_min_overlap(&region, &out);
+
+	if (min > region.start + image_size) {
+		struct mem_vector tmp;
+
+		tmp.start = region.start;
+		tmp.size = min - region.start;
+		store_slot_info(&tmp, image_size);
+	}
+
+	region.size -= out.start - region.start + out.size;
+	region.start = out.start + out.size;
+	goto repeat;
 }
 
 static unsigned long find_random_phy_addr(unsigned long minimum,
@@ -364,6 +394,10 @@ static unsigned long find_random_phy_addr(unsigned long minimum,
 	/* Verify potential e820 positions, appending to slots list. */
 	for (i = 0; i < real_mode->e820_entries; i++) {
 		process_e820_entry(&real_mode->e820_map[i], minimum, size);
+		if (slot_area_index == MAX_SLOT_AREA) {
+			debug_putstr("Stop processing e820 since slot_areas is full...\n");
+			break;
+		}
 	}
 
 	return slots_fetch_random();
-- 
1.8.4.5
