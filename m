From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.12 27/84] efi: Process the MEMATTR table only if EFI_MEMMAP is enabled
Date: Wed, 19 Jul 2017 11:43:33 +0200
Message-ID: <20170719092323.437018318@linuxfoundation.org>
References: <20170719092322.362625377@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719092322.362625377@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Daniel Kiper <daniel.kiper@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com, jgross@suse.com, linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, xen-devel@lists.xenproject.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Kiper <daniel.kiper@oracle.com>

commit 457ea3f7e97881f937136ce0ba1f29f82b9abdb0 upstream.

Otherwise e.g. Xen dom0 on x86_64 EFI platforms crashes.

In theory we can check EFI_PARAVIRT too, however,
EFI_MEMMAP looks more targeted and covers more cases.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: andrew.cooper3@citrix.com
Cc: boris.ostrovsky@oracle.com
Cc: jgross@suse.com
Cc: linux-efi@vger.kernel.org
Cc: matt@codeblueprint.co.uk
Cc: xen-devel@lists.xenproject.org
Link: http://lkml.kernel.org/r/1498128697-12943-2-git-send-email-daniel.kiper@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -528,7 +528,8 @@ int __init efi_config_parse_tables(void
 		}
 	}
 
-	efi_memattr_init();
+	if (efi_enabled(EFI_MEMMAP))
+		efi_memattr_init();
 
 	/* Parse the EFI Properties table if it exists */
 	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
