Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750CE3DC85B
	for <linux-efi@vger.kernel.org>; Tue,  6 Oct 2026 15:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791299695; cv=none; b=ekbWzQEMTAUuJiSeOfj4rQ4MMxT1MFyWvcEQbMg5vwLunYzYuUMSn6nNJzLAu7THKm3M76mYCsvaQSYlC1/ua0y5noRCEI7M2WXwOK/nouqbgSzLE4I+jNBLeKTaD/l6JY9C827Kn/G2ELd4N4+YYcmrKn4DuV1zq4fSqgpfBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791299695; c=relaxed/simple;
	bh=nrpoUjeGhXa3Jx6nQrwBvc6YjkiO96rVglBerQeILKs=;
	h=MIME-Version:Date:From:To:Message-Id:Subject:Content-Type; b=T2voRMyqMMg3QG9JObWGUfp83um079g83NAYZgDQa+UiA4NW6X5Olbh5RdAt36Wq03Q2KVs3vK11KFLl1EHYhtQGOfHi6UQRzSRBny7sxtFVCkrUPGO5+ZGLgQKBpQmjrLLDP+KNDQOCInEKqlQFE9AZvnAGp5BI8MiD+6gOwRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wolber.net; spf=pass smtp.mailfrom=wolber.net; dkim=pass (2048-bit key) header.d=wolber.net header.i=@wolber.net header.b=es/4M4p7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kYzDHpf3; arc=none smtp.client-ip=202.12.124.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wolber.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wolber.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wolber.net header.i=@wolber.net header.b="es/4M4p7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kYzDHpf3"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id C0ED5130098E
	for <linux-efi@vger.kernel.org>; Tue,  6 Oct 2026 11:14:52 -0400 (EDT)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-03.internal (MEProxy); Tue, 06 Oct 2026 11:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolber.net; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1791299686; x=1791306886; bh=nrpoUjeGhX
	a3Jx6nQrwBvc6YjkiO96rVglBerQeILKs=; b=es/4M4p7L48TZi0rOQK7DCLqAx
	e3t+pJ6IcbLmok1HFzqJd9V/IuujTjl0yuWJQnEOztg1g+YiK2Aux9u1Rr5eo85g
	hnVIZZmehyGgvygArQ+AHG132EYKfX0xAjLc2URwnrFcQFABk217tgheCWNePor8
	hDMl/FhKo7Yv+FUx7LZkC/lw8WPEZw8LmLKCRHOK6GlNdE1c10lz8sgGTIR5nRf6
	DydIzFbzq5j91W6qvnr6wuLiHNRhQu0DIEe38HF9YD27gc0Pll9PkRqoZ4MArChf
	hcRI0Tb7D2jVJwGoFEZMXivfX5tJer4kDr3cOpOYlI0bjCKyURs36T9e7SXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791299686; x=1791306886; bh=nrpoUjeGhXa3Jx6nQrwBvc6YjkiO96rVglB
	erQeILKs=; b=kYzDHpf3THRnM2zfN5O/hsIaFhd402s5TeiYovsBwwF7PWege5M
	LyEhlazPavsDx56AlvU2tD3uONqYdqif6rRwyQgGMTIEeVgjH8ycsokYER9PkpGa
	F90xTjStRDUUv8HK26TeefwT2gkA28Htnh12Xyr2X3r+0t2Ah0GbQvSltI5DnUDw
	1wXCE/LSPx59wOzbTi3QRjDgs9r4064KA9qmjibGopLEWKAzIgxWGBqIcdiIrK14
	/Qtmg3i/KQ8PEK+XuTG11xweUDQCxxcWkJ1NNkyyPvhVgA6GSlC9xxU/Dl7JgeoU
	wzUb0+vXHcojbrUl8K7I+OB2ATbD37P3QIw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=wolber.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791299686; d=wolber.net;
	mf=PGNodWNrQHdvbGJlci5uZXQ+;
	rt=PGxpbnV4LWVmaUB2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:I+HXeOHLp135BxwPG+QhtejDfrPxX/Khnk5yYRJvwojQwiz
	QUcNjJ+In/6zP5wI8rBFj4a2lP5BcCax8SNbrYC8fKyXNhlN/9H40DU4hXEQghpT
	U5V1jeRS0rzlC48T1FBm+jzImyOPGeOYISVDSglcV3G5gql1rd/9gfGdHUqQFaB9
	95NSXQu4xtB95Xxo8XWKFePaw5aQ+j1WGVI+EBHrewMslR6air81//KqSadvSAbi
	cPURvZohizwbL+Ux9+vViR5hv8bf0R5QiU3RIvZHlAwIFBn4Uq5kF5H0CiS75Xhl
	UO54OdIlob3hnMdfq6VmoCc9/nxHQSEuheag/Fg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=content-transfer-encoding,content-type,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:WChpd7i0wHWsLYVItBldyt7OGlmrwUkdH5bDeWvy/MI=:nrpoUjeGhXa3Jx6nQrwBvc6YjkiO96rVglBerQeILKs=;
