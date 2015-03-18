From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 15/19] x86, kaslr: Introduce fetch_random_virt_offset to randomize the kernel text mapping address
Date: Wed, 18 Mar 2015 00:28:22 -0700
Message-ID: <1426663706-23979-16-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Kaslr extended kernel text mapping region size from 512M to 1G,
namely CONFIG_RANDOMIZE_BASE_MAX_OFFSET. This means kernel text
can be mapped to below region:

[__START_KERNEL_map + LOAD_PHYSICAL_ADDR, __START_KERNEL_map + 1G]

Introduce a function find_random_virt_offset() to get random value
between LOAD_PHYSICAL_ADDR and CONFIG_RANDOMIZE_BASE_MAX_OFFSET.
This random value will be added to __START_KERNEL_map to get the
starting address which kernel text is mapped from. Since slot can
be anywhere of this region, means it is an independent slot_area,
it is simple to get a slot according to random value.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/boot/compressed/aslr.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 37dce4f..5114142 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -369,6 +369,27 @@ static unsigned long find_random_addr(unsigned long minimum,
 	return slots_fetch_random();
 }
 
+static unsigned long find_random_virt_offset(unsigned long minimum,
+				  unsigned long image_size)
+{
+	unsigned long slot_num, random;
+
+	/* Make sure minimum is aligned. */
+	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
+
+	if (image_size <= CONFIG_PHYSICAL_ALIGN)
+		slot_num = (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - minimum) /
+				CONFIG_PHYSICAL_ALIGN;
+	else
+		slot_num = (CONFIG_RANDOMIZE_BASE_MAX_OFFSET -
+				minimum - image_size) /
+				CONFIG_PHYSICAL_ALIGN + 1;
+
+	random = get_random_long() % slot_num;
+
+	return random * CONFIG_PHYSICAL_ALIGN + minimum;
+}
+
 static void add_kaslr_setup_data(__u8 enabled)
 {
 	struct setup_data *data;
-- 
1.8.4.5
