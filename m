Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4E338238B
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 12:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046249; cv=none; b=FXq4vDDxxs46ZoWCkB5fuvizrf/dzeP2LvmjUgBIoPYCdGID3aKVsrFHLf0IeS+MIWLNXontlxF+2qO4r6Bwxket/SX0o/jFNjQ4z0t9XmAvBHROGtOj8aGBtmHvomXFe8ovXaVkt+3fBBaADOO2cQCPlPRnewFp3CZOol/iOmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046249; c=relaxed/simple;
	bh=fH7t4CLoMxZ4hGmlSQX/UeCrlLK1h+wo/X3EJch0vls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V3qjvGGUHBPxkIrAPZLhd+Vz4NdoX3NfFJG3pI6KJo/G9ZxjODKltr0iinlFVj00xHw9uUXgSpiAXmPVs+VVxewkvgvoPuSF4EhcTqiYVacspDhW/87demvlYMXWIbQjYaoBZj5A2aZrabfD/Ku2Uy3u9QNdrJK6fsE2aQreGrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tNZKFUUy; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tNZKFUUy"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43cfb72377bso2708932f8f.2
        for <linux-efi@vger.kernel.org>; Wed, 01 Apr 2026 05:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775046246; x=1775651046; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ubtZTgynj1xoqNeD7/xyduK3+fryeNVENJKTAAs0vMo=;
        b=tNZKFUUybvXQJoTco7t0/PSEmxZq60qcSFtgLzIm/6YPG5Eqt+GmH7MsAV+cX0+eUD
         PkjSzJ/pj+GoKr4+D8Wgs4oO19vbL/ti75LiRLLjUbB3sczrsMXiQ2OYjLqqU004HOxK
         je1pYcAKrLXd4G+nCdt4Rh3IOX1niE66f5+1/b+JTAIdM/aI765PVSN8OUoTXiJ1+gjd
         a+Ej33i/xDaW51/L9SWmTm3qQWAFHmT6h3JYQPfXVSKQBU+gV623jwXkjaKz3pBTkvGw
         yQTRtZDBxP9PZxZLpQHOs2gxrAO+8ULZGG/CzFphBk2XmdPtdDIAeUmJpzJp8iNXHWGQ
         73Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775046246; x=1775651046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ubtZTgynj1xoqNeD7/xyduK3+fryeNVENJKTAAs0vMo=;
        b=qP4q9NS68p4m3wnhEbgefikrxxqojSSCmU2rpOPDIQFx1k47uzFEpyD6k5c6X5jufX
         mmHup5hPozM7FGBUsLZN5EZqEdc3+bmbm6uRg88bfChG4PtRRT8tBtopTXcGSjI5kFWO
         tEycQdnJ7JrqMPUBhf+bAnwvFUx6fBYBZLRqiMY2+QNSaJMD79zKyhSWvWxXdVDB/bu4
         4ztNGuGZiOjKmuk4NQk6PwJhIHGv3SJ79y2/Nx91Pr+Y3KLgvN2cFaFCCTb2sHeADjGs
         57FS39F3mnMJKuSfTnxZ67m9f9SOye0b/nOjmAADqr5y93Xuf7FnihKrU34l/xjsp9N6
         sWmQ==
X-Gm-Message-State: AOJu0YxsacOFYyv2DNWORq+w3tM8sFGZTO7dlegdEOKT3UdvHPtFV0fd
	Bm2l1QeRdT5/6x3sUWBwCZ14GL6ryMQBazMFGhzneIiCc+KE8GH5uesqLA4cCRz4+y4zmTCUxKh
	tPX2dm5dcQpmdK1vYkXCjLCJKc2jtAck64m2/WY+/mcc9id2QCzROSulhgvBsCMRNbMTXx+jURG
	Bmub3LQI+5fl/CpoEeqsBBdQ0Zw6t3jQ==
