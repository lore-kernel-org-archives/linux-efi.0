Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654976;
	b=NIJ4csUSiVAmoIAkkhZjd5IOceZ/4rFGeN+9y21xoPu7U8n5/2UjDm/s0jWyngemOBja
	 wppttlbHwUlY7hEeIfMlOhRQdB3nKGw6cwN52GUcbxUGqz0tsb9/jOTtqal5lroaNXR4P
	 wbciIAUl9WrXCACPzwb5c26IAqnpypldv0pygBGy5MXaGfDT+aroMETIwhNWClGNXqFe/
	 h8c8Qs+IVN1scDMg77Vg+/jeduKerdjbdQVWMA2+fLdU8wLmg2ol3wA5sNMZZzxI7DBwl
	 VEt5hrAht/tt7qeVZjUE99i3+518kDXWAryT+PRrYdmeqvRj4PLyg1Qgmlh3jlXuw1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654976;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Qgxf6cPMRa2fgOZLNkKYBji7ae+uqYeBopsxbR/dI6Y=;
	b=gWC8tOk5o09OrYIlv9Yyk3Au/F195LVIcp7ATXwCQTkSt+XFXhH9KM4REvCloIa1FkLD
	 SWCsgTPpaeeaKrpoXt3zVQ+OfzjcpDB036yqqEBjHCR649dUwSSZKQaGhOH1f0GGD0K/T
	 hpH0yMP85kTiOpAyL9MLe7JG2X6nOiFF2oTlhtaPb5k9HAznmURvgx8MY5+7qsV8ER7p3
	 tPy94TpZYEyp+3CwN0LFn2Hl9o61kawp8+uz4Aw0PFe3nfEZh0nup9W8QTnkz4wn0LrG5
	 3Nj+bTvPyoiCS+GT8WqR8Txp/lL6uoMekhuZ40Zyz8kffD9SwzXSjL7/Slxsz3L49jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gw6nyaBf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC2B606A329;
	Mon,  2 Nov 2026 21:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gw6nyaBf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D501F00A16;
	Mon,  2 Nov 2026 21:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654975;
	bh=Qgxf6cPMRa2fgOZLNkKYBji7ae+uqYeBopsxbR/dI6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gw6nyaBfkvLjKlF9cbp+6df2Lwbw0+pS5533QsbvNM8MFMZ7Ya8MTBYT2iFT/Y1a8
	 LE4unNtcs7xv3KszNBJ1PgFUhOKH8vI+AfiwbCbuWs/Md4pWVBgl69YoRSg2Z1IBM/
	 gmteFYQXV81Zc2wc7SleSMdx2uLm9z2u2K0ehAvnOblx+ROmN1+5meitHSyEnwnhZQ
	 MWfvc0MQ0gEX2Y7F/Y+A2Nu9os5f8Cu/p7tXkW3q3yl4jJuaVZjkC7LHj0Sqsy0VFe
	 3ylGyoy6t5fBwhzHg5708KSgYacJxaqD3kWL5Ie69Ho5PEJMXNPmXZbMdDNaWPIWGD
	 aJx8q81bf6yRQ==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 02 Nov 2026 22:29:09 +0100
Subject: [PATCH v3 2/7] block: add DPS root partition type UUID definitions
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
Message-Id: <20261102-discoverable-root_partitions-v3-2-27f04b69b7ab@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1660; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=AL8uN7/7MSksrsBruApS+z49m8V8+cpTPrJkxJAGLio=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGTaKrrMKeGDHovigW1E9O7Ds++NfNsdfiry0MJ81c
 6OM97pLHRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1fHPGf6XsGi8n3o3hlfW9XJklnvlzT6dOe3+vz/f0EthZnbXt//F8Ffysk3icr5
 psdOupB2oC5l/aYOGp5JLwK/mDz8n6i2S8uUHAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns a native root partition type UUID to each supported
architecture. Add a hidden DPS_ROOT_PARTITION_TYPE_UUID string symbol
and populate it from the architecture selected in Kconfig. Only
architectures with EFI support in the kernel are added.

Gate the symbol on EFI and EFI_PARTITION because discovery needs block
devices, EFI runtime services and GPT partition parsing.

Derive the hidden DPS_ROOT_AUTO_DISCOVERY boolean from whether
DPS_ROOT_PARTITION_TYPE_UUID is nonempty.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/Kconfig | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index 70e4a66d941f..3b5d3ad42dde 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -211,6 +211,20 @@ config BLK_INLINE_ENCRYPTION_FALLBACK
 
 source "block/partitions/Kconfig"
 
+config DPS_ROOT_PARTITION_TYPE_UUID
+	depends on EFI && EFI_PARTITION
+	string
+	default "69dad710-2ce4-4e3c-b16c-21a1d49abed3" if ARM
+	default "b921b045-1df0-41c3-af44-4c6f280d3fae" if ARM64
+	default "77055800-792c-4f94-b39a-98c91b762bb6" if LOONGARCH && 64BIT
+	default "72ec70a6-cf74-40e6-bd49-4bda08e8f224" if RISCV && 64BIT
+	default "60d5a7fe-8e7d-435c-b714-3dd8162144e1" if RISCV
+	default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
+	default "44479540-f297-41b2-9af7-d131d5f0458a" if X86
+
+config DPS_ROOT_AUTO_DISCOVERY
+	def_bool DPS_ROOT_PARTITION_TYPE_UUID != ""
+
 config BLK_PM
 	def_bool PM
 

-- 
2.56.0

