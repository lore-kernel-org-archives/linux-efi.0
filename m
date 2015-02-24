From: Juergen Gross <jgross@suse.com>
Subject: [PATCH 3/4] x86: use early_memunmap in arch/x86/kernel/setup.c
Date: Tue, 24 Feb 2015 10:13:30 +0100
Message-ID: <1424769211-11378-4-git-send-email-jgross@suse.com>
References: <1424769211-11378-1-git-send-email-jgross@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424769211-11378-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, linux-efi@vger.kernel.org, matt.fleming@intel.com
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-efi@vger.kernel.org

Memory mapped via early_memremap() should be unmapped with
early_memunmap() instead of early_iounmap().

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kernel/setup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 98dc931..733864a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -356,7 +356,7 @@ static void __init relocate_initrd(void)
 		mapaddr = ramdisk_image & PAGE_MASK;
 		p = early_memremap(mapaddr, clen+slop);
 		memcpy(q, p+slop, clen);
-		early_iounmap(p, clen+slop);
+		early_memunmap(p, clen+slop);
 		q += clen;
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
@@ -445,7 +445,7 @@ static void __init parse_setup_data(void)
 		data_len = data->len + sizeof(struct setup_data);
 		data_type = data->type;
 		pa_next = data->next;
-		early_iounmap(data, sizeof(*data));
+		early_memunmap(data, sizeof(*data));
 
 		switch (data_type) {
 		case SETUP_E820_EXT:
@@ -480,7 +480,7 @@ static void __init e820_reserve_setup_data(void)
 			 E820_RAM, E820_RESERVED_KERN);
 		found = 1;
 		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
+		early_memunmap(data, sizeof(*data));
 	}
 	if (!found)
 		return;
@@ -501,7 +501,7 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 		data = early_memremap(pa_data, sizeof(*data));
 		memblock_reserve(pa_data, sizeof(*data) + data->len);
 		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
+		early_memunmap(data, sizeof(*data));
 	}
 }
 
-- 
2.1.4
