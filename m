Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701788;
	b=CdtzpTxU8G0U8e6lBhcklphsfOqTx48vbQ0JseXQU0FFx2+Wk2PQ8GisxP5qyBC4fADF
	 nso1A8QObDoYZIZfgjfc8F51no7evix3g09S40g4gtylCRp0chMBbkoxFIRE1RKWvLXaT
	 cOYU8pwprdDWdqr0xlgse/IrZZnslR9tsQZh84H7ImKiIkcn3slEFNN2TYAsHDUtBRUXl
	 z8/tvlZ7Nm4nsRXuuez9be/0scXnrtSQrk4/m/5coSGqv/FS0sZycfUkmCwiLSoHYTFMF
	 zPZiaaWp8MO7c4Lnw73Q7idxQP/U6mq2yB/QqAwpm31PNlmcM+ZBhnTa0ygth1Mu/vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701788;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9OSvScGRwha8A7Tb2tHR3R5F02sXRmMamVkr8+PRTWs=;
	b=wn052scmxwX2oHtu2WXfqO0SCZiOD9HTOV8cfyk1JJGglztoU/4fyfaEA2bT51o67GAm
	 CqdtD1FcHy/LmGGpshQzae8xlSD7Mgsk7wz9hYkv8FhXWWYK7r5w9ffnGi6bHS5Xjw9UF
	 rxPAVZE7XQx6C649FgInlN7fXNrSY/iN2uGVCh7H98Znmp9xTQcADzwvIMXX2tIkHfB5/
	 h0IHvffA+QTrazEdRzjZplhR4DBAtf+9inqSalFnseHyPSHPBeX2fwT82MQoUAjTRRWyj
	 vIsvN7egUvVdlS4TwY/dbGy8B2Y2J4jOmxa1XTZLwongm8DOIxBKpgHzRQ7MuHMvbzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QQ1qfgqU;
	arc=none smtp.remote-ip=95.215.58.112
Received: from mta1.migadu.com (out-112.mta1.migadu.com [95.215.58.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C212606B12B
	for <linux-efi@vger.kernel.org>; Tue,  3 Nov 2026 10:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C212606B12B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QQ1qfgqU
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9OSvScGRwha8A7Tb2tHR3R5F02sXRmMamVkr8+PRTWs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793701785; v=1; x=1794306585;
 b=QQ1qfgqUbGhGBerxeLuJhyNk7bgr29IpB6mdUWq7I5GBjwVxZyy1/52gPaY/7kXtM0GXHLCx
 4RpcT2uiJ1ar4EFiI4YDe8tiB1L5f3BVfM1Orm01rf7eF0WUMSfamObsQPcMPJ6r1YAuC3tWkmp
 0vu1Vhi7wZbuoThW/OWjzw8w=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 129eb9b76a2afe71;
	Tue, 03 Nov 2026 10:29:45 +0000
X-Mizu-Trace-ID: 129eb9b76a2afe71
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: ardb@kernel.org,
	pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	chenhuacai@kernel.org,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration table
Date: Tue,  3 Nov 2026 19:29:41 +0900
Message-ID: <20261103102941.11087-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
References: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ard, Pratyush,

On Thu, Oct 29 2026, Ard Biesheuvel wrote:
> Can we handle this as an arch table then, and handle everything in
> the LoongArch arch code?

Ard, LoongArch is currently the only user, so I understand the suggestion
to keep the handling in the architecture code.

My preference is to keep the table definition and handling common, given
the potential for x86 to use it as Pratyush described in his reply, to
replace setup_data once x86 gains EFI support. The table contains no
LoongArch-specific fields, and only the LoongArch stub installs it. On
systems without the table, the common code does nothing.

Would that be acceptable, or would you prefer to keep the handling in
LoongArch until a second architecture adopts it?

Thanks,
George
