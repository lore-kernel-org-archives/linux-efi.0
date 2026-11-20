Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180715;
	b=MPvu6Sdsm9uEdExHWZE0S9UiQBFTzEtXAxKMFfuj2WSUMQghuF9H4QO3iz5h60Oe7Mn3
	 rln+v1FoIGhiIoyVHMb66mDg5rvShAfKTZEDEECbUDLhZq7HxGRlB34dywDn+Mc+czpzG
	 4dfn/djd/RRn+AICsWJNHBKvY6xsIo5qYna75MZvN618ZOqIUDW0cByWXIV3tZLrssbW7
	 0/MD2DTSnzJFSuysKuBB91sYjJrHE9K1OCPnMKqWXO1AqjiAxP51WvE9UqgPwLHqSBUBH
	 wudPu8PCdEktOuqth0X6jpXdOQ02nDOpb43oPu0ZPTqm0532aSPwV9yNxXajrR8rYtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180715;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=wVClh5ANnMKPlZ9DxvStfeC7z+NugTM+O6khnh3HAHQ=;
	b=JQVQ0OyU54aLWhYuZ8gk6GyWoKUlbhIMw7oDTX0RLQlSQ8oG4LfD3NuuupjP9vneyvA1
	 l1tfZ9K8IgdeaHAQZxlVAUFwADk2BOyJ0bluP0ggNdb6A94E7vBucWH+XP5arLQ8wQZkX
	 UhgXFR2TqdW25O7TWJ6I+BrPUEFy6MrgOzotmpybwlgqzNU8zI/r4hx3av0LhOj0caZnw
	 /V1WyDX70CXOUQIoDhK+Zqq2g3Q7jY/9vkAFmG/F/7XMTROkonhJyIbFn09HocYkfty4d
	 YWZKmR5L/ALBFFB3KJRy5kSDS5Ro2RXRYzzRTDMoTN32BwBp3t0dY0QXWJl4VMdE+hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=InojRyHL;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68964606A320
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 13:18:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68964606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=InojRyHL
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c50713860c0so89282466b.0
        for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 05:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795180714; x=1795785514; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wVClh5ANnMKPlZ9DxvStfeC7z+NugTM+O6khnh3HAHQ=;
        b=InojRyHLlXLyIPwumbbGOnr8OzFU+M2FRu8O8SrC1STBgOGeoZfTxSeKelxbTkRUrO
         ja4ZR7K731HyD12KrsL3ojYzuzUXhkLs2fZbsP4Ts1BQzvutdwY+LiXSbuNngbusk2dr
         2eO5cZrCqnfD+X2+Ut/NAjCoZjYsFYFXrlT37hmxKLDLPItQMx3+02emvekK4UFJri1U
         +NP+mxW0ZX1BfnvlQwjZIXOemMam+e/Kxwv8fy8rmwCIppg4/g7Nx23ERAAblAJluaNW
         +Ad/SzTRVu7luwZ030gRt0Q8FtnqkppivFkIq6EERizDJN3fEM7lqgPrWZwOyFViexxk
         5WTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795180714; x=1795785514;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wVClh5ANnMKPlZ9DxvStfeC7z+NugTM+O6khnh3HAHQ=;
        b=cHspKKIz11HsyU3yKXEaR1w7ZsIbmUG+UW55SVm05QY6ywv0YIOsAAmOQkYU9I6O/T
         7q5QhaPjNENQqzA0t+N/o34DfrpZxu3u2Jc2YeR9BP2sbb3NrPBxnzFZCqC/6yPLO/5I
         kx0ujMQcS6k9yZ2d55Rc6SDs0TUQRnQfZOKVSqNFHn7N7owXNiGdJvLvcVLZcecVnW6Z
         7WpN+sGrpUq72H9CvsltDWJn4qczP573bc5gp4jw4JF/Y4JBkeMRxML1qdDGBVUjpyFr
         1qer/y3wV1fYeif7VUQzBnZ15JB/kzEgzjNbkF73H+nN7J2GEpCMMCJw5v47l91CEKXi
         7hOw==
X-Gm-Message-State: APuU4Z9aRWVNgFvd5Wb3rlc6WihEMi7ZB1eXh4YBwgUxKiS1QYqO8IDA
	jJeyOknFAkbZcBwtEaWZ2YEYpD9mawRwSy2SRFOA8ssM7z5NP75irHOpWUFnXHyuNjNV4ogFSmg
	06WY8MNboHU3/WxHmO6H25JBlbyrlmEcenFgjTSqtA5dUrBAcU8FzGBnv66KgxqNnsgQjHqTVz2
	1XGMYxc7A4npENfDQ9rX6KiGlh3wYeJg==
X-Received: from wrxo9.prod.google.com ([2002:a05:6000:109:b0:49e:4855:28f6])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:1955:b0:c40:4848:f7fa
 with SMTP id a640c23a62f3a-c513ab1dc62mr226576666b.44.1795180713244; Fri, 20
 Nov 2026 05:18:33 -0800 (PST)
Date: Fri, 20 Nov 2026 14:18:28 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=646; i=ardb@kernel.org;
 h=from:subject; bh=GVrbkC+j1VoGFDvIdrcZ8jz0pSXyM9mulPtDX4O8t9w=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZvBY3FX57YDE075dzjZ2vZeFlnBlXm64cgS21fhCZZpv
 w/FPl7ZUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYScpWRofXkTOWwhozXPT/i
 b0U7XIq/rxKsfP3ztOrLUjNPRkW9UWBkWPvmtbe31vwZto9un6q873HxmvOGwm2CjGyWv+yN46u X8wMA
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261120131827.480055-4-ardb+git@google.com>
Subject: [PATCH 0/2] efi: Fix pstore runtime en/disable
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Fix buggy use of /sys/mode/efi-pstore/params to control the module at
runtime

Cc: Kees Cook <kees@kernel.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Link: https://lore.kernel.org/all/20260906235838.2928815-1-gpiccoli@igalia.com/

Ard Biesheuvel (2):
  efi: pstore: Make pstore_disable parameter read-only again
  efi: pstore: Convert into a platform driver for 'efivars'

 drivers/firmware/efi/efi-pstore.c | 84 ++++++++++----------
 drivers/firmware/efi/efi.c        |  3 +-
 2 files changed, 46 insertions(+), 41 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.1.750.gf70dc682cf-goog

