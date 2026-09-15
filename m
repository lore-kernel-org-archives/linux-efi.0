Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4783A1A27;
	Tue, 15 Sep 2026 22:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789509844; cv=none; b=lB5de7oS/ue8zdFr7n/x+ws2Wvm9Bkq9IUzeAA+6biCcog2joJh+A+648g23APUQM5Of6PEpYBvaD3FvFsgdBJ95EL/Y1Jq33WdHz1sTNGF/KnnMX5f5IIy07eRVBSN5qyxzhaXiyuaqUKOrWeglTM+FOI7tvOnUARgaypCtOlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789509844; c=relaxed/simple;
	bh=s5NJ4sFw2hDR+G55f8BxOqbRlSQijMacWuiHLeSu1RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VRnrn2vUHvZIM/3+4sDjfu/mg13pMfPb6gMrC4WR5Zh457v9Bbjn6kDTWBZqMti0Bn22BZJ7S6ixwmnosZr1Zozjlw0LEkU8xqUU4BwtgHEq1VFLt603/Tm2MV+LCgPWaM7ebi0xcNbG8s4SPtnXFk8VTo0cbqTbG4iQ3tiDim8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUPKQ9UR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUPKQ9UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962551F000FF;
	Tue, 15 Sep 2026 22:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789509843;
	bh=N0+jPaUK0ZPtv9PF9WoW26rptLupy04Q3abjlTG0MCs=;
	h=From:To:Cc:Subject:Date;
	b=cUPKQ9URqlTFCA+whzdas3/1jpWpzqqiJcvv1P5YgNZRh30fOoViEPX5JTMKkaB20
	 EyqnTetF+MUNE54Jtg4sAbRCVUrt2up8VUrkoHgI4Hq0Cf6CuuYiTgX6z3jO8m/6RJ
	 wC3fnNrc2Z6NthBkAD7EvRwKjJEC9/YRFY85WFcDpF3e22XvVTy9Huqk2+zfxY1mps
	 1bNK9y42pe7pdO9gYR2bYEofLXbqKzSSaqGaXPWcPXMK2zVSRHGDqvwi2oXJ8z55dj
	 Lla5fN37w2DKC0ojRO1C2s/YLQkz3J8Aw5YUv6z1JKOY9IvbNXuwYrSBAPyFJ4UTP9
	 OmTQuQ/vJh5fA==
From: Thorsten Blum <blum@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Francesco Pompo <francescopompo2@gmail.com>,
	Lenny Szubowicz <lszubowi@redhat.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Thorsten Blum <blum@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 1/2] efistub/x86: Use struct_size() for setup_data sizes
Date: Wed, 16 Sep 2026 00:03:23 +0200
Message-ID: <20260915220324.103216-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1976; i=blum@kernel.org; h=from:subject; bh=s5NJ4sFw2hDR+G55f8BxOqbRlSQijMacWuiHLeSu1RQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkrD6zhP7PEed+RhQmzOYTVgoOPx1wWdV57Vv3iy39X9 i3knty6oqOUhUGMi0FWTJHlwawfM3xLayo3mUTshJnDygQyhIGLUwAmcngSw//U84575gnOTbpl aLsoMM9Uv9fhlLmzdVuOMb9B7J+HJnYMv1n4Tj/KyA7fIL553uljbZc9OYIshH4duNwgFM5W+P/ /Y0YA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use struct_size(), which provides additional compile-time checks for
structures with flexible array members (e.g., __must_be_array()), to
calculate struct setup_data sizes.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/firmware/efi/libstub/x86-stub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index dbfbe8a74ab2..d399ab9aa8f3 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -7,6 +7,7 @@
  * ----------------------------------------------------------------------- */
 
 #include <linux/efi.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/stddef.h>
 
@@ -176,7 +177,7 @@ static void retrieve_apple_device_properties(struct boot_params *boot_params)
 
 	do {
 		status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
-				     size + sizeof(struct setup_data),
+				     struct_size(new, data, size),
 				     (void **)&new);
 		if (status != EFI_SUCCESS) {
 			efi_err("Failed to allocate memory for 'properties'\n");
@@ -649,8 +650,8 @@ setup_e820(struct boot_params *params, struct setup_data *e820ext, u32 e820ext_s
 		}
 
 		if (nr_entries == ARRAY_SIZE(params->e820_table)) {
-			u32 need = (nr_desc - i) * sizeof(struct boot_e820_entry) +
-				   sizeof(struct setup_data);
+			u32 need = struct_size(e820ext, data,
+				(nr_desc - i) * sizeof(struct boot_e820_entry));
 
 			if (!e820ext || e820ext_size < need)
 				return EFI_BUFFER_TOO_SMALL;
@@ -684,8 +685,7 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 	efi_status_t status;
 	unsigned long size;
 
-	size = sizeof(struct setup_data) +
-		sizeof(struct boot_e820_entry) * nr_desc;
+	size = struct_size(*e820ext, data, nr_desc * sizeof(struct boot_e820_entry));
 
 	if (*e820ext) {
 		efi_bs_call(free_pool, *e820ext);
