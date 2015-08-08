From: <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Patch "efi: fix 32bit kernel boot failed problem using efi" has been added to the 3.10-stable tree
Date: Sat, 08 Aug 2015 15:05:18 -0700
Message-ID: <1439071518248231@kroah.com>
References: <1438653081-25746-1-git-send-email-fupan.li@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438653081-25746-1-git-send-email-fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, fupanli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    efi: fix 32bit kernel boot failed problem using efi

to the 3.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     efi-fix-32bit-kernel-boot-failed-problem-using-efi.patch
and it can be found in the queue-3.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> know about it.


>From fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org  Sat Aug  8 15:03:02 2015
From: <fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Date: Tue, 4 Aug 2015 09:51:21 +0800
Subject: efi: fix 32bit kernel boot failed problem using efi
To: <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: <jslaby-AlSwsSmVLrQ@public.gmane.org>, <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <fupanli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Message-ID: <1438653081-25746-1-git-send-email-fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

From: Fupan Li <fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

Commit 35d5134b7d5a
("x86/efi: Correct EFI boot stub use of code32_start")
imported a bug, which will cause 32bit kernel boot failed
using efi method. It should use the label's address instead
of the value stored in the label to caculate the address of
code32_start.

Signed-off-by: Fupan Li <fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


Patches currently in stable-queue which might be from fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org are

queue-3.10/efi-fix-32bit-kernel-boot-failed-problem-using-efi.patch
