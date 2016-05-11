From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH 2/2] Fix efi_call
Date: Wed, 11 May 2016 14:55:45 -0500
Message-ID: <1462996545-98387-3-git-send-email-athorlton@sgi.com>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

The efi_call assembly code has a slight error that prevents us from
using arguments 7 and higher, which will be passed in on the stack.

        mov (%rsp), %rax
        mov 8(%rax), %rax
	...
        mov %rax, 40(%rsp)

This code goes and grabs the return address for the current stack frame,
and puts it on the stack, next the 5th argument for the EFI runtime
call.  Considering the fact that having the return address in that
position on the stack makes no sense, I'm guessing that the intent of
this code was actually to grab an argument off the stack frame for this
call and place it into the frame for the next one.

The small change to that offset (i.e. 8(%rax) to 16(%rax)) ensures that
we grab the 7th argument off the stack, and pass it as the 6th argument
to the EFI runtime function that we're about to call.  This change gets
our EFI runtime calls that need to pass more than 6 arguments working
again.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/platform/efi/efi_stub_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 92723ae..62938ff 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -43,7 +43,7 @@ ENTRY(efi_call)
 	FRAME_BEGIN
 	SAVE_XMM
 	mov (%rsp), %rax
-	mov 8(%rax), %rax
+	mov 16(%rax), %rax
 	subq $48, %rsp
 	mov %r9, 32(%rsp)
 	mov %rax, 40(%rsp)
-- 
1.8.5.6
