Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC90839C011
	for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 13:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774531643; cv=none; b=Hmza5lfJBOdZhBCNUUwjNdukYumOITlS9APtJ2euuEmS+toeEyRnchfccFEfMMqSbsvtz7OoBcZu6Awb/PIrnuRAB4YY2P7IhjEfJaodjDqa1TC3rFnLa2CuFTmYdF3bH7V1c5UyJl44dkD66/kFeqlc/TFvOK3eAEqm2PA67gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774531643; c=relaxed/simple;
	bh=fZjPOaIGiInXb9FfsWODgJoFCvX+VTlkGFglUy+3XQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GlQi8apZVFYnmoOCZPlzURZeCLTzgvTLA0uO3qR90zCel0Py6t/L25xY74JOwk1SIFrhBo5CQZYOOYZSDNUyMDJXIb5vslQvwc5z40yQkux9fbzotnvVn1DxwHPK2K7bcRBLaQUkgsC4wr0zjmqWexaPy8dJ3LAgWm0NjUVz5KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pctTHLze; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pctTHLze"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b97a381912eso69554466b.0
        for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 06:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774531640; x=1775136440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WBiR9gxXBcLOHofBlDWTXR6in2B24aoi6pN3TLZufuY=;
        b=pctTHLzeoXp+RRtgp6CRnQ2OArnqzGUA1v8Xm76ZuTKgs4DmD4/5dRHiORas/vZfAC
         mvS/G80d+ClqHeBN4TVKl2ruCe8Q7w9uzb26Jqck8D10fPxx+fJ4iuP2LO5YLjgd/T92
         JJ57IvqoebBD2JNkjvy7afEnUbcGwjWmXbGZoo9iNlZOJQ9byg4TgZWAy2CL0voGn0Qk
         FyWlAUvcfTEBjnOWb68yPal/la9ob1BoAwg9S9kkooaXjtN97T3O2kea0/Gfw+r8A1fQ
         iuJL3FEaJ3G7VayBO9IArRStJcEOSRqdu8EWSOxu0HziQTYk5PCqZleIaAzBZbQPasc9
         zhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774531640; x=1775136440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBiR9gxXBcLOHofBlDWTXR6in2B24aoi6pN3TLZufuY=;
        b=dX5lTuJqqg7NYhohGmUBJXPT5icoVCZO6zWahA/UcJHDsufjNHj7Y7V879QJ0XwSdV
         6/gyFnI0/XYtwFNrpAzLHGEiCRXo/ksN1JJEKnorwyHocezSagt17p3MOvKU0l4BMBNf
         wzKuJlugRK2u4rsiPt13l3ScdZk8oV8SgJr548f+6dJABWG9VOxCHAj6MESJqY6MpWQ/
         9rIgL1OtnQ3gc+r1coLdWsTIGnWLkYsPujjwLbL5fXJuLy0581NdRkx3PWOZiDEfSIlX
         I1zad5ciZtjXujb5dVI2FxVZvcNRH3dLdy9LLUg5rKmihG9RfuFf2RLQN8lg2mC7UD+l
         Hfcw==
X-Gm-Message-State: AOJu0YyhNb2WTk3hJj3HmqlOQJPf6wwewItA4m6hK/QdcRJhsMQAsHRg
	Tgsv4BYMNn0RkfcVtw2AJYbHF+n9ZKpEwAUV186QG2ZetouFb57eC6e99nv8urdNizG69bhdE/l
	Ke0JwWIVot10JdVrAUks7X75rlNXicRcG1Eip6dQjjiQwavv2IFQM+aEv33xYN9i6oAFSLnHSiK
	nuF/LT6BN90BG73gZ7i/EjWpn0GvUXpQ==
X-Received: from ejchk6.prod.google.com ([2002:a17:907:3cc6:b0:b98:24c1:423])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:806:b0:b98:44b3:7e95
 with SMTP id a640c23a62f3a-b9a54268840mr536267166b.40.1774531639913; Thu, 26
 Mar 2026 06:27:19 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:27:00 +0100
In-Reply-To: <20260326132655.1733873-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260326132655.1733873-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=855; i=ardb@kernel.org;
 h=from:subject; bh=IrDXJ0SpMQSirNYm+oXKTNnBUrUZx/I6yCygt5YygRQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOoiep0/vCVPsd970wKP8j1PcfNqM9EccMx/0yNx5zTD
 J8uEPnfUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbin8rwv2waW3d79KJGNuFJ
 civbdL02XfVZHVbzSPmVisrOGXLu/owMb0+IPuPO1pBQrLw4iT/I+0jUPjaDUyz/WDVOHXrT2/6 UFwA=
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326132655.1733873-11-ardb+git@google.com>
Subject: [PATCH 4/5] efi: Use efi_mem_reserve() to reserve the memory
 attribute table
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Use efi_mem_reserve() rather than memblock_reserve() to reserve the EFI
memory attributes table. This is needed on x86, where memblock_reserve()
is not sufficient for assets that may be placed in EFI boot services
data memory.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/memattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index 8d4004149297..f9cfdec1fb51 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -59,7 +59,7 @@ void __init efi_memattr_init(void)
 	}
 
 	tbl_size = sizeof(*tbl) + size;
-	memblock_reserve(efi_mem_attr_table, tbl_size);
+	efi_mem_reserve(efi_mem_attr_table, tbl_size);
 	set_bit(EFI_MEM_ATTR, &efi.flags);
 
 unmap:
-- 
2.53.0.1018.g2bb0e51243-goog

