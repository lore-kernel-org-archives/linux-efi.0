Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795426957;
	b=mibkuhRQq+9VtMHRcEDJLIon8HV9k7zQZ5wzQZBsvT2kTd8D6m0uCzXVz/gkgCDTj0Qk
	 611ANDU06KwPD5yg8vrKkEQEVg07RNQESpt5TvnOLgUJT/5R8R/edqH69VWuWSsTr7p7W
	 WvVE5FwCOPLAX4FJTJUOaCoYBfhq+VXq2c7r2i7FqsGabUvvxrY5XQLAv5hABuK+lnGbq
	 ZppZCXMlH7A91mlH1FgNPLKLjgQPh5GgKZR1KwfCBV0NKz8NsCgmcAmmMN0qt8kJKNei/
	 Q2U3AylTvzg1p3fQojwx+V96ocXO107E3N7Znv/yStbqQq8N64LT8YV5xA80AmY7pDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795426957;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+B94KE3B0EDX5b5+lu0mb5FYbNNw9/Bxww+ihebgicU=;
	b=HW9140zblgw9m7sW950qFVr5gDAZsibAVhiI89SAKlZ4HrvOVmZnPDdkcCNp9Y4bAY6K
	 Wda4r7ZcB2toyBVQxJ8uSzefNNzLWu4f6UtIkxCN8j5Gz8uQ5Z8HN2NdTlpp6GseXwpo3
	 1lBQgrqSCWr8gbPNAjiDr+BkJdHul2/vXg7BoLrIdRkaQqruKndGv0lahvuDacL9i5spw
	 cMBgh23BbyU0v80N1oehUIRA97L7qdTYXSacsgDzwZ4peAj/Mlamk8jgry2taD2ArJagl
	 +cMUeYlOHxvtGjfA8Dpb75lbaadSSOJBC51roGpADAhX2NBfGOn+Xuc9+NpLfBZhLHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JFbpVesd;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342E9606A32C
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 09:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 342E9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JFbpVesd
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4bb66fc3aa6so29083175e9.2
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 01:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795426955; x=1796031755; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+B94KE3B0EDX5b5+lu0mb5FYbNNw9/Bxww+ihebgicU=;
        b=JFbpVesdZNkg+YhQRPP68F7B+BtwC7Bxh6jZaMoG5Op4cWZpvRpoEfSEjXz5KdoAWm
         blCt0pkBPHQSXwE5PFaDZmKvHAkvW+e/7rqMJGncHBmOpsbGg09Ig9OhH5GXB05ARbTH
         vjZYti4SysGMG9Hb13hufDDizlrhJUHstH58MrPq3wozuODj5U5oKq61j1M+DAaOKWvz
         C8MILMadz6gGY/ZEbm2ra4Eu2PURRsNQXxXtMdc6+jw1umLM/+6aYEV3SbvLeWRN255p
         eTLAN2SmTsRzf/1HuFFCyHyy9zw7dLzXFbxU3YpiuB8YuHiL7ItvHkM/7TATUHn4p1jH
         LHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795426955; x=1796031755;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+B94KE3B0EDX5b5+lu0mb5FYbNNw9/Bxww+ihebgicU=;
        b=CyyqlJrJtwo75roNO4PV7tR+G6oAfWIp3MPmg5U2qqsFaRZFP2YPk4WB3Nw0NVrb+W
         lRHiuYvNqbWNQup0kkVO4sb4aBxNJ+aftY0WABKvCA4yQx2WqKtN79wldPaEfiIs7x9S
         YSUEhmbuRjauZ6+SWThjWA7c8fYLKVH+8v6umrDsXblgYYMaVtO86/Jpe3qLtqQpdWGG
         RXO9/ZEO//8wDsRXgPUjamqF7lufkg7bpN3JqyGUPT/HFQEdfMmk7hSet0qcFzGiP7l+
         V6ulNZgrMUEcbrEV7xbLRq6Vo5mEvh5pslnzOhigHWDp1RL+qr4prFLbTCQDLWpaYA3t
         eHhA==
X-Gm-Message-State: APuU4Z9FnPy8mBMfhj4/H7u7POrN3EWiojDPcRHPZTGRsUG+p+zXdFrK
	jb/jq84kqsc6BOBF/b/N7pUSBwEPK5a1eMavOFWjqj5SXdjGsMMaDjN5SxOJAZUQEzYbU9EoNaQ
	KKzqqMC+dtEo6vdr9Sh20PunS0yauYitQFrmuTHb1Cgg+Z+uJlxn70Xl4BhB+TA289djFlF9tt9
	oUioZLY1rZTgnllU2s2ZI8/SP2NXe8sA==
X-Received: from wmoi24.prod.google.com ([2002:a05:600c:4818:b0:4a2:df9b:ef74])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:820c:b0:49c:d019:70c5
 with SMTP id 5b1f17b1804b1-4bb887876c0mr246932535e9.0.1795426955206; Mon, 23
 Nov 2026 01:42:35 -0800 (PST)
Date: Mon, 23 Nov 2026 10:42:29 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1487; i=ardb@kernel.org;
 h=from:subject; bh=gXKdTzWeETpigdssZLpoGqElEvZ+43UV/PiFfA3J/F4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZuFqzXwwu4XvaJ3ri7cVpYz7/bOL4YPd15x85BPiO8OV
 Gwt3xbUUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYiVsHwv/REs6ZXadsSg9Px
 n69EdvWdOxSttddN3eUEywWP9cbu2YwMm/76alX4Hd1590Mi7/tzFyWbN3lYqrzd/OXHdZnkvhe hjAA=
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261123094228.466164-4-ardb+git@google.com>
Subject: [PATCH 0/2] x86/efi: Disregard stale EFI config tables after kexec
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

On x86, kexec passes the firmware's EFI configuration table array on to
the next kernel as-is, including tables that reside in memory that has
been released or repurposed since, and may therefore have been clobbered
by the time the next kernel gets to parse them.

Patch #1 wires up efi_config_table_is_usable() for x86, and uses it to
disregard the INITRD and Memory Attributes tables when booting via kexec.
This fixes a panic when kexec'ing without an initrd, and supersedes the
existing handling of the Memory Attributes table, which does not cover
all cases.

Patch #2 does the same for the TPM event log table, so that the EFI stub
can allocate it as EFI loader data again without regressing kexec. This
fixes hibernation on systems where the ACPI reclaim allocation that is
currently used for the event log ends up at a different address on each
boot, resulting in an inconsistent E820 map.

Cc: Jasmeet (Jazz) Bhatia <jasmeet.bhatia.us@gmail.com>

Ard Biesheuvel (2):
  x86/efi: Disregard the INITRD and MEMATTR config tables after kexec
  efi/tpm: Allocate the event log from EFI loader data again

 arch/x86/platform/efi/efi.c        | 32 ++++++++++++++++++++++++++++++
 arch/x86/platform/efi/quirks.c     |  4 ----
 drivers/firmware/efi/libstub/tpm.c |  2 +-
 include/linux/efi.h                |  3 +++
 4 files changed, 36 insertions(+), 5 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.1.750.gf70dc682cf-goog

