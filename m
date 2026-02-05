Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914D83B8D41;
	Thu,  5 Feb 2026 11:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770292566; cv=none; b=jcygnRKah0adfpunNNtIMRwyNepmfeqEjEJ7nfpt+ssynsbJaI8WL3R6r2FI4QJ22zkyxkLCJPUK1IMH6QVsAsaaY00HCiPjBzSCW2LB4LYQHarjNRbJosfWYVmzLBFKZ164oB5OdTU8W08cEhfXjfuBXGMhjImESR0yg+N16/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770292566; c=relaxed/simple;
	bh=ttSGUz2fuwp529FZBLh9O7eZSSXhGf8AfA6AB2xbx7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHJ3Y7AW8zoKen7sT41c20Pk969vS4Ah/gK3hHMo5cJRirMklKFHWEMv9yNkORPZ6LxrMn+U3ggJznqpnvDfud8zRCDi2n+4fCLBb92S6gV2mRThV1Q1KIsabn/k5NlOZRVIF0zjr7JjnJCVOxP0GNJMS5+DGhrEhnzqpZwG/YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ApR/n61y; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ze9LaSyo; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ApR/n61y";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ze9LaSyo"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1770292565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LEBCC/jyHo5W95P4/Ry1IDTEPnVSLB+yx4Vu1+vBMT4=;
	b=ApR/n61yEJzFncuaw3oMsWQxRh7hKTgM8adJK8xeQwJkGQApnmdnLI52xxPH2goChl0E3K
	Y9MDj3j2K3oFJbw1r0PBJDKLvdbK9EHEtvz442sCCwL3L7Qv64kaKNJyQI7l+qiXhzUZ4y
	iTVN3om5dTd76DlBozV+4tMghWNypkI74z3sigCA0QfUVI5xCBMh+3AiKeMd6kc3QGv+9v
	XB+ydZ9NqkdOWhlncMu+YC7loolyEJ9oY+javPXWvoYvD0vs9TtysOIis6DiuZTrF+qNUh
	Y+OHqJLCfUG9k5n1yFFeN+8AO7YdQ6w0ykOS2QFMI/cIGeavz8SL45BZzwlTUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1770292565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LEBCC/jyHo5W95P4/Ry1IDTEPnVSLB+yx4Vu1+vBMT4=;
	b=ze9LaSyoMKBHyI367WG5Yr7hmWueb3RHrGbkHwziyRmTcNzxBWFdB82F+7rklG5nlu+pLK
	IPePa0IS3g4hGqAw==
To: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] workqueue: Allow to expose ordered workqueues via sysfs
Date: Thu,  5 Feb 2026 12:55:58 +0100
Message-ID: <20260205115559.1625236-2-bigeasy@linutronix.de>
In-Reply-To: <20260205115559.1625236-1-bigeasy@linutronix.de>
References: <20260205115559.1625236-1-bigeasy@linutronix.de>
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
 kernel/workqueue.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 253311af47c6d..625ee8cc47f40 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7097,6 +7097,13 @@ static ssize_t max_active_store(struct device *dev,
 	struct workqueue_struct *wq =3D dev_to_wq(dev);
 	int val;
=20
+	/*
+	 * Adjusting max_active breaks ordering guarantee. Changing it has no
+	 * effect on BH worker.
+	 */
+	if (wq->flags & (WQ_BH | __WQ_ORDERED))
+		return -EACCES;
+
 	if (sscanf(buf, "%d", &val) !=3D 1 || val <=3D 0)
 		return -EINVAL;
=20
@@ -7413,13 +7420,6 @@ int workqueue_sysfs_register(struct workqueue_struct=
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
 	wq->wq_dev =3D wq_dev =3D kzalloc(sizeof(*wq_dev), GFP_KERNEL);
 	if (!wq_dev)
 		return -ENOMEM;
--=20
2.51.0

