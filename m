Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411F34EE849;
	Thu,  3 Sep 2026 21:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470739; cv=none; b=k6PSWL+Z/mL1QC1BWOJdXoiKReXEIDvSOcInKhAQKAnqrOFHwRTIWif3BrWgtm4VdGyGe056l3ocv80etA96qwfqgPcFZIZII3FYhYzMqOJD7lyvtcMAjhb5BO9JLqTKThPtgVXugpXo+I8n53SmKc0MWaeWPzlzEfQDizB9yNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470739; c=relaxed/simple;
	bh=VKodwoGsqZqFfJZ9ZPLgVu/Y5p034Al6RJg5ytdgpwg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BeFRj/wF6bzkVV4mvyP8OLupj5X7fpwLOrUhl7dL7Ajn31NHQUNfF6GUryBYhZHVBIiHgKVTvNCx2I71RKpRQFUL4jb4JNQCI6O0QORO0PVcObov7Ph3hf+o4RzDAyEIXygEQNzuXtToretiz6PSQdkn22DCkwwnF3xjNrXryY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4bnJqzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4bnJqzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1551F00A3E;
	Thu,  3 Sep 2026 21:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788470736;
	bh=JfAREg5nSpMGCnYkfgXywqxm+il2UeJxz2xj/ulmNA0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G4bnJqzGJVVsoTgpfQfHQvBHT39z7YN58I9Ludvkl8B1l0qa3wYGsKLAfHpqWjWSB
	 yfTgjTHtNk1j306lvj0qdrYm2+I1Hxpd4RdW2xLuHdqLbmvGpUqODpJg6BmTF2WIDI
	 PGr+HvjxhAYJ2boRlbehrOAG5qKebTWqV5N00K6/C7U7phWk8dndVfJ1/M2g1ulYM9
	 N0BxhGN/3AAAXOh0ane9jCst9YZhnwr7gum2+7K1OKSV/a7GlnWNH7XSPmOMGzsLxb
	 4djzuAo1CZS2Xr8ny3zr7ye1Ed93t4nXYUAA/kwkhYxXvJa5XIXbYdM2aO3y3hlumM
	 VoJyV233ASTCg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Thu, 03 Sep 2026 23:25:17 +0200
Subject: [PATCH 3/3] efi/libstub: factor shared static GUID variables
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-libstub_guid_cleanup-v1-3-06fcb6216975@kernel.org>
References: <20260903-libstub_guid_cleanup-v1-0-06fcb6216975@kernel.org>
In-Reply-To: <20260903-libstub_guid_cleanup-v1-0-06fcb6216975@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4558; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=VKodwoGsqZqFfJZ9ZPLgVu/Y5p034Al6RJg5ytdgpwg=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkzn57wSnlfs+H+Lb1JC99Ie1+KfPfhxtGfaxr2d/avu
 7r/0q5+hY6JLAxiXAyWYoosy8o5uRU6Cr3DDv21hJnDygQyRFqkgQEIWBj4chPzSo10jPRMtQ31
 DIEMHSMGLk4BuK3nGf4X7nXNyu/V/O3Sz67M+VPvtcoOxfcn6/Oddj7YzKFZ097O8L9obkdz33k
 9m+Vfdr04rFlU8Uv+Er+mzpp8H2PNgo6QKgYA
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

Some GUIDs are used several times in the same translation unit.

Factor the duplicated EFI_FILE_SYSTEM_GUID, EFI_RNG_PROTOCOL_GUID and
EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID objects at file scope within their
translation units. Leave the single-use GUID objects at function scope.

For an x86_64 build with gcc 15.3.0, bloat-o-meter reports:

  add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-48 (-48)
  Function                                     old     new   delta
  rng_proto                                     32      16     -16
  graphics_output_guid                          32      16     -16
  fs_proto                                      32      16     -16
  Total: Before=28471, After=28423, chg -0.17%

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 drivers/firmware/efi/libstub/file.c   | 4 ++--
 drivers/firmware/efi/libstub/gop.c    | 4 ++--
 drivers/firmware/efi/libstub/random.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/libstub/file.c b/drivers/firmware/efi/libstub/file.c
