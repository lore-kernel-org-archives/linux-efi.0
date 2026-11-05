Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883432;
	b=pK4zQRGCR9Y0lkjpL1k3HIndSy3wPllCr9w+2wqdwapH8NW/cZsJOw2mBloOmhvnR7g1
	 m3Tn8kDXj0nGmoestCmk8HJCNN/gInEfXpDaqiaiT0At4QS1Y9jkKp18xdzcHWVVYcHEK
	 KbAbiqcTgvGmbIKMU0eE4GjtPxu8cTUAwqnUbCh3/o6xowCpqKTjQTVqPbIovodo85ajL
	 sxYycX/Lw8Byvm9mIrepsg3PYY3DIBGLH6sdqS+UO/ix1IiLxzbiQHERqCNTL8BfnRx8J
	 F+4QKO0iP66+32bUxbrLvx0iWZUeQihAwx08FVOyAZ91HwKWPDCfkk0RDwdF/k/tL4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883432;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ReGNOaOBCMvIg7gK/G7qltHWui+c1mv7BQpRUdRVU2o=;
	b=Zg5Hxj3Dq18zm9giVmWCbGcII4+sNTJjY+Jgy/+YBjL6zudBFfiMwWIRbCGpoMXrj0dp
	 2M+eSOK7wLsvKOSapMz3WLWNwUiDtRuYnFMm2rWzox44vAClkuo1Pj0AJO+BBJmrkqpkA
	 3n+A/fm7a4ykZx/WRhL731NFKdJqM/GFPncz2LJZqy1KwTSVwbf0yq1Y03QNcrGsN+K0L
	 Dbv6A2EaGS0dKPrNmrHpZdMjqUWi0DMJM+s+i3Ft0gRZNRUMSyOaUEpkbImSBB9LLsrCA
	 TZx0VY6R5Eu8G/p2WG99TIdKqZY/8auI+HBhJcAdTsOlVlAPA5/ZKRqTpk7llxQb9oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dxKzc6mj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92843606D827;
	Thu,  5 Nov 2026 12:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dxKzc6mj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010D61F00A1C;
	Thu,  5 Nov 2026 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883432;
	bh=ReGNOaOBCMvIg7gK/G7qltHWui+c1mv7BQpRUdRVU2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dxKzc6mjgpEI/gtpOZyuQeLjQvddHurnQsGDoMpXnjknrfY2hKAiYfqUmgA557koH
	 e7jmaCP+YJaAZRcy5orhOkgHcEFid9SLfIXq5prOVlqYQVEZZwtmz9vUtd5273iQxI
	 UKxAfeO0bjeO9WLaog9V0U61zMaIpiIZ7UeSyqBH9eym1B0XA4KlbnQtdJ0bW7qW6B
	 Z1EHYFW28+7LtXyj9olREmKA7WH/g4bDfXZqlXZTqiELFDFk2194EltzQCAk3l7bUi
	 BrmfDnlOnDQgNxM40UatpYAMCFdANbrAM6XbiFTbSkp5ZSQsr91noJlmtNvMpPf0XO
	 IQZ1KqUo2KWEA==
Date: Thu, 5 Nov 2026 14:57:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, chenhuacai@kernel.org,
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org, baoquan.he@linux.dev,
	ruirui.yang@linux.dev, guodongtai@kylinos.cn, kernel@xen0n.name,
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
Message-ID: <aux9Hm0QFJLUDPWv@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-6-dongtai.guo@linux.dev>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029172956.20791-6-dongtai.guo@linux.dev>

On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> LoongArch never calls memblock_allow_resize(), so the reserved region
> array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> (INIT_MEMBLOCK_REGIONS + NR_CPUS).

This might be something to fix independent of KHO.

Huacai,

What's the reason LoongArch never enables memblock resizing and why it
defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?

-- 
Sincerely yours,
Mike.
