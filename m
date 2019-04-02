From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH 1/2] efi: Fix cast to pointer from integer of different size
 in TPM log code
Date: Tue,  2 Apr 2019 14:55:55 -0700
Message-ID: <20190402215556.257406-2-matthewgarrett@google.com>
References: <20190402215556.257406-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402215556.257406-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com, Matthew Garrett <matthewgarrett@google.com>, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

8bfcff4a6a1d9d7226bb63a7da758b82d9ab4373 introduced a cast from
efi_physical_address_t to (void *), which are different sizes on 32-bit.
Fix that. Caught by the 0-day test bot.

Signed-off-by: Matthew Garrett <mjg59@google.com>
---
 drivers/firmware/efi/libstub/tpm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index b6e93e14fcf1..6b3b507a54eb 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -114,8 +114,8 @@ void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table_arg)
 			 */
 			last_entry_size =
 				__calc_tpm2_event_size((void *)last_entry_addr,
-						       (void *)log_location,
-						       false);
+						    (void *)(long)log_location,
+						    false);
 		} else {
 			last_entry_size = sizeof(struct tcpa_event) +
 			   ((struct tcpa_event *) last_entry_addr)->event_size;
-- 
2.21.0.392.gf8f6787159e-goog
