Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E939D4A4989;
	Tue,  8 Sep 2026 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788888376; cv=none; b=Y5Qb+lLC9U2KwSRS07zZbs4zfmyk4dmi6HUZEqQZPOFLMIZ1MvdXQrXK/csYqT8kWbT5CJwLeu2+53XfNUYqfXJMlJqD7tu8Fa3Y0tbF8DCH5gORrKTYdM0z4XBnh4gyrEuPx+5pgeMyibPMCN+dz3zpCaEmPFA0PQeTLxm3U84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788888376; c=relaxed/simple;
	bh=OS6GckkaKtUv/HWuqL0G/2QoFTSf6JP2z/baJIhCLf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3KUWWayjLKYxYQ/0vAJa0VMqlO36hvNsO7nK4dLlGp5Loir+BbBfqVtMWGyyrf/2M2gfOh6ZG1K0C+2YtonMCUeh7LKwULbhKhlV5sK1d0XbuABChCzvcjmKMBfgvzXRmD8AgKsyRnHacRsVMQwMO+VNBBZ+1Dv945logHJ7qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bb/wUR2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bb/wUR2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DE81F00A3A;
	Tue,  8 Sep 2026 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788888374;
	bh=jM3P1SONxa42AJzxhJ25bnkVtmobAHaArz1/6Ajlj0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb/wUR2w8sqwWsO38QEbnn1fVtayV+qDnb5wC7JB5qlgFJ6pu8srUgZGwCDisg3LC
	 /KMqH+jSg4BKfEqV4CiMc99xasVRnbfYVhFKKO/QECoQZfd7IOndcB7xCCNnJipUAs
	 qmzdw/rsCx7MwZEkRccucn3xpYBMmobfY6eX6mPQTAS4QM/uXFvtaGEeOE2MvNsO4A
	 oXCCGPD4Nh8jCAvTxP9IVwsOA1OL+stqVlV4QtFhWyYMpyyOzS9qs8syNZDcdLPpuy
	 B5iqPw/OYSdc1UwDXbNqK3Lapp86DKRmA+ZJTTPDeA9Askkg2JlQskUHKMnmL9KrTQ
	 POJnOsuEZsm0A==
From: Vincent Mailhol <mailhol@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Vincent Mailhol <mailhol@kernel.org>
Subject: [PATCH] efi: pass NUL-inclusive sizes to ucs2_as_utf8()
Date: Tue,  8 Sep 2026 19:24:34 +0200
Message-ID: <20260908172555.3356-1-mailhol@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An upcoming change will update ucs2_as_utf8() to expose a strscpy()
style API where the size argument is the destination buffer size,
including space for the final NUL terminator.

Some EFI callers currently pass the exact number of UTF-8 payload bytes
that they expect to copy and add the terminator themselves afterwards.
Extend those sizes to include the final NUL terminator so the upcoming
contract change does not truncate the converted output by one byte.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
Hi Ard,

I saw that you pushed on efi-libstub-native-utf16 WIP branch [1] and did
some testing, despite those changes not yet submitted for review.

There is an off-by-one error following your ucs2_as_utf8() code
refactor. This patch prevents the issue. It should be cherry-picked just
before your "efi/libstub: Use ucs2_string library for UTF-16 to UTF-8
conversion" commit.

There is one final off-by-one in "efi/libstub: Use ucs2_string library
for UTF-16 to UTF-8 conversion" itself. This is the fix:

	---8<---
	diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
	index e9b714ca811db..db0bde514f7fd 100644
	--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
	+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
	@@ -379,8 +379,7 @@ char *efi_convert_cmdline(efi_loaded_image_t *image)
	 	if (status != EFI_SUCCESS)
	 		return NULL;

	-	ucs2_as_utf8(cmdline_addr, options, options_bytes - 1);
	-	cmdline_addr[options_bytes - 1] = '\0';
	+	ucs2_as_utf8(cmdline_addr, options, options_bytes);

	 	return cmdline_addr;
	 }
	---8<---

[1] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=efi-libstub-native-utf16
---
 drivers/firmware/efi/efi.c | 2 +-
 fs/efivarfs/vars.c         | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 6d987d7f97781..221804e7d5390 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -304,7 +304,7 @@ static __init int efivar_ssdt_load(void)
 		}
 
 		limit = min(EFIVAR_SSDT_NAME_MAX, name_size);
-		ucs2_as_utf8(utf8_name, name, limit - 1);
+		ucs2_as_utf8(utf8_name, name, limit);
 		if (strncmp(utf8_name, efivar_ssdt, limit) != 0)
 			continue;
 
diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
index 6833c3d24b541..1ddc89e13518f 100644
--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -237,7 +237,7 @@ efivar_get_utf8name(const efi_char16_t *name16, efi_guid_t *vendor)
 	if (!name)
 		return NULL;
 
-	ucs2_as_utf8(name, name16, len);
+	ucs2_as_utf8(name, name16, len + 1);
 
 	name[len] = '-';
 
@@ -264,8 +264,7 @@ efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
 	if (!utf8_name)
 		return false;
 
-	ucs2_as_utf8(utf8_name, var_name, utf8_size);
-	utf8_name[utf8_size] = '\0';
+	ucs2_as_utf8(utf8_name, var_name, utf8_size + 1);
 
 	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
 		const char *name = variable_validate[i].name;
-- 
2.43.0

