From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.5 126/200] efi: Expose non-blocking set_variable() wrapper to efivars
Date: Mon,  2 May 2016 17:12:05 -0700
Message-ID: <20160503000558.728683187@linuxfoundation.org>
References: <20160503000554.631204776@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160503000554.631204776@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 9c6672ac9c91f7eb1ec436be1442b8c26d098e55 upstream.

Commit 6d80dba1c9fe ("efi: Provide a non-blocking SetVariable()
operation") implemented a non-blocking alternative for the UEFI
SetVariable() invocation performed by efivars, since it may
occur in atomic context. However, this version of the function
was never exposed via the efivars struct, so the non-blocking
versions was not actually callable. Fix that.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 6d80dba1c9fe ("efi: Provide a non-blocking SetVariable() operation")
Link: http://lkml.kernel.org/r/1454364428-494-2-git-send-email-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -182,6 +182,7 @@ static int generic_ops_register(void)
 {
 	generic_ops.get_variable = efi.get_variable;
 	generic_ops.set_variable = efi.set_variable;
+	generic_ops.set_variable_nonblocking = efi.set_variable_nonblocking;
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_store = efi_query_variable_store;
 
