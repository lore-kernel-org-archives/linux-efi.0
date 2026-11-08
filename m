Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794151774;
	b=Hm9DNI5qcNrsk21MSeQx9F9YX35x4iHIHk76DfeDhEKvQix+2Y7Fi5vwS8gXtFg4MKuJ
	 iGPLb8/KGeWxScA5FSFj0dJXotsYSuYi2SRrGtfBOC9uP/K9k4HePj/NxNmXFLf+Kmkl2
	 YwhXUs8CD0sf/rHSseQza9fQFCDyZ2BcogIuf15895RWYGeRN0Kj6yqi8Ycd22/CkpTxa
	 btHQyr8zeJ9Y1N/7EK0CZqzFq6Rri/JEsRaaV1/pfbI7P5rfbI0kgTsug5FuQODhixz6X
	 yi3Z5PF5DG/vq5rPU4BaPxxV53oO43qRAsWpwcXRprt90fJkS3XY304X/wz02OVG8rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794151774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=g+ER5kPnhXzOYMxnOXlLaVXcCds8fft6k42Ed9xzF3k=;
	b=QXAdGT56uv9WB64E8ktE8tGx3wUoXLGYJ8Ub1/2MgDZ/Pn5FWBICEvmVOR9R1Odd0TlE
	 /czj0SSYphEpMWXHVqdSyLnNGCRU+4j2JCXcavJadBpgAr2h2aSFVGTVxnPuUftUAINrT
	 bjeljgL1Zgz2eGdLKJNwwXvPBOkbulNxuX+bgF3Q1Luj2Zl6DG19Objx+aajFhY/RVZSC
	 zeQ4b3ioaW297gGkeZnzGoTXbuEtBCJTgh5cvnbxcUOV0z5OD6KzOzYc0rDYRbdK6EbIz
	 ikgOfo0wv1Cr+QryM7os3gifBTJho+ygXBWUei7MlaD8sU92l0DbOUjoUsL9dK1QBhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaOHI6h7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6A1606A31C;
	Sun,  8 Nov 2026 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaOHI6h7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9721F0089F;
	Sun,  8 Nov 2026 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794151773;
	bh=g+ER5kPnhXzOYMxnOXlLaVXcCds8fft6k42Ed9xzF3k=;
	h=From:To:Cc:Subject:Date;
	b=aaOHI6h7ELoEUKN1g939H60ZxMIUhAndzBmcsNGH4saSSfAD6w0Xacc9nscJyraz4
	 8ppGmmzpAv2uwDbNeL20YpTJ59FcfioMp9O9SjQ9JuSnKZFdqZMO2hD+xxEVmlbZF4
	 u/fNKWKUCQhoh2oRBd7lBuQgJeY2NT1wroi8XFGDix8CU42dsxorp9tqMhUBZj3o51
	 pzKjk9xkhZjvSwCilKfMCzu5IaK1WfN/ZDTw+l8gp7RwK5avEPNSvsl14b0ImEhxfX
	 RIOAKbtlNAuvpnAMIfgH9aYzFrj+uRUMNEHbXIOpgLarqLUrczu+0RYEsLQVUkTUzO
	 EwcB6fAyb+qOQ==
From: Thorsten Blum <blum@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thorsten Blum <blum@kernel.org>
Cc: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] efistub/x86: Use struct_size() in preserve_pci_rom_image()
Date: Sun,  8 Nov 2026 16:28:33 +0100
Message-ID: <20261108152835.20294-2-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1132; i=blum@kernel.org; h=from:subject; bh=3dcw4MtXYOE07LwrOIhbvfgjzu4VYdTKYuI7e2d6F4c=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkfpio3HX6wzPmv4uckdjNfw/i553+zhGv9fqdz8MsNq W/dX2o3dZSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEpsxkZHg/oWBdwhsjidKi s6oNEf1aV3M763daO1zMUrvw6uFv5RJGho0Omv7ima0cauvTGOXOz97o/N3KutJjwodX1gy/etZ t4gMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use struct_size(), which provides additional compile-time checks for
structures with flexible array members (e.g., __must_be_array()), to
determine the ROM allocation size.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/firmware/efi/libstub/x86-stub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 253dd3ba8fab..5d35cfe78775 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -7,6 +7,7 @@
  * ----------------------------------------------------------------------- */
 
 #include <linux/efi.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/stddef.h>
 
@@ -62,7 +63,7 @@ preserve_pci_rom_image(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 	if (!romimage || !romsize || romsize > SZ_16M)
 		return EFI_INVALID_PARAMETER;
 
-	size = romsize + sizeof(*rom);
+	size = struct_size(rom, romdata, romsize);
 
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, size,
 			     (void **)&rom);
