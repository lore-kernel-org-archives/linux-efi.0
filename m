Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6300F549369
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954962; cv=none; b=SYVkLbo62scgBKMI7FDkCTrrKST2xdh2ov6qBnhq+dmZdKALKHq/49N0aBUVMcSHGPfjOcHQ2zPx+CI1ZdY6rrurT8MVEnSQto7/i1CJazMa2RMTQmwRl+Zh3ci5fo5t5uOtoebiTjQ22y184EZXW1RFd5M4aa9xB3mgoMSWS9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954962; c=relaxed/simple;
	bh=tcpQtPG1LqjWHQcdYdyBj3c6VFVNWxy+XZ+d+QXhJr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FmU49roPeSae983o+bCN0gP2U4jINOGQiHAG2EZIGZrDk4kc6wj4mnSmc98T5d+EPVjIhVwciyGSp0Ja1Zjt1a/3he5iD6mfXD0LLuubm/dC6MLWUuF6HNoqaEXy73fbm9P1PdPIpx/uQPogymFPuo6GqNKJglRZESQqYx649vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AGES0Dby; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AGES0Dby"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so6046811a12.1
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954958; x=1789559758; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pd/4A8F8XRZbl4sQpabJjlKenkBbaEXlaZ5AQnmnAzk=;
        b=AGES0DbySFOzYybzmCWoEYhXnbGh5GuQ5vOHFKZhk9Y20YlXe97iaXOvrXwycocnIL
         7+U5LU4ct+AWZKk+JRR8+o+CyMIxxn1l4X/6ERfr1722W78ynJXk5tqzKWc/Fvs/p6sX
         mWcrcZ6EtwaoIdQ/VFsPUsBaHVpi7cV859RB+1WN3ysTYQmXSmXxdiIFN/Zw4KKnF1e9
         zTiJhzUbcZIXD/0gnvVV8yU3kSRDVh9BRrJmy0h7gmLJdELJ1yaxAijlgyOphx94yWhz
         CTRYdEL88uDrvUh3vwg/gWtp1rAkMTB30LpG7K34btRLV6/ThvxiKW10AOmXkDLe/I/W
         LXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954958; x=1789559758;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pd/4A8F8XRZbl4sQpabJjlKenkBbaEXlaZ5AQnmnAzk=;
        b=TWjitIjLurVQsQVqtcoQGfa63fQtwrICuZylV0HunZ2UmdDW7GVYfM/ShyrPTKORvZ
         HQisqVTXiQL1rnuA1Eqage1Wq1QAg/uJeTI7CJf5ALnOA7y2jcfLogQKwv19vKY+t7YJ
         W8U9TJYQwq7IsZTtXLclo1Gw0I3ccQhxy3mZvzjjGhu7FVE2779vzo1YAaT7hsDf5+d6
         TnIwCDQqgx0kB+I23SyYHuTfzN2lByWWLGwL+n3pmstcBn9PGrdYsQxnAhlNKa4u2iCE
         qDsS0aAopp/BDpThOhuOQ8iZv6mF11XPvHY28Hn0A/cLSNGbqn+EH54f59qodnrpMnJl
         CPwQ==
X-Gm-Message-State: AFuF++lnnvr2hI6NHudVF1zlfpJT3/J98puzePRZDSOXhPzZzjwAHnIe
	asRH9WyPOSoGaJuW3j7nj3H/8SNjOic+gw5jcwK+vBpx26jDR2LU7/HY+QnEq1/MQLWZU35Yb2m
	1BdhvfcnVEeBiOkGKgl3foZxi0usbRSQwMOfSswu/VHkjkTP/jU9yNYv28z3pQbv8w3A8XoXzLT
	XUw3BFcLujyt59JQY4rrR3hqDXCUio/g==
X-Received: from edvf14.prod.google.com ([2002:a05:6402:160e:b0:6a8:210f:72ce])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27ce:b0:6a6:7882:89f2
 with SMTP id 4fb4d7f45d1cf-6a7e8f9623cmr12327207a12.17.1788954958326; Wed, 09
 Sep 2026 04:55:58 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:34 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=705; i=ardb@kernel.org;
 h=from:subject; bh=/LdgSZFzZjtYA02calFNa+IAiCgEi1RyLw02qhfaQIg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp9nb/j1SGZxHnZ6Ln7iTX91mUVK8sXuaeKjllpfbd
 /yU5ajsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNZWs3wV7j6vcbHsJrQ5q15
 c5f/FQsIapx6UzLj0R9F4xdNG0UiWBl+s3TMWFXpkMNsEWGzqnxllszBua//2d8y4V7zd/WmSYW TmAA=
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-15-ardb+git@google.com>
Subject: [PATCH v2 03/10] lib/ucs2_string: Suppress modinfo when
 __DISABLE_EXPORTS is set
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Allow the UCS-2 string library to be reused in the EFI stub, by
suppressing the modinfo data that is usually emitted so that the library
can be built as a module.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/ucs2_string.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index d66fef9c9b81..f75fb4f7961a 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -165,5 +165,7 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
 }
 EXPORT_SYMBOL(ucs2_as_utf8);
 
+#ifndef __DISABLE_EXPORTS
 MODULE_DESCRIPTION("UCS2 string handling");
 MODULE_LICENSE("GPL v2");
+#endif
-- 
2.55.0.1003.g10538fe699-goog

