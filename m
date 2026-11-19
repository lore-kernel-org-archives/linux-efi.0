Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795091800;
	b=vAFQTXc+l2R9flkDkWM3BbAGo4VmE6gOce7AxkTJjYjF7PFV/HH0/KTailtc9Jcs+L/K
	 xirGaoD/jdjlGpYeOg/N9pTP7i69ho4AoxYEh3zjHffWb+6Z63/8wVHGI22QKdKEkKgtI
	 KOEmuBY1P1sfT7+w84HW+ddRiINr9R+GxtTReXTedMkTtBUhKRR4TYxyHRpqAJsjzxN3e
	 CrBJlHemFRpjJykr9No+Hfmgq8Sbew+wiwIpkYe4nQAtBSSJQ7UZ0SUDoyD3H41ODQhus
	 X3Tn2QuTZ2g7vqBH44vCGqaugh6C01bdJ61v/tNVMwJy6sUAyFwfvnnn1neJohc3iAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795091800;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Z3UaETqrvFfA005xDH3cLACWIQAJP32vQKwKRzUivqI=;
	b=uiS76yzQwN/kp2nR6v5mi8ZZDhNeeaFq15ACR1oj2sbHQGx5FTAjPBEpKxbJbKn7JYpG
	 umb/ueeDknpuLBrT6l1P1gf3bt2FwFa9knFcHmFa/9mRYeSYLkRCapG5XCkyJ775VXvoF
	 G6UP/UngcDDqaz3I9BrfDben/9dBFqkZRYU8A8sQ7IQq75jjQGqQziSzf1xFlOSqNC9RU
	 j7mAEliucsxUYWNII4CRO0gMr+1BiGFk1djPkb9ceGZcfNguwEQITZhqdivRs0iaP0s22
	 EuG8hdURPSui6YyPAoxu8tEet2gwrOm/om1h3gO7+6WJHJ376KEcY13HZcHXmK2NZeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lC6uMZzr;
	arc=none smtp.remote-ip=95.215.58.37
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5BA606A324
	for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 12:36:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D5BA606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lC6uMZzr
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z3UaETqrvFfA005xDH3cLACWIQAJP32vQKwKRzUivqI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795091797; v=1; x=1795696597;
 b=lC6uMZzr3ePKQeAmTHxIhjRO54prPfHzsGIGlwdxiRYK/x13orsA38lW/OKGvJ2UJwbnLaGu
 IJaqHUFanrC7+JPI1DpsvL2OT+FfjO6qijHirmQdj3INbUcFwvjLFj1Rdau0Gt/Mp99dF9OE8i1
 8w25qsNQUOiPVzeU3R/Bc0xs=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 22a63bec1e9ad1bd;
	Thu, 19 Nov 2026 12:36:37 +0000
X-Mizu-Trace-ID: 22a63bec1e9ad1bd
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org,
	ardb@kernel.org
Cc: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
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
Date: Thu, 19 Nov 2026 21:36:31 +0900
Message-ID: <20261119123631.11165-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2vxzecch3x6k.fsf@kernel.org>
References: <2vxzecch3x6k.fsf@kernel.org>
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

Hi Pratyush,

On Thu, Nov 19 2026, Pratyush Yadav wrote:
> Do we even care about non-EFI boot? I'd say ignore that for now until
> someone comes with a real use case for KHO on such systems.

OK. The fallback is only the existing setup_data path, kept when the
table is missing. I won't spend more effort on non-EFI boot, and
whether to remove setup_data can be decided in the x86 series.

> This should be a follow up series. Don't get your series get caught up
> in x86 changes.

Will do. v7 will keep the table common with LoongArch as the only
user, and the x86 patches will follow as a separate series.

> Sounds good to me. You will still need to chase Ard for an ACK on the
> generic EFI table though.

Ard, you asked whether this could be an arch table handled in the
LoongArch code. Pratyush would like a common table that x86 can move to
later, and the x86 prototype above used the same table without changing
its layout. Would you be OK with keeping it in drivers/firmware/efi/
for v7? If you would still rather have it in arch/loongarch/ until the
x86 series lands, I will move it there for v7.

Thanks,
George
