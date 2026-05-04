Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B4A3E51E8
	for <linux-efi@vger.kernel.org>; Mon,  4 May 2026 18:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777917747; cv=none; b=RvP8uGLVO3803+04z0qxZ40TUHwZ+8tRwzM9Kj05JNjS2cL+FHMqPxOmnmSPqDrZYAjumoqP0XsIL9/avn8w9MEzqXBMRS0S8Q2pG5lpPlxBp8nPxCUc3a8L+iXgjrj7NV2VcKstUb7i365SCHtPHMzww4Y8wiFnya57KCfL9SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777917747; c=relaxed/simple;
	bh=Y8jHW+aK9aDO5zeN5JSyvy6EYZDn8ZqmpofbPMv6h+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0n6ci6xoSDFd00JnCB9jcHDZRWZmKfmgLVT+nf2fGKro/4yG1+msaioOILFJ9w3vks1xteLnuR3zkbl1mk6Az7O3JJarIeQC+54IF71SMNVtuDsfRbQe8w77mmQhGhtH0ACK3Ao8PS6gByBSbY1lHUAVB3+dVpW79iBgb3wFhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMQTGpJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMQTGpJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1382EC2BCB8;
	Mon,  4 May 2026 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777917747;
	bh=Y8jHW+aK9aDO5zeN5JSyvy6EYZDn8ZqmpofbPMv6h+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AMQTGpJLWgUKMFnX++xCPkSjE8AsOybKpRcoerSZqkbCyesMQgdBRTMZVbsYcQpjo
	 pvjhUj/dzKl44WP2K2BYftrXTEHVp7lYv56YV8BTneXFqu/R1hOcKTo9d/vWG5m82i
	 xCJ9n7HptfDiX1g9tA/b4jARtHs/GOrJoFNrYXRjedQem4nTuzcFXlfMglV76aenpJ
	 aoIA72GXEM3I9Xlngj/hUJ599Ug91aCF+I7dgqjEy/88TyZtLLFv8ZBtOIi6RtuJGj
	 k+PQmDrLDrVIyUQW1w1bPNQyTJl1vQzPZdrCuAnxDojRmeLSDWBsM/4mYH7cv0jHf0
	 Sd+iAKgMWsusg==
Date: Mon, 4 May 2026 11:01:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Ivan Hu <ivan.hu@canonical.com>
Subject: Re: [PATCH] x86/efi: Restore IRQ state in EFI page fault handler
Message-ID: <20260504180107.GD2291@sol>
References: <20260501090311.2483809-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501090311.2483809-2-ardb+git@google.com>

On Fri, May 01, 2026 at 11:03:12AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The kernel's softirq API does not permit re-enabling softirqs while IRQs
> are disabled. The reason for this is that local_bh_enable() will not
> only re-enable delivery of softirqs over the back of IRQs, it will also
> handle any pending softirqs immediately, regardless of whether IRQs are
> enabled at that point.
> 
> For this reason, commit
> 
>   d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
> 
> disables softirqs only when IRQs are enabled, as it is not permitted
> otherwise, but also unnecessary, given that asynchronous softirq
> delivery never happens to begin with while IRQs are disabled.
> 
> However, this does mean that entering a kernel mode FPU section with
> IRQs enabled and leaving it with IRQs disabled leads to problems, as
> identified by Sashiko [0]: the EFI page fault handler is called from
> page_fault_oops() with IRQs disabled, and thus ends the kernel mode FPU
> section with IRQs disabled as well, regardless of whether IRQs were
> enabled when it was started. This may result in schedule() being called
> with a non-zero preempt_count, causing a BUG().
> 
> So take care to re-enable IRQs when handling any EFI page faults if they
> were taken with IRQs enabled.
> 
> [0] https://sashiko.dev/#/patchset/20260430074107.27051-1-ivan.hu%40canonical.com
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Ivan Hu <ivan.hu@canonical.com>
> Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/include/asm/efi.h     |  3 ++-
>  arch/x86/mm/fault.c            |  2 +-
>  arch/x86/platform/efi/quirks.c | 11 ++++++++++-
>  3 files changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
