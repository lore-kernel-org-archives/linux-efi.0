From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 4/7] x86, kaslr: Access the correct kaslr_enabled variable
Date: Sat,  7 Mar 2015 14:07:18 -0800
Message-ID: <1425766041-6551-5-git-send-email-yinghai@kernel.org>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Commit

  f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")

started passing KASLR status to kernel proper, but it uses a physical
address as the vaule, leading to parsing bogus KASLR status in kernel
proper.

The setup_data linked list and thus the element which contains
kaslr_enabled is chained together using physical addresses. At the time
when we access it in the kernel proper, we're already running with
paging enabled and therefore must access it through its virtual address.

This patch changes the code to use early_memmap() and access the value.

-v3: add checking return from early_memmap according to Boris.
-v4: add description about setup_data accessing from Boris to change log.

Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 98dc931..912f124 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -429,7 +429,18 @@ static void __init reserve_initrd(void)
 
 static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
 {
-	kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
+	/* kaslr_setup_data is defined in aslr.c */
+	unsigned char *data;
+	unsigned long offset = sizeof(struct setup_data);
+
+	data = early_memremap(pa_data, offset + 1);
+	if (!data) {
+		kaslr_enabled = true;
+		return;
+	}
+
+	kaslr_enabled = *(data + offset);
+	early_memunmap(data, offset + 1);
 }
 
 static void __init parse_setup_data(void)
-- 
1.8.4.5
