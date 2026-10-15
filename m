Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504A048B383
	for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 06:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047093; cv=none; b=uf7UOqMrks9n1FOKq/6eWfE9BtAp8dGjLdr4CBYgbBmrxUGKt2XdWLg8HOs8X/EY7Uo6b2GQMayU5l06o+lbwysu1/h5iE5kejZw+bOwksXSoVD12CcjyB9mFdgHE4xiCsMarkWlfMVC0iQ+jLWRKBdbiH6CKC66E/dybjNadP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047093; c=relaxed/simple;
	bh=SItlcE6smWJ9HWMtIeToa9WeUeX4DHDe7cGssIy3xRE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bRnmP0EJvT0wHX1EJkS87Dkc9GNuDhFY4xsFShd9+lWquCy8JNrA9ETsA4obpL1/5igkJcf6cd5lHf5RSPNchSasOPpSTZKxxu3l8go9Bxf/JfLWIen7lJrpalVL97OF84kLVxsgsczkWtsziScCS6B8rZB82l6ZRaVe+lV2x8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IcN+yYrW; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IcN+yYrW"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a5d57a8d51so5526535a12.1
        for <linux-efi@vger.kernel.org>; Wed, 14 Oct 2026 23:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792047087; x=1792651887; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=01+6NNJE+oY24QEwS4N1zsdGWUwgIgBwewKqWCgHYVI=;
        b=IcN+yYrWElOb1rxDI0CnFhAbzvNjM7FlR1MWLsfTNfhUl2bDFej/ZMImF7/92rkz3h
         Pui1XYpb9ql5UPn41GpCpSLl7NKYCioYwhAR9WlnDIhW0FFlgX3W75Pt6Btu8TAVndcL
         gz01UDf+qpTlk7CH9DPBXmsUWJd2JkrfnvFSqZKAFWvmGd/CtIbEKOCcfcpedPtrrKr9
         ByOYnOUmV7Z3zjnrv5uYp4lIVDvpchxQjLiavTCvAhHTBgkyfdnB+MxF5LvzGu/+FbCO
         +HOLvJQO2pPfgOwaP/UpIn/vRD5UsCsLg+5oCBwsq+AmZy2IYpVeqcPM57RiGmYufyU7
         oDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792047087; x=1792651887;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=01+6NNJE+oY24QEwS4N1zsdGWUwgIgBwewKqWCgHYVI=;
        b=POn5OCd1KrNZA0Zb9cN1mfZ/DOcYVR74h+tdPEQ7OgNKWIsot/rdliYFpUHPMSizB1
         egpHjAJT3jJpG1gJNcGfaLIVfIe3BVnu5qOWbb7UsVuS7nREHaEkI7QNqjWLS+Dquzy0
         hbHo0Oou6TrAFSErk5kzbyb8vMokzRnFog+a+TBLSUqCDBmSRcsfNGddC2ntj/kPEnZY
         XcyQbtfqMF+2mun6GYOlPbU+i254DdpxxJnvtLZ8ZvKPzL2XXTXaWm596JxlFIYLjDV6
         I1vSL9Ud4cjqVd3WzV7CNr3HjmI8kPfEBHC9F1xzPX+z/vLdjA/GTnvi0tqfpK9Q9grP
         +3BA==
X-Gm-Message-State: AFq9FYKBkXVOfVQ0OL2sr2+dv4cikMvrbM/tWJ2H0zxpLNDsXE7ZMXAI
	t/xBD4lMXZ1WSuK0WFXynL+tsHv6+DRGE96LSFbeTl/5mqpvtgDnGH1bF9FeISYfJ8R1/BLa0Z1
	ULSQW5LlfMXQO9Q5zx5zKekxkMDsWJGuMXeFMvfxesI9s/tDjqOStzMeLWNE69pO0INkVPyLErP
	s5OE219uR42hhqtqP4zZA4K2pX1btmyA==
X-Received: from edsl13.prod.google.com ([2002:aa7:d94d:0:b0:6b1:f575:1635])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1d53:b0:6b1:b5b8:b691
 with SMTP id 4fb4d7f45d1cf-6b1b5b8b8demr10254428a12.21.1792047086929; Wed, 14
 Oct 2026 23:51:26 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:51:20 +0200
In-Reply-To: <20261015065116.3365029-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015065116.3365029-5-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015065116.3365029-8-ardb+git@google.com>
Subject: [PATCH 3/3] efi: Initialize all configuration table addresses to EFI_INVALID_TABLE_ADDR
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The addresses of the MOK variable table, the confidential computing
secret area and the unaccepted memory table in struct efi are only
initialized to EFI_INVALID_TABLE_ADDR if support for the respective
table is enabled, and are left at 0 otherwise. This is harmless for
the existing users, which are compiled out in that case, but code that
consumes the table addresses in struct efi generically, such as a kexec
loader that passes the configuration tables on to the incoming kernel,
would mistake 0 for a valid table address.

So initialize all of them unconditionally: efi_config_parse_tables()
only assigns them if support for the table is enabled, and so they
remain EFI_INVALID_TABLE_ADDR otherwise.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 14b9c7ebb5df..9bc22de0d67e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -47,15 +47,9 @@ struct efi __read_mostly efi = {
 	.tpm_final_log		= EFI_INVALID_TABLE_ADDR,
 	.ovmf_debug_log         = EFI_INVALID_TABLE_ADDR,
 	.mem_reserve		= EFI_INVALID_TABLE_ADDR,
-#ifdef CONFIG_LOAD_UEFI_KEYS
 	.mokvar_table		= EFI_INVALID_TABLE_ADDR,
-#endif
-#ifdef CONFIG_EFI_COCO_SECRET
 	.coco_secret		= EFI_INVALID_TABLE_ADDR,
-#endif
-#ifdef CONFIG_UNACCEPTED_MEMORY
 	.unaccepted		= EFI_INVALID_TABLE_ADDR,
-#endif
 };
 EXPORT_SYMBOL(efi);
 
-- 
2.56.0.385.gd3acb90ef8-goog

