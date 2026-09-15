Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFCA477285;
	Tue, 15 Sep 2026 22:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789509854; cv=none; b=kYk/AKlcaW3vRzQYFYmePYfFbZ01t+kS67veRf/SSRIFjVZRoy+sJwjcKGTzuLd4AelB6BUR8B+GiT86PwFaASwaVb7hiOVdVK0md3HPn9Q8STjq8I14Fr7yy68wCzmqzdKPKtb/96l/7VPNioYKgkcUjFqbIt3/InfCCdUZQdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789509854; c=relaxed/simple;
	bh=RvFo4YG1JbrcNdUdpE+qlKEDV0Gkw6PSRi4dNw0mPk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYeorS5WF+O1UaJ9ro0BjeVDnQmjVxQS3lRpR4rKyR1O3TaZmjCAglO9fxBZsziY0YY/1Abq0xhXYU1MsHh+M0W1u4LVeXWj3xU4/PMDn1JuJxSVgcYy3o9JLX9ung7qFW2Xc490A+FfOpTvQfombkYCW8Pt4JFdFIyX9ixpHG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAJwRQGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAJwRQGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A9F1F000FF;
	Tue, 15 Sep 2026 22:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789509852;
	bh=ZQDgqlj5R2F10FVuIsjCaNsiRZMZhVDIY6Yg2zzdnwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAJwRQGejR14+9X0ZJu8mGe2vJERFn9cELIuL7TehuU4TJ7NnUqJYn+Cnc9/fkuUC
	 Hk7uIgVZhQOaXULzdkdzlcf/ldP0Sf09HvIcvLqThkoLhvohd5FbJHuO3fjTky8+PV
	 N0IYmuz12ntRHaL/tgUdutH0GrzOUIdiS9FCthg/6BJbWv2XSyDYdn29szO8ya/M2r
	 +qEzMPj1QTMcpZOBTDj+25Nv6KlwKUEyfHjSe2Qf+uCY4zqq2nIjyX3hpiPL4rd90e
	 4c9kLT/8fVFWEtVQG9nN4kpcayVV3RVo+CMbs8fNGwkPJ08HqqAhMWeMUfB1iXv5tm
	 m2bNqnm6DOxvA==
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
	x86@kernel.org,
	Thorsten Blum <blum@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/2] x86/setup: Use struct_size() for setup_data sizes
Date: Wed, 16 Sep 2026 00:03:24 +0200
Message-ID: <20260915220324.103216-4-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915220324.103216-3-blum@kernel.org>
References: <20260915220324.103216-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1407; i=blum@kernel.org; h=from:subject; bh=RvFo4YG1JbrcNdUdpE+qlKEDV0Gkw6PSRi4dNw0mPk0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkrD+w6mfFE9NiykrgKDoWOM5yz/jTPLOOotTvi9ub2y 49v7mm3dZSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEimIZGRojSrrcAxJmXhVW Sw77/ffmoo+xRYv69gsdVthesGh9PQMjwynHD5HfUq6+4BUp40/clXI4M0d69i7f58duzvh3LIG HjR8A
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use struct_size(), which provides additional compile-time checks for
structures with flexible array members (e.g., __must_be_array()), to
calculate struct setup_data sizes.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 arch/x86/kernel/setup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cda6adb9f69c..20facddee922 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -19,6 +19,7 @@
 #include <linux/iscsi_ibft.h>
 #include <linux/kexec_handover.h>
 #include <linux/memblock.h>
+#include <linux/overflow.h>
 #include <linux/panic_notifier.h>
 #include <linux/pci.h>
 #include <linux/random.h>
@@ -487,7 +488,7 @@ static void __init parse_setup_data(void)
 		u32 data_len, data_type;
 
 		data = early_memremap(pa_data, sizeof(*data));
-		data_len = data->len + sizeof(struct setup_data);
+		data_len = struct_size(data, data, data->len);
 		data_type = data->type;
 		pa_next = data->next;
 		early_memunmap(data, sizeof(*data));
@@ -584,7 +585,7 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 		len = sizeof(*data);
 		pa_next = data->next;
 
-		memblock_reserve_kern(pa_data, sizeof(*data) + data->len);
+		memblock_reserve_kern(pa_data, struct_size(data, data, data->len));
 
 		if (data->type == SETUP_INDIRECT) {
 			len += data->len;
