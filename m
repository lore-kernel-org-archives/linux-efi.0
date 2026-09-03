Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1612D456DE5;
	Thu,  3 Sep 2026 21:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470732; cv=none; b=r36hJ9Q3wEp7tm/oy7BPY5ylB6XI6QoNKDt8a265kS02RnHpsQD0LJSiBzr5p+CxVd4Huh2Y25ka5j04xvQRpJpQTSc8D54gRDbZlK+xwAg7Ki/9tinwfxavmHaEHyty4m1vgAg4ZxeVRau8qsHlqqJLsjYyo96a4p/r8gp0BXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470732; c=relaxed/simple;
	bh=/PbcVuaqKpql8BazVd+vhcHVJjHOjXcKAj9bZduqAV8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UZjfd0t8bm4KyomAs0X6GupbulacQrfhsz1uVpTy/CDN/Obhu/+ZVKIqq1ClFbyjss3ksAntm5mxSBiZEKSUKzfuk8GwKsaKpJOS+h4FhnmoNLg7X74wC79HPJbI6coevCUNJdRA3l6C51HbpE4bYNz+cYdkEezcKZZisbrODlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCMEm9m2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCMEm9m2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345341F000E9;
	Thu,  3 Sep 2026 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788470730;
	bh=pBYXfV7nRNq2hchcDOyCNV6/3rhTj6xVaP6dQDBt29E=;
	h=From:Subject:Date:To:Cc;
	b=ZCMEm9m20Rxoghi80cFY8N3dLDXCMLWKXKinEtpEabP8RLuXZtkNGkyI7tt04+T6W
	 y063G4fDDDtCpx8k8ROESheOp/+7/M1xHGk+lCmo0a8ULJI6KGyLsisdhaAHJQKmLv
	 31ZPRktLO4X7UEAHAgugUIARHzXINQZe8VAcYFu8c/9qKPUAWiTimE9Rb0BkXtrWht
	 8nlTbc8aMm8CTfZM64v9584c5rB0mzlNOW2i34RGvtz43plavV2/yRYaBdRnJtGrCw
	 WfrATpOmYkD1LNKVVj1vsthd1oAxVQETUEkyDq/GBKt2suJNKfn41lmNwgx0CH6LP1
	 nVB+X/IHSsqCg==
From: Vincent Mailhol <mailhol@kernel.org>
Subject: [PATCH 0/3] efi/libstub: reduce size by optimizing GUID storage
Date: Thu, 03 Sep 2026 23:25:14 +0200
Message-Id: <20260903-libstub_guid_cleanup-v1-0-06fcb6216975@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrBuIEZX2KlIkmYx2ikTJGBHEu
 5vW5Vv8f4BQZBJ4FQdE2lh4DhnlowD82DCSYp8NRptGP3WlJnayJtePiX2PE9mQFtVa6007lKi
 xhpwukQbe/9vufVuS+xKuvxec5wUCjM8deAAAAA==
X-Change-ID: 20260903-libstub_guid_cleanup-7aad27f1c0c5
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4606; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=/PbcVuaqKpql8BazVd+vhcHVJjHOjXcKAj9bZduqAV8=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkzn56Y+NEyXTKUbWWVXHu5x8S0Tc1NijsXCjQv+MnTz
 quaMTu5YyILgxgXg6WYIsuyck5uhY5C77BDfy1h5rAygQyRFmlgAAIWBr7cxLxSIx0jPVNtQz1D
 IEPHiIGLUwCmWuc8w3/3pd9cNz68uUz43ANdHnWuwi97FY8LCVdFu/0Wn/Wyt/8+w/+E6Q+PsEV
 UtGSXP+Pa+thm4saprOWZWXtu/Hy8MeK++2lGAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

The EFI stub is size-sensitive. Several call sites currently pass GUID
macro addresses directly, or keep GUID objects as automatic local
variables. With gcc, this materializes the GUID at the call site,
resulting in several assembly instructions. Using static storage instead
emits 16 bytes of GUID data and only one instruction to pass its
address.

The first two patches convert direct GUID references and automatic GUID
variables to static storage. The last patch factors GUID objects that
are shared within the same translation unit.

For the full series, on an x86_64 build with gcc 15.3.0, bloat-o-meter
reports:

  add/remove: 21/0 grow/shrink: 0/12 up/down: 400/-1200 (-800)
  Function                                     old     new   delta
  tbl_guid                                       -      32     +32
  pci_proto                                      -      32     +32
  guid                                           -      32     +32
  cc_guid                                        -      32     +32
  tpm2_guid                                      -      16     +16
  text_to_dp_guid                                -      16     +16
  tcg2_guid                                      -      16     +16
  smbios_guid                                    -      16     +16
  rng_table_guid                                 -      16     +16
  rng_proto                                      -      16     +16
  rng_algo_raw                                   -      16     +16
  proto                                          -      16     +16
  linux_eventlog_guid                            -      16     +16
  lf2_proto_guid                                 -      16     +16
  info_guid                                      -      16     +16
  graphics_output_guid                           -      16     +16
  fs_proto                                       -      16     +16
  edid_discovered_guid                           -      16     +16
  edid_active_guid                               -      16     +16
  console_out_device_guid                        -      16     +16
  apple_set_os_guid                              -      16     +16
  efi_get_memory_map                           707     696     -11
  efi_pci_disable_bridge_busmaster            1199    1184     -15
  efi_get_random_bytes                         216     188     -28
  efi_remap_image                              357     328     -29
  efi_load_initrd                             1113    1065     -48
  efi_get_smbios_record                        283     226     -57
  efi_random_get_seed                         1368    1297     -71
  efi_measure_tagged_event                     935     854     -81
  efi_retrieve_eventlog                       1686    1570    -116
  handle_cmdline_files                        2501    2341    -160
  efi_stub_entry                              4180    3953    -227
  efi_setup_graphics                          2210    1853    -357
  Total: Before=29223, After=28423, chg -2.74%

See this as my penitence for adding the BLI feature: I am giving you
back the bytes that I consumed, and even more.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
Vincent Mailhol (3):
      efi/libstub: move direct GUID references to static storage
      efi/libstub: make local GUID variables static
      efi/libstub: factor shared static GUID variables

 drivers/firmware/efi/libstub/efi-stub-entry.c    |  2 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c   | 10 +++++-----
 drivers/firmware/efi/libstub/efi-stub.c          |  2 +-
 drivers/firmware/efi/libstub/file.c              |  8 ++++----
 drivers/firmware/efi/libstub/gop.c               | 17 ++++++++++-------
 drivers/firmware/efi/libstub/kaslr.c             |  2 +-
 drivers/firmware/efi/libstub/mem.c               |  2 +-
 drivers/firmware/efi/libstub/pci.c               |  2 +-
 drivers/firmware/efi/libstub/random.c            |  8 ++++----
 drivers/firmware/efi/libstub/riscv.c             |  2 +-
 drivers/firmware/efi/libstub/smbios.c            |  3 ++-
 drivers/firmware/efi/libstub/tpm.c               |  8 ++++----
 drivers/firmware/efi/libstub/unaccepted_memory.c |  2 +-
 drivers/firmware/efi/libstub/x86-stub.c          | 13 +++++++------
 drivers/firmware/efi/libstub/zboot.c             |  3 ++-
 15 files changed, 45 insertions(+), 39 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260903-libstub_guid_cleanup-7aad27f1c0c5

Best regards,
--  
Vincent Mailhol <mailhol@kernel.org>

