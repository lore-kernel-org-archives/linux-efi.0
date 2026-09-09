Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1645519A5
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954969; cv=none; b=chSWI9iEnuTROxOFQNmNRYhfwDWTHSxU6a20vyUGlUNI1EPgyu8p8ofbCTX6JFYgYz0E3SgAdhFlBAlz3albwMij0FBFSovgWJVaUMijkx62TL0maFC3B+Xkpzhy8qXKZPcPhYAUqkURpTWzfECiV8f8sSjMjCdBeqzi7t++zAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954969; c=relaxed/simple;
	bh=nApRI5xFcTlqGwc2l4tHLOqA5hh9r3n8CfsjMUrRmbg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A+22JWDPsilKE+jP8pOn8E/xx5oEK/IGIcaa2d4cgjSTni/YW7svKCds4JfCsnAizc45reIjiDkqHW+NtKsBUO7RCC0hvOZ1S/TM+aR3nqHVN2LLAIuomF72bz/Jy5U8+eVpPj8iXwDnJL4ayz1TnFC7vosAht7XLFKNLiW5kq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NBmoxH1l; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NBmoxH1l"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49564d4b849so21077395e9.3
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954966; x=1789559766; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JN+BC6ry/kWEdgNANYcdxE9IvlLiYz9YH0i3KnXc+nw=;
        b=NBmoxH1lPwQv2yoL58DgLaAF+hHRmEg+UDjH463PwaZ0mBY8K1aayDy9P25fJkjVPJ
         p6/kFExO70+UqmnAP/VQiQpneNkTytxOu6fzYDJnAKBCzZnPrv9PO+0SNRGTjVT9WVCQ
         qJmSh0xh8Xvy3bnyrcSCNiFWLW8gQJr4dcZhfhCDWsB8u5MwQ3ZMvsF1GX1RmL87IjB1
         bP0nx8VTP935fCHmMJyeStgiCAN2Pe42jioU+tIP8OTbhGLmZsidr+0yRm5/9VnvB02U
         /zC60Al2bzSZuICuxXR/tIte4KkjqqMCRSxsvrBqeLlMw3E/PfWoaHH+DQW+wNOhDQvF
         sTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954966; x=1789559766;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JN+BC6ry/kWEdgNANYcdxE9IvlLiYz9YH0i3KnXc+nw=;
        b=rK/7mm6B4AzUlXyUiL2R41EJGwsGM8Fukxm4vVp3thlsL4gIF8n2oX0vr9nY0TCrjd
         gH3cjZ5VN+CgPWghsIdBlZDKKhKsXLNP04e5AB6j+UjGljJhHCoMLeeIZ38MoJ+Evcry
         G/cesbmnDj0J6ZG2I1V76AybxsCYvnrbmsWXEwCc55jZSldMu3myUCOIrJQ9jKS2/BE0
         UCQvlXz32ChmXqB1SA3hGQTx+B1iMK6IsMLHBrBScoCFGiIn7e2dhDfYMeDDM8lG9bCg
         BJ4qBaIj67EZTqbK0U7h1zr70YqSm/DZynDp3MN94GaVuDSJSVpNy2UsBx0ZKhnBCuTa
         TOyg==
X-Gm-Message-State: AFuF++nZU9/5oD3pvMBxmov7y/dC4f+LSsNqtJzYcOESI5N0ws8hiPHR
	6qpZQ1M91jwqZx3ot1xso0/XBQkgkiVK3rUQSHkjvHYZOGq9SXY3TPszDUG9dJtk1FEoUpziNSm
	Ra/AsWRcKjByk2ruzMvHHCPuUSYb70XCUGlmI+BOo/SJY9YlqZ/Qo5lt4o5mVGR6cpi3YWPbUvY
	JNWcNEERQVG1kmHIlKH7qGt9EwkJ8KjA==
X-Received: from wrbeg6.prod.google.com ([2002:a05:6000:21c6:b0:484:4268:849d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3588:b0:49c:fc6e:a3d7
 with SMTP id 5b1f17b1804b1-49cfc6ea7d5mr331543535e9.22.1788954965277; Wed, 09
 Sep 2026 04:56:05 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:40 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1793; i=ardb@kernel.org;
 h=from:subject; bh=C2R/2A0OSQiIXep0It779ZTyIOZrKQNdvmBQDXeIiBI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp23ijfCcE9c/PZhrVfi6P9rOP9qvNuGVVfVTDgb7g
 1sNTvt2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIm0KDIyvLz1Vcp/nZVT7jHl
 WNkZgsyP4xue5cRWL2s5f33nxojEcwx/RQ9aFdfJbCl8p6sZ9vDAd9Zb4VGlK9rbeCXqF8t7crz kBwA=
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-21-ardb+git@google.com>
Subject: [PATCH v2 09/10] efi/libstub: Add efi_snprintf() to construct wide strings
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The native EFI character set is UTF-16 (or in practice, UCS-2).
Implement efi_snprintf() to construct UTF-16 strings using printf style
templates. This will be used in a subsequent patch to set the
LoaderDevicePartUUID EFI variable.

Link: https://lore.kernel.org/all/20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h  |  1 +
 drivers/firmware/efi/libstub/vsprintf.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 36056c624782..880c1d0c464b 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1084,6 +1084,7 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 		  bool crlf);
 
 __printf(1, 2) int efi_printk(char const *fmt, ...);
+__printf(3, 4) int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...);
 
 void efi_free(unsigned long size, unsigned long addr);
 DEFINE_FREE(efi_pool, void *, if (_T) efi_bs_call(free_pool, _T));
diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index 7f6b891a338a..34a19495dace 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -509,3 +509,14 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 
 	return pos;
 }
+
+int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...)
+{
+       va_list args;
+       int i;
+
+       va_start(args, fmt);
+       i = efi_vsnprintf(buf, size, fmt, args, false);
+       va_end(args);
+       return i;
+}
-- 
2.55.0.1003.g10538fe699-goog

