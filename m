From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v8 2/3] x86/boot/KASLR: Walk srat tables to filter immovable memory
Date: Wed, 10 Oct 2018 16:41:18 +0800
Message-ID: <20181010084119.17539-3-fanc.fnst@cn.fujitsu.com>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com
Cc: rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

If CONFIG_MEMORY_HOTREMOVE enabled, walk through the acpi srat memory
tables and store those immovable memory regions so that kaslr can get
where to choose for randomization.

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/kaslr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 9ed9709d9947..573e582e8709 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -417,6 +417,9 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	/* Mark the memmap regions we need to avoid */
 	handle_mem_options();
 
+	/* Mark the immovable regions we need to choose */
+	get_immovable_mem();
+
 #ifdef CONFIG_X86_VERBOSE_BOOTUP
 	/* Make sure video RAM can be used. */
 	add_identity_map(0, PMD_SIZE);
-- 
2.17.1
