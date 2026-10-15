Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F97448C3F3
	for <linux-efi@vger.kernel.org>; Thu, 15 Oct 2026 06:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047095; cv=none; b=LcZtoZ9KQV16t1Wa1wskHF4bXwIzURKGH5Vz7rsNt6xMwZE8fshenU7aSL/SrXw74a4FgbqsPW+tCbdYQu+N0eCaVajQ3uIL5Vwkrcohq+8/kVWEZfw5ZstSkjUKrDKzkxXFh9oOudOW2vcObEy/AAVoV8V4+22/N6sku+z8faE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047095; c=relaxed/simple;
	bh=CoURnaEAceEXQwAt5rIxAf1BmNuj1SEfdMMTwQY5S6c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gxpLI1qDrknHxCbVoIGUm8jffuhtoNyNqPZITmwXlf/v7xiGi3Yta1qZNyTiqq20kCmT9kVIffoyZST2Zmz9UXs3jlr5OJSM59G0SOPEHfDiJVNHcILTdQ+ntyKzSmRSHfgayG9AIE4ourgwFSIVW2/BHDtikn66BfF2q/jiQ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PtNJTyqn; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PtNJTyqn"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-487038bc9b8so3927187f8f.2
        for <linux-efi@vger.kernel.org>; Wed, 14 Oct 2026 23:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792047085; x=1792651885; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KegbrHiSQyHiHPpZTs9VdePuzmuQYA+LUuhtvzhprvE=;
        b=PtNJTyqnyVDjVfbF65uT76j4W5gw8Zt09co2ND9ir/l/R4mMSfXFFixENNfGCvxNTC
         V271bcFRmJ8c3SavRGhEIywyLGt/zcI+vgVAtSBRuRakDbRe7+yTrcoLRIQScZniW2gG
         e2yD0KoZmxfsS3hG4RZuaWasA19DCuqnGc8zYNn41lsm6HRcpp5hZ8HRwShAwvTvKmPK
         7lZosU3sxNDGlgUKqvAhsIogRf7l7E76VjcyUO/UMu85fAGZfGTKRpDJCpyx97AxvSyK
         yUTASjQFKiYYSsKX9Vpx/OfxKwmdvYhZeaUDHmiz4TbonuFwBqeku4wkW5SVvpZHD10w
         Kn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792047085; x=1792651885;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KegbrHiSQyHiHPpZTs9VdePuzmuQYA+LUuhtvzhprvE=;
        b=SetDE+DGq6vjjZlE5SX+Pw1EpAbAwqCcaoAcv/njKAU9PQN2qvbYUGcCHuMmDFaJEK
         o1vStZBrcKg7dQTSGg2nGE7nR6v9rLuwhUqeT8eMOJDmrwXzOHPSrbj/ES5xgmz+EquD
         6Skc0ekX6w/1umhofWRrUv4mbl3XAORiCpxP3Mfd9lxhrF5BmbpSzbpB0cpPqY9EoFVw
         ii6nxP0hXAcw3Q1ymGK5+Syy65aIJnPJv08FJPtBgJMKyoEMgHdRVlU6n4b0uQgHhZT8
         +y0oP5JG6qrSXZQ7nCGZaZf0PwLcgshCTNghtFzw+r5W76oywP0f+BwJyqJlO7FcITY2
         COww==
X-Gm-Message-State: AFq9FYLFr8f+CeD+yqzlosXTpW70RE8sbykgGE4DACELUUiY5N0+MU3H
	N+506fP+fxE91FKfZJgs65vTdlE1YrWDM5pJHFDU8jtoAXbHfzo39fTW1D2DJqFd84IkEwFFiD0
	+YaFJL3HUzBESW4BgB4Ib3h6EwbtzOxrloFHD0VaJaSr4LisI30K13pKbOrJCKRiOTktae2ZcLW
	LG9YAGz2Ix6qwCDXxE7mV0pe0HPzMo3Q==
X-Received: from wrsg14.prod.google.com ([2002:a5d:46ce:0:b0:48d:e956:4631])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1ac5:b0:487:91e:d8ed
 with SMTP id ffacd0b85a97d-48dba784ca9mr35598921f8f.2.1792047084249; Wed, 14
 Oct 2026 23:51:24 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:51:18 +0200
In-Reply-To: <20261015065116.3365029-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015065116.3365029-5-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015065116.3365029-6-ardb+git@google.com>
Subject: [PATCH 1/3] efi/libstub: Don't replace an existing
 LINUX_EFI_MEMRESERVE table
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The LINUX_EFI_MEMRESERVE table is the root of a linked list of memory
reservations that need to persist across kexec, such as the GICv3 LPI
pending and property tables, which cannot be moved once the
redistributors have been enabled. Each kernel adds its own reservations
to the list that it finds via the EFI configuration table, and honours
the ones made by its predecessors.

The EFI stub installs a new, empty table unconditionally, replacing any
existing one. This is fine on a cold boot, but not if the stub is being
executed by a loader that passes on the configuration tables of an
earlier kernel, e.g., a kexec loader that runs the incoming kernel's EFI
stub, as the reservations made by earlier kernels would be lost.

So leave an existing table in place, and only install a new one if none
exists yet.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 975148f986bf..6db10590f89b 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -83,6 +83,14 @@ static void install_memreserve_table(void)
 	struct linux_efi_memreserve *rsv;
 	efi_status_t status;
 
+	/*
+	 * If an earlier boot stage installed a memreserve table already, e.g.,
+	 * a kexec loader passing on the persistent reservations made by the
+	 * previous kernel, use it as is: installing a new one would replace it.
+	 */
+	if (get_efi_config_table(memreserve_table_guid))
+		return;
+
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
 			     (void **)&rsv);
 	if (status != EFI_SUCCESS) {
-- 
2.56.0.385.gd3acb90ef8-goog