X-ME-Sender: <xms:YxDFatoBAj23ZS8XTzksOuL38eDSs8mFdmEukrGIudgVPEvOaTa69g>
    <xme:YxDFaqd5C2Ql363Q-q5IqMaRrgHfxzmU17k1_8PV6_hl3qHRss3vvrJlpE_Ma6lBP
    r3PZK8wS4MAXYGLiZWF1EFOdNizLt29VJo_e8cpsBfPQ7g5YvIOqZZu>
X-ME-Proxy-Cause: dmFkZTFy8oI7AfTvE04zGVwLG2tUuj9jaUQLHwirElC4ORN1NUE3+pb2NAW9hifkaPD49+
    eBAKpjh7FWCdul/sTjKKD1DMtJwrmP7oEb2aeN9euV0usbkhzB+gW0OZUSaU1UoOE63K2W
    2A5GHMDlYXtC9ffCGK4i5sZ8go7hdnVmEpB50EmhywySR3j2zlBvpv/TICjGdUK8iDRMhc
    IFOWmsVE4QTzmLt70dv/inbEdSr7GZnbfM5EsufFPTZt9PYMnsi8oXvlUFTnYBnI67aNyc
    1FMRHLLaI2EjmOZ58qhHuA4DYVOdrcgUX8JsgRJSiioxtIWZHxgic5kc/iX7fgA/0y5DHY
    3s9LU2iPyM3WvY/K3YlTYQcOX/Cf548eNMR7pyTwiKKSbAzb5zTJuWPRYcpdTW9Z7l+WNv
    +C0S9saqoSn/GRNrFysG673VPazpNCpEhMENIimWbccBR8IjNJprlfRHtdpKsiQYs9a1lT
    TO31/Fru5z60I2pUWx9M48KGp4mv5Z9Rrwns3//zqAFU2Tt7x00yD9XgyvDWtfXD99agfC
    7gqEzHj3czAvT7aklQCCEYdlKaYO1mAFYGNWVbpTjoS+6LhmFL31LxBE3fOZjt4tX+4TyA
    LZdWz6uPxkM/yJTfp+Sqa8TOYpRhFNn/Xvl3qZt5m5RDV2ZSndKUlp0XC9cQ
X-ME-Proxy: <xmx:YxDFanzlpFSU09mL-fr1Xsr4D0B7gJrPmAGWBKA-e8tqECSxiVUZaw>
    <xmx:YxDFagw6eggw4BhdTV9snjA_9TCnMxK-ZuPVXH1BPDt7zBKd-ggL0Q>
    <xmx:YxDFap8NWgxE1yZY2NrowQzN0-3Aw96xR_1o5UrAP4E7TeVTO7P9Cw>
    <xmx:YxDFaji5geDStHerljuenqt1kmVRnyNiPIzks_DqiI7Ko5j0nK2GBA>
    <xmx:ZhDFagkMfsZ0OZvmIUTBeTItShUtN5SnOoEpMLpcKbkJqKrkBr8cSAuS>
Feedback-ID: i5cf64821:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B59CB18E0071; Tue,  6 Oct 2026 11:14:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A8p1gvDKPv03
Date: Tue, 06 Oct 2026 15:14:23 +0000
From: "Chuck Wolber" <chuck@wolber.net>
To: kasan-dev@googlegroups.com, nathan@kernel.org, akpm@linux-foundation.org,
 anton.ivanov@cambridgegreys.com, oberpar@linux.ibm.com, ardb@kernel.org,
 arnd@arndb.de, bhelgaas@google.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dvyukov@google.com, hpa@zytor.com,
 jinghao7@illinois.edu, johannes@sipsolutions.net, jpoimboe@kernel.org,
 justinstitt@google.com, kees@kernel.org, kent.overstreet@linux.dev,
 linux-arch@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-um@lists.infradead.org,
 llvm@lists.linux.dev, luto@kernel.org, marinov@illinois.edu,
 masahiroy@kernel.org, maskray@google.com, mathieu.desnoyers@efficios.com,
 mhiramat@kernel.org, mingo@redhat.com, morbo@google.com,
 ndesaulniers@google.com, paulmck@kernel.org, richard@nod.at,
 rostedt@goodmis.org, samitolvanen@google.com, tglx@linutronix.de,
 tingxur@illinois.edu, tyxu@illinois.edu, wentaoz5@illinois.edu,
 x86@kernel.org, peterz@infradead.org, sashal@kernel.org,
 elver@google.com
Message-Id: <00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.com>
Subject: [PROPOSAL] Replace gcov and kcov with llvm-cov
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Stemming from some hallway track conversations with maintainers at LPC
2026, I propose replacing gcov and kcov in the kernel with llvm-cov.

llvm-cov instruments at the AST which enables precise mapping back to
source code regardless of optimization level.

We have a set of patches [1] that implements kernel based llvm-cov. They
need to be updated and some additional patches are required to address
some stubs that are missing noinstr annotation. But otherwise I should
be able to send a full set of patches (including taking on the
maintainer role) to remove gcov and kcov and replace it with llvm-cov in
fairly short order.

If there is a desire to take this in pieces or implement other
intermediate steps, let me know. Otherwise I can generate a monolithic
set all at once.

[1] https://lore.kernel.org/lkml/20240905043245.1389509-1-wentaoz5@illinois.edu/

Thank you,

..Ch:W..
