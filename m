Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654992;
	b=khELRIMcvbgCNNA707vUQfTPw4Zr6CMKjw+V8Is7759jYg4X1GQQThB7nMYlYjcFD7dn
	 CiQTfiWdinT4VRD6idXnrwDTAVdomgo7+Q9B0y4kxIWh3BKExWyIR2KC5Q++aqinAhAJs
	 I89Ht234N4txONQYbkoxMuFNsnlq40XMUaF2zZLiPwslx5RxlXBlpRgi9vsVdx2LXodyW
	 cbfr5uuqw9KuKRTG/18B7CbCPWks8migvUTNPKmk72xhfl1eBLy7y3IJiHF6ydhOYwwb7
	 tbhqEtMCUFcsWAg9x016NnrtmVZYxYt3zG2954TiP0xlbVUXIVIgpcniSgilFZgy4oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654992;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=X765b+SvDUY0hI4tKNjS4ZVBnhPOM9JahqRHMsNz42w=;
	b=4c8Fzo9twMWz3Gad7mvHzPznsCF84es4w1uk+OA90+OlhfWncY6K9Zfd08C7M4XTT6+8
	 l1TakDI0JrdzMB45Bvn9TyPf4+GzrLson/G+U7OWbQUf84Uaoa57XlPt4sqe/9732ebMJ
	 /KI3KGQpdcLa9RWuM2MXKACitxzwlaiJlaJAPaJbgcSROW3ZZPFUKctn0AVZ++iZZcm3M
	 SRwj/3p0wTCB/nZUqandVUptgY4zJHVDpj5MhqKXhFo1et9bay1lzvqjq7yvkLWO7zMZf
	 ORodosY/PeMDNhkpErNRJgROQmSINIWMMjAHNAiFgW2VwhpcwTS8eoxw3/TapoBANBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UyDq2pOl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BA2606D804;
	Mon,  2 Nov 2026 21:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UyDq2pOl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDEC1F00A17;
	Mon,  2 Nov 2026 21:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654992;
	bh=X765b+SvDUY0hI4tKNjS4ZVBnhPOM9JahqRHMsNz42w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UyDq2pOlHw5NcM2bA1Nmc9WumekGwGn0Zus7q1irqEKY3VH3Jh4bEutbKl9wLPZnn
	 O5MB+4SBP0hmYT/3KJrCpD4trrft25RJGdQUqNU0tziTEjyBrviA7bkpKHtnIidvZA
	 L+c+8oY1USunZ5N6NcGU8KA1WpCrDqdrV6LRCrgC+NWTF/xB5zToEQND8ni5d6qw8U
	 riMy3QngAiZAZXCrw/LtXssvqv7YPu9K4HPG+q4u0wGnkr3CVV51eK+3cfa6FIfwmP
	 4SDpliLhOwcwgZy5tukPNIDjsciMBrTlZvmCFHBxxCzCFUYWRdclW1etHJmqD7/bMC
	 A3hRJrkEi6i5A==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 02 Nov 2026 22:29:13 +0100
Subject: [PATCH v3 6/7] block: add secondary DPS root partition type UUID
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-discoverable-root_partitions-v3-6-27f04b69b7ab@kernel.org>
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
In-Reply-To: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2260; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=Ryh3J+29qpq7BeFRKlKRoIlPVTXvgjw20ddqndSK8l8=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGTay+mcc/9rVbS21TDWiZNXTBb1GTeumZLNO/8Z6a
 +FvvTMdHRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1S7bGBl6j7Es2yt6N2XKseNfM1J7ZJ7/qDI0lf3yI3NOz9Pyen0pRoaFRdH7Utm
 2yn1lfzrxNPOcSP3OlS0r5k9bqeQ8w60p9ysPAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

Some 64-bit architectures can run 32-bit user space. For those
configurations, also allow DPS root discovery to use the compatible
32-bit root partition type UUID as a fallback.

Add a secondary root partition type UUID Kconfig symbol and include it
in the DPS root lookup when it is defined.

Try the secondary UUID only when the native lookup returns -ENODEV.

The fallback reflects compatibility support built into the kernel. If
32-bit execution is disabled, for example with ia32_emulation=0, the
selected root's 32-bit init will fail to execute. Do not check
ia32_enabled(): rejecting the fallback would instead leave no
discoverable root partition, resulting in a kernel panic either way.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Link: https://lore.kernel.org/r/03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/Kconfig        | 7 +++++++
 block/early-lookup.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index 3b5d3ad42dde..f3a0730ffcde 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -222,6 +222,13 @@ config DPS_ROOT_PARTITION_TYPE_UUID
 	default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
 	default "44479540-f297-41b2-9af7-d131d5f0458a" if X86
 
+config DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY
+	depends on DPS_ROOT_PARTITION_TYPE_UUID != "" && COMPAT
+	string
+	default "69dad710-2ce4-4e3c-b16c-21a1d49abed3" if ARM64
+	default "60d5a7fe-8e7d-435c-b714-3dd8162144e1" if RISCV
+	default "44479540-f297-41b2-9af7-d131d5f0458a" if X86_64 && IA32_EMULATION
+
 config DPS_ROOT_AUTO_DISCOVERY
 	def_bool DPS_ROOT_PARTITION_TYPE_UUID != ""
 
diff --git a/block/early-lookup.c b/block/early-lookup.c
index c59d14889fee..2e7dace5efa3 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -340,6 +340,9 @@ int __init early_lookup_dps_root(dev_t *dev)
 {
 	static const char root_type_uuids[][UUID_STRING_LEN + 1] __initconst = {
 		CONFIG_DPS_ROOT_PARTITION_TYPE_UUID,
+#ifdef CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY
+		CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY,
+#endif
 	};
 	static char esp_partuuid[UUID_STRING_LEN + 1] __initdata;
 	int err;

-- 
2.56.0