index 0dff9e08d49e..b2601e284695 100644
--- a/drivers/firmware/efi/libstub/file.c
+++ b/drivers/firmware/efi/libstub/file.c
@@ -29,6 +29,8 @@
  */
 #define EFI_READ_CHUNK_SIZE	SZ_1M
 
+static efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+
 struct finfo {
 	efi_file_info_t info;
 	efi_char16_t	filename[MAX_FILENAME_SIZE];
@@ -74,7 +76,6 @@ static efi_status_t efi_open_file(efi_file_protocol_t *volume,
 static efi_status_t efi_open_volume(efi_loaded_image_t *image,
 				    efi_file_protocol_t **fh)
 {
-	static efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
 	efi_simple_file_system_protocol_t *io;
 	efi_status_t status;
 
@@ -129,7 +130,6 @@ static efi_status_t efi_open_device_path(efi_file_protocol_t **volume,
 					 struct finfo *fi)
 {
 	static efi_guid_t text_to_dp_guid = EFI_DEVICE_PATH_FROM_TEXT_PROTOCOL_GUID;
-	static efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
 	static efi_device_path_from_text_protocol_t *text_to_dp = NULL;
 	efi_device_path_protocol_t *initrd_dp;
 	efi_simple_file_system_protocol_t *io;
diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index acc2827ba4d7..fa324d4abcaa 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -24,6 +24,8 @@ enum efi_cmdline_option {
 	EFI_CMDLINE_LIST
 };
 
+static efi_guid_t graphics_output_guid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
+
 static struct {
 	enum efi_cmdline_option option;
 	union {
@@ -425,7 +427,6 @@ static void setup_edid_info(struct edid_info *edid, u32 gop_size_of_edid, u8 *go
 static efi_handle_t find_handle_with_primary_gop(unsigned long num, const efi_handle_t handles[],
 						 efi_graphics_output_protocol_t **found_gop)
 {
-	static efi_guid_t graphics_output_guid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
 	static efi_guid_t console_out_device_guid = EFI_CONSOLE_OUT_DEVICE_GUID;
 	efi_graphics_output_protocol_t *first_gop;
 	efi_handle_t h, first_gop_handle;
@@ -481,7 +482,6 @@ static efi_handle_t find_handle_with_primary_gop(unsigned long num, const efi_ha
 
 efi_status_t efi_setup_graphics(struct screen_info *si, struct edid_info *edid)
 {
-	static efi_guid_t graphics_output_guid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
 	static efi_guid_t edid_active_guid = EFI_EDID_ACTIVE_PROTOCOL_GUID;
 	static efi_guid_t edid_discovered_guid = EFI_EDID_DISCOVERED_PROTOCOL_GUID;
 	efi_handle_t *handles __free(efi_pool) = NULL;
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 3ca230fa7aa3..d63262d36e47 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -8,6 +8,8 @@
 
 #include "efistub.h"
 
+static efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+
 typedef union efi_rng_protocol efi_rng_protocol_t;
 
 union efi_rng_protocol {
@@ -38,7 +40,6 @@ union efi_rng_protocol {
  */
 efi_status_t efi_get_random_bytes(unsigned long size, u8 *out)
 {
-	static efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
 	efi_status_t status;
 	efi_rng_protocol_t *rng = NULL;
 
@@ -64,7 +65,6 @@ efi_status_t efi_get_random_bytes(unsigned long size, u8 *out)
  */
 efi_status_t efi_random_get_seed(void)
 {
-	static efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
 	static efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
 	static efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
 	struct linux_efi_random_seed *prev_seed, *seed = NULL;

-- 
2.55.0

