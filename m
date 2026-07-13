Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933F033B6D6;
	Mon, 13 Jul 2026 10:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783937045; cv=none; b=ITgebZOP5B1KvMKarE3toHEC/YW8JV2rRa7/7dya7kuQFYNYcl0EekGBMgYkM7r6M7y2Mm3QUUb8T2gsdiqnZnBhB4bOQbSf6Jbb1/nky9gFXecSEikCPfFmhFWGaKZPEsZs+RmplmEFHglSS3QNY5J2bjYh1Hi3gsfDyCW30nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783937045; c=relaxed/simple;
	bh=6q/Fa/VhVWZwmoITXKFBQvsKkCdqEAi5WRJQxA2BrpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9hlYIo2QgFhbBNSIHWSFiJoCYQ4llm5B8UHDtMGI6sxxeVq+Kfwh6A2uML/PV5+kckFjxHWoYZvCgJzIJ9iyLfisFnq0LEf4ubE5HKZ/gjkBdqyo5G61J9eLw7kxEBz/SjFowa7dqR51IIaxT0UcOfxrnabHCghXRGie8jcLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=RGQPkl8g; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="RGQPkl8g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DB5yYcs7diTyQraUqj8923wLs3Sor9xAtsOctSgLg1k=; b=RGQPkl8gtpQxyo/tQuzestu/FO
	4gWLeySNTaDKyJmSojgT/nMiDpVLHIJbUDVwRq8gRFYDhLMy4eZBnEideNktohC4yRml9zjpsg8uL
	BMyjAH4PjtOUl2Gk19N8dADQa8lSvV7NvR3+/mjcJdQB+f+c/3lS+Y4tLKsgQhM3D6q0gCImiCpU7
	g8OH18L++tvjIqORx4OFgom7qWB++6eY1S9mh0gNGt1icJZSPkNTzU61uqmWbi5+wLlEKl9A7Imip
	zeLdZ4QXKBTdRoB0EuQN/NfZhMjYaM5+Iu5HqDNHnqHBP+u7LCdycUf022zkPOkBK5xnl0Q5VX972
	PQ25ESTA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjDVT-001Q6g-2W;
	Mon, 13 Jul 2026 10:03:24 +0000
Date: Mon, 13 Jul 2026 03:03:18 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, 
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Message-ID: <alS2izWImqj0N_IZ@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com>
 <alDJNWZdBpkIZrcM@gmail.com>
 <alDMRabP9s6Pqhxq@e129823.arm.com>
 <alDTjHtL5Q4ormKb@gmail.com>
 <alDW8vjjU_f7dkIK@e129823.arm.com>
 <alD3ZFgfgMj0_qoT@gmail.com>
 <af81fe18-d246-4bd7-b32e-c61ec2e7c856@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af81fe18-d246-4bd7-b32e-c61ec2e7c856@app.fastmail.com>
X-Debian-User: leitao

Hello Ard,

On Sun, Jul 12, 2026 at 07:25:19PM +0300, Ard Biesheuvel wrote:

> > Sounds good. Let's wait for Ard's feedback on the additional patches
> > [1], and we can decide how to proceed from there.
> >
> > Link: https://lore.kernel.org/all/alDDv3XGXVdd1mri@gmail.com/ [1]
> 
> Please send patches against efi/next, I will apply them promptly. 

Acknowledged. I'll rebase the fixes on efi/next and send them shortly.

> UpdateCapsule is a special case that we can deal with separately

Understood. I understand I should defer the configurable timeout work
for now.
