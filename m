Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5030B3CF20C;
	Sun,  6 Sep 2026 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700129; cv=none; b=sdxw6d1Cztxezjm2Q3iIFUTarvvoYSVLAwQHyxgFpA907Yqrw72uBV2lUbTPmWmOasuVNHbxVXUDjBQ7HKMw+wx4OJKw+7yiWTlrtq4JKYM6EwQ8hIeFX6mg8a1L/b/0eOStXvwrlJz0eoly1V69FObrpkWb6Z2YY5fFhoSPduo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700129; c=relaxed/simple;
	bh=iboO10g3Ee6nqq95gXfzyoo/IppyePzufMy4zEa754I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No2nLnllnXmfteyuZGJIJ2YpZhPH5jvbGpgr/1H8mCDLYVW+EtlkRnDbeHmIBolV+h7Ka03FiMf5AmJJ7mTZ42qj5qL1JNiOiVUwji43FVHnZheE/50L2oLDF+GkIuk2AXK7a7OVySbBwhg+PyTrCv8lpOHS9QGBxPVBFzF1ukI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhAav7vB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhAav7vB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB641F00A3D;
	Sun,  6 Sep 2026 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788700127;
	bh=ypS4GaCWPY2eWch613jft148kE4UGIa+o3+eY6E2KWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhAav7vB+QHZXfe2G/+S6Bc84xoSJbFkVup32E0mCjXZwCtRpSCviXTdTKVFauyQQ
	 Kmu8R3PrrItiyzP7hqL7wNEqywC1l8x4JMN4mdzJ/EIUC7ITBbgughNFEPibEr36jH
	 DeX3oKAJLalxNSJnXLHBRKoiKzb6McT6s1X1DIEbxX5vZkGMmizdU/Y0rs/Dz/ZLmp
	 mmXlo6ransHcTamfyfFd8shHkiOiuolt5o5nUDmV/CmikaFZxbMybanhSzcAnlCbAs
	 rcZOjXMZDhYaeVHceFXHrPfsmAi6+HNxH+KJij6Be9uNGJ/ncok6PpxDcYWImD1Oti
	 3x3dUaQBptlYA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: [PATCH 6/7] efi/libstub: Add support for printing human readable GUIDs
Date: Sun,  6 Sep 2026 15:08:24 +0200
Message-ID: <20260906130817.1151961-15-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2941; i=ardb@kernel.org; h=from:subject; bh=iboO10g3Ee6nqq95gXfzyoo/IppyePzufMy4zEa754I=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWtu6rnL7+Z1NZhIzdYsSOqSjYz41nlAQa3nmBfTn/3iC xlXic3oKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNpN2NkuF0rO2V1NMvf1GDz 8j7nf0Us+ny75e5JZ5d98VN/pbl+DsNfySi13fu/C39Yp27hIbFMdek2kwrfZ6yTVhW7zDRaeuY zEwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Add support for the %pUl printk conversion specifier, which takes a
pointer to a GUID and prints it in the usual format:

  aaaaaaaa-bbbb-cccc-dddd-dddddddddddd

Co-developed-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/vsprintf.c | 40 +++++++++++++++++---
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index 9ac6df268105..4c11cee6c722 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -111,6 +111,9 @@ char *put_dec(char *end, unsigned long long n)
 	return p;
 }
 
+/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
 static
 char *number(char *end, unsigned long long num, int base, char locase)
 {
@@ -119,9 +122,6 @@ char *number(char *end, unsigned long long num, int base, char locase)
 	 * produces same digits or (maybe lowercased) letters
 	 */
 
-	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
-	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
-
 	switch (base) {
 	case 10:
 		if (num != 0)
@@ -142,6 +142,29 @@ char *number(char *end, unsigned long long num, int base, char locase)
 	return end;
 }
 
+static char *guid_to_str(const efi_guid_t *guid, char *out, char locase)
+{
+	static const u8 guid_index[UUID_SIZE] = {
+		3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15,
+	};
+
+	for (int i = 0, p = 0; i < ARRAY_SIZE(guid_index); i++) {
+		u8 byte = guid->b[guid_index[i]];
+
+		out[p++] = locase | digits[byte >> 4];
+		out[p++] = locase | digits[byte & 0xf];
+
+		switch (i) {
+		case 3:
+		case 5:
+		case 7:
+		case 9:
+			out[p++] = '-';
+		}
+	}
+	return out;
+}
+
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
@@ -251,8 +274,7 @@ do {				\
 int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 		  bool crlf)
 {
-	/* The maximum space required is to print a 64-bit number in octal */
-	char tmp[(sizeof(unsigned long long) * 8 + 2) / 3];
+	char tmp[UUID_STRING_LEN];
 	char *tmp_end = &tmp[ARRAY_SIZE(tmp)];
 	long long num;
 	int base;
@@ -365,6 +387,14 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 			break;
 
 		case 'p':
+			if (fmt[1] == 'U' && (fmt[2] | 0x20) == 'l') {
+				flags &= LEFT;
+				s = guid_to_str(va_arg(args, efi_guid_t *), tmp, fmt[2] & 0x20);
+				precision = len = UUID_STRING_LEN;
+				fmt += 2;
+				goto output;
+			}
+
 			if (precision < 0)
 				precision = 2 * sizeof(void *);
 			fallthrough;
-- 
2.47.3

