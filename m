From: Yazen Ghannam <Yazen.Ghannam@amd.com>
Subject: [PATCH v4 1/8] efi: Fix IA32/X64 Processor Error Record definition
Date: Mon,  2 Apr 2018 10:06:49 -0500
Message-ID: <20180402150656.101022-2-Yazen.Ghannam@amd.com>
References: <20180402150656.101022-1-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180402150656.101022-1-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, bp@suse.de, x86@kernel.org, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

Based on UEFI 2.7 Table 255. Processor Error Record, the "Local APIC_ID"
field is 8 bytes but Linux defines this field as 1 byte.

Fix this in the struct cper_sec_proc_ia definition.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
---
Link:
https://lkml.kernel.org/r/20180324184940.19762-2-Yazen.Ghannam@amd.com

v3->v4:
* No changes.

v2->v3:
* Fix table number in commit message.

v1->v2:
* No changes

 include/linux/cper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cper.h b/include/linux/cper.h
index d14ef4e77c8a..4b5f8459b403 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -381,7 +381,7 @@ struct cper_sec_proc_generic {
 /* IA32/X64 Processor Error Section */
 struct cper_sec_proc_ia {
 	__u64	validation_bits;
-	__u8	lapic_id;
+	__u64	lapic_id;
 	__u8	cpuid[48];
 };
 
-- 
2.14.1
