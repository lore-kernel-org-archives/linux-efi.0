Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DF6227EA7;
	Mon,  7 Sep 2026 00:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788741496; cv=none; b=KOOnxE3yKeNl0tt6cvdT1o3ukvsT6RFPoyvHTTceB4IIE5bsHNQe5aLSwbOCdMhkJfTmoTKgyLFVZQl/SO3TgR8yMbkX0L+XZLsAuay1fySN9E9QhZLFuXXF3ETC059hqKmwzGfa6eo1dG5wlr4AP1E8w/JeWew72xRLfoOCXUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788741496; c=relaxed/simple;
	bh=Pj+9C4DA+l5GZAnO99jFc3RdrpHzrwLzYWLjwSTMDf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fTRQfSN9fYuQnaRqjOLKX4kcFLTDQUfbvbumauPCLLPANPjJH8aFyvNgX6JuJmBq+0+0Y8t0DlZBqWxVQurhz+9CUo+FJ17GP4lMF3BkSd+AMhqFZBU3MhcDF6uc+W7aUnDqABtmgYPzy7rbAK7p3uO1NTzDc/GR5J3l+D4uy1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=IaTuF5D3; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="IaTuF5D3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:From:Reply-To; bh=aKQV2REp2fcpwnrza2fucinmI1xZTT1H52UGzxMS81A=; b=
	IaTuF5D3fQ0SQeYmx1ZJF8uWf2TLIcBsb1Oqjy0jGthKF3Xl4Qbcesf7Tex5D70/5LWZjQrte0iWc
	D1wB+cn3lDRgud/jqBCg8Dqq0RmNSltIeU5d4xxIu8EgkMMlS1Bh+AOtGjXdqs1F62jiBn5VjpCpJ
	mam26jHpTogsp+lVsQZH5tlqPGMeD5U1zlyYSLzy+agqcvbE0el8kNzOZPQCYVhzbAwyblIacAJim
	F+wfB6WMi3zIOgE+MjFsnJf1xzmkupyqCfYC31ILIaYAs9Bch+Fl1IOaodZfTEwKjmPWDAmMYkMUu
	w8RdlJ5ra/5ZkcYrh6syebRel2GWYMIW6Q==;
Received: from [191.32.245.236] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x3Mky-00Fnp4-N1; Mon, 07 Sep 2026 01:58:41 +0200
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: gpiccoli@igalia.com
Cc: linux-efi@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	kees@kernel.org,
	tony.luck@intel.com,
	stable@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net
Subject: [PATCH] efi: pstore: Fix pstore_disable parameter setting (if built as module)
Date: Sun,  6 Sep 2026 20:55:11 -0300
Message-ID: <20260906235838.2928815-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a28655c330ab ("efi: pstore: Allow dynamic initialization based on module parameter")
introduced the functionality of switching the pstore_disable parameter,
effectively allowing efi-pstore to be used even if builtin and having
pstore_disabled=Y (a lot of distros do that at Kconfig level).

Well, it also introduced a bug if efi-pstore is built as module and loaded
with pstore_disable=N parameter. On load time, load_module() -> parse_args()
calls our mod_param callback efi_pstore_disable_set(), which initializes
efi_pstore, registering it as a pstore backend. Happens that, slightly
later in the module loading process, do_init_module() calls our module
init function, which currently ... retries registering us as a pstore
backend. Since this was done successfully before, in the module parameter
parsing, pstore_register() refuses to re-register us and efi-pstore ends-up
clearing some structures, like freeing its data buffer allocated memory
and setting its size to 0.

Net effect of that: efi-pstore ends-up in a weird state, partially
initialized but with cleared structures. More than that, if we try to
unload it, it won't call pstore_unregister() but will get the module
unloaded, hence pstore writes on oops or with other frontends will
trigger NULL pointer dereferences.

Fix it by guarding efivars_pstore_init() against re-running if the
driver was previously initialized - this is kind of an analog to
what is already done on efivars_pstore_exit() and fixes the issue.

Fixes: a28655c330ab ("efi: pstore: Allow dynamic initialization based on module parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---


Hi folks, apologies for introducing this bug =|
Cheers,


Guilherme


 drivers/firmware/efi/efi-pstore.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index a5db3534f0a6..2e125db7d43b 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -263,6 +263,9 @@ static int efivars_pstore_init(void)
 	if (pstore_disable)
 		return 0;
 
+	if (efi_pstore_info.bufsize)
+		return 0;
+
 	/*
 	 * Notice that 1024 is the minimum here to prevent issues with
 	 * decompression algorithms that were spotted during tests;
-- 
2.50.1

