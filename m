From: Juergen Gross <jgross@suse.com>
Subject: [PATCH 2/4] x86: use early_memunmap in arch/x86/kernel/e820.c
Date: Tue, 24 Feb 2015 10:13:29 +0100
Message-ID: <1424769211-11378-3-git-send-email-jgross@suse.com>
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
 arch/x86/kernel/e820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 46201de..7d46bb2 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -661,7 +661,7 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-	early_iounmap(sdata, data_len);
+	early_memunmap(sdata, data_len);
 	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
 }
-- 
2.1.4
