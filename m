Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632FA2765D4
	for <linux-efi@vger.kernel.org>; Sat, 31 Jan 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769875610; cv=none; b=S6Ob5lbmgWOne7GtbvBXl9pqPdxw/cYTyDRZLFLHW3qfDtmL7aJiq4Bkkf8mk+XihAKxhaaQgFDzPHyzAGT639Lx5Yrgg55kO6BVNw+4wUcwy9YFtSQNCRc2HPajQSU4YXaGLGHvA0z/oy/9FfisfxN6oaWAZx0Sl+ZQRgr9L/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769875610; c=relaxed/simple;
	bh=RVZEN1uCsgRe4IYsQAyZUgh7wiTVAScuDXKHQone/3I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mD4kCPmQiVLQYFXAUfQPcvBKLbUTF1oI3fAUZsCtSLz9hG8J8BrHJtKycfsPE2MeKmS+nVjjH5m0xSqQ1CSwr8bFqgi5++pUedSPSyi5VoF7TS9mDXL62txx4YMNats5Jdp2NSuMWV+ZSQyaPOWBSkO/ImkKaEMzp9tlsIu7v3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kj+mnSgX; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kj+mnSgX"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806cb47edaso23028835e9.1
        for <linux-efi@vger.kernel.org>; Sat, 31 Jan 2026 08:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769875608; x=1770480408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nk9cE2eJRYOt/S87hm7M+zV9gu0oKCbdtE3VOeklGi4=;
        b=kj+mnSgX3DQXo0006YmnnXFr8Y2QO46EZc24xy7Jf3Ez6A0PtzOEptLC0jguXfOmih
         MND/xsOi22wTAkKUfm+/J+LllqePlAL6aZGpxc9QOe6ubsZYAzOQyxvho/UBnDi8g8I4
         Ar+S63z+3gPGK5nIBsWtT4UA2JNvU7JiXv11NPrJAJ3H3aOevh69oNM/RNo3H9P2P+9l
         jqz3y4O5Hj2OTvx0c6IEC/lc9jVEMiHYhq3/vEi85cBDwUGOb3LVA8bRHN1NxZnW/W/2
         ahrpC6jSmqAMz/Pen093B72ara9JfdurBCU6fBE7CJhz7oiVOayhIj63wYi7aJJqnzMM
         ivVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769875608; x=1770480408;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nk9cE2eJRYOt/S87hm7M+zV9gu0oKCbdtE3VOeklGi4=;
        b=qsffYlznbJ9hGsfelF7AsIWgjCGLH7frxCC7WNwAGTVtEqVsfHhy2OGBJHrHR4d7uX
         VMCWZ5mlow0nWULo3k72dSPWKUjLKy9up16dg93SnBZjtBjo4RfkUXFRm4EtJLMGl78z
         16MAYlI4uf2ebB7wFbm3JTaHIeWdW2M33xeRlc4S3zmrxViOW7dBJzV85QS34vCaVngc
         tteQc38NGpZq4raNjHVnI2sLhevLfFt0YHoWho+NBcjMZFlprwpTcUtypkDr+Ny8J9ih
         x9NRV32SJ4o3CLZXaHJVRrGlrb8K0L7Y3KAiXB/JnSz188WEQVs971rzpQ8p4lphPpTC
         iWWw==
X-Gm-Message-State: AOJu0YzDb0Jjk1naCpIn3eA+U/jwGhogMG4T/deArDPLd0XJRDg+9NR2
	5+yhI+D/Y2yHf4H2Fx22mVURPK+i1W/Igluog1IhWoMqhRCXTZUMY1hpinatoKsY9pQnf5cycw=
	=
X-Received: from wmbip10.prod.google.com ([2002:a05:600c:a68a:b0:47e:ddf0:fd00])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b85:b0:46f:a2ba:581f
 with SMTP id 5b1f17b1804b1-482db49b0b4mr85091705e9.16.1769875607822; Sat, 31
 Jan 2026 08:06:47 -0800 (PST)
Date: Sat, 31 Jan 2026 17:06:42 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=887; i=ardb@kernel.org;
 h=from:subject; bh=z8+3Z4N7hP0189Q2BBy7DGiasDRcVF9gLjijIYP2Jg0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIbNOY1Lah39bHfnnxzHrH/zw5UbvdKep75betBSIOHkrR
 chyuUtYRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhIzEtGhmNb/+k4rer+0/Xl
 9xKruOB1hqe6xR9/U1vaXBn8yru6RpyRYbnJmh1Zyf/KHuz5luTT81ohcpn3sglrey/NWM7iUxf +ggkA
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131160642.3480429-2-ardb+git@google.com>
Subject: [GIT PULL] EFI fixes for v6.19 #3
From: Ard Biesheuvel <ardb+git@google.com>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Hi Linus,

One more EFI fix - please pull.


The following changes since commit d7f1b4bdc7108be1b178e1617b5f45c8918e88d7:

  efi/cper: Fix cper_bits_to_str buffer handling and return value (2026-01-14 11:34:42 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v6.19-3

for you to fetch changes up to 4b22ec1685ce1fc0d862dcda3225d852fb107995:

  efivarfs: fix error propagation in efivar_entry_get() (2026-01-19 08:40:36 +0100)

----------------------------------------------------------------
EFI fixes for v6.19 #3

- Fix regression in efivarfs error propagation

----------------------------------------------------------------
Kohei Enju (1):
      efivarfs: fix error propagation in efivar_entry_get()

 fs/efivarfs/vars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
