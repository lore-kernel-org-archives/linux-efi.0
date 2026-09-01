Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E876F3914F8
	for <linux-efi@vger.kernel.org>; Tue,  1 Sep 2026 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788262455; cv=none; b=Nn2OpRPgAJ920RB9OqDXYqgXmFI/2tzpYm1dSXS7agGGFTC1tC8Hvx6PbyO1mpLg4jK/x6mUM4BwiKurIvTtUBjjCzU7AQUDGceAV22kMX8deYJJT7RGCvlbpgC3DLX90g1wieb/aQPsKJPEJ/uxjdrBEzUkf1uVvt/KRvlMtRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788262455; c=relaxed/simple;
	bh=mZyATfjoQAsFYm8U+fyrUxsWm7/pm6Bqh0PNR8KqsxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kr38nkwnXo57x7zjQOjcm8w8V7PTP38EmncHPIbK9kcaD3DLGDWmgjeIYJZ/s+Q8C4ooXp1F9N9iR4pcBxVIf5FNeeukaQSH0pz6usLARsvGKVReCzthwhaYkgT5lAgbWLMhArKha+4WFWOuAF84HBt+PCF7JOI0jwu0vBQgA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GlqVWvEL; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlqVWvEL"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d01663d816so5886515ad.1
        for <linux-efi@vger.kernel.org>; Tue, 01 Sep 2026 04:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788262452; x=1788867252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yKaP2T9ukNcmdzxbkC0gy1CiVS9kokfvPnzw1Zdn3K4=;
        b=GlqVWvELTbVOqXKFxGZgoV5Ja1zJADMea/vJIfT8wSbTsg0ZgfodHxmxG6cDTDWhlb
         4OEHh+MYvZKbA9gdKBC07vDaMkIZPrKAW6BYG3Uo/nN+/7pzfKnOuqDn0DmctWCGnm8D
         8t79NeoPbVzddM3LYWeT0eJhW75eOYXbJE9GvNDIheEnJVE0Rk25TEQh1TtDYh1925Rt
         ctODvmDGtwRc5RY1DJK3M6DJXgwqA7x5Wek9f8CD89Dcr2Ax6koM8IePcnholPclJYdx
         qHBZKK3E1XeYgE7VSCt9Ano4f89UD2f/ZFUjFZaP52lYDDdnmwraHT/4e6fMCZbDeeT3
         1Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788262452; x=1788867252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yKaP2T9ukNcmdzxbkC0gy1CiVS9kokfvPnzw1Zdn3K4=;
        b=iLrVYL/ZPhfbaXIQrMW2fxp5WvRqJ4cbc/LPOSIqpRbjD1UI53FPbDyxuYDrcwqVox
         coMDBtURY+8ec/G8ryOUWLSf+cgJYQDJHZ90QX96i3XkaMHWHXAf5GFQSyaOei0MsN8b
         z7q8eWtj/navxPeJOuTtMTC790fSmFpoWdyUdynhlwV6IdlpJcbYpc6hJbZPQZeBuxAM
         HO4a2y+EkcXEl3RgQrmjg1n5c99PcpX6VGF65nPK3a+W21zrXD0g/gXuEOp1Do2EOEqj
         +mgH7y6p2DQPR/0AyS//hlvI/J5sFTdHjGunmPzB1Zi9VkVQk8ofAGjds+fe5v94nJfb
         3EBg==
X-Forwarded-Encrypted: i=1; AHgh+RoUr6A8G9qQKL1XImHrqTBfxG6zY9XxYmXGTuGebEIombjiYUWg36umA4kgxekG8Yrmf7GoYtW9LX4=@vger.kernel.org
X-Gm-Message-State: AFuF++nabI/IVeH0rnRA42//UtpjziVSI+oOKHVvrnxF9+8tOcJjmQgH
	Qefsm769VGC7EcyY6KUThLC/UWPntKDma3tV64Vzsgik/hVsAe+7hfnm
