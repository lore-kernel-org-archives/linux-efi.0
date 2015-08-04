From: <fupan.li@windriver.com>
Subject: [PATCH V3 request from stable 3.10 to 3.14] efi: fix 32bit kernel boot failed problem using efi
Date: Tue, 4 Aug 2015 09:51:21 +0800
Message-ID: <1438653081-25746-1-git-send-email-fupan.li@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, matt@codeblueprint.co.uk
Cc: jslaby@suse.cz, linux-efi@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, fupanli@gmail.com, ben@decadent.org.uk
List-Id: linux-efi@vger.kernel.org

From: Fupan Li <fupan.li@windriver.com>

Commit 35d5134b7d5a
("x86/efi: Correct EFI boot stub use of code32_start")
imported a bug, which will cause 32bit kernel boot failed
using efi method. It should use the label's address instead
of the value stored in the label to caculate the address of
code32_start.

Signed-off-by: Fupan Li <fupan.li@windriver.com>
---
 arch/x86/boot/compressed/head_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index abb988a..3b28eff 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -54,7 +54,7 @@ ENTRY(efi_pe_entry)
 	call	reloc
 reloc:
 	popl	%ecx
-	subl	reloc, %ecx
+	subl	$reloc, %ecx
 	movl	%ecx, BP_code32_start(%eax)
 
 	sub	$0x4, %esp
-- 
1.9.1
