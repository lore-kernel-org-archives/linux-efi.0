Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3703314C4
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570052; cv=none; b=o7w834F6zgiWaZk/uuQCfqQzdjz0wHkFDWirBpEL9bP5Q1tzbbWLIZprk8S/eDnHYZuKRzHWA4k3lOhJ1P4DoMdbUX9YzYPPh8Iap2bVEKY45DZYU5o6M4RoO4XmtYusQVM2syDYxrQi5s3rChHziqqxGFLmZtBbKkDowfahbdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570052; c=relaxed/simple;
	bh=eqWkJSmv/tiBGGD3+FSHwBakwbSAKn+5SWHD5Y176es=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PCR+Ti9dVNZIKx9k9yG0NIAafKsDTsWDHED547W2NlvBfBT1EhUxKKlftkD82xk5dK+urbNuR3KJe+ePMUNROCw7R9P62mYmX+0gWXE+9z/PJXaqxFKO+fxf10baYd/XVWfDPppdNeGI47HElxRqS3TBOkgFdBQgJ8aDTt20eeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=moEFLI5z; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="moEFLI5z"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49cd55ee2f7so51461865e9.0
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570049; x=1790174849; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VEK2A1EMPHm2wewONLMkfK/EPHAjA+H6M8lM4TvNREg=;
        b=moEFLI5z8hObgBF+l6eDz3V5/pSP7848c/fAi4BYcBbX6E38FiiScdnURwJJ3yxBSH
         qL80Idx9zKC0ly1rGrjBHk0L+mwWVgA1vxrx0MM0vdJYbbcpMHqDRndRLYAB/KLzsBMA
         H0my9/pCvik/k0L+aHn/y4Ez7HDzle3Cl/IFJE1GcLtmkngcTsOUqhGugw9LGWSATQYM
         +2N5299SEtKpLBTrHwzJifdXHv6CuUFVUO7GGHcK9ktEzQUCtY06ztzheaOIpqDPh6OX
         fxtcBgz5tUClOpBVMSaB1CuJ0kqAUQzpEajOZMNFZJpKzcHwFYuJdZel9a+3v44D7SiZ
         xIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570049; x=1790174849;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VEK2A1EMPHm2wewONLMkfK/EPHAjA+H6M8lM4TvNREg=;
        b=dY2BGJru9F/kIP+khh2LO6IFODkV5E8E2Uu2fzV990qynmpnep5pQaEDNFgA3TLWV7
         4L8BD/Qh6nne/Pr2aus8xD1yUlj/WQZc+lG3ZB5GtlJtYFdb9jGdTyKziUsQdW/2hRup
         MOBTQ8HgkC+p6kLjsNMMPxnEmp5jI+FFEbWp5u5J1AkZfL60tV9ABWisJPZCtq8p0Com
         huBm/iA14mUK5JyIr9TFcA4hK9ljdj/GqOtCu6GFV+nE9TROj/v/knwoKdd0zu8+YL3P
         hZM/9ekzr3QwLMf4BUzoNJUyIzbX/CpNvAz7IxzcUx3jDJErQ+mybTw0bhKnpN/WNSsX
         JORw==
X-Gm-Message-State: AFuF++mJkImQujtuoE4kpIIdi89OGCQ5FDZf8MFtgQt1eif+Jo7fPpZZ
	oYiBsV/NHGtTwpo4YKSiEdZFCrUWv+QTXB1e52XtGLtS/h6JU5vI3VTiSv51A24spm89LzGdoLf
	OFES+0P4zEKBfq2wQLhr90v5KsnAL/LTylpL3KdySwgGdVbFEInGQ5Uq+RaScgyOl1UVY2ULVPd
	tdVkE7H0Leg19UKezynkA7Ljyo5JcMeQ==
X-Received: from wmoo14.prod.google.com ([2002:a05:600d:10e:b0:499:b2b5:78e8])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4713:b0:49d:4ef:bf70
 with SMTP id 5b1f17b1804b1-49eac467915mr34495405e9.10.1789570049219; Wed, 16
 Sep 2026 07:47:29 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:51 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3279; i=ardb@kernel.org;
 h=from:subject; bh=Lgsb/yq0Dq6T5v71CGxty1QuUmSRQI4tlUIGP++kj0I=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6jsstjJcUfP+pp2QVK5huc4T4lP51VOkeYdP4DHBt
 gmzv8R3lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIms/cTIsMp0w4z8EhmXTo2d
 oam89xeLaBRumS+36YM4z+P+1a/uGjP8Zl+8zynS0uZIGRPzZ3/B9c8/zWorV7mX6fPkxR42fvX ZXAA=
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-14-ardb+git@google.com>
Subject: [PATCH v3 3/9] lib/ucs2_string: Split out ucs2_as_utf8_l() taking a
 separate limit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

ucs2_as_utf8() takes a maxlength argument, which specifies how many
bytes the function is permitted to store into the destination buffer.

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
 lib/ucs2_string.c           | 15 ++++++++-------
 2 files changed, 18 insertions(+), 8 deletions(-)

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
index f75fb4f7961a..6c067b4280b9 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -125,18 +125,19 @@ ucs2_utf8size(const ucs2_char_t *src)
 EXPORT_SYMBOL(ucs2_utf8size);
 
 /*
- * copy at most maxlength bytes of whole utf8 characters to dest from the
- * ucs2 string src.
+ * Copy at most @limit whole utf8 characters to @dest from the ucs2 string
+ * @src, using no more than @maxlength bytes of buffer space.
  *
- * The return value is the number of characters copied, not including the
- * final NUL character.
+ * The return value is the number of bytes copied, not including the final NUL
+ * character. No NUL character will be appended if the output length equals
+ * @maxlength.
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
@@ -163,7 +164,7 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
 		dest[j] = '\0';
 	return j;
 }
-EXPORT_SYMBOL(ucs2_as_utf8);
+EXPORT_SYMBOL(ucs2_as_utf8_l);
 
 #ifndef __DISABLE_EXPORTS
 MODULE_DESCRIPTION("UCS2 string handling");
-- 
2.55.0.1032.g73a4cd73de-goog

