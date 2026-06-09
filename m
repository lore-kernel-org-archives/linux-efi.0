Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98516390212;
	Tue,  9 Jun 2026 11:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006197; cv=none; b=DB97X6qnlCcIvqv50Y5xRn4eIwVgB9VVJ22N3cVCXwTJ9X5DgD78che42IgEAGFBUaVbzcZYKYurieHJIcb9xvNN+AFpNBMS9MoCjYm0gIFiWVupVtCFviZcnLX0xnmiTcYl3vWjLkb7mQFWpGbxfwKAWoM9Ltk8ouGdak4phvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006197; c=relaxed/simple;
	bh=hk1+Emgo8I20EoLRD7chzCHSBQJU4Yv50P00boWd7fQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mYQpknwqoGC4Ai71vWr17sjQSgkEjnSW54uSWd4h8++y5ddb6Dna13sVn3OlcAK7Zkbi3SuDlAPLZANcwbM2XS8LFmmJr4BGxWbj5yJMVc81FrHHexJv17IwVvARQx8P/3r74JaCAXjKBWRVOrHNTlp79YEybohawnaW0BnLXWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=iPlR4uXd; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="iPlR4uXd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ihT6wkDXaRpG0JOpJ3EhN5/fa2s+KKkl3MD5QkftFCc=; b=iPlR4uXd7AGx2AckU8FaFOmV9O
	xYOjwRvoAkzxbEp8ghseP6YF8JZD3r5XlwRyKc9Vq21TP7mlhr1g8+ern0MNlnTYPH2jIG0ol/oya
	jjUIi+9ZTXEKF0OHzvCgMPRUM4C24Zd1cqW3WQE76rCxdbvrgA3G63wIX8tD8/1/qyZbiwxz5oYsc
	QIw1IJLlacHmTv/JwIPf5bRN0SyUWyyzapBtvTq7QM1v+XTm1spkS9S7+GnGIjYR1vBJSUxxKi7sA
	3mKCC/hLxV2xjA4XvnwLs930G3dNiWugiK00nfzlDZhw9HcrYiJSKo7qhO0Di2e67i0VJodTR2CiT
	j6xPsxCA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWv4J-008NrL-0B;
	Tue, 09 Jun 2026 11:56:31 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] efi/runtime-wrappers: bound the wait for EFI runtime
 service calls
Date: Tue, 09 Jun 2026 04:55:26 -0700
Message-Id: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC7/J2oC/x3MWwqAIBAF0K0M91vBgozcSkRkjTUfPVCLINp70
 FnAeZA4Cic4ehD5kiT7BkeFIozLsM2sZYIjlKa0xppGc5A+y8r7mbUNVTFV3o/B11CEI3KQ+9/
 a7n0/s8OkqF0AAAA=
X-Change-ID: 20260609-efi_timeout-6f51d5bbcfb7
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3981; i=leitao@debian.org;
 h=from:subject:message-id; bh=hk1+Emgo8I20EoLRD7chzCHSBQJU4Yv50P00boWd7fQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/9re45F/olishxvTUkEjJKFU7lmOd0S718Up
 KlXQ3TefISJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaif/awAKCRA1o5Of/Hh3
 bVPzD/45TC/bheVap4qlNR52W/PbojOKa4ChKEbSO0Wqr6HdyZo8CyEhnpi7j9WDEVsgCyvah10
 /nxf+y1Smke/oF9rjoSv03kF5fmyVRKEHA2SEZEMBbOh6Rx4bgc0q8r+jeKHXepzK5V7LXJXE3d
 kko24uH9fumEFYv0kc6cLU3IJeHf6Q3Zg8O5jcaAj0Gb9h50d5D7cP5Io5Eqi37FHtSGXAFkDSt
 OIwsXBA89TKM9gWZP05Mf7xUpl4UynKKREQ95p4Ym5O3J5lyDCdGUzn/fSbAzWP4ShsAFVP/+TK
 0k9/TicmbToLWMz9xJhmpV+4FrKbrYgdCzoM4INAnkJNBOeE+vuzHm8vF1GEspDwXiGW8ihZIir
 V+RQGRXSrxt5KaN2NE82Vl1lIuVKGgm4nNroPU1kN/kFnTPtIA5Tj4MuV8zMRa/iiCN8BC675Kj
 xtPswSj4B7vy4pa9zYF/++idsBOFhqpr2eK+gtN03n4Ku+9tHJkXDkCEiIii++983dcvMt9JrKO
 5G1VMFgeBmUPxoK+TLl/SEAI8CC+EEMoVvEFV5Nhh1AAGlkqln6GQsDvVgxSW1s0Nlek7RV9wRK
 xNZHEdEdYxEa0cp5NsFX51Bz5g8UabClglo0vWRNfTjiq2ogqaXKZfJBujE1DKSoq1++cFZXoGB
 Aqx6DzOz+z6eeWQ==
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

Patch 1 bounds the wait at 120 seconds via wait_for_completion_timeout().
On timeout it logs the wedged runtime service id and returns
EFI_TIMEOUT to the caller instead of letting the task hang forever.

Patch 2 introduces the efi_rts_dead flag set on timeout and checked
at the entry of __efi_queue_work() so all subsequent callers fail
fast with EFI_DEVICE_ERROR rather than each paying another 120
seconds. The flag is also required for correctness - without it the
next caller after a timeout walks into INIT_WORK() and
init_completion() on the work_struct and completion the leaked
worker still owns. Patch 1 and patch 2 should land together;
reviewers may prefer to squash them.

The wedged worker is intentionally leaked - it is still inside
firmware and cannot be cancelled - and the shared efi_rts_work is
abandoned to it. EFI runtime services are unavailable until reboot,
but the rest of userspace keeps running.

Known limitation: the union efi_rts_args that the worker receives
contains pointers into the caller's stack frame (the compound literal
in efi_queue_work() and the in/out buffers it points to, e.g. *tm in
GetTime). Once the caller returns -EIO and unwinds, those slots are
reusable. If firmware eventually unblocks and writes the output
buffers after the timeout has fired, the writes land in whatever now
occupies that memory. In practice firmware that hangs for more than
120 seconds tends to stay hung, but the trade-off is real. A
follow-up bouncing args and output buffers through kmalloc would
close this gap.

Tested under virtme-ng + OVMF with a debug hook that hangs one
runtime service on demand: pr_err fires at +120s, the syscall that
triggered it (mount -t efivarfs) returns with EFI_TIMEOUT
(status=0x8000000000000012) propagated through efivars instead of
blocking indefinitely.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (2):
      efi/runtime-wrappers: bound the wait for EFI runtime service calls
      efi/runtime-wrappers: disable EFI runtime services after a hang

 drivers/firmware/efi/runtime-wrappers.c | 35 ++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)
---
base-commit: a87737435cfa134f9cdcc696ba3080759d04cf72
change-id: 20260609-efi_timeout-6f51d5bbcfb7

Best regards,
-- 
Breno Leitao <leitao@debian.org>

