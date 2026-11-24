Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541876;
	b=wXjxkWwGW0QGpFVdjMOTRriJNlALFQxDxcQE4xMI7sMhaFEykJ/ecSR3jtccLpg6a42c
	 rX7JKfjgz/3KRwyrsf2ewF/zhMYXD9/XA5KlOXiSeIiCau0F9ayFNyj7vNN6BHvjIzIq1
	 XACnGgUVP7bQZPhhEGV7FFm+TLLZ/lUtsG2OfqmdS2j8xEkfMe3iOHrByp1BAAr92VtZm
	 ZhizGIsbd33mYaPwhdMld9NpomupIr1mCYc2RujKYcSMVqqBHNdL/8fS7yN7kvDaZHo1R
	 JGrh6omZuL4+A5EKS3SPrQ0KhLHy7dlltfj5b/qzQG/VIMyujveT4s+Man2bVdJY2Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=G69O/BlkH22ZYIj7xp+lE2XTSd46SKBHU59HdeJNpYY=;
	b=KF24P//mzddDQHYxGcv33FVP0i+ikMknAbHPz1/SBEAP25FhQh1QZJe2uSci/dX0/7k9
	 +8GA06fEv68LYj25hPbGs9vWYNJneuSdiLtCPd+E2lOPYDcPu/bKdLYbNEdj0s7n+p0QB
	 3vwYsE54wUK03a+1LLnDdeHwNdSkW+zXUCB2atRixQ9i9xyCQbYxOLE9QECVWi+ghIIMk
	 z0MJYOlRvpioXsgOlvDZBhDlaiX6DZLx8ablaM6hA5DnnZm3bnuhrQULg7M+RxVJb+bx/
	 34lX7slJVbev+K1zlnkxTWnAZDUSqMrkZqCl98AqYA9hVwvGlVqbblqJ2qY9bwMBs1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SH8rHZbU;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F94606A31E
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 17:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80F94606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SH8rHZbU
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4915ba023d4so3040370f8f.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 09:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541875; x=1796146675; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G69O/BlkH22ZYIj7xp+lE2XTSd46SKBHU59HdeJNpYY=;
        b=SH8rHZbUHwkp8JIw2HtG20CSPEB7+1vgThvSftACSVEvoAdv21Fw/bKTD7XdOAynQA
         hqmNrYu0RaHuH93V837zFwp9070CN6Ka/Bvf5iMYLLSlb8CWq1ekBz7B59FujenH7CdZ
         wFBtgfma7mmPMMQ5uwyAVNE0pVvdjnbZ3BKyEzlTq+5rwfIzi70nEZIH5HZ1cBupAzNh
         eM6tvhGCRkjNV1+GuqS3rG8yUyDNczt5OSbhASTuf+Sf20PEfLCGLUOl0KWCkoMp8C/k
         EJF26l7KWKPwHF5Ier8eOG7TOhJ1ZhQDw3bFV2N8E9ZVihaHeC8k4iIZl5BMj6ciec+1
         9PUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541875; x=1796146675;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G69O/BlkH22ZYIj7xp+lE2XTSd46SKBHU59HdeJNpYY=;
        b=QXI2/VEvcpo7OmNSc+MuTwy0wF2ikNhBKgobwsZGkIrbljJIST4p/LT21p1tvoneXM
         S4wms/WOPK4L6LKRmdJyZ2WlP0KL5+Bqt0ZsMNx32bcRBbjQIuKy8JQU77nRyOxMf+jV
         j0Ub5VGcfv2KA1BlPLbHhcCCihweji11NeA8QeoJxeb8ITp7H5lbrSWrTr4e8tukKJp6
         vv2Me2l7GVlgc5aIZCL03EyNY9MC9p4fa2/gINU49tzlDjKaFF8xKH9U7eBI2WZa94SQ
         O2SC03kTHL2BQB4xV/WKYO3ENmgo1+SzxvN2t6fwpgUCepNa3i0Li18K2Czcc79ANW6q
         Ko+g==
X-Gm-Message-State: APuU4Z9bdh/9+alctA615xPFziEWTK1b9SqfFrplzq22HwIoK9oHQYiX
	ZYXJ7dq8alA1Qx5FMw/z1LTQzxavNsjU4iilL2vptTqeEb99yResme8DZUjsoK4Cmm3rZ/I56rp
	RZjYPFYojTBl2N0xwDzSWMFGd+exSEEgAEoY3D/LdN++iaiFqNQkO7ucIlZwA5DOQREBJvABX6A
	y03tl2r6/fcwBsn2eekZJ5djh0i8MPLw==
X-Received: from wrjb1.prod.google.com ([2002:adf:e301:0:b0:4a3:6d62:8107])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f10:b0:4a1:88de:9e8b
 with SMTP id 5b1f17b1804b1-4bb88807909mr341731565e9.5.1795541874421; Tue, 24
 Nov 2026 09:37:54 -0800 (PST)
Date: Tue, 24 Nov 2026 18:28:10 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1053; i=ardb@kernel.org;
 h=from:subject; bh=Cu4l63ir4SJCNe0bGDU+eoKP2eTLvYAJWbKL+6g2QPs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZv1pA7zh4JAgykcRSGXNrBfrhTeseeqtsiveM2fCgvdn
 k2YnjOjo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkvBfDP4MZfSsjklx1GGwn
 c34qns8kPaPlKtez6KLIN7y3vrEn5DEyXEzxiPp1SCvqjVWnz/NL/YzFdjl3dp1RUnp8fJrc7TQ rdgA=
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124172811.2580784-7-ardb+git@google.com>
Subject: [PATCH v2 0/5] efi: Fix pstore runtime en/disable
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=" <u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Ard Biesheuvel <ardb@kernel.org>

Fix buggy use of /sys/mode/efi-pstore/params to control the module at
runtime

Changes since v1:
- Address feedback from Uwe and Sashiko
  * Two fixes for pre-existing issues
- Split the conversion patch into two

Cc: Kees Cook <kees@kernel.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/all/20260906235838.2928815-1-gpiccoli@igalia.=
com/

Ard Biesheuvel (5):
  efi: pstore: Make pstore_disable parameter read-only again
  efi: efivars: Don't dereference NULL __efivars in efivar_lock()
  efi: Statically initialize efivar_ops_nh
  efi: Tie 'efivars' pdev lifecycle to generic efivars
  efi: pstore: Convert into a platform driver for 'efivars'

 drivers/firmware/efi/efi-pstore.c | 120 +++++++++++++-------
 drivers/firmware/efi/efi.c        |  71 +++++++++++-
 drivers/firmware/efi/vars.c       |   4 +-
 include/linux/efi.h               |  11 ++
 4 files changed, 158 insertions(+), 48 deletions(-)

--=20
2.56.1.831.g720f3f5937-goog

