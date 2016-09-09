From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 19/29] lib/ucs2_string: Speed up ucs2_utf8size()
Date: Fri,  9 Sep 2016 16:18:41 +0100
Message-ID: <20160909151851.27577-20-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

No need to calculate the string length on every loop iteration.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 lib/ucs2_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index f0b323abb4c6..ae8d2491133c 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -56,7 +56,7 @@ ucs2_utf8size(const ucs2_char_t *src)
 	unsigned long i;
 	unsigned long j = 0;
 
-	for (i = 0; i < ucs2_strlen(src); i++) {
+	for (i = 0; src[i]; i++) {
 		u16 c = src[i];
 
 		if (c >= 0x800)
-- 
2.9.3
