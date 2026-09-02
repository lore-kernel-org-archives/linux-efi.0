Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2503D1B6D08;
	Wed,  2 Sep 2026 04:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788323856; cv=none; b=nEZrob38xPdXOKwPmq59QZHzWsCFdzQ2SUGdr4H6ATV9mkwqkEDnBzxbrm4L69a5dZVtp6oUVE5TzGUG75lRMH976GsiNiJnIMUOlbAdUvQdq1jPWNbkzbjBIahaMkLRBjUlQpZXRntdjCLBrItVi9RYpRivkdIWzuE1sVqaLw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788323856; c=relaxed/simple;
	bh=On8JtaYf4IImvmca0gIWh+FZoLwOzSuPZoMd2NMwLAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reWmEccKmqC9GtH7KkL6DK1VDOUGnM+IEW9j+Jz2DwB+EDDOUEG5d9klz0kAk/74rLVhPqyFKduS+H6NcQheSh3l6sCNDAJHe00FpVywtAmV1l5GyVkXc38lzU/j7VeGC8XZJdYY9GcCbgOqJK1qDXU2XVFCNUgSN+fTimpjULI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPMGKv5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPMGKv5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029471F000E9;
	Wed,  2 Sep 2026 04:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788323854;
	bh=d0e0uqOdU6NgWIr+HbAaOHv4zN/M6xLFRJQfCqtOFAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SPMGKv5bozr5rlRmDdEc63KApPccBUl+lDqSx67y6dYKhpjsJUtIX66Udoh37OhWu
	 tvRZJWjGIqaSGMOVCtAg/yRTTdJi8m6XpLYZuMzGgH6q+uW9oVmwVLLRERxsK6eQzQ
	 BwdE5c3iNvtcboLYKrJy8aSslsriFLy2wEk9C8UUYMFG7Syog9hb0bvAlHR6wAr3jA
	 8gGe6TSlZ3YZOGkPhKBQQAxE/PE9SzAO6dJTBpa5pZZumzHbFJlqm2HgQYVDbzqHz7
	 cplBF8+tul3cygh/0e22MZ6gX4FDPz9IZ1bCzJ/OM3zQsHLciKIpHVgJbtI/etachG
	 ccTifozpQpovw==
Date: Tue, 1 Sep 2026 21:37:32 -0700
From: Wei Liu <wei.liu@kernel.org>
To: Thara Gopinath <tgopinath@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	ardb@kernel.org, ilias.apalodimas@linaro.org,
	James.Bottomley@hansenpartnership.com, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Subject: Re: [RFC PATCH 07/12] drivers: hv: hv_vsm_boot: load secure kernel
 image from firmware
Message-ID: <20260902043732.GF2583463@liuwe-devbox-debian-v2.local>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-8-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901165647.3160413-8-tgopinath@linux.microsoft.com>

On Tue, Sep 01, 2026 at 09:55:21AM -0700, Thara Gopinath wrote:
> LVBS bring-up requires loading a secure kernel image into VTL1 before
> starting it. Add the VTL0-side loader that stages the image in the
> memory region reserved by hv_vsm_securekernel, in preparation for the
> VTL1 bring-up.
> 
> The image is a 64-bit ELF fetched via request_firmware("vsm_sk"). It
> is expected to ship inside the signed UKI/initramfs so it is
> authenticated end-to-end via Secure Boot before the loader consumes
> it; sourcing it from an unauthenticated location would break the LVBS
> trust model.
> 
> The loader validates the ELF header, stages the PT_LOAD segments into
> the reserved region and records the entry point as a physical address
> for use at VTL1 start time.
> 
> If VSM support has been advertised to the hypervisor but no secure
> kernel region was reserved on the command line, panic: LVBS bring-up
> is committed at this point and there is no safe way to continue.

This conflicts with the memory reservation patch, in which there is an
automatic allocation when no kernel command line is specified.

> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
> Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
> ---
>  drivers/hv/hv_vsm.h      |  17 ++++
>  drivers/hv/hv_vsm_boot.c | 201 ++++++++++++++++++++++++++++++++++++++-
>  include/hyperv/vsm.h     |  21 ++++
>  3 files changed, 238 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/hv/hv_vsm.h
>  create mode 100644 include/hyperv/vsm.h
[...]
> +
> +static void __init hv_vsm_get_sk_mem(void)
> +{
> +	/*
> +	 * The reserved secure kernel region is mandatory once VSM support has
> +	 * been advertised. Without it we cannot load the secure kernel and
> +	 * bringing up VTL1 is impossible, so fail hard rather than continuing
> +	 * in an unusable state.
> +	 */
> +	if (!sk_res.start)
> +		panic("No memory reserved in cmdline for secure kernel");
> +

This log line is wrong.

Wei
