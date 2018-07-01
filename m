From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.17 083/220] efi/libstub/tpm: Initialize efi_physical_addr_t vars to zero for mixed mode
Date: Sun,  1 Jul 2018 18:21:47 +0200
Message-ID: <20180701160911.897966940@linuxfoundation.org>
References: <20180701160908.272447118@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180701160908.272447118@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 52e1cf2d19c2e62e6a81b8de3f7320d033917dd5 upstream.

Commit:

  79832f0b5f71 ("efi/libstub/tpm: Initialize pointer variables to zero for mixed mode")

fixes a problem with the tpm code on mixed mode (64-bit kernel on 32-bit UEFI),
where 64-bit pointer variables are not fully initialized by the 32-bit EFI code.

A similar problem applies to the efi_physical_addr_t variables which
are written by the ->get_event_log() EFI call. Even though efi_physical_addr_t
is 64-bit everywhere, it seems that some 32-bit UEFI implementations only
fill in the lower 32 bits when passed a pointer to an efi_physical_addr_t
to fill.

This commit initializes these to 0 to, to ensure the upper 32 bits are
0 in mixed mode. This fixes recent kernels sometimes hanging during
early boot on mixed mode UEFI systems.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: <stable@vger.kernel.org> # v4.16+
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20180622064222.11633-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/libstub/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -64,7 +64,7 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_
 	efi_guid_t tcg2_guid = EFI_TCG2_PROTOCOL_GUID;
 	efi_guid_t linux_eventlog_guid = LINUX_EFI_TPM_EVENT_LOG_GUID;
 	efi_status_t status;
-	efi_physical_addr_t log_location, log_last_entry;
+	efi_physical_addr_t log_location = 0, log_last_entry = 0;
 	struct linux_efi_tpm_eventlog *log_tbl = NULL;
 	unsigned long first_entry_addr, last_entry_addr;
 	size_t log_size, last_entry_size;
