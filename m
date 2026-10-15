Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33099497B84
	for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 06:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047087; cv=none; b=c4Nj1jBJpK23E3Y48259whCpPo1aCubn1BUOAkiWLyTjaWP93Uj+vvUjAlN6X/XQ9kR38EFKM7ZuY1Kx6L8QrAL4b3Rsk4gelUsqJDeYGdFhQKnImi3CMc/c6rx6esDdqv8DK8CWfDvY5NoP0p0v8kV3c21u+V2uAQT4y4zsbdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047087; c=relaxed/simple;
	bh=4O6AvkrFJGQjRDhazMoOBHGu7E9OWtWnmR46AlA3b3w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IXGBeczFwPvD0+zJqW7zw1VhRB6s/dF8ac5QHzRToWSX/BvyE4yJQC05gt3VPCBeKyJyi3TSL8hG01cCTj6Tmto8AWTZQG7zN6Z/pa5+BFajUxl0u8n0bS2ZMdRKDgQLzCkS6jmw4bNT0acBM78xuxtYLDqu6psqdgUFt/c+Xm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hwUTzIQV; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hwUTzIQV"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a17ec7a49cso34925715e9.2
        for <linux-efi@vger.kernel.org>; Wed, 14 Oct 2026 23:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792047083; x=1792651883; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xpplYb2oPCNA5wcEdWwlrXbdnchi0HKM0+CEPZit9XQ=;
        b=hwUTzIQVFc57uee8fre/AqjWVteLvivyelHNd0LZ0pjtrTh3QQJ08BAd4tfAmkdwMM
         8jblXUgPa9yCR2hqtTrjsb2rU4bKPQDJZTZLuvGlubSaT6uSZIZpTzg78dJgVFA5Xd1Z
         nBKdyqUs++UaKlbPPNx2lFVqBkm+ctp2UWAOgx1pRK8EXKN/hXH9E4mcdpUFoT+gqJrq
         YZbEfmL3NAfWvMpXd2LmNTun6j1XIj73cGPsaFXtt6WVaueN6Tx9clg567Siq4p+ZRql
         fGqUS0Y+CJH+7blU6lEGeQqiU4yOllkSYdq+Ui+shuNGW091QhZ+Kv+qHqn5hW5Dm6ZS
         l4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792047083; x=1792651883;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xpplYb2oPCNA5wcEdWwlrXbdnchi0HKM0+CEPZit9XQ=;
        b=wvRvNWT9uUCUTrA/W30naZ91VAKN0WvbisvFGRY3TWsXXfKtiazHtwsFFdrN4K/m69
         6U+jN9BinvLkeIVbyFvFwUBjNehvcrwfYfwY979B6vWQMeRaoqmEk523oKcMxEU7kcTs
         myb+EPFHXMK4cdSrlYhAePfVmshJbq4B+EeyD5BFg0ajFDuywhQAtMb1xbLZhMfkB4Om
         7/6NIBVlsJ7qGgjkrEArBo4Pw4DnMM53lK0JvudklRve+TsFQXdMDoL28pwCKxq0o24W
         tEPO2/SMV+ylb3/BcJNS+r3Q76iWRNZsqWRw195LXbInPqn1EkBGyyi0QR9WKSJJeacL
         ab0g==
X-Gm-Message-State: AFq9FYL5xQGqJDGRYts8Wyh1yLyimdFSTdI6iHgrGHE1HkdmHu3MwL5K
	bw2nrjrRWaK1VFpngDalIZTHK86ufyeXAebkxa6mTW4HCXn8umc8vhdNkjvKkk5z6KcCDgzEy/C
	dp0R+hGyX8/G38h/NDLXAahdmwG5Qrl9iqkZZjemf2lYf1tbXpW4nxl+OFzkQqKDARDY6h+PID9
	vXg2ha7majHIZaC7KShRmFlpIEIS3TQQ==
X-Received: from wmkn17.prod.google.com ([2002:a7b:c5d1:0:b0:4a1:80f9:1fe9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:630f:b0:4a1:9f59:ee7
 with SMTP id 5b1f17b1804b1-4a19f5911f4mr231937815e9.0.1792047083023; Wed, 14
 Oct 2026 23:51:23 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:51:17 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015065116.3365029-5-ardb+git@google.com>
Subject: [PATCH 0/3] efi: Unconditionally preserve kernel's own config tables
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Some prepwork for kexec via the EFI stub, which may never land, but
these are arguably cleanups in their own right, or neutral at the least.

Ard Biesheuvel (3):
  efi/libstub: Don't replace an existing LINUX_EFI_MEMRESERVE table
  efi: Retain the address of the LINUX_EFI_MEMRESERVE table
  efi: Initialize all configuration table addresses to
    EFI_INVALID_TABLE_ADDR

 drivers/firmware/efi/efi.c              | 18 ++++++------------
 drivers/firmware/efi/libstub/efi-stub.c |  8 ++++++++
 include/linux/efi.h                     |  1 +
 3 files changed, 15 insertions(+), 12 deletions(-)

-- 
2.56.0.385.gd3acb90ef8-goog

