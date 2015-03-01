From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Sat, 28 Feb 2015 18:17:32 -0800
Message-ID: <1425176259-30087-2-git-send-email-yinghai@kernel.org>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

We should access variable with referrence instead of using physical
address as value.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 98dc931..05d444f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -429,7 +429,13 @@ static void __init reserve_initrd(void)
 
 static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
 {
-	kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
+	/* kaslr_setup_data is defined in aslr.c */
+	unsigned char *data;
+	unsigned long offset = sizeof(struct setup_data);
+
+	data = early_memremap(pa_data, offset + 1);
+	kaslr_enabled = *(data + offset);
+	early_memunmap(data, offset + 1);
 }
 
 static void __init parse_setup_data(void)
-- 
1.8.4.5
