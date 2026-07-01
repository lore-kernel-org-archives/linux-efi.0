Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4908C48122F;
	Wed,  1 Jul 2026 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782908937; cv=none; b=Adr5NQcXJlUT7y6XTmFZyxQgZ4ugGYcSL5x7u9MkOb7gbW0qJFoTRjH6lWJ2EqodJlbV/2IUEoEd939iUvSBKRD55UKPdQCD/RDCZuwUdR+oJfswnRy2w130vbB4yQpAmBECmb1aaxUWs/wBb87eNqViRL3ibUIiYTgPchsp2XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782908937; c=relaxed/simple;
	bh=TK3qhBqXPFQkdvrehT/7reUcAkMOQBfZh1fJb/UJn+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlmYq0JPs8ZpJeqTMJirNY8Y3naL+ZnbAIaCpZmjkMAUv48xjUn4vC85vcB3jg9EESxeYl15c8fh5hJ3/hbrh1kDeHW7MswVmZ8bwe/fD/HnJUbz8ptckaWm8QOHgI5qPtMy0tT3uxX2Cta/1Z+EqxEII0bJocOSOddkpApEbHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=ivjMgpIY; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="ivjMgpIY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TK3qhBqXPFQkdvrehT/7reUcAkMOQBfZh1fJb/UJn+w=; b=ivjMgpIYc1U1j0IwchiajTTaIe
	unEcYIlCUUnQiroyCpUu5aKN74qEg/M6vkSMKYjTJdPfE3S09IkMY+AdB3vHBq8AYbwVmqaxJvuXW
	4iuNglvMbv1jVusL7AHL9wxRJQwNOShJXw00vBsbwAzmT6lzYUIvDBpZeUMG3LkxVAMK/UH5swGJN
	BDCvMHJw1mPQAnuh90KMM9FqcDw7Lw2PAMNNZFgVqXxZr6+lI1Odq1BBv4xmpmudVjG0M6vL2zpx2
	8ejnFostuyMM2P3l5V7+1lqttHxzpMP6tgKXHLiSIoQYIg/oRd0fiIMV0osnsOB/Robjt5np2ijDA
	uFzv1rSA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weu3c-007q64-26;
	Wed, 01 Jul 2026 12:28:48 +0000
Date: Wed, 1 Jul 2026 05:28:42 -0700
From: Breno Leitao <leitao@debian.org>
To: ardb@kernel.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <kees@kernel.org>, 
	Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 0/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Message-ID: <akUG8giyFn2a3Lts@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
X-Debian-User: leitao

Hello Ard,

On Tue, Jun 16, 2026 at 05:09:33AM -0700, Breno Leitao wrote:
> When an EFI runtime service call hangs in firmware, the kworker on
> efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
> The kernel currently waits indefinitely on the completion, and the
> caller holds efi_runtime_lock for the duration, so every subsequent
> EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
> handlers, ...) is wedged until reboot. The only externally visible
> symptom is a "workqueue lockup" message and userspace processes
> piling up uninterruptibly on the semaphore.

I'd appreciate your thoughts on this approach. Is there anything you'd
like me to adjust or improve before we move forward?

Thanks,
--breno
