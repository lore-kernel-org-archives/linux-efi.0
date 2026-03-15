Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935B6370D70
	for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 21:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773611591; cv=none; b=gEOGq0KuKxHR90pZJtxOkJervNyuuPc2uiIF9vUg4tw5O+kebPU1ilQfNqaKTpogYnlno6m3HvvEpCnj0kikqb6ZlDkhVpi6Oo7OOsvctsePIHS5yiXyle1TkRPj6RPdPOYB4bU2G1WedPIFp5dDxEDixD/Ak30zKXFnrnecErY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773611591; c=relaxed/simple;
	bh=p8ZMDL0ATelD+YMbWy5VJVld5YBBFVddDlr5bIuy8jA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BKXCDRfeoNZhd2XusBJIeJg9RX/IbHOJq20/oiWH/96KrBr+JmfuowF0XhHvnXOaeXfkhfv8kBZEXgdZyxMDc26tobFDjst6v7N4yzHPfboEyiOCS6wC0ZAqtyZX2xG+xv0aH3vrsDCCkhWxR8dntzSU6a7ugIS1kcGXpf/YNtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UTmb3jm0; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTmb3jm0"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35b97ed057cso246466a91.1
        for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 14:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773611590; x=1774216390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ShhDALn1OVXt830iNpmwt2NWXRAroThv+VhHPtCxAKY=;
        b=UTmb3jm0wtNM2hMgYHM8sRB5QxTjtm+tIQxjVuNLZh6EdRcKA34X4xS3R3b9PjQoxE
         qsVJJ8OMSJ5leZmqvgbHRIgKTr6DDnjlJVX/DZ8tkQT75NrzMR6pk7CY0WhqonPzBBJ5
         DZXjKwHIk+762BHhMGwzstdxddevwP/qdG/HSXJ7fYtJerf89+6sSRcqS+GKsw5YOXl4
         Pgt9gM0kHcDwzOI2L92iy4drr6QXK+LUnf/X9OpJ6Wia2j6VXPxFq8IFOoOQB5E7B48i
         mg7a7W5pZgUvIHYHXfgfbmovixd/iVQhfvvoKY/0hxova2FtUwxe6GpvZtfpmAj/9VRH
         WdUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773611590; x=1774216390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ShhDALn1OVXt830iNpmwt2NWXRAroThv+VhHPtCxAKY=;
        b=Bcs3g+LPrrwFuzx7ElfPqIIdTjk+VO1bcuQV4MSS+dbBGTwdz+wBvEod3iPLuBLgVH
         LKxRfcbxUgM+nnFVCFrzfy8LFuVyuQP8BZNP6QwnRae4eZen0aSYCDhQQPj5ti0CLhNG
         U9gTJCKwbe5k7ZfXZS5KgUemJgQIuPSm5qRQIlkMFLktZNtOHmSuRtK3gVvcOlG+3EPh
         CTmEVcW3G440WefU+MlwfBqL9PqbB8STIL3sb0mfR+r8G9PmyH1tRR9cj4QtWVInKtUb
         oTNW+3riChqgSgii1xqpty27Bfzrj9+fRU2kgZhyjSNuJ80+BTseeUXuT3Ikz4WnY/kt
         spDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbyGLHiFfaJqhaSrZxQdlWDDLf5qTu3wJD18ZkZvn9ItmtzK1P0hSWwniqQX4qbohmB0NrapBiRzo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys7eeKsEj9f7ILAFkwgrYJFIL+bRg3PhOaYsQ2n/kEYN2oYnHG
	KkS8pzVP6b+uTpzGDWLTQmx4DePxf9euhquekcxIz9FPw9yEXwZJAdU=
X-Gm-Gg: ATEYQzzm7/wmC+X/RIMvUT3rq15sTMbSr1V5gAfsb7qY8BWE9chRjB5BaksP4yDWZlf
	23ALSinXjjIpRommT4v15ICWJe86BfLQQWC5MHbWfuNeY7tEC+naf6Ohg4ScxoAqY5vh1YT5Cr9
	C3EngwuQIVKFXx5bM71iBxR6QfKXLrfIShsoQmYNkiiBhlRL2w3b/55cYA6sKuVnJ9mrRLX4Ov1
	btg37VXbCVL1iCd9afqZFK6Cvf4Zlg9OwS1qvlxPnD5lawQjkCmdGQ9JAs49XQsa2WxIKAzk1It
	zunN0kU8PHn7Whl0H/KCY0eTelW63Kmi+ct8jThLzklBXYP4sW/JMEJ2bRVTXOrtHhL8YLvzoxF
	9LBLY2u8gxYFX6P0FhGdTBDWSf/4ID2X85W0O/CIXwcp0h0eeZ8nndqlH16DYJjHAQl3tQP708p
	HXSQK8vyBSEI8tV43F1t8/uI6+DEP6kSed8JW1HeAqJDOoO4ZrCILKLD3t48HTqkE=
X-Received: by 2002:a17:90b:39cd:b0:35b:9a95:dfb0 with SMTP id 98e67ed59e1d1-35b9a95e3afmr1981652a91.25.1773611589949;
        Sun, 15 Mar 2026 14:53:09 -0700 (PDT)
Received: from at-Standard-PC-Q35-ICH9-2009.. ([171.61.163.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b9303eb9bsm3074980a91.8.2026.03.15.14.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 14:53:09 -0700 (PDT)
From: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
To: 
Cc: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 0/2] Save Brightness on Macs
Date: Mon, 16 Mar 2026 03:22:40 +0530
Message-ID: <20260315215302.24087-1-atharvatiwarilinuxdev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when a Mac is rebooted, the display brightness does not reflect
the level used during the previous boot. Instead, the brightness is
reset to the value last stored by macOS, causing the system to
ignore any changes made since that time.

We fix this by writing the brightness value to efivar 'backlight-level'
at shutdown only, when it is changed since the last boot.

Changes in v2:
- Saved the brightness only when it is different than the previous boot.

Link to v1:
https://lore.kernel.org/all/20260206125641.12983-1-atharvatiwarilinuxdev@gmail.com/

Atharva Tiwari (2):
  efi: Save Brightness using EFI on Macs
  platform/apple-gmux: use apple_brightness to save brightness to EFI

 drivers/firmware/efi/Kconfig                  | 10 +++
 drivers/firmware/efi/Makefile                 |  1 +
 drivers/firmware/efi/apple-brightness.c       | 67 +++++++++++++++++++
 drivers/platform/x86/apple-gmux.c             | 21 ++++++
 .../linux/platform_data/apple-brightness.h    | 20 ++++++
 5 files changed, 119 insertions(+)
 create mode 100644 drivers/firmware/efi/apple-brightness.c
 create mode 100644 include/linux/platform_data/apple-brightness.h

-- 
2.43.0

