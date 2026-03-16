Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B643A1E70
	for <linux-efi@vger.kernel.org>; Mon, 16 Mar 2026 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675257; cv=none; b=AgifGtUvOPUraFapN/leEW070BkaJfHw+BrBMkm6Ffn8AcK1oGJx0W66bTwcWD8F8kWWhM8dwI5kPGW0CnJylkw+wj5y84R4lH5ccL233jxDWukAaa6KE1JJEeTKvz5MqjP6C8D5TW5GfUZX5Yd7hw4LVRDR9d9JJb/LJDrnCmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675257; c=relaxed/simple;
	bh=y/ZLibchuQj7YlYLpkVr+2Z0sBYMwEjJK8GbheI4gus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rWoqoBBQKI4R30NlNJzrTVjHuPYY2ALkfNu8jnrVYEQXtjGVxgLIAMfOc2iTKwG274Qn4pJHpo6uFF1VZ9vyWf/NGaGNnq8In4I3vqRhdzcNr7pkoU9ENZPwnvTtGq8p2gQULs13tnsIqFXbiARlHAUAc+IKGpsWszk+yzlKQL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NE1l/chP; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NE1l/chP"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso2496469a91.0
        for <linux-efi@vger.kernel.org>; Mon, 16 Mar 2026 08:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773675255; x=1774280055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=31hFqWE+7CsGeugLW57EQWcnO71gJWH1yfQQssYWeNc=;
        b=NE1l/chPmhzwOJQgiGj91utWJOlMAk5TcyxjNy8ZPysExemvpKgWgelSrAF/Gi14Mh
         vn48JDCFPWGKM/rxTboQDQHOmQUvNbdxUOQtRK0Nn4uINcosJ1ifvl5DvhRQiR6UAtfv
         upI/A8GAFthL+Cv/JuCDFUH6Kn6SbyiKdoK1wfLo84HpomMc7YXxtmTYc3IyE/+P6uth
         bZO3rmNfBfls0YGsBPDTDKZscprb8P1tCu/1EQNSe6LZP6a+HNL//5fjhhTJvqfPm1wG
         7WF6W9GT/vUzafNZO5FHo7AwDF+6KoQWLZaLUJ8S9duk4dUhGHrVB0vtimVxvpXOC5en
         hbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773675255; x=1774280055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31hFqWE+7CsGeugLW57EQWcnO71gJWH1yfQQssYWeNc=;
        b=f8oM9pOHMv9gKZddiEnR7ThQtz8QNbF+lTfp3dcPuCxuOBXbo8a0vRqaGnbMZtxlHO
         Yo5HMHOsW1gvYFoL8SvICJczjk4AmYeu4U4nYBSWb4Mho7s7njqpqvf5b3GhVZhqJr3t
         WgGTzsCoHj7yhEeC+6YxRgu0Bd+zgifrsHg9WaNkTmSPi8n7BtUqnGJK7R7jaEdQDGM4
         R3rAygXNhCxw8WOv6zj02HLqnmMNCiZgeM9Qe/EVEzCwSlX4OlL9JEYnAssIRYdhlJkm
         7y8mAVCfBu4pn4GFbEGkLT9CdYJcCnWwQal1C4Z1ACx/a9iAhXZWiEEkyuMxz5Dxcv41
         Qp2w==
X-Forwarded-Encrypted: i=1; AJvYcCXjWUoeB7uqJGAR72PYajTVZH5rJ657Geg+LzmO+fw/yX8c95DOl4m+soNCd77bHD/nHKsSny7KcrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP7mpgs6tQ3DPavqAjB9mVBAOsUK/+fG3LCpMmzLSyIXL061uj
	UBMOFjknbeH4NKxAvloXyn5lmhUeaJDusVWPBeZ0bd9qyu19voPQcLz2H29v
X-Gm-Gg: ATEYQzzDzZRHYhma12+6YoK6c6svXDy13pSJfgFlnvQk0I48hq718tlOA+qUZ67fE9c
	2jXtrzypNqWTqR4oiHrSINNiagCDTb++ZuCTczOksxpM1rVsNuSMkLV5h75CQSQzgxHDae3JU72
	P0FV4KvVg5zsODXOsTEep3OnjdSAua/Ti1cI+IsEe3CIwmZSKijy5SpE7Wtv56U0LTrEbZuS/IM
	EPx7KO3lu4bkyPIBG9ImtDkJaVQhFjpV8/mbyndaQAZ3VJTabIz96kdHjgFsMGRnY8AfGwIZJbT
	AH4OB81Ykw85JMoM8PHGeAXGP7vpqNs+we/K5VrqoS6uDGC9vix4PbdSV8pPeKCt87Gzq4Z5D/i
	Tf7eDn15ndgYfcf5N6kQ1p2z7sPASxZayLhrDCMEw+wYCCXB+BFzL9/SlE6sa+qhMoJWdoC0iSU
	SkpiH0/YZ2FzYLGiRY8pQnCnufMzX88K13N/0JozgY2/saG3g7VvMTnIGF1Ue5geU=
X-Received: by 2002:a17:90b:2ccb:b0:35b:947d:9fca with SMTP id 98e67ed59e1d1-35b947da15amr4932335a91.19.1773675255126;
        Mon, 16 Mar 2026 08:34:15 -0700 (PDT)
Received: from at-Standard-PC-Q35-ICH9-2009.. ([171.61.163.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badb906c6sm2685a91.9.2026.03.16.08.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:34:14 -0700 (PDT)
From: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
To: 
Cc: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v4 0/2] Save Brightness on Macs
Date: Mon, 16 Mar 2026 21:03:45 +0530
Message-ID: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com>
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

Changes in v4:
- Fixed build error, when apple-gmux is compiled without
  apple-brightness.
- Fix grammatical errors.
Changes in v3:
- Fixed a bug, in which apple_brightness_shutdown is still called on
  non-supported devices.
Changes in v2:
- Saved the brightness only when it is different than the previous boot.

Link to v3:
https://lore.kernel.org/all/20260315222020.24341-1-atharvatiwarilinuxdev@gmail.com/
Link to v2:
https://lore.kernel.org/all/20260315215302.24087-1-atharvatiwarilinuxdev@gmail.com/
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

