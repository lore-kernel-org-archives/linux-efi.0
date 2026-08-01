Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ADC86334;
	Sat,  1 Aug 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785595397; cv=none; b=XITaF61nSN6JvlOc5QgURw+I365JeKl2y7mLujSEbZDf9MsT1JY6wJT9KpaI/W/zEt3Fb4b6Rni1Id4jGJQtHdTdFxWr/FFpI0orhH0FAfoj8is8gvBi8vSddy5wGEdxq+uSxYMFF3L8CFRmr2//sIbIRqx3yxPjnxxthdmMRVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785595397; c=relaxed/simple;
	bh=W2dntG/0Mza5NRLs2IUYdgsQm487Xbbfw4m6cnvZQU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B8gIGK/dAtCRBzHEhm/Ks+esAU4Uem5JdQUKTIO0rfvdEqoaJRhynvlmdeoSsZBdR4YnT3bFTtWXproQjMw0tLmkQq7kFP2iU9vew5HWOxd+8q/RHcviBArYW+05jOgzfr2r4SQTax2/i7LQscU4y/3aO58MNDbmYlKN7X6DXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWwj/8Td; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWwj/8Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722741F00AC4;
	Sat,  1 Aug 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785595395;
	bh=Rrg1wMRr524Wsc7KUE/wtIu9lPkC6t78r94Ihq9U164=;
	h=From:To:Cc:Subject:Date;
	b=IWwj/8Td5aSupHeeDBwHnmBfR8wGhbgNTze7I2mf/B679OELyIh7SUzae24ZdrsiE
	 nnbhvQ6cPeQwd1YJwDE/vCwwNAkrDxbuqJ89gAixzq8XfJTJk4h0urLGbC9RXa99DY
	 nRBb/JzwOeM1exi3CvS8tHCLWxPCvZnRdCkRlyfvgexn4P8zcwBd3n4gJusTWbcan3
	 6n21USKrJYMeffkmEFiM3C1T4kwLjYQWh7xX9kjuUibqwBdxks87wh3IpPDmd/XJ6C
	 dizBca+C4sX1H6nd0vF2CtAOAAKKyYCfUuUrVna+w4UpTemQr0VofsUAleol4luFIa
	 MNkhqfpLXCJWQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: x86@kernel.org,
	Anisse Astier <an.astier@criteo.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH] efivarfs: Cache occupied and available space
Date: Sat,  1 Aug 2026 16:42:59 +0200
Message-ID: <20260801144258.15977-2-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5007; i=ardb@kernel.org; h=from:subject; bh=W2dntG/0Mza5NRLs2IUYdgsQm487Xbbfw4m6cnvZQU8=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JISuP9TOf6wsm/aI5fbOWMB+M+7pnc653omPcFOmglFeXp 897eFy0o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkoRjD/yLTe/8cbJl3PW3y 1/54zJKBqdfmY8rlNZMKl8yO5EtmKmH4p31bwEjG7nuLxMdzNs7V/dP2OZ39KcZVs0ZydeHe5yU KjAA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Ravi reports that statfs() may be called by unprivileged users on the
efivarfs mount point, resulting in repeated calls to QueryVariableInfo()
which are disproportionately costly on x86 systems where the variable
store is backed by SMM, as each SMM entry requires a rendez-vous of all
the CPUs.

So cache the output of QueryVariableInfo(), and invalidate the cached
values when an entry is added or deleted, or the variable store is
synchronized after a suspend/resume sequence.

Cc: <stable@vger.kernel.org>
Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 fs/efivarfs/internal.h |  2 ++
 fs/efivarfs/super.c    | 21 +++++++++++---------
 fs/efivarfs/vars.c     |  9 +++++++++
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
index f913b6824289..d43789bc7839 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -31,6 +31,8 @@ struct efivar_entry {
 	bool removed;
 };
 
+extern u64 efivar_storage_space, efivar_remaining_space;
+
 static inline struct efivar_entry *efivar_entry(struct inode *inode)
 {
 	return container_of(inode, struct efivar_entry, vfs_inode);
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 733c19571f1c..3691a2a087a0 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -23,6 +23,8 @@
 #include "internal.h"
 #include "../internal.h"
 
+u64 efivar_storage_space, efivar_remaining_space;
+
 static int efivarfs_ops_notifier(struct notifier_block *nb, unsigned long event,
 				 void *data)
 {
@@ -82,15 +84,16 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
 			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			 EFI_VARIABLE_RUNTIME_ACCESS;
-	u64 storage_space, remaining_space, max_variable_size;
 	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
+	u64 max_variable_size;
 	efi_status_t status;
 
 	/* Some UEFI firmware does not implement QueryVariableInfo() */
-	storage_space = remaining_space = 0;
-	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
-		status = efivar_query_variable_info(attr, &storage_space,
-						    &remaining_space,
+	if (efivar_storage_space == 0 &&
+	    efivar_remaining_space == 0 &&
+	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
+		status = efivar_query_variable_info(attr, &efivar_storage_space,
+						    &efivar_remaining_space,
 						    &max_variable_size);
 		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
 			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",
@@ -104,8 +107,8 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 */
 	buf->f_bsize	= 1;
 	buf->f_namelen	= NAME_MAX;
-	buf->f_blocks	= storage_space;
-	buf->f_bfree	= remaining_space;
+	buf->f_blocks	= efivar_storage_space;
+	buf->f_bfree	= efivar_remaining_space;
 	buf->f_type	= dentry->d_sb->s_magic;
 	buf->f_fsid	= u64_to_fsid(id);
 
@@ -114,8 +117,8 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 * when the storage_paranoia x86 quirk is active. To use more, users
 	 * should boot the kernel with efi_no_storage_paranoia.
 	 */
-	if (remaining_space > efivar_reserved_space())
-		buf->f_bavail = remaining_space - efivar_reserved_space();
+	if (efivar_remaining_space > efivar_reserved_space())
+		buf->f_bavail = efivar_remaining_space - efivar_reserved_space();
 	else
 		buf->f_bavail = 0;
 
diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
index 6833c3d24b54..4196963695bd 100644
--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -361,6 +361,11 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
 	kfree(str8);
 }
 
+static void efivar_invalidate_cached_storage_space(void)
+{
+	efivar_storage_space = efivar_remaining_space = 0;
+}
+
 /**
  * efivar_init - build the initial list of EFI variables
  * @func: callback function to invoke for every variable
@@ -450,6 +455,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 	} while (status != EFI_NOT_FOUND);
 
 	efivar_unlock();
+	efivar_invalidate_cached_storage_space();
 free:
 	kfree(variable_name);
 
@@ -480,6 +486,8 @@ int efivar_entry_delete(struct efivar_entry *entry)
 					    &entry->var.VendorGuid,
 					    0, 0, NULL, false);
 	efivar_unlock();
+	efivar_invalidate_cached_storage_space();
+
 	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND))
 		return efi_status_to_err(status);
 
@@ -620,6 +628,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 				    NULL, size, NULL);
 
 	efivar_unlock();
+	efivar_invalidate_cached_storage_space();
 
 	if (status && status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
-- 
2.55.0.508.g3f0d502094-goog

