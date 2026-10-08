Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FF73EC839
	for <linux-efi@vger.kernel.org>; Thu,  8 Oct 2026 08:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447207; cv=none; b=hkM1lxoLXRYoic8VVLbDdIUem9dksWvKjlnCFHaJNkEot5rfBNP5v6wZP7ztzB3sU8d/uXlJ/NoyrIdKBU5aZTsXkpZMhPrK9KnlAHtcTV4OrEYddM9uALTAwQusIbyAAH6MCXHugGBZ3q3nyuJWB6x7200AJ58+g7pcOU2vP6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447207; c=relaxed/simple;
	bh=eYYih+ynO2oP3fLkPqIUtAILMYOlbp/caA1xWN8WlJY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GUnNmkIWqQY/NCcs0+hK+Qe3JK2OlP+LPbJfWGJrn8xn+ug/p4D8545/KEG1y/sK+El56Ohunftu+C/pGD3NB1fJzp6X3LuKT4TgPOsCc1DFhDVBBuGFU8ei4wJopjEIlraxKpjd/WoC3BfHogHVgjnYBj42LM+eu/h9/xTLlzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hT7S9wqP; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hT7S9wqP"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c293e604f0eso518309666b.3
        for <linux-efi@vger.kernel.org>; Thu, 08 Oct 2026 01:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791447204; x=1792052004; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=M+EXxVIoAc+7gOB2P0McchlGKIX8MtBnu+nbC+foyvM=;
        b=hT7S9wqPHlNAb42jOrLky5E2mM3IWARhzAbWjxGYReaqymVEF1V0bcI2YDdTzyrijV
         bPyzimZy6JOuWX4Z1eIDa54m/32mBpoxBAw6ZsxcZtTUG/Ju5wnWREEDGacDGLt7Mjxy
         KyYgw/b3zlt+4C2LCpxrbi3sEi5ImExY9rTC9YDAcX3uMMbw2W799lPcmR2G2a61gBvr
         l14VrrA0smBG1XSHsYvJ94ouHEKWq1fvjzf1ZwSB40CAgFmroqGU9VOCRzgTuAPqH+/6
         wRO0wcIOu46I8aCvMmPPA/lFLWw34dclhvX8nqw/IPeu5z9Wt8Lq0waelXnn57t2lYmK
         mVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791447204; x=1792052004;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M+EXxVIoAc+7gOB2P0McchlGKIX8MtBnu+nbC+foyvM=;
        b=CTdl8ufaogikn0bL6QSMbrcmrN6+RhFT/h9qmLoZD/onYT/O2LZ5t+BAwgNS7FsHWV
         clnfflMEhRAdyVVIyigOG+6Z7IGO9kmUp3viB3Yh/ls2/l9HlfHcTNYjbTLhr3pPEFAh
         cQ02/i19CUE29vi8k0TBcvWF5+4TdmfNqEZMHZL/djAG6As81EZhIJl53OgDa/ktxFyD
         lWZa+6GT1uYRMMC1JzQV3uAxl/nIbYP53Y5Mayrn4YAqEeiqTH+ScmBvjMxFS9MaLCIQ
         GCB9glMzpfvl6o7fnPEsbfu+K9Cqk0B1dvlS24uD4UymP7ISkLZyjLEiovYfXC6Fv3t6
         hkxg==
X-Gm-Message-State: AFuF++nng+KAR4P23BdifbfvUxV0Op932eN7wvPJUg+BZlHMGDkgwHvW
	epf7QnMrXMAujtYRYb7WbB6y6FCbmlY37MjWV2fbzE0TkjApN+bj+8j6doYzoFsmZuMUNyWv0pj
	0VBAi6e1hOJqiXg9lTl8eD0c35BQ5zTaTSKZngl/Mu1y2z0U2S+WE38cVp8bzroV7mIe4y5fbts
	ZZ5w9JnQQk0Hq12xrSrIkDXz0oW5sA7g==
X-Received: from edev3-n2.prod.google.com ([2002:a05:6402:a2c3:20b0:6aa:44dc:89a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:f586:b0:c29:4b79:e41a
 with SMTP id a640c23a62f3a-c317be010f6mr427164066b.20.1791447203705; Thu, 08
 Oct 2026 01:13:23 -0700 (PDT)
Date: Thu,  8 Oct 2026 10:13:18 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.360.g66cac248cb-goog
Message-ID: <20261008081317.2602565-4-ardb+git@google.com>
Subject: [PATCH v2 0/2] EFI sysfs constification
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=" <linux@weissschuh.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Ard Biesheuvel <ardb@kernel.org>

Constify static sysfs node accessors in the EFI core code. While at it,
switch to sysfs_emit() where appropriate.

Changes since v1:
- constify efi_runtime_show() prototype and use __KOBJ_ATTR
- add sysfs_emit() patch

Cc: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>

Ard Biesheuvel (2):
  efi: Constify sysfs attributes
  efi: Use sysfs_emit() not sprintf() to generate sysfs file contents

 arch/x86/platform/efi/efi.c | 13 ++---
 drivers/firmware/efi/efi.c  | 52 +++++++++++---------
 include/linux/efi.h         |  3 +-
 3 files changed, 37 insertions(+), 31 deletions(-)

--=20
2.56.0.360.g66cac248cb-goog

