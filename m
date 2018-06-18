From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] efi: cper: avoid using get_seconds()
Date: Mon, 18 Jun 2018 16:17:59 +0200
Message-ID: <20180618141811.3353245-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>, Yazen Ghannam <yazen.ghannam@amd.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, gengdongjiu <gengdongjiu@huawei.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

get_seconds() is deprecated because of the 32-bit time overflow
in y2038/y2106 on 32-bit architectures. The way it is used in
cper_next_record_id() causes an overflow in 2106 when unsigned UTC
seconds overflow, even on 64-bit architectures.

This starts using ktime_get_real_seconds() to give us more than 32 bits
of timestamp on all architectures, and then changes the algorithm to use
39 bits for the timestamp after the y2038 wrap date, plus an always-1
bit at the top. This gives us another 127 epochs of 136 years, with
strictly monotonically increasing sequence numbers across boots.

This is almost certainly overkill, but seems better than just extending
the deadline from 2038 to 2106.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/firmware/efi/cper.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 3bf0dca378a6..b73fc4cab083 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -48,8 +48,21 @@ u64 cper_next_record_id(void)
 {
 	static atomic64_t seq;
 
-	if (!atomic64_read(&seq))
-		atomic64_set(&seq, ((u64)get_seconds()) << 32);
+	if (!atomic64_read(&seq)) {
+		time64_t time = ktime_get_real_seconds();
+
+		/*
+		 * This code is unlikely to still be needed in year 2106,
+		 * but just in case, let's use a few more bits for timestamps
+		 * after y2038 to be sure they keep increasing monotonically
+		 * for the next few hundred years...
+		 */
+		if (time < 0x80000000)
+			atomic64_set(&seq, (ktime_get_real_seconds()) << 32);
+		else
+			atomic64_set(&seq, 0x8000000000000000ull |
+					   ktime_get_real_seconds() << 24);
+	}
 
 	return atomic64_inc_return(&seq);
 }
-- 
2.9.0
