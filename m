Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841F52EEE79;
	Wed,  2 Sep 2026 04:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788324218; cv=none; b=Ych7W7823L2uqyg5Y0uQQvXRDnR+X+IqAAPErn30UwcCr8ZgS4CdhtVBJpj18k8g5Z8UaNY+gyPBJYEePo3uuXNuFEI+5orCApWgRO5RehZc8R/dDfxt/zEfahpIbVnn3t1lRPsNk7sVKbcdOVM6T9AyN/bafZA9o7SAHUQ56w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788324218; c=relaxed/simple;
	bh=gE4ZuGZzmvX0JCGCTBga0lrfhUokG3/VeEk5Wm5/6Ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3GJ2VJZSN4kd95BHo/VMaGUWrq2E0i6ORV3O2dw6EHCdl49Bh/ynqi7GwJQlcXtWfyRjA/9PbamEhkj5eMpT37tAcgL69x6T93OrFwjZNp6Nn8nc8MYe07AhS2HYYRCff7vE0wuMAZ/2sFve5dM5hiTljUAonzr/0OnJvHUTJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i47CLh13; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i47CLh13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01321F000E9;
	Wed,  2 Sep 2026 04:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788324217;
	bh=0rBENult3d2A99g9KdaZLVqIItAlZRCQmLXxxn0iqPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i47CLh13M3TCcIqnF8yF3DcT5g/9GQx6f7lBIrdKYMA8hpd/K4TwYl6t7neK5SjZs
	 GNo3JgO645JQTnUMXgAeiIYd526JPjRmY2L3h+yn0+NMI4nEtcC9HtL78pGUo4pK/7
	 irOWw2yc9zK8W1sruFvTFnufCYlcTfsQk/13TrLxOY2A5w5AiMtLM7QGNyYcJQDkx4
	 J7gbyscmNL0PrncR/NAht+FGHr+yTeuMYuGrvNjmHmOemZsUZ+GOOnC84gcVTuqXu1
	 D3BtwEi1vSOK7AcS/nCAanx8FoFAM4KVh2earmemScp8CXtUr/TpYc22zYvMQ8odSw
	 3b/hBCMDzn0rA==
Date: Tue, 1 Sep 2026 21:43:35 -0700
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
	linux-efi@vger.kernel.org
Subject: Re: [RFC PATCH 06/12] drivers: hv: Add VSM boot driver and enable
 VTL1 at the partition level
Message-ID: <20260902044335.GG2583463@liuwe-devbox-debian-v2.local>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-7-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901165647.3160413-7-tgopinath@linux.microsoft.com>

On Tue, Sep 01, 2026 at 09:55:20AM -0700, Thara Gopinath wrote:
> Linux VBS (LVBS) uses Hyper-V's Virtual Secure Mode to run a small
> trusted kernel in VTL1 alongside the regular VTL0 kernel, so that
> security-sensitive state (e.g. hypervisor-enforced code integrity,
> credential isolation) can live behind a higher-privilege boundary
> that VTL0 compromise cannot cross. Bringing that up from Linux
> requires the VTL0 kernel to drive the VSM setup itself.
> 
> Add drivers/hv/hv_vsm_boot.c as the entry point for that sequence.
> This first step handles partition-level VTL1 enable only:
> 
>   - Probe VSM / VP-register privileges and SynIC availability before
>     doing anything.
>   - Pin init to the VTL0 boot CPU so VTL1 comes up on the same CPU
>     (later patches rely on this).
>   - Read HV_REGISTER_VSM_PARTITION_STATUS, and if VTL1 is not already
>     enabled, issue HVCALL_ENABLE_PARTITION_VTL with MBEC and confirm
>     by re-reading the register.
> 
> Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
> ---
[...]
> +	cpumask_copy(mask, &current->cpus_mask);
> +	boot_cpu = cpumask_first(cpu_online_mask);
> +	set_cpus_allowed_ptr(current, cpumask_of(boot_cpu));
> +
> +	ret = hv_vsm_bootstrap_vtl();
> +	/*
> +	 * At this point VTL0 has already advertised VSM support to the
> +	 * bootloader/firmware via the Hyper-V OsLoaderIndications EFI
> +	 * variable (see the x86-stub change). That signals the platform
> +	 * that a trusted VTL1 will be brought up. If we fail to actually
> +	 * set VTL1 up here, the partition is left in a state where an
> +	 * attacker could race to configure VTL1 themselves and gain a
> +	 * higher-privilege foothold than VTL0. Panic rather than continue
> +	 * running with that exposure.
> +	 */

Okay, I think this answers my question in the previous patch -- if VTL1
is not used by us, that's a security problem.

It is unclear to me, if this code is enabled, how a generic kernel can
work without a secure kernel. There should be a way to configure the
system such that not enabling VTL1 is okay. Is there any pre-EFI command
line parsing we can do?

Wei


> +	if (ret)
> +		panic("VTL1 boot failure caused kernel panic; consult log for more details.\n");
> +
> +	set_cpus_allowed_ptr(current, mask);
> +	free_cpumask_var(mask);
> +	return ret;
> +}
> +device_initcall(hv_vsm_boot_init);
> -- 
> 2.34.1
> 
> 
