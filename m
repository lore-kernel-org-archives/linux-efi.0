From: <gregkh@linuxfoundation.org>
Subject: Patch "efi: fix 32bit kernel boot failed problem using efi" has been added to the 3.14-stable tree
Date: Sat, 08 Aug 2015 15:05:22 -0700
Message-ID: <143907152212120@kroah.com>
References: <1438653081-25746-1-git-send-email-fupan.li@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438653081-25746-1-git-send-email-fupan.li@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
To: fupan.li@windriver.com, ben@decadent.org.uk, fupanli@gmail.com, gregkh@linuxfoundation.org, jslaby@suse.cz, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, matt@codeblueprint.co.uk
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    efi: fix 32bit kernel boot failed problem using efi

to the 3.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     efi-fix-32bit-kernel-boot-failed-problem-using-efi.patch
and it can be found in the queue-3.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From fupan.li@windriver.com  Sat Aug  8 15:03:02 2015
From: <fupan.li@windriver.com>
Date: Tue, 4 Aug 2015 09:51:21 +0800
Subject: efi: fix 32bit kernel boot failed problem using efi
To: <gregkh@linuxfoundation.org>, <matt@codeblueprint.co.uk>
Cc: <jslaby@suse.cz>, <linux-efi@vger.kernel.org>, <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <fupanli@gmail.com>, <ben@decadent.org.uk>
Message-ID: <1438653081-25746-1-git-send-email-fupan.li@windriver.com>

From: Fupan Li <fupan.li@windriver.com>

Commit 35d5134b7d5a
("x86/efi: Correct EFI boot stub use of code32_start")
imported a bug, which will cause 32bit kernel boot failed
using efi method. It should use the label's address instead
of the value stored in the label to caculate the address of
code32_start.

Signed-off-by: Fupan Li <fupan.li@windriver.com>
Reviewed-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


Patches currently in stable-queue which might be from fupan.li@windriver.com are

queue-3.14/efi-fix-32bit-kernel-boot-failed-problem-using-efi.patch
