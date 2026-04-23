Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18E3330B2D
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957664; cv=none; b=LoRkhlI4o7cDPpSAwR0vYd79QJZzukck7LudVqBoYBkZkeh1rOZOBXii7hb5e2FYdGNCwhyMo6yLyHdjYgnwo3wsdxJt1w8lumT50uKjBikRmE21qgeUIxGZb7yfmNqnzi9rF/ExTp6C/mLOBK+NdhtJdh4sLGZkddcx/bi2mQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957664; c=relaxed/simple;
	bh=wee0QVzVreWi9RJ0YemJikUQ3D9dEMKQ3RAWuVtiUJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F/ykZJdvvZJRpG7MsTxv4wUY7d/PW1vxrLvx3ZJRW6+ggEBYHNNxoJt7RZZYfBlFMgvQj6wfHtvGoe6g9ToWyaRh00dWmyfutboiEXLnocDbrlQqWNr7B0aEnjYvLkYh8pH+LRDaQnCxuFZ1SXdvn9YMzWVlbiXxzMYcwEvglrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wKPYJr/a; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wKPYJr/a"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-440d0d7872aso4050675f8f.2
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957661; x=1777562461; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4cggla2hHE+Ip2W4Jmjd/BLtckR5M9vhjG/3uRS7ZNk=;
        b=wKPYJr/aFXQ+rNsjk7IeImwHEOisC1zSp2D7Kj9ph3eefbTy+aEvySW73D5ukszp5N
         i4ZoHas7gMvq4/Tf9QEr6V1tjNf3MgJqXuh9a7tkVPf4BcJGt8v1gIIyEGuF4RJJUDHz
         o+QtyB1/eBua1OY/OWCModgkYoQm6j8xj5PkEC1mtkKxkdbcCjsCLBKIOgx8TcvBXR0g
         yn2MIyKQN9RwIeZ7o4qOfd3/f4Pcn5lZraC0EAud7VMpjXD4CAycILqTlluCg5XRxmOK
         qjf0O7GFA0/8f27Oo+fqAug+DF+VNeIJhfNoZ2k4aCHMwnB11jitWUzRX77oLnfA29ZM
         bljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957661; x=1777562461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cggla2hHE+Ip2W4Jmjd/BLtckR5M9vhjG/3uRS7ZNk=;
        b=TjtTPbksoaetA5GIfHqgktTe7oramvUVgPV8nKXpGJypb/yuRhcx5VpRenOq9ph6QN
         2Ch12uOyLhbkeBoO0oRbfLdLzBOqdVUqCwYUzbs7m61ong+rYZHBVtuF4YLWat5j+OPw
         0eMz3inNosRnbg7o5H12Kl6YAnjlUmAQV5BOglF8wOfhA7+kk6Wq7pt7pCZHsSVs5TE1
         FSHq434bjbweD9twZwXnBuldztIT7d82IJzy/EwqjZ/QTMSrlx3idZm+iFrLpZvjHzdH
         tt26H1UK+fMWqGWfTO3Ly0sdE6gHsQlcyXYb89Ir7MeymiIP7K1E4FLRQxtJX1jFJrTW
         DoEw==
X-Gm-Message-State: AOJu0YzAA3bwLUQght4q1wHq1H/by8b2q+Qsug/83jmHGgVhWmq9JiDX
	9uY/4CSfWGWKhRiPFPLXmhMnZQFWaqCYTJj0NhICyGXBwDrr9vW0UY8CKz1oafUqmROFS6jaNg=
	=
X-Received: from wrux5.prod.google.com ([2002:a5d:6505:0:b0:43d:7225:237d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d05:0:b0:441:247a:e98e
 with SMTP id ffacd0b85a97d-441247ae9ebmr13356827f8f.24.1776957661125; Thu, 23
 Apr 2026 08:21:01 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:27 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=918; i=ardb@kernel.org;
 h=from:subject; bh=VrZOK8Rp6qriysr4XEO2Q6DCvrCik8fTVotJeLqYD5g=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxZ7UqLbj/S8/a9zavszqbPis1h3e8ntL7ebPPxD/z
 vipB79rRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjI0SBGhk2f56kdW7apsnVd
 wcV/elc/N9m/WxFxZ9VrG34b5vKfFWEM/yPnnwxn3nNilgNbuF0zJ1PZzSdvtjSGG3+dPknv5ln zbawA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-21-ardb+git@google.com>
Subject: [PATCH v3 02/17] x86/efi: Drop redundant EFI_PARAVIRT check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_memblock_x86_reserve_range() exits early if EFI_PARAVIRT is set, so
there is no point in checking it a second time further down.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c39adb96b91..1b7a0cd54d08 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -211,11 +211,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	data.desc_size		= e->efi_memdesc_size;
 	data.desc_version	= e->efi_memdesc_version;
 
-	if (!efi_enabled(EFI_PARAVIRT)) {
-		rv = efi_memmap_init_early(&data);
-		if (rv)
-			return rv;
-	}
+	rv = efi_memmap_init_early(&data);
+	if (rv)
+		return rv;
 
 	if (add_efi_memmap || do_efi_soft_reserve())
 		do_add_efi_memmap();
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

