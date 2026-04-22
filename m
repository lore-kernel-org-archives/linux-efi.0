Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3903D3CF05E;
	Wed, 22 Apr 2026 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776860757; cv=none; b=ddlfv9qmBa/xXcaE8wq7xCBjbN4HGcEhQJfwO/zyobT368sg6TnX8DeZ6iBJMgHgD+p6SnD9COvi9KS8aqYKlanwGMVtw0vD+l48HonAu93UZHm+pe2srE+sVmpV+p3QLaK6WCgjUgYzgooeJjXLqquk9TU+1wQ77tkg2IRmbpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776860757; c=relaxed/simple;
	bh=zURasJ/Vs9JBAkVLWIaKbawf7yugmFP6uNm6J2qZmnw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GCTLszIgkLXJpq+zt2CJD96ZNjYnu9csxRNWNtcI1PRQUJ3eQCRG3fxCqy1idE8tMPCZ05iFHA1bVUKR7K0JRm8u96cxtay3LTCtBrreELvLZSVxIRpw/R+FcuNqhYv+pYhRGG609imshpSw9jIloGbr4SCDpSs1RJdJ0HfiNqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DdrWwAbn; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DdrWwAbn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776860753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UQA3yfFp9K8VCBHP/rywmVPN24vU0SHxx081GgV26OE=;
	b=DdrWwAbnBmAaHhxYj4DAHWbCaek26d3wEIH2Fcs/BVdhHVmxk2P/nV5YffS967oGonarAz
	pmqwfS/TJr5mNMTWtyVC0ipEBjFunhY8Heg+sgJQuiqen0MWSAYI+vXj/jmRcMRVRJbIUz
	NENbT8iqHzi4qTyk1qtL9pgNcbt8qkA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jeremy Kerr <jk@ozlabs.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] efivarfs: use QSTR() in efivarfs_alloc_dentry
Date: Wed, 22 Apr 2026 14:25:27 +0200
Message-ID: <20260422122525.99460-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=725; i=thorsten.blum@linux.dev; h=from:subject; bh=zURasJ/Vs9JBAkVLWIaKbawf7yugmFP6uNm6J2qZmnw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkv9pne3xITeE+jutB15xyrnLUutzfc4ZUUV9J+tHtba MHDNvc1HaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRy+8ZGd5GaJ9akfa2uI3j Q0th884f4bvkf62JWpPmkpLedtXkUhwjwz3/qZZ3Lu3Q85SrrkmZV7Eh0I/XYeNB9h/Z/kHyj9d 95QQA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use QSTR() and drop strlen() in efivarfs_alloc_dentry().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/efivarfs/super.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 1c5224cf183e..95a685f022e6 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -192,12 +192,9 @@ static const struct dentry_operations efivarfs_d_ops = {
 static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
 {
 	struct dentry *d;
-	struct qstr q;
+	struct qstr q = QSTR(name);
 	int err;
 
-	q.name = name;
-	q.len = strlen(name);
-
 	err = efivarfs_d_hash(parent, &q);
 	if (err)
 		return ERR_PTR(err);
