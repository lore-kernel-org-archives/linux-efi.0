From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 039/164] efi/esrt: Use memunmap() instead of kfree() to free the remapping
Date: Tue, 12 Dec 2017 13:43:39 +0100
Message-ID: <20171212123445.700984798@linuxfoundation.org>
References: <20171212123443.785979602@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171212123443.785979602@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pan Bian <bianpan2016@163.com>

commit 89c5a2d34bda58319e3075e8e7dd727ea25a435c upstream.

The remapping result of memremap() should be freed with memunmap(), not kfree().

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20171206095010.24170-3-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/esrt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -428,7 +428,7 @@ err_remove_group:
 err_remove_esrt:
 	kobject_put(esrt_kobj);
 err:
-	kfree(esrt);
+	memunmap(esrt);
 	esrt = NULL;
 	return error;
 }
