From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v7 2/3] x86/boot/KASLR: Walk srat tables to filter immovable memory
Date: Thu, 13 Sep 2018 18:46:28 +0800
Message-ID: <20180913104629.5179-3-fanc.fnst@cn.fujitsu.com>
References: <20180913104629.5179-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913104629.5179-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, bhe@redhat.com
Cc: rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, Chao Fan <fanc.fnst@cn.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

If CONFIG_MEMORY_HOTREMOVE enabled, walk through the acpi srat memory
tables and store those immovable memory regions so that kaslr can get
where to choose for randomization.

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/kaslr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 9ed9709d9947..0c3567bc231c 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -417,6 +417,11 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	/* Mark the memmap regions we need to avoid */
 	handle_mem_options();
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+	/* Mark the immovable regions we need to choose */
+	get_immovable_mem();
+#endif
+
 #ifdef CONFIG_X86_VERBOSE_BOOTUP
 	/* Make sure video RAM can be used. */
 	add_identity_map(0, PMD_SIZE);
-- 
2.17.1
