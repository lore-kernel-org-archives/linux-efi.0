From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/2] lib/ucs2_string: Correct ucs2 -> utf8 conversion
Date: Tue, 16 Feb 2016 12:59:20 +0000
Message-ID: <1455627560-10576-3-git-send-email-matt@codeblueprint.co.uk>
References: <1455627560-10576-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455627560-10576-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jason Andryuk <jandryuk@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@coreos.com>, "Lee, Chun-Yi" <jlee@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Laszlo Ersek <lersek@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Jason Andryuk <jandryuk@gmail.com>

The comparisons should be >= since 0x800 and 0x80 require an additional bit
to store.

For the 3 byte case, the existing shift would drop off 2 more bits than
intended.

For the 2 byte case, there should be 5 bits bits in byte 1, and 6 bits in
byte 2.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Matthew Garrett <mjg59@coreos.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 lib/ucs2_string.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index 17dd74e21ef9..f0b323abb4c6 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -59,9 +59,9 @@ ucs2_utf8size(const ucs2_char_t *src)
 	for (i = 0; i < ucs2_strlen(src); i++) {
 		u16 c = src[i];
 
-		if (c > 0x800)
+		if (c >= 0x800)
 			j += 3;
-		else if (c > 0x80)
+		else if (c >= 0x80)
 			j += 2;
 		else
 			j += 1;
@@ -88,19 +88,19 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
 	for (i = 0; maxlength && i < limit; i++) {
 		u16 c = src[i];
 
-		if (c > 0x800) {
+		if (c >= 0x800) {
 			if (maxlength < 3)
 				break;
 			maxlength -= 3;
 			dest[j++] = 0xe0 | (c & 0xf000) >> 12;
-			dest[j++] = 0x80 | (c & 0x0fc0) >> 8;
+			dest[j++] = 0x80 | (c & 0x0fc0) >> 6;
 			dest[j++] = 0x80 | (c & 0x003f);
-		} else if (c > 0x80) {
+		} else if (c >= 0x80) {
 			if (maxlength < 2)
 				break;
 			maxlength -= 2;
-			dest[j++] = 0xc0 | (c & 0xfe0) >> 5;
-			dest[j++] = 0x80 | (c & 0x01f);
+			dest[j++] = 0xc0 | (c & 0x7c0) >> 6;
+			dest[j++] = 0x80 | (c & 0x03f);
 		} else {
 			maxlength -= 1;
 			dest[j++] = c & 0x7f;
-- 
2.6.2
