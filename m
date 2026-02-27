Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A898735970F;
	Fri, 27 Feb 2026 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211670; cv=none; b=dddxBiIHAxAVW79KvACVklFb0eSmyTDA6jj+sE+1owUBeI0vF0OaL0J5dZTEZurDA4u5v7PVtFisTb/JnZ7lTdy+K3qHZCXFzEvrr3/MCrs5y87+k3o08n3FCXGDioaSOHoUbOIk9CjRokIatxnIgy0MQKilSEVafidefvdz6og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211670; c=relaxed/simple;
	bh=pP0+vLPgMfHqfQbUnCgXTR7J+QeiTwq9mkuMlf6BB7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJtjqeqbrKAWQMJ6eqyQzloA13cLMMwi7qOd5gQTdALdbX2nC0ThV6a6XTdQCt+zFHvGHB1qoTc3VeP/5vSllJeS403on3xqhpSw2N9Jcoda1CycDpC2GLGRsO9WFrKSW6LntNYL5Wl0MgkX4F3G84O7Uqv3g0kE/6c18koKgNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=baA+DpAg; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6vRbr0jq; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="baA+DpAg";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6vRbr0jq"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772211668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qW7YC+NhUcGv9AiAl1k536TG+Cb4xwm5b/RZaPT5+U8=;
	b=baA+DpAgWRw5dFtv3CAdh6AW0mivJMwkcgJZGJh5kwwB9MrChHPwsh/N4Md1qtl2E6YpCh
	4wXggi7237oPKMxriPxum/+APwtZJkEcbyZ0HOaJVTn1zAA267xB8+gyK2+hHXoJ0oEvvN
	nWSrNy3zl7FWDdB3mpmg9meocmcAMGf1k1sUy6pE6t5yen87A+SQev8UmhXI3DoPGuR81D
	oTNPC4qaTAnyWhgn/9SUZwq2eV7lK4yiVFlycALijCw5TR5gu4s/UyJX+XjDEEOWWSJ3NO
	DI2bK2ypWheGUIjWVa/omi/F3Kzq17d+RMCXoS9wvLwz5O05nstZBSlYaIkQew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772211668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qW7YC+NhUcGv9AiAl1k536TG+Cb4xwm5b/RZaPT5+U8=;
	b=6vRbr0jqHvkXYWOMn0LSyJ7aJ4heJUiPNIPZISAxGhJrpPsb4FgZiYvrEX15aSR2aOFzeg
	4p1hAeIXBCY0P8Dg==
To: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 1/2] workqueue: Allow to expose ordered workqueues via sysfs
Date: Fri, 27 Feb 2026 18:01:02 +0100
Message-ID: <20260227170103.4042157-2-bigeasy@linutronix.de>
In-Reply-To: <20260227170103.4042157-1-bigeasy@linutronix.de>
References: <20260227170103.4042157-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Ordered workqueues are not exposed via sysfs because the 'max_active'
attribute changes the number actives worker. More than one active worker
can break ordering guarantees.

This can be avoided by forbidding writes the file for ordered
workqueues. Exposing it via sysfs allows to alter other attributes such
as the cpumask on which CPU the worker can run.

The 'max_active' value shouldn't be changed for BH worker because the
core never spawns additional worker and the worker itself can not be
preempted. So this make no sense.

Allow to expose ordered workqueues via sysfs if requested and forbid
changing 'max_active' value for ordered and BH worker.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/workqueue.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index aeaec79bc09c4..2f95cb0d2f1b8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7176,7 +7176,26 @@ static struct attribute *wq_sysfs_attrs[] =3D {
 	&dev_attr_max_active.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(wq_sysfs);
+
+static umode_t wq_sysfs_is_visible(struct kobject *kobj, struct attribute =
*a, int n)
+{
+	struct device *dev =3D kobj_to_dev(kobj);
+	struct workqueue_struct *wq =3D dev_to_wq(dev);
+
+	/*
+	 * Adjusting max_active breaks ordering guarantee. Changing it has no
+	 * effect on BH worker. Limit max_active to RO in such case.
+	 */
+	if (wq->flags & (WQ_BH | __WQ_ORDERED))
+		return 0444;
+	return a->mode;
+}
+
+static const struct attribute_group wq_sysfs_group =3D {
+	.is_visible =3D wq_sysfs_is_visible,
+	.attrs =3D wq_sysfs_attrs,
+};
+__ATTRIBUTE_GROUPS(wq_sysfs);
=20
 static ssize_t wq_nice_show(struct device *dev, struct device_attribute *a=
ttr,
 			    char *buf)
@@ -7479,13 +7498,6 @@ int workqueue_sysfs_register(struct workqueue_struct=
 *wq)
 	struct wq_device *wq_dev;
 	int ret;
=20
-	/*
-	 * Adjusting max_active breaks ordering guarantee.  Disallow exposing
-	 * ordered workqueues.
-	 */
-	if (WARN_ON(wq->flags & __WQ_ORDERED))
-		return -EINVAL;
-
 	wq->wq_dev =3D wq_dev =3D kzalloc_obj(*wq_dev);
 	if (!wq_dev)
 		return -ENOMEM;
--=20
2.51.0

