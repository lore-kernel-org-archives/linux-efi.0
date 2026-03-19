Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113293B8D47
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911185; cv=none; b=hfBrotMXrrcwJ+OaR0v33XNYzAougim3OFrnvTAsTX47BKGciCeZ/ZeiBswQBCRMLno1obMP9np5YfxdfSIIL4h5AhAPBPMpNSHe74ZJGcXn1miyYqgJO0ebPx1/DlkRLZ81h3kdWGG+d0WvE4JnvHjgYVuwUBj8kUHxPlHNd5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911185; c=relaxed/simple;
	bh=Wf8kQNEMmtzZGyUJPwnpA/dfE7IQk+3+2ogaLZM7sX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lvJF9q1t03O2MX5w/czlUaVBXDK5HoX2ZI4sL6j3JOWtN9xKSeiVMTsn8fxNWSEBa3u7gc9Nc/Y4pdDYAdEvHWElZA0UP4rgTMFlQDBeTT9kme2foO/SA0y9MOgPTfOX6obqJDsvgai5SDOYT6dqiUhH+5YB0XOHCBECuEqugaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jddZIGLu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jddZIGLu"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4853466655dso9566655e9.3
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911182; x=1774515982; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hzByK+ynICbqxc0B14saHqMa64fxvk7Hl+Eh4R4V85s=;
        b=jddZIGLuISgU8tC5CNzndN5ZBFWO1IjGxHw1bWHUefI3FnwGU3mqaTkrV/0NCkrZpA
         9j3gGbUp3528z+uoovMm02eyCavVIi0gP52F1OvCspnT8Q1rs8ZRPnK6+NRSsOs9bUzW
         Ho+Y1WPRWEmxdS6TXvQbPlzgDFSCMwZOwVPq4QdCuuaWRaL+tb+evZujgG3t+BAHb+xz
         Mr42EheGipVZZUIwDs6bhVtqc7vVKeFVot+a4lhoMMP+MZXrzHgw8yej7Kr/Z5XiXIwK
         xQTV9x7YgVmnuN04iL1OJ4JdEqeAGysQBkWI+ODuo7DZoAwzJmcs7LGE0/0Zi+s+Fwea
         /GAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911182; x=1774515982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hzByK+ynICbqxc0B14saHqMa64fxvk7Hl+Eh4R4V85s=;
        b=Exx736PtO23NTQ3HFvtEf0lIpUsGSDqI3v1yrTEaZO5d/Rv9iek4G/qpzPmHBvtOtQ
         0ZS3RrcJfyT6rwO3n2tXDSn2v5/27wUVKBmpJHh87fjzYKtKPT9a+KXiwWDtnW1QJS+J
         7XvCz7e5WXc/rKiO0hSQZEN6yspzUY8Tzzibd1T80tLeXSJ0oIDskDZzg9MnZu/NNE0W
         9/HVb9onxFyLKfWrZYCjG2ED1+hoWwCjzG5JBAa/BLlyha565OGItZqvXmqohj+szgf2
         m4aw1KRBsKZ0Xq1tfCpOCVEEZEveuQjvhYTDaQKXbz/OVtZfIl00XEr0VQbAi9SwFKzP
         xXEw==
X-Gm-Message-State: AOJu0YwMIrSkvaIAdDBTMiTvYkgMmyHS7hs62mz91m04hoakEwcVVj8T
	gOHXKf3glbAvg50XoGauqRBJno4KYHr5dJp33+H1MW64dzJd7JmP8+dnLzyA3xcnrp+aW2E37Q=
	=
X-Received: from wmlf11.prod.google.com ([2002:a7b:c8cb:0:b0:480:6c91:3efb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8183:b0:486:f634:ef1
 with SMTP id 5b1f17b1804b1-486f634100dmr86779245e9.17.1773911182276; Thu, 19
 Mar 2026 02:06:22 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:49 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=916; i=ardb@kernel.org;
 h=from:subject; bh=MmnX/fkpzOzS5g7YhXoL61ypB3Du4JDzx3K+Oahbalc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3niLjpUdDS16wOQfX3j/PGq69bMfZEm+z978Lbs3fa
 5pbPr+oo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEykWImRYdfkg05/dFVZ7h34
 d2j16SezlRdtu7HMYWKTS6L+W4PVkjEM//1zlQQmfOksF7pwZn/dIfNnpxw3u235ohVQJexm3JG XywkA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-40-ardb+git@google.com>
Subject: [PATCH v2 19/19] x86/efi: Free unused tail of the EFI memory map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

After moving the relevant entries to the start of the map, the remainder
can be handed back to the page allocator.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 8f2dc477eee0..3b3652c4b90e 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -443,6 +443,10 @@ static int __init efi_free_boot_services(void)
 
 	efi.memmap.num_valid_entries = (new_md - efi.memmap.map) / efi.memmap.desc_size;
 
+	/* Free the part of the memory map allocation that has become unused */
+	free_reserved_area(new_md, efi.memmap.map_end, -1, NULL);
+	freed += (void *)efi.memmap.map_end - new_md;
+
 	if (freed)
 		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
 
-- 
2.53.0.851.ga537e3e6e9-goog

