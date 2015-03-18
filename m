From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 12/19] x86, kaslr: Fix a bug that relocation can not be handled when kernel is loaded above 2G
Date: Wed, 18 Mar 2015 00:28:19 -0700
Message-ID: <1426663706-23979-13-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

When process 32 bit relocation tables a local variable extended is
defined to calculate the physical address of relocs entry. However
it's type is int which is enough for i386, for x86_64 not enough.
That's why relocation can only be handled when kernel is loaded
below 2G, otherwise a overflow will happen and cause system hang.

Here change it to long as 32 bit inverse relocation processing does,
and this change is safe for i386 relocation handling too.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 94e283c..d6b4d91 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -273,7 +273,7 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * So we work backwards from the end of the decompressed image.
 	 */
 	for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
-		int extended = *reloc;
+		long extended = *reloc;
 		extended += map;
 
 		ptr = (unsigned long)extended;
-- 
1.8.4.5
