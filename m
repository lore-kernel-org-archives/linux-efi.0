Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF01D2FFDEA;
	Wed,  2 Sep 2026 01:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788311779; cv=none; b=ZiW+lrnxX7+9+iBDBgHLVkVD9NF5VP03GDHhkRnod0pc8WjdE3s5epybXgFBeF0zn96F8juObDPp4dRb/OvjyaZgdYhdFoxKy/6lEkqvDrGQmdbiLdfFG8TkNuRbjVf/keM8Urx1WGw6pCnufGjsHHQ/Ef7x/rTW9wU+xyjcCJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788311779; c=relaxed/simple;
	bh=ZAMUHon1gs/wG9bddYmFDKbb2l9r+Vy2DBxCzLCRD/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZSa7j0uc2OrKtnifrFFsDGmKlQZ5LUl+DVfRSk8MoFqs17xVkI29YIJbwVJV3DBGyhf5iv8KS0oAgAVDUrhESZTq/2W4BFBeMSFf0NRwrmBUk2KIsn5YXCXrkI6qVDYhBKym8uZA7XA5Xyf5cMRkbKWRWy8DoUEOO6BSNCPfT9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qs9uMuDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qs9uMuDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1433A1F000E9;
	Wed,  2 Sep 2026 01:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788311777;
	bh=+MvqVmQTfTFOdXNNlT1ynolKBRUcZbyluA/ExFj8JmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qs9uMuDliiVDZr+pN4S560jdVcQIjVnbsj0NgtgNKWi1ZXk2AriMzlYM5w/ko7liN
	 d1KkWoHrJTMm9fGd+LSIOXo+j8zA6BP82ZDqQITRDJ9wOQ5QVX8JuLxXJAwUX1yG/G
	 O4pl0ZqkFXaWP0+q06Btl6YYKmeDZc51gwzJjCAxvJ5IQyG2iwW4OhrPi6FVfANd0b
	 TVwJBaQRvNwtbFvHbAraVKheU+Ft10zcRGtUeHQzwV8j/PYUTiV1y0wuHAoGvRwDIJ
	 fKToq4IXj5O1VO6p5JfE0fCEyNsQvrZ+2PfSQgOVvxikgtczyWusE3GkEfIPJFuUsu
	 ya7vNZHzstvDQ==
Date: Tue, 1 Sep 2026 18:16:15 -0700
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
Message-ID: <20260902011615.GE2583463@liuwe-devbox-debian-v2.local>
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
> +static int __init hv_vsm_boot_init(void)
> +{
> +	cpumask_var_t mask;
> +	unsigned int boot_cpu;
> +	int ret;
> +
> +	if (!vsm_arch_has_vsm_access())
> +		return 0;
> +
> +	/*
> +	 * Copy the current cpu mask and pin rest of the running code to boot cpu.
> +	 * Important since we want boot cpu of VTL0 to be the boot cpu for VTL1.
> +	 * ToDo: Check if copying and restoring current->cpus_mask is enough
> +	 * ToDo: Verify the assumption that cpumask_first(cpu_online_mask) is
> +	 * the boot cpu

Can we get closures on these todos?

I see a bunch of todos in other patches, too. It would be good to close
them as well.

Wei

> +	 */
> +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> +		panic("Could not allocate cpumask");
> +
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
