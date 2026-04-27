Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BB43A1D02
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279666; cv=none; b=cOIvKmViZds+GmGVcEeMD0wCaDJ+xFODgNUgHPhGYr6mdN5oU1zcJIwKrBKoAyl81+Un8XmGnbNUiByzjrCSeUJxRSjfNXpxmi4JWoTHBvMJLuexnqqbzLKlXH+KBmneLlM4Ke6148HAcCTmfp9Cfm7SU9QPWaG435FbJiEueVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279666; c=relaxed/simple;
	bh=vnWQaMXFkKtGP6ZC1Nh1A7b0JU1COH1xk8nY4+B24jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2pgFCmdZjbySGhgM7mx69pIRfzTlTv5bPB7+SFG45cgQJf3QwiKOP/qoOWDKGk/WsMa3B8foh5q2+5tJyo+Tgwe8QtaCsqfVv9lhVopAdgLZ/hYpw1PeKyUHnGxJxu081o/jyfohfBWFovwrvEtcrpBArBfSUZ14amC3sVjLho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=x3DkV2ra; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="x3DkV2ra"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ab46931cf1so74417615ad.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777279665; x=1777884465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HjfJ4whsRboDgauJW5lAp4KFfEFuATjZYAYX/3z86Ss=;
        b=x3DkV2rak2Q09/rI7vP5CJFvhPYKBavOd/0srFoonqbIEcFjVSjF6d9ozVCJhYJ6y4
         4FP6q3NLQuwoiR6sTzuFiDYmBSCHRfHXnwGlpMmmFz/T4vO0O8ishk4JyjhuhRAmfrO8
         wVlmphxyBNp9tWD40yXlEs+8mJCMosLy3qpDZsJjMrE4FO6Jtu0EPRP/HDF5lrnU8Vfn
         /q11Yx4zZ1Db0rg3i1HZ7qc7/c5uy8MOn+C4UopElwOccS2y7ZrUBWd0Pnz91czHErGM
         xYxmzvCoDA8zyyI4hRIaR0OIOSmSMQcBsZKBDEQYHiUusgL0+JB42AsImKgXSOBpkvRI
         PiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777279665; x=1777884465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HjfJ4whsRboDgauJW5lAp4KFfEFuATjZYAYX/3z86Ss=;
        b=jqrywgK68V8+G/FzblYnckDmp6eInSMQ1UL/tElpOpCYf5hNuauY134pKV6mhuj9Cw
         VWEJZ3I4WLQ9OkLK3wfVXQEIuj9MpizdkIVD1vCPt/gLHMvq9RsimydqIj5MT9Sqr4c/
         S3GpsOQFfnYozGSjt5x5+yZsFBx/EeWYtd3CBHXTvIxDAlokHZYvfxzGlAQHHEir71L8
         PbnUE90lQKOf9IWmh1ipvnDyCCv90IidN4mbCzASMD/ZtyJsXEQq3L05iu0ubtIQAaQw
         3Mb/0nAptWbt2NbBehJBJbs1pECScMS1bOFxTQdp595FDaI/dioNzRmIHRHKyprqEvwe
         wUkQ==
X-Forwarded-Encrypted: i=1; AFNElJ+0wDBSw2bXK9QMm79fFsWkgfvCtFsgA69f1Pp/aPLwOkRh8iw7OmYE4XetDBMV+iH6zxpK90cWu08=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUX28jQiwf0HSxljvzoAln4w9BtL4U9E96miJoznacfrjDmHlg
	6fOsPGD29CVX6YX2kEOXbPUbygEjeorw2YJ9LZ0GxHR4I1jzQvOObbz7rJsh1E9/D9s=
X-Gm-Gg: AeBDiesrASFxLAPGzegXJVIryy8fVhtLxvcWi5nJRSijMu3tmFrEj2Lc3IAEAgL9RjY
	SFi/cYRgYi93PgKB5kBnthLeAF2Rr0xZUKO8LPOMCpL4udD2G5AJK2cNnpneTHEElNR+pdz3nmO
	NWcFrUQJ6qJQAc9n26a/qh9iUOuTeUcNChF/6d22Y1v2ZiyrOsYP+3k8i+uxJyGSDOtixHS4EZK
	dBWdubaTtqcglT6Amo9B3UWt9IlY2xjxK8MyfQj5RhBQM+AqNNqGo0kV4fvSK0lz3m+7qdlwiXd
	gs5aC3LEWKtlYuI72qGtp8XyiOUG7jac1NKyGcNyHPcweA4cGpJX1eLOzXNKZNZRH8attJ3DAZA
	SsBV40NEmrJDIHO27Olnpzl7Qoh3H2qVYnhoUW4oH75TXZJUftHlZBg9UC+DKswMWAvHgNChIhw
	DIl1XJqZYHkgU=
X-Received: by 2002:a17:903:b8e:b0:2b0:b258:2a57 with SMTP id d9443c01a7336-2b5f9ef72bbmr336496125ad.27.1777279665017;
        Mon, 27 Apr 2026 01:47:45 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3a929sm291703215ad.72.2026.04.27.01.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 01:47:44 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [RESEND PATCH v2 2/2] efi/libstub: Synchronize instruction cache after kernel relocation
Date: Mon, 27 Apr 2026 16:47:21 +0800
Message-ID: <20260427084721.40535-3-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427084721.40535-1-r@hev.cc>
References: <20260427084721.40535-1-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The relocated kernel image is copied to its new location using memcpy().
On architectures with separate instruction and data caches, the copied
instructions may remain stale in the instruction cache, leading to the
execution of outdated contents.

Call efi_cache_sync_image() after the relocation copy to ensure the
instruction cache is synchronized with the updated memory contents before
control is transferred to the relocated kernel.

Signed-off-by: WANG Rui <r@hev.cc>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
---
 drivers/firmware/efi/libstub/relocate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/efi/libstub/relocate.c
index d4264bfb6dc1..913b425d089d 100644
--- a/drivers/firmware/efi/libstub/relocate.c
+++ b/drivers/firmware/efi/libstub/relocate.c
@@ -158,6 +158,7 @@ efi_status_t efi_relocate_kernel(unsigned long *image_addr,
 	 * have been allocated by UEFI, so we can safely use memcpy.
 	 */
 	memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
+	efi_cache_sync_image(new_addr, image_size);
 
 	/* Return the new address of the relocated image. */
 	*image_addr = new_addr;
-- 
2.54.0

