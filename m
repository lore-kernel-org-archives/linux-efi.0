Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B1754DAF9
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954964; cv=none; b=W7oR+CXUCarcyQH8tmuTN4Z7qpHdCl5HpcX6H3RNx+TaCXMoDbpWidoHHs/8JlFPmoiMNOfEyDxsSz6vY/g8LEeG1IeDegCMxtmbFf2Y7FXDEKNQhXghp+SLnUjoeTmiqHtaneXNzOp+HsYpONpz0ssXRhoCMQCwPjSiXPJt0Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954964; c=relaxed/simple;
	bh=X6rSS2Ud/nPCzc6nAeL1YpQCFMZ1iQCr+SIHwWuezlI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Or7fVA+T5heesPQF0XItNnXOZOUO7M6pUliyezVNuFm912UTjGJP4WS1Gh0gr8Ksb+YE5LI3LCxhOpfRP1CUKX0EPSwVKANQcLPrk97ZtH5yqZizCnbdjvPQmwygwjwoM+9p0vyGb40E6SZX/7xiB5JWnPT4InS481APhU5hJzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ilu7rR+V; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ilu7rR+V"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495529a93f9so57577375e9.3
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954960; x=1789559760; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SJt8ZcdZG9yVISY4f4k7yj08nGsSFwJkPsldz9PZDh0=;
        b=Ilu7rR+VTURlTU0BhiSVcrdfrxklIcawRizCNO+M3rEW46QRMfKhMMqxu/s9ID5ome
         cyAktLjoG2DL6Rw512DVnyL9ogUUYvQoDXo2hZqe4BRUkVlc73KHSBSJem13eo7KT9J/
         +6X/PexOwbtW3I/y+6ORQwVN6MNIOkQUDA5/eiymJQfFvi5YY2Uc7MEAspi2eWkpwJiP
         hbAPFhST4MADQbfJ+nmhx4XrTwHeCPWBa2roEffeCoD2kbwYC7b7h/iPTZPzt3pAl1RT
         3oFyVCUsCaluGn9CErxm0WVhEOWYfqP4vBYl9zeJASNgw+4XSHu0MnUd2JgOTmbRzrVu
         TqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954960; x=1789559760;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SJt8ZcdZG9yVISY4f4k7yj08nGsSFwJkPsldz9PZDh0=;
        b=WsvBJuZ40Q9y1W6Q6eXiuUPvqFwhaMJQZMVwhDAVa6IUXO0Qg8hgWXBqfvcHVaYPxl
         KsWjBlRyXY8GsobktfhJQJFwPWyXucqDE3rgTD5Xwz5kIEMJYu1fuQZkqafBfTTd6+iE
         9Jcj+BC/EHSw0C0aHOw1m6gNtuVjYnBUuJRzw7xILX++4RW1BGsAklL9WuXlVb3oCp7U
         t7i0Vd3pRM3ycvcBIn2y6FgYhRQGzbeH3Jqxl0tZ3eD0Tk6TkDagyduJVXccJtJLzO1T
         41+uzE85I5WtO0VF7REREkjmtjQ88KQzQeHPQ+yPvRSfz8u2R7SFwg1KAl1TOJt/PoOs
         q+dg==
X-Gm-Message-State: AFuF++mQSJUr/lhjPTri9gIdtdeQ3Tz28FYVaG/NI0oN+t70uhINIoNn
	wMAEB+zLgLU/KhHHDDh6o1pxZTaSZssBKTjQpkMsnyOaNg9z6IGuE5b4pu11pBWa37HVrbmSRWf
	6uRmWvN2bLoMr5YNCBF6ULDfh3dAhf9UNsLOLNAWcuoJZ/F2xgGK9Gq6hsWt3jlBfR9DU7GwnuQ
	UckO0zqvUcEYvCyvZXuelzWVdZY2OuhA==
X-Received: from wmpm28.prod.google.com ([2002:a05:600c:91c:b0:49b:90c7:d488])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:8446:20b0:49c:fc7a:22d5
 with SMTP id 5b1f17b1804b1-49cfc7a2342mr240560935e9.4.1788954959579; Wed, 09
 Sep 2026 04:55:59 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:35 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2725; i=ardb@kernel.org;
 h=from:subject; bh=Ou0gz9BnagvIIpYFujImcdi2acgBEwyYNpUmbejvkVs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp7lEzXwPlyTBkm0iYjZr2H+vW18zZZvVGvVJUpcXV
 VbEr2rvKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPh3M7I8KKdpf9BxcSO5kfm
 k/UqPl7jePvD49q/K0Jed5cYn2gKNGdkeNkjpz9B4Oy2yys+/HxS0RWQXjcv2SJxipU5Y96nuQs 2sQAA
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-16-ardb+git@google.com>
Subject: [PATCH v2 04/10] lib/ucs2_string: Split out ucs2_as_utf8_l() taking a
 separate limit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

ucs2_as_utf() takes a maxlength argument, which specifies how many bytes
the function is permitted to store into the destination buffer.

The same value is used as an upper bound for the ucs2_strnlen()
invocation, which is reasonable in the general case, as each UCS-2
character produces at least one byte of UTF-8 output, and so there is
never a need to process more than 'maxlength' UCS-2 characters.

However, if the UCS-2 string is not NUL terminated, ucs2_strnlen() may
read past the end of the buffer if 'maxlength' is set to a high value.

Current callers pass UCS-2 strings that are expected to be NUL
terminated, but for processing the load options in the EFI stub, a
version is needed that takes a separate limit argument. So split that
off from the current implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/ucs2_string.h | 11 ++++++++++-
 lib/ucs2_string.c           |  6 +++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/ucs2_string.h b/include/linux/ucs2_string.h
index c499ae809c7d..74f23ca5a967 100644
--- a/include/linux/ucs2_string.h
+++ b/include/linux/ucs2_string.h
@@ -14,7 +14,16 @@ ssize_t ucs2_strscpy(ucs2_char_t *dst, const ucs2_char_t *src, size_t count);
 int ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len);
 
 unsigned long ucs2_utf8size(const ucs2_char_t *src);
+unsigned long
+ucs2_as_utf8_l(u8 *dest, const ucs2_char_t *src, unsigned long limit,
+	       unsigned long maxlength);
+
+static inline
 unsigned long ucs2_as_utf8(u8 *dest, const ucs2_char_t *src,
-			   unsigned long maxlength);
+			   unsigned long maxlength)
+{
+	return ucs2_as_utf8_l(dest, src, ucs2_strnlen(src, maxlength),
+			      maxlength);
+}
 
 #endif /* _LINUX_UCS2_STRING_H_ */
diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index f75fb4f7961a..2df9bef79eea 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -132,11 +132,11 @@ EXPORT_SYMBOL(ucs2_utf8size);
  * final NUL character.
  */
 unsigned long
-ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
+ucs2_as_utf8_l(u8 *dest, const ucs2_char_t *src, unsigned long limit,
+	       unsigned long maxlength)
 {
 	unsigned int i;
 	unsigned long j = 0;
-	unsigned long limit = ucs2_strnlen(src, maxlength);
 
 	for (i = 0; maxlength && i < limit; i++) {
 		u16 c = src[i];
@@ -163,7 +163,7 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
 		dest[j] = '\0';
 	return j;
 }
-EXPORT_SYMBOL(ucs2_as_utf8);
+EXPORT_SYMBOL(ucs2_as_utf8_l);
 
 #ifndef __DISABLE_EXPORTS
 MODULE_DESCRIPTION("UCS2 string handling");
-- 
2.55.0.1003.g10538fe699-goog

