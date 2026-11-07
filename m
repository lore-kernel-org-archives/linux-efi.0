Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794091380;
	b=Na1erju7D1JexQUBjn3Qa1V0HZ5xnOJaRyz67JgMNxbF4KdO3/vVS9yCXhUZWc8Ciu09
	 FYoLLznwvVOM3GKPBd3vumb97TLX7y3ovFwHUjuq6gK2zfuNlKZZ+QTclHNbe2VthOm8z
	 R8Zs7MKmFoFrvx0+qi9qRWO3p6EeliCTisIPnpA3T9sAgq+Q8X9X2IgoIWdgxb3LcmAKM
	 +JoJGzTQstVdSEYakn7VjlG5I7wp7XqlaITcHS2MHR+xeFaPgr2j/83hjZfI2V7jkcrx9
	 Jv47PdpRUltOfqggMraoQVuCEsCL6ySNTd65+ty3cMFuqdgjJFwjAJf6yAAASE2wtYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794091380;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=tiQfKsFyOHw8u3O47YSkIKnn3TyNxLXR1SdumyCP9wU=;
	b=Kot3BZfCLaImt6hTpZ7myVoUTk7al4NigogM+lBe6+slIKQwmvjcygPty2immBmWId8C
	 GtqNLDcJ+bffk0e5D6Z64hMeLRpnRwX/SrqlNTNmnU6IhQmoosxJw8o/kifflcq8Pp/4A
	 dXZp2sZPockUfcm+HB9bP4FkOiQ7WFEF/B+wWXrBTJHBqyZyaP6ETto3bzztU8nLQCcVJ
	 COGpA4xGaHELhMqnqGSZCBzufmvOgjUGhBZhXx80zFSClGMdzLTSkOpo9VFaHGAc+f4Qu
	 t3JtKn01vQICO5546MimlfT8Vc13BPNKr6rgA6Lkghmd1La5i5PzI9UUDgdZuYmmtSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=RtvRe9qE;
	arc=none smtp.remote-ip=79.135.106.119
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA6E606A326
	for <linux-efi@vger.kernel.org>; Sat,  7 Nov 2026 22:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABA6E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=RtvRe9qE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1794091376; x=1794350576;
	bh=tiQfKsFyOHw8u3O47YSkIKnn3TyNxLXR1SdumyCP9wU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=RtvRe9qE5i/jPoic9u5cS8N3Ix+J2IvjMuQzd9FvgK2R3Uc5f4aDBPle/2tyEtbVg
	 C9KW9NBX2yRs6jmNv37tgUVgzByy1mMZkVOiDQEvCiUUF1CBMP8SK088Bf/nuovbZ/
	 rCTEgUVNNlKYwymDFoVQsMaxAWgB2eQaiUINJ/GXnqanhV6azcA0EGjGH7TnBCORCu
	 ZDFoPuBh1RYY2XOn1oegXPOXa/ZQ7Euyle39ZjbynpaXvJt+ezAWxltMmhJFZryX2V
	 YYM72C/lYyCz0wx0kXrAF9OQQ8iZCe7nJqSP2YbVfVmbiioij9k64FCWUVGf5sgv5D
	 s1w7HOoni+2Ng==
Date: Sat, 07 Nov 2026 22:42:49 +0000
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
From: Birk Skyum <birk.skyum@pm.me>
Cc: Bjorn Andersson <andersson@kernel.org>, Maximilian Luz <luzmaximilian@gmail.com>, Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Johan Hovold <johan@kernel.org>, Steev Klimaszewski <steev@kali.org>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Tobias Heider <tobias.heider@canonical.com>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v4 0/8] firmware: qcom: enable UEFI variables on Lenovo Yoga C630
Message-ID: <179409136720.63533.3499513835986215877@pm.me>
In-Reply-To: <20250625-more-qseecom-v4-0-aacca9306cee@oss.qualcomm.com>
References: <20250625-more-qseecom-v4-0-aacca9306cee@oss.qualcomm.com>
Feedback-ID: 21326998:user:proton
X-Pm-Message-ID: a8236e0245e5166aee49a2ef1233446eed5ea918
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

I've been carrying patches 1-7 of this series in Omarchy's arm64 kernel,
rebased onto 7.3, for the reason Tobias gave. Every laptop we add needed
a qcom_scm patch on top of its device tree. On top of the series, our
table also lists qcom,glymur and qcom,mahua.

Tested on a Lenovo Yoga Slim 7x (X1E80100). The series takes
lenovo,yoga-slim7x off the table, so QSEECOM comes up only through the
qcom,x1e80100 entry:

- By default, uefisecapp comes up with the same 118 variables as
  before, efibootmgr reads the boot order, the RTC gets its offset, and
  a test variable can be written, read back and deleted.
- With qcom_scm.qseecom=3Doff, QSEECOM stays off and the laptop boots
  without UEFI variables.
- With qcom_scm.qseecom=3Droefivars, the variables are readable, efivarfs
  is mounted read-only, writes are refused, and hwclock --systohc
  returns without an oops.

Tested-by: Birk Skyum <birk.skyum@pm.me> # Lenovo Yoga Slim 7x

Is a v5 planned? I'd be glad to test it.

Birk

