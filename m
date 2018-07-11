From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/8] efi: cper: avoid using get_seconds()
Date: Wed, 11 Jul 2018 11:40:36 +0200
Message-ID: <20180711094040.12506-5-ard.biesheuvel@linaro.org>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

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
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
2.17.1
