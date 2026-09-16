Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C2832ED3A
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570059; cv=none; b=HspMaqHgQ4Kb1IigKRoU7HKhf4yl1oGsim6Lufk5pVpKK5RCGGjy1DB0d5AzJE/PFda4mveTnDYGHF+rDiJNZUCx5LPGytAxO6KlU+BJM+6iPrXFHATLSsgdk8rTQ3uyb0ZIdZN7WdUf7O4CDCVepW35QZzPT1CcYFL1OXq+1tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570059; c=relaxed/simple;
	bh=OuZ8FbKxnQyrbFX0fG6Hzht0V5w4fGRW+VAq0BseW9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bUMkxLlXr6rnwGdRGkry1diAFTCVuwdW/OQGz1UVuWYO98YUrJJydKeGTfSl7ByLD8qjPQjX3W3iBVHzRmWVztG8FtXBzzP6MIG2DQAwZYsJpGgJgBVaYFPgIBls0mXUmF2r91jPV/J78dlE92IN/BfvrN1404iTynMpCwpM+OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QgjWP523; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QgjWP523"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c295b027ee0so481380766b.0
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570055; x=1790174855; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n7++c8G2n+1RKQWflt7ZuCXFqKBOkqbx84bi5KofggA=;
        b=QgjWP523TMmrXYzVYuUvk4r9dPqoG59JY4I/kqxP9q+dACGaUuferxa3U9oiS4W+f5
         jLMnDmeYWw/pnyfG3mrhTIeUysdf7Ef5e/whdgTBjpKg35vmtOWSmMZFrIp6eY/5sNtb
         42kwWyNJJD+L+7/iAC55VdaFxoNmH6PLyT1dYD3SrpMk/tihmja7wLYSRjj+/94JYwQU
         gUSNrphBpNjjU9utZtv4+khTYCGzF15oGNtBEHOFk8aatwfjEjnC0fzgrWqgAtPViZBp
         v37p1lv7qGbZ041NSBxLwXY/bz0K2edGDWSZDSEK3jSKc8qryyFweQaRBMVMAJz6neBb
         mF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570055; x=1790174855;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n7++c8G2n+1RKQWflt7ZuCXFqKBOkqbx84bi5KofggA=;
        b=d/lRdwhNYx5IQWa6M2dCJ6upSIn01iWPyreA5k2CkJXX28pRNM4lBdkc2+4Uts/j+D
         k27XxrV63LHWdhR2nXUNBd2eHTQjFvjDlKwXn8VdguJA7E22HH8t0l9WukcDzT1QkSNv
         r45EMe0B8cGElrVxtvAfRpwJYbwc0K0ywZH327nr0laIHawdwiRg7gtvJoIGGL8EQ0lr
         xBTl3i6hvAehGBbmC1ldqLBa3yapeZ2Nk5AwYh5C/ki3TDi0zcIiaECXO1FFES8slOfh
         n2NPQ4LBpLYVrMFS+uo8y74NwdfkCC0SBCepHP9dZjnm7gzDQ2aWiQ/xdIBOeoI9pORR
         nErQ==
X-Gm-Message-State: AFuF++mhuzOufTDsY+Oil1VILIg9xiLqamR+JTyFBRzln7xoaUP5uvmV
	C3fuuY/s/GyAowlUvEhiK1/xAamruDMO065XDLPGGBaHv5D88gVZuMzaczUevueFIeUkVmbmLyV
	U7JJlrtMllKJnyhNhfnQYJSQM/N+zy5ozdeMW6hYzOF2GDjPBrbvGpYzIgqLeuF+PUD7nZvglh0
	CFp7+qWcKJk1wHPK9f1miF7uxgpYtsAQ==
X-Received: from ejbmj23.prod.google.com ([2002:a17:906:af97:b0:c25:2b28:b647])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6092:b0:c16:84dc:9607
 with SMTP id a640c23a62f3a-c29e5333df7mr354716466b.19.1789570054133; Wed, 16
 Sep 2026 07:47:34 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:55 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2858; i=ardb@kernel.org;
 h=from:subject; bh=BHh6avMxu3GGP3VARPK44z1/lEJAob47wThf/IcE9TQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6ocem/s3l94UfLzytF+Uy7KLBrWzpglLPaydfUHRx
 33CpHuRHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiR7czMrw8weEyp7PdvC3d
 vf5vsODExa+1sso8RB4nq04Srk+6d4Dhr7ToUuHJp1tmt8YZreme7lyod3BWWZz7zG3s68yyd5w /xQ0A
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-18-ardb+git@google.com>
Subject: [PATCH v3 7/9] efi/libstub: Add support for printing human readable GUIDs
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Add support for the %pUl printk conversion specifier, which takes a
pointer to a GUID and prints it in the usual format:

  aaaaaaaa-bbbb-cccc-dddd-dddddddddddd

Co-developed-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/vsprintf.c | 39 +++++++++++++++++---
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index bd32af6b4f4d..54b82ba798a2 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -113,6 +113,8 @@ char *put_dec(char *end, unsigned long long n)
 	return p;
 }
 
+static const char digits[16] = "0123456789ABCDEF";
+
 static
 char *number(char *end, unsigned long long num, int base, char locase)
 {
@@ -121,9 +123,6 @@ char *number(char *end, unsigned long long num, int base, char locase)
 	 * produces same digits or (maybe lowercased) letters
 	 */
 
-	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
-	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
-
 	switch (base) {
 	case 10:
 		if (num != 0)
@@ -144,6 +143,29 @@ char *number(char *end, unsigned long long num, int base, char locase)
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
@@ -253,8 +275,7 @@ do {				\
 int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 		  bool crlf)
 {
-	/* The maximum space required is to print a 64-bit number in octal */
-	char tmp[(sizeof(unsigned long long) * 8 + 2) / 3];
+	char tmp[UUID_STRING_LEN];
 	char *tmp_end = &tmp[ARRAY_SIZE(tmp)];
 	long long num;
 	int base;
@@ -367,6 +388,14 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
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
2.55.0.1032.g73a4cd73de-goog

