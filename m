Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE9F550DD0
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954968; cv=none; b=CJbq2AKvZVNTgGqUmaXlgJceTpzfLDG7zDZP+JYIBfCV5VvE/YtdAnQ+IVxAXJEMLuWkcjO/m+IWpGG/G3lq766M8WCq86pqy1CW4hzXZrdtLvCEqTha6JsHWKNSB4FV7VMfNqjeP59YV8FIq0Oaey+DBBd21j/JgwHXBNFUucg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954968; c=relaxed/simple;
	bh=s1/82MTGgkzbBwlpgHOrnKNXWZF9hy81U2YebCpxGTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IFLmTLB76zjd+QzXtBC95Gh39uxWV1QCJFetNUH8gKSnDkXZc6b6VkWrCk324dzEufHERQv5IyqxFVaF53We5DZemgBqo5vyZMd7rvOp01zx8G8a9DCagBmWAtksyNQRi0SZRC8grBTZtEA5o1VV5ClNKYJYiUn/80Kig4KTKbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BUnzup7m; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BUnzup7m"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-496bbcf7d1eso52013095e9.0
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954964; x=1789559764; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UBQRet/chWy4OOOfuuDBVXfyuNkZdYYoGG6zjY0T2rg=;
        b=BUnzup7mbsF04KZhUQWvTvTiWgnFYf/1r0V8ZWK6fVKQ9JQh5kjhexDU0XQdg5D9Sa
         wy3xjqhkbw0yLL0aL9vM9Nd7BzaSGg+rZga5DDL2C4brjNQ3aQb5BLX0iw+6AKCLkjhu
         6ml6cwZ0k+CWs4Vw6oskocg8wM2pNFeuvicb/jIxQbM+NaciVXvZcyxi3TYoTrRgg3Ci
         Jlke/9+U14tg72vU5NIy9IWRqWl3Qqq+9UNjAHmU+c9fSHIatUwvY8gEtCeCej1U+Xti
         25me1c1qrGjXGsZ1F/PYaT2mZd9DKoIoeYd/Deyk6dFKiK0tCrxY3I70XHND4gOr+3ib
         lN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954964; x=1789559764;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UBQRet/chWy4OOOfuuDBVXfyuNkZdYYoGG6zjY0T2rg=;
        b=Ez6fRR/B2AApdunhB/9ZxKYQysb/0cfWOtAHqFLzufKbyXwrNmzgNjPL5MCx6+SLOP
         f4nmEvLaBzd/A35zGdOqvCl8wxpQd3GpsIhgJ4qiqvz1zPoShlgVDOUnq5ZqRyUoe+Gn
         IxFOi8Mtcujy9mL+aVIh/G0/XUXqpCyu0/yxzCXn9ho8oLvvN3hREfnPLmSPguRtRAO+
         7oOPjvQZx/Tsr5BM2SatLgfT226i6Q4ORTqBXHzsbsJZJNGJTkaNq587KYceq8Q9mbjH
         MCmUUWn+Wf+6+lrYapJ2gkKkDTQecerfeIuqlXpYdNN/4TSCGFeg2qUxTH4muh4qFqqB
         8Aig==
X-Gm-Message-State: AFuF++nm81Tl6XW5UOPm0ojJ4qMqCSYh665tHEAvzujhgv8fpeoMYKet
	R8Q6sA1HQ7iyEf+K48XDIByeFnElQ9nJhy5+EB1qgVYieKZ7r2eEATM3qi1yf6j+Ng2lVsDInAd
	dBi8kYK7cCTC6dJmUmJxMZXIVHpWk3liR6Il/8Qb56v6/8pktBLhQmHN39wn48bC6NMjKgl/kNT
	0tm1dRIxFV55n3xD6owPJoY2BDDhzavg==
X-Received: from wmpm28.prod.google.com ([2002:a05:600c:91c:b0:49b:90c7:d488])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:848e:20b0:495:4d88:e630
 with SMTP id 5b1f17b1804b1-49cf824f697mr252322075e9.10.1788954964312; Wed, 09
 Sep 2026 04:56:04 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:39 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2963; i=ardb@kernel.org;
 h=from:subject; bh=8w5CNhvLDyt2eBYmWjMeec5mW8SnFbz6woyBTfjX6VE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp42oXIilb4t0cMLbFZf8Kxgl1DcsT42/stbh08Xa4
 +IFE3Z3lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIkskGX4K+SWbvqo/xj7nZvC
 CUonHF7vtHzg8/pWxEomdQ976e/fjBgZOvNK+27s8vC6E3KIzWr9lh08h00vVKs1rJ77qdje9dh ubgA=
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-20-ardb+git@google.com>
Subject: [PATCH v2 08/10] efi/libstub: Add support for printing human readable GUIDs
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

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
index bd32af6b4f4d..7f6b891a338a 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -113,6 +113,9 @@ char *put_dec(char *end, unsigned long long n)
 	return p;
 }
 
+/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
 static
 char *number(char *end, unsigned long long num, int base, char locase)
 {
@@ -121,9 +124,6 @@ char *number(char *end, unsigned long long num, int base, char locase)
 	 * produces same digits or (maybe lowercased) letters
 	 */
 
-	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
-	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
-
 	switch (base) {
 	case 10:
 		if (num != 0)
@@ -144,6 +144,29 @@ char *number(char *end, unsigned long long num, int base, char locase)
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
@@ -253,8 +276,7 @@ do {				\
 int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 		  bool crlf)
 {
-	/* The maximum space required is to print a 64-bit number in octal */
-	char tmp[(sizeof(unsigned long long) * 8 + 2) / 3];
+	char tmp[UUID_STRING_LEN];
 	char *tmp_end = &tmp[ARRAY_SIZE(tmp)];
 	long long num;
 	int base;
@@ -367,6 +389,14 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
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
2.55.0.1003.g10538fe699-goog

