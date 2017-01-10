From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 099/206] efi/efivar_ssdt_load: Dont return success on allocation failure
Date: Tue, 10 Jan 2017 14:36:22 +0100
Message-ID: <20170110131507.141194322@linuxfoundation.org>
References: <20170110131502.767555407@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170110131502.767555407@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a75dcb5848359f488c32c0aef8711d9bd37a77b8 upstream.

We should return -ENOMEM here, instead of success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 475fb4e8b2f4 ("efi / ACPI: load SSTDs from EFI variables")
Link: http://lkml.kernel.org/r/20161018143318.15673-9-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -259,8 +259,10 @@ static __init int efivar_ssdt_load(void)
 		}
 
 		data = kmalloc(size, GFP_KERNEL);
-		if (!data)
+		if (!data) {
+			ret = -ENOMEM;
 			goto free_entry;
+		}
 
 		ret = efivar_entry_get(entry, NULL, &size, data);
 		if (ret) {
