Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207EF388E62;
	Thu,  8 Oct 2026 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791478442; cv=none; b=TMx3Ivd/PWkzR6jwsH8WNYklA9XSEA3V3d/e6aFvfux+NWE/uw7dXVp+wJrgWf7RsDnAvV74m2Zlc0PENY6g6bs1zJUFYnEY2gGnwZUpDJNc6yLFol9Lq88DVNFcTV1ejSpLTsCtePeGk60qOoyoeqdzMv89+nr6fYiImU1dHuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791478442; c=relaxed/simple;
	bh=+UNzQYO7dnhRLX0vzxUqXZhVe4VzPs5aP1oqgovhZ/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WynxH0wKx/DOxL/hDtschIdQ18IC77xcWb4Y/+w7edK8rW/ML6dV5QL3PxpdFHYwIaoA+RAPWo5bDRx51t+MlX84c+WsCF2PfWj05s/4cFqP5mjxva3bLP0fmKszKJUQaAs+ZiGR3oj5x+xxbz87fN5DR1fFgIHv8mPQ9vC1v9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndPUM/nH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndPUM/nH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 292971F000FF;
	Thu,  8 Oct 2026 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791478440;
	bh=TyfZTa3f2gwWyTpwVLKhgGLJ3RxuSeYSVpEa43oEZdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ndPUM/nH71/l2bI3Ahgg+BycguvAfQ1iFF/JOWyKeP0KPTxgS2lSYaaUwwcpv512/
	 G8NiF+OmCqePTZhyCTOVLzt9fh0c3W2ZCK8f0+hD42VIlI+hGlrhAKXwtqFqTsLDYD
	 yJtcPs52HmozfEg/Cw3ITV3S3QP5bf9AZSfqijNcn0isc/S4jFKM645ZuRrs47SYh3
	 8GqxjyotHn2+cW9q6b9BqaFwbTD4Ub3/1YQsFHIm2zU2R3tC0OPgKyPLR8lqZnGq+V
	 vkkLZX3Hz7pK0azh33LyxGQZQtjK1tpqf8hUQv3C6f6/xjO5+Gx2VbM05TXF2COF5j
	 tS4ChIn2i6yvg==
Date: Thu, 8 Oct 2026 19:53:56 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 17/17] PM: hibernate: Allow hibernation under lockdown
 with signed images
Message-ID: <asfKpInP6j8DYA4-@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-18-matthewg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008132532.1155166-18-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:33AM -0700, Matthew Garrett wrote:
> Hibernation is unavailable when the kernel is locked down, as an image
> could be modified to alter the running kernel when it is restored. With
> CONFIG_HIBERNATION_TPM_SIGNATURE, only images signed with a key that the
> kernel created are restored, so this no longer applies.
> 
> Allow hibernation under lockdown when images are signed. Images are not
> encrypted, though, and contain all of kernel memory, which would then be
> readable from the swap device or through /dev/snapshot. Add a
> LOCKDOWN_HIBERNATION_IMAGE reason at the confidentiality level, so that
> hibernation remains unavailable when the kernel is locked down for
> confidentiality.
> 
> Signed-off-by: Matthew Garrett <matthewg@nvidia.com>

I skimmed the rest of the patches but gave up for now given time and
bandwidth, and also having quite loose grip to the changes until I
run them (it's just complex patch set enough).

What kind of test environment you have in high-level, or could you
give some rough guidelines for a test environment?

I'm thinking of setting up something with Buildroot, QEMU and swtpm
perhaps.

> ---
>  include/linux/security.h |  1 +
>  kernel/power/Kconfig     |  5 +++++
>  kernel/power/hibernate.c | 18 +++++++++++++-----
>  security/security.c      |  1 +
>  4 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 153e9043058f..6b4dfe80501b 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -155,6 +155,7 @@ enum lockdown_reason {
>  	LOCKDOWN_TRACEFS,
>  	LOCKDOWN_XMON_RW,
>  	LOCKDOWN_XFRM_SECRET,
> +	LOCKDOWN_HIBERNATION_IMAGE,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
>  
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 2eb6af9226f7..639dc124c17d 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -132,6 +132,11 @@ config HIBERNATION_TPM_SIGNATURE
>  	  ExitBootServices() is called. If these requirements are not met,
>  	  hibernation is unavailable.
>  
> +	  As only signed images are restored, hibernation remains available
> +	  when the kernel is locked down for integrity. Images are not
> +	  encrypted, so it is unavailable when the kernel is locked down for
> +	  confidentiality.
> +
>  	  If unsure, say N.
>  
>  config TPM_HIBERNATE_INSECURE
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 256790aeca86..7bbef9c3ae1c 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -108,11 +108,19 @@ bool hibernation_in_progress(void)
>  
>  bool hibernation_available(void)
>  {
> -	return nohibernate == 0 &&
> -		!security_locked_down(LOCKDOWN_HIBERNATION) &&
> -		!secretmem_active() && !cxl_mem_active() &&
> -		(!IS_ENABLED(CONFIG_HIBERNATION_TPM_SIGNATURE) ||
> -		 hibernate_tpm_available());
> +	if (nohibernate || secretmem_active() || cxl_mem_active())
> +		return false;
> +
> +	/*
> +	 * Only images signed by the kernel are restored, so hibernation does
> +	 * not undermine the integrity of a locked down kernel.  Images are
> +	 * not encrypted, though, so they would expose kernel memory.
> +	 */
> +	if (IS_ENABLED(CONFIG_HIBERNATION_TPM_SIGNATURE))
> +		return hibernate_tpm_available() &&
> +		       !security_locked_down(LOCKDOWN_HIBERNATION_IMAGE);
> +
> +	return !security_locked_down(LOCKDOWN_HIBERNATION);
>  }
>  
>  /**
> diff --git a/security/security.c b/security/security.c
> index 2ee276ab15c5..5d91ca69bbf1 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -71,6 +71,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX + 1] = {
>  	[LOCKDOWN_TRACEFS] = "use of tracefs",
>  	[LOCKDOWN_XMON_RW] = "xmon read and write access",
>  	[LOCKDOWN_XFRM_SECRET] = "xfrm SA secret",
> +	[LOCKDOWN_HIBERNATION_IMAGE] = "hibernation with signed images",
>  	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>  };
>  
> -- 
> 2.43.0
> 
> 

Br, Jarkko