X-Received: from wrpv1.prod.google.com ([2002:adf:f681:0:b0:43c:fab7:4ffb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:178d:b0:43d:184:8aa2
 with SMTP id ffacd0b85a97d-43d15051ecbmr6088304f8f.16.1775046245895; Wed, 01
 Apr 2026 05:24:05 -0700 (PDT)
Date: Wed,  1 Apr 2026 14:23:53 +0200
In-Reply-To: <20260401122351.2058145-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260401122351.2058145-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3875; i=ardb@kernel.org;
 h=from:subject; bh=Jx0PtHjYP7r1fy/2H9zhi0ODRUOUmIUV3b1pYSgmzlo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMsX6T0nAiOC64fqt7lLXl74l28S5X1gr7pfma28Vt85
 67ZoXWmo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwkiY/hf1m045NPK9+uWCzN
 6/EzSVd043TnJaJJ3+ebRilryJy8tJLhf/nJtc0S4oHeet2e8e3P+9ZNdjx358C9eOUdr+KOBz+ LZgAA
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260401122351.2058145-8-ardb+git@google.com>
Subject: [PATCH v2 1/5] efi/memattr: Fix thinko in table size sanity check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

While it is true that each PE/COFF runtime driver in memory can
generally be split into 3 different regions (the header, the code/rodata
region and the data/bss region), each with different permissions, it
does not mean that 3x the size of the memory map is a suitable upper
bound. This is due to the fact that all runtime drivers could be
coalesced into a single EFI runtime code region by the firmware, and if
the firmware does a good job of keeping the fragmentation down, it is
conceivable that the memory attributes table has more entries than the
EFI memory map itself.

So instead, base the sanity check on whether the descriptor size matches
the EFI memory map's descriptor size closely enough (which is not
mandated by the spec but extremely unlikely to differ in practice), and
whether the size of the whole table does not exceed 64k entries.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/memattr.c | 37 +++++++++++++++-----
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index e727cc5909cb..b83f1c5a9164 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -22,7 +22,6 @@ unsigned long __ro_after_init efi_mem_attr_table = EFI_INVALID_TABLE_ADDR;
 void __init efi_memattr_init(void)
 {
 	efi_memory_attributes_table_t *tbl;
-	unsigned long size;
 
 	if (efi_mem_attr_table == EFI_INVALID_TABLE_ADDR)
 		return;
@@ -40,22 +39,42 @@ void __init efi_memattr_init(void)
 		goto unmap;
 	}
 
+	/*
+	 * The EFI memory attributes table descriptors might potentially be
+	 * smaller than those used by the EFI memory map, as long as they can
+	 * fit a efi_memory_desc_t. However, a larger descriptor size makes no
+	 * sense, and might be an indication that the table is corrupted.
+	 *
+	 * The only exception is kexec_load(), where the EFI memory map is
+	 * reconstructed by user space, and may use a smaller descriptor size
+	 * than the original. Given that, ignoring this companion table is
+	 * still the right thing to do here, but don't complain too loudly when
+	 * this happens.
+	 */
+	if (tbl->desc_size < sizeof(efi_memory_desc_t) ||
+	    tbl->desc_size > efi.memmap.desc_size) {
+		pr_warn("Unexpected EFI Memory Attributes descriptor size %d (expected: %ld)\n",
+			tbl->desc_size, efi.memmap.desc_size);
+		goto unmap;
+	}
 
 	/*
-	 * Sanity check: the Memory Attributes Table contains up to 3 entries
-	 * for each entry of type EfiRuntimeServicesCode in the EFI memory map.
-	 * So if the size of the table exceeds 3x the size of the entire EFI
-	 * memory map, there is clearly something wrong, and the table should
-	 * just be ignored altogether.
+	 * Sanity check: the Memory Attributes Table contains multiple entries
+	 * for each EFI runtime services code or data region in the EFI memory
+	 * map, each with the permission attributes that may be applied when
+	 * mapping the region.  There is no upper bound for the number of
+	 * entries, as it could conceivably contain more entries than the EFI
+	 * memory map itself. So pick an arbitrary limit of 64k, which is
+	 * ludicrously high. This prevents a corrupted table from eating all
+	 * system RAM.
 	 */
-	size = tbl->num_entries * tbl->desc_size;
-	if (size > 3 * efi.memmap.nr_map * efi.memmap.desc_size) {
+	if (tbl->num_entries > SZ_64K) {
 		pr_warn(FW_BUG "Corrupted EFI Memory Attributes Table detected! (version == %u, desc_size == %u, num_entries == %u)\n",
 			tbl->version, tbl->desc_size, tbl->num_entries);
 		goto unmap;
 	}
 
-	tbl_size = sizeof(*tbl) + size;
+	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
 	memblock_reserve(efi_mem_attr_table, tbl_size);
 	set_bit(EFI_MEM_ATTR, &efi.flags);
 
-- 
2.53.0.1118.gaef5881109-goog

