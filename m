Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A5333ADA7;
	Wed,  2 Sep 2026 01:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788311402; cv=none; b=qP3CJGzEE1ciLQVyOkUXIauVvKKZG2MIVuSEgnckzcgxUcoMgdDljEBOxJ48/yb4kEsc0YL5ADEc3N5gXnS7Dvhv4HTPFwgYiJcsDg5jByaPJBcNELKj44Y+rrb+vnD1RO4ywt+6R/u2n70li4I9b+K4z4r1TPH5Z3tveVr5Oa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788311402; c=relaxed/simple;
	bh=47kEReU2syTRMEdeTg/mQbzkEdr0ZLr49lH9qKTvtpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOnvy3ETFsw0xlmjv8BgVCup2Zaz84jwOw9mE1vkUucLOxbVZ0BOejzN/Bq677YSWkkjUp9FG+pa5FWxEN28cLa5hwvf1i3vFpWoQT8DzqPgZ9GmiTAMizkRNmRS/OZK1NYioZ3Eq439SeXF3m5/9cmIpPm56ZjvmmWOgh84Jzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHGpOVJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHGpOVJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024301F000E9;
	Wed,  2 Sep 2026 01:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788311400;
	bh=tA79mL88B+qRi5ZjT11ACc06itvpBxYSkq4PBiFRbrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RHGpOVJIfFkHEUum0NnmjUDi/+L2PQGRZoaEESNG1+dCDQc4BwYSpZskbN0GH/E3e
	 3fd57Zzz4Yn14BE4hDsk8WoqJxhkQZA1KCEv+vjfXpLqg3BDrhUts4nltT8B88M/fS
	 LtHnp6B2kajywXNxIVhtfiatwlX8IPEEXY/t/V0PtMpQGIh0B256RPFGXq8FkSBJpW
	 9tT8FsUc9Du01k+V8IMYNnty+OYYvO1ywEaHa0fGo3flvFK9tocE6BBqMw7R7w0RlD
	 UBlM+4E7bneWDzYq+l9/YK26hHs8ErNel3Tqa7B2wtrBn+7FNc+IINUppWDkyQbT1R
	 zaE/zbPnT3d+g==
Date: Tue, 1 Sep 2026 18:09:58 -0700
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
Subject: Re: [RFC PATCH 04/12] firmware: efi: libstub: x86-stub: Enable VSM
 awareness in efi os indications variable
Message-ID: <20260902010958.GD2583463@liuwe-devbox-debian-v2.local>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-5-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901165647.3160413-5-tgopinath@linux.microsoft.com>

On Tue, Sep 01, 2026 at 09:55:18AM -0700, Thara Gopinath wrote:
> Set bit 0 of the Hyper-V private OsLoaderIndications EFI variable
> during exit_boot() so the bootloader/firmware knows the OS intends
> to enable VTL1. Without this, VTL1 cannot be brought up from the
> Linux kernel.
> 
> The support bit is first checked in OsLoaderIndicationsSupported,
> and the variable is only written when the VSM bit is not already
> set.
> 
> Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
> ---
>  drivers/firmware/efi/libstub/x86-stub.c | 57 +++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
[...]
> +#ifdef CONFIG_HYPERV_VSM
> +static void efi_set_hv_os_indications(void)
> +{
> +	efi_guid_t guid = HYPERV_PRIVATE_EFI_NAMESPACE_GUID;
> +	efi_status_t status;
> +	unsigned long size;
> +	u32 attr, val;
> +
> +	size = sizeof(val);
> +	status = get_efi_var(efi_HvPrivOsloaderIndicationsSupported_name,
> +			     &guid, &attr, &size, &val);
> +	if (status != EFI_SUCCESS) {
> +		efi_err("Could not read Hyper-V OsloaderIndicationsSupported\n");
> +		return;
> +	}
> +
> +	if (!(val & HV_OSLOADER_INDICATION_VSM)) {
> +		efi_info("Hyper-V does not support VSM in OsloaderIndicationsSupported\n");
> +		return;
> +	}
> +
> +	size = sizeof(val);
> +	status = get_efi_var(efi_HvPrivOsloaderIndications_name, &guid, &attr, &size, &val);
> +	if (status != EFI_SUCCESS) {
> +		efi_err("Could not read Hyper-V OsLoaderIndications\n");
> +		return;
> +	}
> +
> +	if (val & HV_OSLOADER_INDICATION_VSM) {
> +		efi_info("VSM is already supported in OsLoaderIndications.");
> +		return;
> +	}
> +
> +	val |= HV_OSLOADER_INDICATION_VSM;
> +	size = sizeof(val);
> +	status = set_efi_var(efi_HvPrivOsloaderIndications_name, &guid, attr, size, &val);

I'm not familiar with the security model, so bear with me.

What happens if the VTL0 kernel doesn't use VTL1 at all? Does that
become a security issue, that malware can use the VTL1 to hide itself?

Asking this because I think you will want to enable this in the generic
kernel(s). Not all users have or want to package a secure kernel.

Wei

> +	if (status != EFI_SUCCESS)
> +		efi_err("Could not set Hyper-V OsLoaderIndications to indicate VSM support\n");
> +}
> +#endif
> +
>  static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
>  {
>  	struct setup_data *e820ext = NULL;
> @@ -768,6 +820,11 @@ static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
>  	if (status != EFI_SUCCESS)
>  		return status;
>  
> +#ifdef CONFIG_HYPERV_VSM
> +	/* Indicate to bootloader that we will be enabling VTL1 before exiting boot services */
> +	efi_set_hv_os_indications();
> +#endif
> +
>  	/* Might as well exit boot services now */
>  	status = efi_exit_boot_services(handle, &priv, exit_boot_func);
>  	if (status != EFI_SUCCESS)
> -- 
> 2.34.1
> 
