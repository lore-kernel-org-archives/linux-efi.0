Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932C43CEF7;
	Tue, 16 Jun 2026 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611804; cv=none; b=fPM0KXtvKzOPCHDm9fdP4lSXKKVvcJ7chjw1tQIFMXs3TXiF8yZBNWL0EpqCDCzB1Vvy/YnxzQeZ+//4nR1gtaXzMbFWGHNZ+mQpXEl9iLqkKdzBVizHU7YWNbxpdAaAYTWDA1OlVlNwgVJh01vtZZ3BY2tz0X3z12Siub4KLKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611804; c=relaxed/simple;
	bh=T3h3X5lMoTnn/FWf8XUIg9DGKAxLJ5x+EbZr6DPK6M0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=TdHFDdOxXpa11W5qpXRi4rBXxxCjpJ8BSFR/QBlnLSBzceoHMMjlc5AIWPWvmQFwdL2lf1IRctzO0e2lgIc7PkCqCt+lnxw2bAAsE2dJj2lFoBSiDRB00VyT5By0quFXbuTdNjP8NNBz1KekTqYSUXYlM6UNmwND/i5ASLWIFfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=oBTgZfKx; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="oBTgZfKx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CirwESxJ6hHpFxp+36fKyY+Cg1PFYkWt3br8SYythRs=; b=oBTgZfKxlEK5GwCTfZl1F1lEHx
	gGtPD4/uXolgRyAtwroHrI/KFAqNXo2r9mrkjNbiuJ9Jom8mEQxUIwaZ0fY0v43BDhZgsrE0BOBXk
	UFYBNoEZMDxTuEUmpG0z8+alc/THRweAJyzUu85lEGDqgxlPqKI4RKcJrhZ+sdTviICLxLNz35TOa
	obAi6U4/q9Rew/uBrW68K/7ECW3gJETtOCy5xWs0YJhs/KVNRtvxfxaM7/KSxSkFxGo8zgrQK5V7A
	exXHZCRBFuull9zhHttHOOoZbdMVDCNKfdivoqc7+6hfltAZx0vhH7HOjYaX0HGRzYW9coBYc7mNL
	UB41sAtw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZSc0-00DpsZ-28;
	Tue, 16 Jun 2026 12:09:49 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Date: Tue, 16 Jun 2026 05:09:33 -0700
Message-Id: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP08MWoC/23MTQ7CIBBA4auQWRcDaOnPynsYY6AM7SwsDVSia
 Xp3065s4vYl71sgYSRM0LIFImZKFEZo2blg0A1m7JGTg5aBEkoLLRqOnh4zPTG8Zq59KV1pbed
 tBQWDKaKn967d7gWDgdIc4mfHs9zqfydLLrhuTN1ob0wtyqtDS2Y8hdjDBmX1M0t1nBUX3FfyY
 q2Q2nl9mNd1/QIMo+lq5AAAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3344; i=leitao@debian.org;
 h=from:subject:message-id; bh=T3h3X5lMoTnn/FWf8XUIg9DGKAxLJ5x+EbZr6DPK6M0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqMT0GR/vmYJ6h5tNRVu7dYh/ZvIv/zYJce8bbh
 jJarpalmu6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCajE9BgAKCRA1o5Of/Hh3
 baI2D/9NXjDVrC1m/0qIYUn+mxCUDGevctlcpot1yoIPZQnZzxCOzM7luAcuBCZmt0t/5PvOdmZ
 1xpfJptswqN+TG/pOgtwzbdOY9gSTu6bRWjtvtwaAOLG8NCcjjegVFxX8ZD2kLy7h3y7NkuAAWg
 C2jmHclU19DEjZ8xMsXhEl/gFX6pLB9iwdYFTuOAcasF8Ec0O8yxeh+YcaAPCyAuyFjqPTDHrEF
 dC44Z0TjoS9hfl7nufrMFANYtxHdauW/RdbYOm+Ne2O8DIcvaLGSrTSZsqRN4Ts/IXa2WWQ/9Lx
 IFvOu0j4Zhj3QW1iFnGybilvWtKH2vfuzZ4WxxSnBhX7/6fotEje2Oai7yBdEGAk130TvgW+WGl
 30qyYcunoltkff3QV9NJci/k5aJ9kpdp/7Eqrt6AT9cDOerYhL+wlWCE81rHtXhWpWZACKnmC3r
 gG28qspOLEVh9gQaHtMuwhsFyj7Lkt62JnhIp3K3OsXFkQqmwuOk/ized7apf//d70rbaLcOR3E
 RtEjUh5zLJNBsqrMMzkDO5BPdJ+lbCKL3oFnz9/UtlXqVLI6id+XlI9vkTmLpe5qVCmWPl8gCVi
 0XN29/gTrctBuCKgwv/gi1a5Y18+YLojZwJY1zgNu4AqV5gpgOuRCtvv4Nb5jeQXxqccg1WRMFX
 c7E+cjX5Lf3RGJQ==
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
Changes in v3:
- Fix two review-flagged races (entry-time worker park vs. freed args;
non-blocking EFI_RUNTIME_SERVICES check now under efi_runtime_lock)
- Link to v2: https://lore.kernel.org/r/20260612-efi_timeout-v2-0-f714bb016df6@debian.org

Changes in v2:
- Drop v1's efi_rts_dead flag; reuse the existing EFI_RUNTIME_SERVICES bit
(cleared on timeout) and return EFI_ABORTED instead of EFI_TIMEOUT (per Ard). 
- Also guard the non-blocking paths (set_variable/query_variable_info/reset_system)
 and park the leaked worker via a shared efi_rts_park_worker() reused by x86's
page-fault handler;
- Split into smaller prep patches.
- Link to v1: https://lore.kernel.org/r/20260609-efi_timeout-v1-0-69a896faa805@debian.org

---
Breno Leitao (7):
      efi: fix stale reference to efi_recover_from_page_fault()
      efi/runtime-wrappers: factor out efi_rts_park_worker()
      efi/runtime-wrappers: handle queue_work() failure with goto exit
      efi/runtime-wrappers: check EFI_RUNTIME_SERVICES before using efi_rts_work
      efi/runtime-wrappers: bound the wait for EFI runtime service calls
      efi/runtime-wrappers: honour EFI_RUNTIME_SERVICES in the non-blocking paths
      efi/runtime-wrappers: retire the worker if a wedged call ever returns

 arch/x86/platform/efi/quirks.c          |  9 +----
 drivers/firmware/efi/runtime-wrappers.c | 68 ++++++++++++++++++++++++++++-----
 include/linux/efi.h                     |  6 ++-
 3 files changed, 64 insertions(+), 19 deletions(-)
---
base-commit: a87737435cfa134f9cdcc696ba3080759d04cf72
change-id: 20260609-efi_timeout-6f51d5bbcfb7

Best regards,
-- 
Breno Leitao <leitao@debian.org>

