From: Juergen Gross <jgross@suse.com>
Subject: [PATCH 1/4] x86: use early_memunmap in arch/x86/kernel/devicetree.c
Date: Tue, 24 Feb 2015 10:13:28 +0100
Message-ID: <1424769211-11378-2-git-send-email-jgross@suse.com>
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
 arch/x86/kernel/devicetree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3d35033..6367a78 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -286,13 +286,13 @@ static void __init x86_flattree_get_config(void)
 	initial_boot_params = dt = early_memremap(initial_dtb, map_len);
 	size = of_get_flat_dt_size();
 	if (map_len < size) {
-		early_iounmap(dt, map_len);
+		early_memunmap(dt, map_len);
 		initial_boot_params = dt = early_memremap(initial_dtb, size);
 		map_len = size;
 	}
 
 	unflatten_and_copy_device_tree();
-	early_iounmap(dt, map_len);
+	early_memunmap(dt, map_len);
 }
 #else
 static inline void x86_flattree_get_config(void) { }
-- 
2.1.4
