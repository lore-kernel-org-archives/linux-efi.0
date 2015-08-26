From: Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: [PATCH v2 2/3] efi: Change abbreviation of EFI_MEMORY_RUNTIME from "RUN" to "RT"
Date: Thu, 27 Aug 2015 02:11:29 +0900
Message-ID: <1440609089-14787-1-git-send-email-izumi.taku@jp.fujitsu.com>
References: <1440609031-14695-1-git-send-email-izumi.taku@jp.fujitsu.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1440609031-14695-1-git-send-email-izumi.taku@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: tony.luck@intel.com, qiuxishi@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, ard.biesheuvel@linaro.org, linux-mm@kvack.org, Taku Izumi <izumi.taku@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

Now efi_md_typeattr_format() outputs "RUN" if passed EFI memory
descriptor has EFI_MEMORY_RUNTIME attribute. But "RT" is preferer
because it is shorter and clearer.

This patch changes abbreviation of EFI_MEMORY_RUNTIME from "RUN"
to "RT".

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
---
 drivers/firmware/efi/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 8124078..25b6477 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -594,8 +594,8 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
 		snprintf(pos, size, "|attr=0x%016llx]",
 			 (unsigned long long)attr);
 	else
-		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
-			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
+		snprintf(pos, size, "|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
+			 attr & EFI_MEMORY_RUNTIME ? "RT" : "",
 			 attr & EFI_MEMORY_MORE_RELIABLE ? "MR" : "",
 			 attr & EFI_MEMORY_XP      ? "XP"  : "",
 			 attr & EFI_MEMORY_RP      ? "RP"  : "",
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
