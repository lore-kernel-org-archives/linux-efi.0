Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACF347884B;
	Tue, 18 Aug 2026 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062319; cv=none; b=hxMoGxlzwSyUp9LNkxLOgxZRFtUPGLTLOI2mHcm8lhUyZhbFcMG9MnRpuiKlX4EPEFCoxdWQdRVuscfzk1Xz929wLH9x7WiyzLC8g5V7wicpH2078463ExnjuY0DMG390e/shO0dDN4ySCKkirLam/IJ4c264QpWHSzdLZLJGwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062319; c=relaxed/simple;
	bh=fIoIqPbUubodBIIxSD+L6GhMDg5Wc4I1XqdQbaERO5U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JfqWERrHAPMuJhX4bff4+CEGTNB+/kmI1YWkD+Kjwr8EhCLHs5uLYdyi1Glg1rEcQxIYlsmXUr4oiOrm2KlBJMXXR29ctbO9CKqcJOSmBNb6Bc+6dYdgcPqYH8qBigf+A/zBXiSaSOr60CdICoEZy2VlRczX4kED1MwIbH+TmI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLQdp0mA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLQdp0mA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C621F00A3A;
	Tue, 18 Aug 2026 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787062317;
	bh=y+3JbKoCLfb4aCv0jX3F9Hhn4V179wBGNgJrcmUx5QI=;
	h=From:To:Cc:Subject:Date;
	b=nLQdp0mA5zuEIbbOIdRaTKIua/sgtNPIedaKGFdO7ZH2BGlUg6IhTBjhvmlS0NNjz
	 Gdvu5gZ+WILpJP0TmLN5N7//fwbFxxPrYD8t6dNvmCyNe9w5DFYyHnfq++IhKnmM2Z
	 0XXxFgbWC/QImJvXXf/02tys51AzRa/kqZEn1rAcZ6f8NDBtab5OsKca26bnWUyutP
	 9MQ9oPs3vWNaASajYDbqsul8VKKBJVb9X9AYLbYnI9m6fSxtbrOpnZqqrlOI36AiTI
	 Ur2pOkFrc2ltMQ0YNwXHDd45vx88hQuSMcoevte3M7tFTwfdBv1RiaURjFQGeyimMa
	 S/4k7t7ubkCkQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org,
	Anisse Astier <anisse@astier.eu>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH] efivarfs: Rate limit statfs() handler
Date: Tue, 18 Aug 2026 16:11:50 +0200
Message-ID: <20260818141150.905336-1-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ravi reports that statfs() may be called by unprivileged users on the
efivarfs mount point, which may result in a flood of calls to the
QueryVariableInfo() runtime service. These calls are disproportionately
costly on x86 systems where the variable store is backed by SMM, as each
SMM entry requires a rendez-vous of all the CPUs.

So rate limit the calls to QueryVariableInfo() at twice per second, and
return the most recently obtained values for calls that are elided.

Cc: <stable@vger.kernel.org>
Cc: Anisse Astier <anisse@astier.eu>
Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
This supersedes [0], which had some issues, the main one being that a
cache that requires explicit invalidation may go out of sync due to
direct calls to SetVariable() made by other drivers.

[0] https://lore.kernel.org/all/20260801144258.15977-2-ardb@kernel.org/

 fs/efivarfs/super.c | 30 ++++++++++++++++----
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 733c19571f1c..8d33f11db2a1 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -89,12 +89,30 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	/* Some UEFI firmware does not implement QueryVariableInfo() */
 	storage_space = remaining_space = 0;
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
-		status = efivar_query_variable_info(attr, &storage_space,
-						    &remaining_space,
-						    &max_variable_size);
-		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
-			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",
-					    status);
+		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
+		static u64 storage, remaining;
+		static DEFINE_SPINLOCK(lock);
+
+		if (!__ratelimit(&_rs)) {
+			ratelimit_set_flags(&_rs, RATELIMIT_MSG_ON_RELEASE);
+
+			spin_lock(&lock);
+			storage_space = storage;
+			remaining_space = remaining;
+			spin_unlock(&lock);
+		} else {
+			status = efivar_query_variable_info(attr, &storage_space,
+							    &remaining_space,
+							    &max_variable_size);
+			if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
+				pr_warn("query_variable_info() failed: 0x%lx\n",
+					status);
+
+			spin_lock(&lock);
+			storage = storage_space;
+			remaining = remaining_space;
+			spin_unlock(&lock);
+		}
 	}
 
 	/*
-- 
2.55.0.699.gb54405d56f-goog

