Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65753CF21B;
	Tue,  9 Jun 2026 11:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006198; cv=none; b=dhWvTlrQJoCJfqjCSiv59z2ene3Sm4QLe4ewVh7mgwj/kqf1Kg+BPyCJbJmmSiYS0M0CNeN+nGVRYNlTGVi7pSt7CWmdCQkIkK3jKNQLwoD2+qIbe9a/V1WOZk9xo/kPeOrfsnCDymuUmXttvi3YcK2cEYPdp9hkzDyPbHNztFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006198; c=relaxed/simple;
	bh=0m1zE+zSeMgFTmm+XHNVgWxNwWYyefcHl5cVKY+HtNs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Xem/j4dnTUHbwtSDpFW5mC62RmHGFq+yfGX9q86It+TgDlPCUYMYZmw4DgEHrE7XWCkd2vVEnwL8ub3C8Vdwts2UXIAi7qaV7kra6jblK/CKmWWUxVDI3KsKH5DYigU8Z0f2nXW+w8rxQUInWwHOP4BEHk+rJr4AXamBnM9v6VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=cH7lnNwo; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="cH7lnNwo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=lwyB0zDjHPnIlzDjnPFESAD/gSrYtVTUVtClAxtBuJs=; b=cH7lnNwo568QGx2yLTBhlbsgev
	5/DOYgu/fkjxI7ue6+tp5HQSVe2/IBmw8v//qPtSGTg/Vl5Ff6AlvS1VYBTgax0snMFO3a1JbVfT/
	AVrKGBekJyhudPORvjs73cLzAmKTLHXW3ZG4pSPDJxafyaq9esSA63XEElMxavP2Df8LrwzIBhL2D
	YzUGnFouZ1qurTRLvYLizleACt+nMtyGAn6pDJYniNtfj4B32cvWvaHwgpgdq+rTTmM6xxFCJy0+J
	SyXVOoqHaU/2bZXh+8y4iAoo5zLKYy1VcC8ZiL3CCD1zE1cNftnQo+a5UW20is874iLQG/WhEWmXJ
	LdCTAoCQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWv4M-008NrO-1P;
	Tue, 09 Jun 2026 11:56:34 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 09 Jun 2026 04:55:27 -0700
Subject: [PATCH 1/2] efi/runtime-wrappers: bound the wait for EFI runtime
 service calls
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-efi_timeout-v1-1-69a896faa805@debian.org>
References: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
In-Reply-To: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3897; i=leitao@debian.org;
 h=from:subject:message-id; bh=0m1zE+zSeMgFTmm+XHNVgWxNwWYyefcHl5cVKY+HtNs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/9r3aMlPOvsnG5eBqfx2DvaQ/mevxcNBf2xw
 fPTIfz1zWeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaif/awAKCRA1o5Of/Hh3
 bWoXD/9s09ZRGkM6XpKNlKA60Fcq52Nv0L+LabhVQTYrvKV0N1i3Fx93Ncua6RrEhIFNWHMb0ph
 MPbRDybVQNEzbKZACn1UPCa46u2Ay88yOFkCjLmywzBxVL/izB/DV7EUAzHcKiPDcoftjm0PEAM
 T8Sy+AMSzhetvWpn7ETAP5yy+YNEhDGcNFIqd5A7LgHd1U+b6oA3P0BI/vVtzFhAAoZEmM5GHQ+
 7MKHNFg00vQzJJ7gFu4FQmLUMXvEM1a2xR8DIFUZGevdV+US4ewE3uR0D0Rq5Akqx3Hfd72E431
 gr81Xv5DKNmodG3MzWXCvQ5U8luTSnwa0vmYdPNuX7rfA4uxmcr96NVvBev6Io4ax8TBqdFUT+/
 nr33/MXwxFeP9kdMWku3gtdBthC7Qx/nIhnN4AH0bPFK38m1pH56cCldCiDmOz3y8mmiHqSrDGU
 7nuSgx6hhhv3YSPoUpKmRBHJ4JXXIRJO8N0ypVIQggKQ4slBsBKbsTonZJpSgk+67GqMAqkgFxr
 dzJpQZz8IZRjd5F6YGFas1BQaZ/zwLW5aasmPiIJvoP/asOR1tq/osxsPd3bUzvgVmJ9FYYLCLg
 zP3uNd0IXyyZ5OsUCqBI45MG8ku60joGm54WmyhSSxvkSEkifcid8UZ85gjCDk/BLZmh2HpuSDF
 NzHrz0+ouKlufEw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When an EFI runtime service call hangs in firmware, the kworker on
efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
The kernel currently waits indefinitely on the completion, and the
caller holds efi_runtime_lock for the duration, so every subsequent
EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
handlers, ...) is wedged until reboot. The only externally visible
symptom is a "workqueue lockup" message and userspace processes piling
up uninterruptibly on the semaphore.

Replace the indefinite wait_for_completion() in __efi_queue_work()
with wait_for_completion_timeout() bounded by EFI_RTS_TIMEOUT
(120 seconds). On timeout, log the wedged runtime service id and
return EFI_TIMEOUT to the caller.

The wedged worker is intentionally leaked - it is still inside
firmware and cannot be cancelled - and the shared efi_rts_work is
abandoned to it. EFI runtime services become unavailable until reboot;
the alternative is permanent userspace hang.

This patch should land together with the follow-up that introduces
the efi_rts_dead fast-fail flag: between the two, a subsequent
__efi_queue_work() caller will re-INIT_WORK() and re-init_completion()
on the work_struct and completion that the leaked worker still owns,
which can corrupt workqueue state and let the next caller observe
the leaked call's status as if it were its own. The split exists for
review clarity; reviewers may prefer to squash.

Known limitation: the union efi_rts_args that __efi_queue_work() hands
to the worker contains pointers into the caller's stack frame (the
compound literal in efi_queue_work() and the in/out buffers it points
to, e.g. *tm in GetTime). Once the caller returns -EIO and unwinds,
those slots are reusable. If firmware eventually unblocks and writes
to the output buffers after the timeout has fired, the writes land in
whatever now occupies that memory. In practice firmware that hangs for
more than 120 seconds tends to stay hung. A follow-up bouncing args
and output buffers through kmalloc would close this gap.

At fleet scale this turns a generic "workqueue lockup" or stalled-task
mystery into an unambiguous "EFI firmware is at fault" signal in
dmesg.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index da8d29621644..6ce6d094066e 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -118,6 +118,14 @@ union efi_rts_args {
 
 struct efi_runtime_work efi_rts_work;
 
+/*
+ * Upper bound on how long we wait for a single EFI runtime service
+ * call to finish before declaring firmware wedged. Chosen to be longer
+ * than any plausible legitimate call (including UpdateCapsule on slow
+ * SPI-NOR) while still bounding userspace wait time.
+ */
+#define EFI_RTS_TIMEOUT		(120 * HZ)
+
 /*
  * efi_queue_work:	Queue EFI runtime service call and wait for completion
  * @_rts:		EFI runtime service function identifier
@@ -338,10 +346,16 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 	 * queue_work() returns 0 if work was already on queue,
 	 * _ideally_ this should never happen.
 	 */
-	if (queue_work(efi_rts_wq, &efi_rts_work.work))
-		wait_for_completion(&efi_rts_work.efi_rts_comp);
-	else
+	if (!queue_work(efi_rts_wq, &efi_rts_work.work)) {
 		pr_err("Failed to queue work to efi_rts_wq.\n");
+		goto exit;
+	}
+
+	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
+					 EFI_RTS_TIMEOUT)) {
+		pr_err("EFI runtime service %d wedged in firmware\n", id);
+		return EFI_TIMEOUT;
+	}
 
 	WARN_ON_ONCE(efi_rts_work.status == EFI_ABORTED);
 exit:

-- 
2.53.0-Meta

