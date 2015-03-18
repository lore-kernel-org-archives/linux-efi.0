From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 19/19] x86, kaslr: Allow random address could be below loaded address
Date: Wed, 18 Mar 2015 00:28:26 -0700
Message-ID: <1426663706-23979-20-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Now new output buffer is always after current one.

With correct tracking in mem_avoid, we can buffer below that.

That would make sure when bootloader like patched grub2 or kexec
have put output rather near the end of ram, we still can get
random base below output.

Now just pick 512M as min_addr.

with this patch, will get:

early console in decompress_kernel
decompress_kernel:
  input: [0x13e9ee3b4-0x13f36b9df], output: [0x13c000000-0x13f394fff], heap: [0x13f376ac0-0x13f37eabf]
boot via startup_64
KASLR using RDTSC...
KASLR using RDTSC...
                     new output: [0x6f000000-0x72394fff]

Decompressing Linux... xz... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] bootconsole [uart0] enabled
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x6f000000-0x70096a9c]
[    0.000000] .rodata: [0x70200000-0x70a4efff]
[    0.000000]   .data: [0x70c00000-0x70e4e9bf]
[    0.000000]   .init: [0x70e50000-0x7120bfff]
[    0.000000]    .bss: [0x71219000-0x7234efff]
[    0.000000]    .brk: [0x7234f000-0x72374fff]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/aslr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index e3bd2e2..35da03c 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -426,7 +426,8 @@ void choose_kernel_location(unsigned char *input,
 				unsigned long output_run_size,
 				unsigned char **virt_offset)
 {
-	unsigned long random;
+	unsigned long random, min_addr;
+
 	*virt_offset = (unsigned char *)LOAD_PHYSICAL_ADDR;
 
 #ifdef CONFIG_HIBERNATION
@@ -448,8 +449,13 @@ void choose_kernel_location(unsigned char *input,
 	mem_avoid_init((unsigned long)input, input_size,
 		       (unsigned long)*output);
 
+	/* start from 512M */
+	min_addr = (unsigned long)*output;
+	if (min_addr > (512UL<<20))
+		min_addr = 512UL<<20;
+
 	/* Walk e820 and find a random address. */
-	random = find_random_phy_addr((unsigned long)*output, output_run_size);
+	random = find_random_phy_addr(min_addr, output_run_size);
 	if (!random)
 		debug_putstr("KASLR could not find suitable E820 region...\n");
 	else {
-- 
1.8.4.5
