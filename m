Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA0B364052;
	Sat, 29 Aug 2026 21:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788038456; cv=none; b=cNSK7pjkfTCvSb8PjnhhE8e7yDuP2xQ/VaP0ApWqKuN7qd3pGfraPXpx9lpVwdS+WVGSXgqOU+FMAQF+plRAVR7emIH15/GNFM2ZKnSV0iz74juJBtWPweIfMxPXtjFnDpz/hhO56+1KuYFoYyIEmWAbR5iZE2TmpKWy72oD5RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788038456; c=relaxed/simple;
	bh=7+AKVSCv81q3zwE5ABq4d4psS2kgIpKN5OfukAqKhSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nudYM4W9fRXOpDA9FQhkWpjVE8z1WN2qU4SBCbzIuhf+SM5pUc3YnS0MhjeoTduX97/nBiyq9yCmD6vh/lh5Rp3ZA9tQWcRa5j7LQKX0wiT3wyMm6K07GO8F89H0Jb5fyCiXsoEa5l7y3PfPfsF2sbUp3ut176rHoYU2xHZnEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWhIPwuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWhIPwuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A0A1F000E9;
	Sat, 29 Aug 2026 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788038454;
	bh=OMVXHLa1HmQu4uo8XsSIwn4sntIQRJHfffEiJUyFrKo=;
	h=From:To:Cc:Subject:Date;
	b=CWhIPwuGtVzyGHppN0Joo/2AdlhLp/vqnNVoNG2z7dePN67VW057cO3gxb7eU19pq
	 Vg64bqjWkmPicDWMpzaKbsYWnTsYOtfmimRIeIAITk23hnWkwUydvyez7RjiCX1uju
	 lVeeOQ/ZuPsyqiEuUHYcOGtU7a9oOCkqSol26PsoC/so4FwDaFEKty4BwiMYo0q+r7
	 j5Lv55nzlrUF/KaIsMKW/tIYzY5WvckBbP/Qd4LImt9XWQP0cLxlO3oY3PMk8P0nCC
	 V52f7AOKHszRoq6J9MAij7n08Ipf6nbfh6Bqm6k+04KNq89whCcIdZquBXDXgFAGqt
	 7/PNWoq3CgI7Q==
From: Thorsten Blum <blum@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lenny Szubowicz <lszubowi@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Francesco Pompo <francescopompo2@gmail.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] efistub/x86: Use struct boot_e820_entry for size calculations
Date: Sat, 29 Aug 2026 23:20:35 +0200
Message-ID: <20260829212037.335569-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1334; i=blum@kernel.org; h=from:subject; bh=7+AKVSCv81q3zwE5ABq4d4psS2kgIpKN5OfukAqKhSo=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmTfVWfznmQ/yJV6dcC69kNlu5R3UEpnpyed1co6ETNn 1/GpPizo5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACay6xDD/+Cf8y4r5s3zS2Re 2mBbcrlF/G/3CemLIs+0lta8dtBvv8bwP/zP9/MPYtKFyjTjCn1E+NmVOGNrXyd89ug1aO2S1tj DDwA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

alloc_e820ext() and setup_e820() use sizeof(struct e820_entry) when
calculating the sizes of boot_e820_entry structures.

Even though struct e820_entry and struct boot_e820_entry have the same
size, use sizeof(struct boot_e820_entry) for consistency instead.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/firmware/efi/libstub/x86-stub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8..ae2481f8a4c3 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -648,7 +648,7 @@ setup_e820(struct boot_params *params, struct setup_data *e820ext, u32 e820ext_s
 		}
 
 		if (nr_entries == ARRAY_SIZE(params->e820_table)) {
-			u32 need = (nr_desc - i) * sizeof(struct e820_entry) +
+			u32 need = (nr_desc - i) * sizeof(struct boot_e820_entry) +
 				   sizeof(struct setup_data);
 
 			if (!e820ext || e820ext_size < need)
@@ -684,7 +684,7 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 	unsigned long size;
 
 	size = sizeof(struct setup_data) +
-		sizeof(struct e820_entry) * nr_desc;
+		sizeof(struct boot_e820_entry) * nr_desc;
 
 	if (*e820ext) {
 		efi_bs_call(free_pool, *e820ext);
