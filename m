Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6703380FC6;
	Fri, 12 Jun 2026 11:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262133; cv=none; b=pP4NCOJydTfj8p0Smp3imlkXUtUXrp3wGxVun9CViIXq0pAlQwUiv22o5WRew2KNnuoCbnGkWYhFZ/HVf6yFooGldiMKVdXflkcx/ftyGQztxdL7xZ2aJ62ApaUotbniDSGc5S1vhsU3J06Q977MowcRYEpLTeAdopZcSDUK7rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262133; c=relaxed/simple;
	bh=EYLyCbF5AoP2UoIwsZTZbX2h0QaBylRmIJOEZblpZ/c=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=f+pmVXKBd7OJK+gvdC74VYJ6SRHG/4j+roKE/obMVWK1+Ae54uv4wq3Y+OiWEUymG4fTXzAHrSm38b+w3P/E/4K5mbApCWzApHV90iH38dIi+CXkLCKha6Un/zUsKEpLqQCvDpPnsRcv1tQguv8wqwnqwmKilORUCspEuu10IDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=hffzJjjU; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="hffzJjjU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4UFCfhqilktoTgIAs4QCO2fRr8/HxC1H4MguJf+KNAc=; b=hffzJjjUI6m33Zg9hqZOLxnAMN
	m6/trzPPqRHsR3mBD2/5G0b7e0UfsOchloyfCQoQvh2MI5kZ6wzc24eRWQ0mYNpfauPDHKY8P45XI
	E8Rv5ogGjXBQhgtsjK4PznDDCSZOFhJywdu9ZMdey22AoMJ2H9IC9t4NbdefcmA0DJj4MlXYtkcuf
	6DWbVHpQ7SPSOYEkiY1jYTaAauVt0bqoGvJ5kMqWZKlqfCIZ4w0JB2gNRLnVPojmt7PR/9gu+OuYP
	36edcGoD352rfk3h0cDKDCPyFD46uEmJnwfF/kiQlFd7PGmh9aYUpI0MKGesUJ0eTL5FMAGSE9SYg
	gPNJoc/g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXzdw-00Aggu-2n;
	Fri, 12 Jun 2026 11:01:45 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/6] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Date: Fri, 12 Jun 2026 04:01:27 -0700
Message-Id: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAjnK2oC/23MMQrDIBQA0KvIn2MxgjZx6j1CKJp8kz9Ui1ppC
 d69NHPXN7wDMibCDIYdkLBSphjAMNkxWHYbNuS0gmEghdRCi5Gjp3uhB8ZX4dqrflXOLd5doWP
 wTOjpfW7T3DHYKZeYPmde+5/+f2rPBdejHUbtrR2Euq3oyIZLTBvMrbUvE6sWzKcAAAA=
X-Change-ID: 20260609-efi_timeout-6f51d5bbcfb7
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, 
 Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3032; i=leitao@debian.org;
 h=from:subject:message-id; bh=EYLyCbF5AoP2UoIwsZTZbX2h0QaBylRmIJOEZblpZ/c=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqK+cS2bkEnaZo5qsTnKYkt+QRDPlWpfhlX9ilE
 CIl9IJXA2iJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaivnEgAKCRA1o5Of/Hh3
 bXJeD/98kGr1wo0xF0DjK5wlGHaqZAnFvNtIYYg8H3+OxnQ0TwmMXFULk6jLmloiiRAK4snf6X/
 XpswntbzMEyf9/kApYVnhxpbn0vCjSbxzYBnVUFL4Mo2mAYFOCPiLsAMsjbNN3iiwkUvW1bjI2E
 4IZ4wH/okPPtRDUsYrxQ/SuKaAbUOeIRM13eBDmSM659Tpm13u+euz8nCayAIczDNNUv4q7kFZ5
 KhxorUtUHJJHX7Xx2MVf2hm0/owmIhNRFUcJ2ZPjlGeJzi5mo0vfgCGyqcD96UD6Q0yjqX5ZKNd
 qMgg2w3BVCGjPpFRCKYwjOqAODDoHBZ4sMSAxLBeU+5DOJQmNaakzH9pAQ4X38Um3QsQl8RFLXT
 GDDKoK3t7t7e1Q217lo9GoQBe2eg4BiO3j4H0paYEG99w0IGoEivgA2htJ3+l87verj4NWwsvFv
 nVuoYh9jmEfXRhEeOeTsEl2rpKWYxjvMWgaBNi4UnA+k8ybqka5bCADB0SETvIFE+v6KlA3reLw
 TtR4Dlw+Mi+cYdsfzMP+BBmiXbSB3WsbfdQh43d7bxESEn0ww8UJg/rqJquTBzHdl8FRakKiFxn
 gC1M3rqwRBH1ylh9cnV+esJqD7WpYBcSQBkt8wNtIAO2f8rptoa+oc4dZCsM7SRsxS/aQqrgxy3
 ZEbB0CIMtfsshNQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When an EFI runtime service call hangs in firmware, the kworker on
efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
The kernel currently waits indefinitely on the completion, and the
caller holds efi_runtime_lock for the duration, so every subsequent
EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
handlers, ...) is wedged until reboot. The only externally visible
symptom is a "workqueue lockup" message and userspace processes
piling up uninterruptibly on the semaphore.

A real example from one of our NVIDIA Grace hosts:

  BUG: workqueue lockup - pool cpus=28 node=0 flags=0x0 nice=0 stuck for 127s!
  ...
  CPU: 28 PID: 590 Comm: kworker/u288:6
  Workqueue: efi_rts_wq efi_call_rts
  Call trace:
   0x4052f11ecc (P)
   0x4052f10ed4
   ...
   __efi_rt_asm_wrapper+0x50/0x78
   efi_call_rts+0x178/0x240
   process_scheduled_works+0x17c/0x420
   worker_thread+0x184/0x4d8
   kthread+0xcc/0x1f8
   ret_from_fork+0x10/0x20

PC and LR are inside EFI runtime services firmware memory; firmware
never returned; the worker stayed stuck across the 127s / 157s / 188s
"workqueue lockup" reports until external monitoring eventually rebooted
the host.

This series doesn't fix the firmware bug - that's vendor territory -
but it stops one stuck EFI call from taking the rest of userspace
down with it, and turns a generic stalled-task mystery into an
unambiguous "EFI firmware is at fault" signal in dmesg, which is
especially valuable at fleet scale where the same symptom could
otherwise be attributed to dozens of unrelated stalls.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Drop v1's efi_rts_dead flag; reuse the existing EFI_RUNTIME_SERVICES bit
(cleared on timeout) and return EFI_ABORTED instead of EFI_TIMEOUT (per Ard). 
- Also guard the non-blocking paths (set_variable/query_variable_info/reset_system)
 and park the leaked worker via a shared efi_rts_park_worker() reused by x86's
page-fault handler;
- Split into smaller prep patches.
- Link to v1: https://lore.kernel.org/r/20260609-efi_timeout-v1-0-69a896faa805@debian.org

---
Breno Leitao (6):
      efi: fix stale reference to efi_recover_from_page_fault()
      efi/runtime-wrappers: handle queue_work() failure with goto exit
      efi/runtime-wrappers: check EFI_RUNTIME_SERVICES before using efi_rts_work
      efi/runtime-wrappers: bound the wait for EFI runtime service calls
      efi/runtime-wrappers: honour EFI_RUNTIME_SERVICES in the non-blocking paths
      efi/runtime-wrappers: retire the worker if a wedged call ever returns

 arch/x86/platform/efi/quirks.c          |  9 +----
 drivers/firmware/efi/runtime-wrappers.c | 65 ++++++++++++++++++++++++++++-----
 include/linux/efi.h                     |  6 ++-
 3 files changed, 61 insertions(+), 19 deletions(-)
---
base-commit: a87737435cfa134f9cdcc696ba3080759d04cf72
change-id: 20260609-efi_timeout-6f51d5bbcfb7

Best regards,
-- 
Breno Leitao <leitao@debian.org>

