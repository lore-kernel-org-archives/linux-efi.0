Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8F83B8D62;
	Thu,  5 Feb 2026 11:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770292566; cv=none; b=VyZC9MrjgR0mw5iLv5AazRXvVX4sDZvftFza64ZLxQx1ZUz/07Mt9LqdxQMTmYWAp7Bfc8fniov/W4wy69xkcpfrje2NFhKX3vYLZNdIgJ6igkoAXn0YW8WHFidDq/9GiTyr+meWI7tqL6lqlQ/Fp1fIemjcAtUFxTZsx6S3juA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770292566; c=relaxed/simple;
	bh=1VESK5PSjVn2nnYN3CXXSwZbnr0EGZEpK+twGl2q6Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfbSdxMoo4O6pETScRvqRzo1/yokzZUMiv2SG53qFmijb6G1KQ3TSEc/wjNHdsV9G0ivGTkt5rFkOsNlz1tctBNPEVV6WlBvrGpt0UrraFLu/T4KFTN8Bkrn4yN9M6RaunHtCF21CLKrHtXKyZzEafwY15zNJt57pePF1YSBa68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=sZoY17kD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4JYcxQxc; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sZoY17kD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4JYcxQxc"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1770292565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I/EwRuAg82AwEbqE1LSk7plov6m0CejNj/9snDXX/8c=;
	b=sZoY17kDobnk8b0FJt17wl93ofw9hCcWYUg55KZtuDLpjFvmVgBtzf/vDPNoLChuIi0q3A
	eIpzi4lJ6yTCo1iHaMfbhIskaZTgsSK4O7/agFepMwxIXfNyQbR1eyPS/sn2EWZ6v256VR
	sA2T8DtP6EKm7Ntil2HsXWhiF+nHu/0Zipyjz3djjDN5GP7mM00BOG4tA/pG+zKcGVHpu+
	oUACQIRa5R8qUpKj7WlcLxrpySMTq06QkKcuXR5DhbBzwXiyAAjkOR2bv+PfmDjl4IgBmS
	OQS91FrKI1k4ZA6gzUXHsG+r3y68CpgUZZalHW5bPO50FTyQZxv+XZilJcenXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1770292565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I/EwRuAg82AwEbqE1LSk7plov6m0CejNj/9snDXX/8c=;
	b=4JYcxQxcZXmBDRBiDyp+d9caoTyzsUXouopDSf7ubc8VUmFdVmwhXlYGfVQS2n6NvbNiBV
	VCREwUgnWQSLdgCg==
To: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] efi: Allow to expose the workqueue via sysfs
Date: Thu,  5 Feb 2026 12:55:59 +0100
Message-ID: <20260205115559.1625236-3-bigeasy@linutronix.de>
In-Reply-To: <20260205115559.1625236-1-bigeasy@linutronix.de>
References: <20260205115559.1625236-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Exposing the efi_rts_wq workqueue via sysfs provides an easy mechanism
to restrict EFI firmware invocation to certain CPU(s).
This can be used to restrict EFI invocations to specific CPUs while
allowing other workqueue to use the remaning CPUs.

Expose the workqueue via sysfs. Change the name to efi_runtime which is
what will be visible under sysfs.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 17b5f3415465e..96c47dbb743a7 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -423,7 +423,7 @@ static int __init efisubsys_init(void)
 		 * ordered workqueue (which creates only one execution context)
 		 * should suffice for all our needs.
 		 */
-		efi_rts_wq =3D alloc_ordered_workqueue("efi_rts_wq", 0);
+		efi_rts_wq =3D alloc_ordered_workqueue("efi_runtime", WQ_SYSFS);
 		if (!efi_rts_wq) {
 			pr_err("Creating efi_rts_wq failed, EFI runtime services disabled.\n");
 			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
--=20
2.51.0

