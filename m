Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68BB383C88
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957681; cv=none; b=afGWetpPMTDu2Z2WsGPaU002YRGrYMEzMvLxqR/J0JCG4ks5kgoHLmeOunbGqoJde7+yD9jZGFhtfaklKYVpoikkadbAXdSET7zJgKfEU1XFli2bx4Mqc1jOkFN3/Q2iDRTg4FQioyDuTY/dSKrCbzZ7vyxoTq0HkAxNJtKIj6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957681; c=relaxed/simple;
	bh=kHWXmbw7E3NC74c6976UkwqhW+N95Bw48E7zKD2zH+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CRBJhij0c9q9Mnz3+znzZk8bXreBib3EbZdzHNWeVkZiLFVA9C+0tIMg0rsj2tDMUoPwKqwOn8D3oeoR8a1txcOaB/v86lDzjTeMKTxgTl6NVVovRqrHvqWcZ/PT0PLxp7+Mtu1tmgBbjlGPxRUAA0XhmwlXPxXCYXvw+njR8n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NuJCq6tp; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NuJCq6tp"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a5523fd53so18202045e9.3
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957678; x=1777562478; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ozc/YFu4zY+6dm6Y0MVQ/zDDn7vwY45tnWdyVpLDfCM=;
        b=NuJCq6tp9e/0m5RtOMDIdyaVhp6iRyuxV8/Lt45Tu8dUTX/n1sxX537XhufzI+tgHA
         JolX8QL9Y72dw3h6lhWpfD4sMnryVzIcPb+uj5CaUeIzuFkVKmPIasKhitcQRAutjJx4
         XQ27hdy1ah451RX/lYxoaeHLPLy5/mlCfNNZMalTRjTXt1wQti+AIuppy6muqsCucGSl
         VfLzqIRg7UkmlUQyqKsI9zcFrLv0fQTX/WWXGk8s7YJF2e7e4KA6dWXOSLlpD5i9iyW2
         yT34JuY4V5ImF8HbThCArvizEF6WhQW2tbHW9D4ge4YJMkoVhkCmDhFBrQw4xrpYOlP3
         L5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957678; x=1777562478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ozc/YFu4zY+6dm6Y0MVQ/zDDn7vwY45tnWdyVpLDfCM=;
        b=sANOXnzjnm6JjGvzXnW64qWqmwKNGROyItEKT3+c1ZMf+DQMKmGk44jUKCoP0Wr/sx
         FO+TKt/bbUNSA1fkjprUKs44SpsDaTtXsJaQz9KRmYH5Oe/WAl7XbrHi1pao7yWyzQIg
         NnAi9lE7zGjxJk0QFXa9N8708upURGlwdrIfTcf8apWjSBGKhe4+bxr2HwLUWMgM6Dh2
         QEWJFZFxY/+wc8D4uVdo1z9/hioBGCmRIDkMYufrLE0C/6R61iXtu640Veh5jjp7Q5D3
         ifrloQQTO1Dd+tvxg9DoM7I2EkkrYs7ATjrA+oUe27z0TlDB5lHjqJ934JWPY1U+goi3
         PTjw==
X-Gm-Message-State: AOJu0YwsoU4sRa0XyWAjyvnRG0V6OZd+1tTqWaXHnLCNoPHf5SZ9Rn/k
	QX/Ev6apJQd2cAmUPS84MvP5fIW9FgrLm9xik+98FpTkpbV6N8GFjqP1FJXibPo/Z62eTrz16Q=
	=
X-Received: from wmim14.prod.google.com ([2002:a7b:cb8e:0:b0:485:4f4a:bd84])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1389:b0:485:9a50:338d
 with SMTP id 5b1f17b1804b1-488fb739d3amr369175715e9.3.1776957678057; Thu, 23
 Apr 2026 08:21:18 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:42 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1264; i=ardb@kernel.org;
 h=from:subject; bh=4kXARMQ9wUsH59E3D6X32IJFsIA2YMKbNS4DiGE+Qis=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxcVPMbXVL7m23fAPD/CcxF4m9NNWeiWvb+smlZrJy
 vvvT9PoKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMJ9mJk+HGiY/W3dL1nO97J
 S5lHv7ymPdfNeteKX3NmzNtVJco+9xXDf9eLpzY7vQg78qyZQ1ng2C1BjYhpTi+U4ia81Zm9zuL HO2YA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-36-ardb+git@google.com>
Subject: [PATCH v3 17/17] x86/efi: Drop kexec quirk for the EFI memory
 attributes table
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that the EFI memory attributes table is preserved properly, and the
quirk to detect corrupted tables has been updated not to result in false
positives when the number of EFI memory map entries is low compared to
the number of EFI memory attributes table entries, there is no longer a
need to ignore the latter when doing a kexec boot. So drop the
workaround.

This reverts commit

  64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index fc6a15c2ace6..92d37f2a5cbe 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -522,10 +522,6 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
 			((efi_config_table_64_t *)p)->table = data->smbios;
 
-		/* Do not bother to play with mem attr table across kexec */
-		if (!efi_guidcmp(guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID))
-			((efi_config_table_64_t *)p)->table = EFI_INVALID_TABLE_ADDR;
-
 		p += sz;
 	}
 	early_memunmap(tablep, nr_tables * sz);
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

