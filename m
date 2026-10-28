Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793193206;
	b=H86ZG0KF9dXG9VbW7ZtVKZpyfy8btsPmstLl5ct5jmjX4nz8aktl7SrjjKX95ObRW3Pw
	 juFkiestj72zeriFi1FZ40BqCazfYcy5Exm8SZxHRxSHBZFlrLtjlDkR3YehEKnStjrzv
	 0ccHqGxBM6P3z6dllChk8JjFfO0VBvQvWK3Zr6kc6qauwqKzW4NRsxZYNMGqFPy8PATFF
	 E/Rks9IYylznL/o8FUg638peYRerTYXAudsgio2k1A6s3JzZMjmKicthwIL+SEWXfRG3l
	 fUxTZcLpM56UIdVnSVPyCUgernssmZz+GZ3nJmqTjK+v0sQI+lQFZJpcJwImzPprM2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793193206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=m7+RiVoaBd7pghMDsp8Epc0R1MgNz1SWmWz7d9aQAyY=;
	b=yiFmRclmZLAwtmIQMsA8dt9AGHFSdPyzpJ74pnot8vjtJkvYwH01v7EerIIeEY6L/8g9
	 cDa+9/hMatFERaFURlFuWk29ut++3Q/C9OrAIn7vdgJxEn5DBcBSxsXApYM+lx5hExxjz
	 a57ZnTIgpuWHj348TjR5zPppJxrabD+45ytIAqfH3mMGtmodHcNfZv550RCjcgpGX0MOB
	 UCPkPDM6KOIEiNZVPOmdDYi5ag0cWThQ5xXEUXeGm3aZk7AIBqArd7N+9K8ErBqm9Pkjr
	 myzaXpOfSJUhoXDD6VxWm/tco1kxzdHZJViFlaoNTPrLroMB1R5rrWHGBxNU+U2fFUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VBt2yfrl;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AA5606A31A
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 13:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53AA5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VBt2yfrl
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so7284775e9.3
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 06:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793193205; x=1793798005; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m7+RiVoaBd7pghMDsp8Epc0R1MgNz1SWmWz7d9aQAyY=;
        b=VBt2yfrlXYJYJSpxTOuYTJ5NivuDlykmRNvm6A5NomykLF7DnM/YDKKflTNBpKbc1n
         gHSC62gkEfvqfGgk8BSZiCXbJvegMCaES11Jq4ix+CB1r18sFtg+TdgYlQ2QovZdU7FM
         ZEbiOY7cFHl25MZsW0NhgzyE0PU5AloIckWtdNLvHcOVNzedbXkQ3L5e8bJbC5Q26Qt+
         66zkumHpBGP21tCoeMQxsc9xybrcqv+DRVfK8+82dIObeHcHPA9LSJy5ITBYxxzjxloE
         NrBCBoJbc7liEU2b5HOr/u0GKlhpLWhlwx384Uhr0C7Ju0k84FiQLDkdizpUiRpL99UD
         rtKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793193205; x=1793798005;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m7+RiVoaBd7pghMDsp8Epc0R1MgNz1SWmWz7d9aQAyY=;
        b=BwrdRa3kc4yyF5BJpZ7VQi0OtAfBuc4QMkKqz7xtoS2QDX999clAxiulGa6c4uKpbN
         f2d0w/5tSAVDUpLedvs2zWgRqnry1wWUFPLtJq61b0/SARTwQZ1Kxl4YKslQpM86zN4a
         wXpfhns+g2m4ja+2mO6O+8wj2tbifkgZznNdHGxZ3DF3WVhJocMm3fupGK7vaX9QzMNY
         biIgQQRyKtrnd9ll/bGEbWIci2CIjsvBGzGAT9HGVy6eYgmu+nlN153sfzWz644tDCAC
         0xIphEsvCdgyUfHbjz9fk60xIs2smwiWcl1exqAzdtazUeYvYLpn5F6Pz+GOqMvic3yH
         28eg==
X-Gm-Message-State: AFq9FYIoWgNIAPLAE5S+h2OXr0JzIoHIhRuduznVDkox2ch0klIl9VWt
	lni1/0oH9Yp8tIsgBt4y9WgJBJzdrjM5dJQMy2WA06ebKLYYUPyuRc3re7qltGqCHmb7lbBGfmM
	q2rWg/iWtnbKBVDwuLpYlmHNyhJXwUpsqCieUQW7YRHSZcvxgznfLFuvcISCQdxR+PaxpaIvPTr
	YQpSrsmlAtDi6VBXoenc6k0hzz2mjQmg==
X-Received: from wmkz15.prod.google.com ([2002:a7b:c7cf:0:b0:4a3:5c1a:5a21])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4754:b0:4a1:dda8:eb73
 with SMTP id 5b1f17b1804b1-4a966e2b8b2mr46574475e9.27.1793193204270; Wed, 28
 Oct 2026 06:13:24 -0700 (PDT)
Date: Wed, 28 Oct 2026 14:13:19 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261028131318.2456215-2-ardb+git@google.com>
Subject: [PATCH] efi/libstub: zboot: Round up image size to section alignment
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Oliver Smith-Denny <osde@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Oliver reports that some arm64 EFI boot images have a SizeOfImage field
in the PE header that is set to a value that is not a round multiple of
the image's section alignment, which violates the PE/COFF spec.

This turns out to be a problem in the zboot linker script, and so it
affects compressed EFI zboot images for all architectures, not only
arm64. Uncompressed arm64 images built with an EFI stub are fine, as
those are rounded up to 64k already.

So fix this by bumping the zboot _end marker to the next 4k boundary .

Reported-by: Oliver Smith-Denny <osde@linux.microsoft.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/zboot.lds | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index 367907eb7d86..a785c0123749 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -45,7 +45,7 @@ SECTIONS
 
 	.bss : {
 		*(.bss* .init.bss*)
-		_end = ALIGN(512);
+		_end = ALIGN(4096);
 		. = _end;
 	}
 
-- 
2.56.0.307.g5fe7bd680c-goog