X-Gm-Gg: AYBFou1SbSQWkFtsBBbgp6McDCqpCVNEgH3HDIjaW22/fxBgcs4YW3gva/bt8BTQPTC
	jbLmMJiOPTgtgrNcc+bAWCZV0MapDZbprh5OM4dYc1GdZH7iiXQ05aqtUFdUQ6EWPlqb2SyDTy+
	Zb68ny+pLF31lmJws2PgTt/SW306qQG2GQvFF1gHFNAG+UhxqhzachB11AHge8Vl3DJF5UMBsOQ
	qRY9eV5SCJlECwpiehDDt9tSPHAn4XSdWLDx3tPl+TsHHi74hPCzFtWcSlqaWP4Bg99rkBVYmQY
	Qp1QI1R7zp4jEB5aYFZvF20HHyXMAnyZ5rfZOIvkXyW6pySbeiYkoB5y1wGELRQeLVpr/MfwIJw
	Pgt6KN7n5YtoNvtpVNtAIzBp0xzqevBb1UTNKh/FFJ3JySs78MHbPJpzahfza8ovD2z0MpXi31q
	z9iYmnJf7M28fUzeGMc5IJvVvuWECUG7kn6/7HkaR36lBhEXutj6GrEbBRqPyS69wrxnLGnBuUx
	iDx+bECIRISP8ZQBsDCkMmHlrl1xfBW0EA=
X-Received: by 2002:a17:903:234d:b0:2ca:660:b1d with SMTP id d9443c01a7336-2d74ddc6daemr461834045ad.11.1788262452125;
        Tue, 01 Sep 2026 04:34:12 -0700 (PDT)
Received: from overlord.home.arpa (ip68-107-67-45.sd.sd.cox.net. [68.107.67.45])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f7bf283sm41447470eec.8.2026.09.01.04.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 04:34:11 -0700 (PDT)
From: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	rafael@kernel.org,
	Pavel Machek <pavel@ucw.cz>,
	linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	"Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
Subject: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86 E820
Date: Tue,  1 Sep 2026 04:34:06 -0700
Message-ID: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The EFI stub currently allocates the TPM event log as
EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
in the E820 map.

On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
can place this allocation at different physical addresses across boots.
Since x86 hibernation validates architecture-specific data from
the firmware E820 map, this causes an otherwise valid hibernation image
to be rejected on resume with the following error:

  Hibernate inconsistent memory map detected!
  PM: hibernation: Image mismatch: architecture specific data

Allocating the event log as EFI_LOADER_DATA avoids changing the E820
map, but doing that alone would regress the kexec corruption issue fixed
by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
log to avoid corruption").

This patch series instead installs the Linux EFI memreserve table on the
x86 stub path and then uses efi_mem_reserve_persistent() to preserve the
TPM event log across kexec while keeping the allocation as
EFI_LOADER_DATA.

The series was also backported to Linux 7.2 for validation on the
affected system.

Results:

- stock 7.2:
  TPM event log allocation changes the E820 map across boots;
  hibernation resume fails

- EFI_LOADER_DATA-only diagnostic build:
  E820 map remains stable;
  hibernation resume succeeds

- this series:
  TPM range is persistently reserved;
  hibernation resume succeeds with the normal device drivers;
  kexec_file_load() succeeds with the TPM range preserved;
  kexec_load() succeeds with the TPM range preserved

For kexec_file_load(), the event log had the same size and SHA256 digest
before and after kexec. For kexec_load(), the before and after event log
files compared byte-for-byte identical.

The original report and investigation are here:
  https://lore.kernel.org/all/DL3MNWW4VEBR.K3K6A92WMHUY@gmail.com/

Patch 1 makes the existing EFI memreserve table installer available to
the x86 EFI stub path.

Patch 2 switches the TPM event log allocation back to EFI_LOADER_DATA
and persistently reserves it after the normal TPM event log reservation
has succeeded.

Jasmeet (Jazz) Bhatia (2):
  efi/libstub: Install memreserve table on x86
  efi/tpm: Persistently reserve the TPM event log

 .../firmware/efi/libstub/efi-stub-helper.c    | 23 ++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c       | 23 ----------------
 drivers/firmware/efi/libstub/efistub.h        |  1 +
 drivers/firmware/efi/libstub/tpm.c            |  2 +-
 drivers/firmware/efi/libstub/x86-stub.c       |  2 ++
 drivers/firmware/efi/tpm.c                    | 27 +++++++++++++++++++
 6 files changed, 54 insertions(+), 24 deletions(-)


base-commit: 786262be6048deab760f68c8acc2c85607165894
-- 
2.55.0

