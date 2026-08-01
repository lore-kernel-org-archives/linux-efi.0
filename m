Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819361B85F8;
	Sat,  1 Aug 2026 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785591941; cv=none; b=eknGsz/eFO3GX4jGFmnMegLp6Oj81dhw3zf2d1DGpBnVa0qs9C51lpJ4OZ1NqXU7Bo/8JI11He0r0ORWyRLvW7DkKt4iX7Hby+G+3+3sQA49ElKmMnfkMTvOgdeyABRZ/9uI8S4GpeKxaNNi0JNkaByMhpzvMNEJ9a3D7qtkQd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785591941; c=relaxed/simple;
	bh=bXal9GWTC27/fYflwFzFlAc9kDv1kxIhftdY5FsayO8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=iW8AIkb8ZAqEvOg7i8vFy1kL4rD3obJ9fqqOkB1DoOJNv8kQZuqMIvJh8niUpmwL13m4SosiMQGlYfjuDiyvWdgKbYruENpQjyM5aMKEH2fdp7fFu9u9rWMHWtcvJjAn5FkyC/cazofnxpN+O8R7jQvpoyOeY0wt/9cq2fD3OeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvWYIXZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvWYIXZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84231F00AC4;
	Sat,  1 Aug 2026 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785591940;
	bh=s2B3S4jFAuMVLSN5xL3d1wlVTu1TWiMn+yma9vCaTCE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VvWYIXZ8gbu3zs7faLBS+OQ2dFh4Jpxx14ZH8I/XPzFMwA5KxFOTFixNuesGgrK7p
	 f2LWnPbX6zixFcRRJYxa6pHIFhBp93y2NiM0e8aMhVIeE2nONBvLdUZ8BknmpsRZNW
	 IEOSnn6VLpkj73wXxrA3aiknfvmgnKLy82egF+cjtTF1iIdiOunFKbBHtx0zE1zNek
	 VE2P/FBKo91WIrJ17spVVfhdV3RwS1dS39F587IrC60GReYw4/cyxNRYUqDgZdOkST
	 PXI5/zt5gzQIix5OADquWDCCChzHaXyloDUDoUz6Af2/IWRor59aR0ggQZqPv0B/MB
	 OMxaB2Zj7fs5w==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id ADB97F40088;
	Sat,  1 Aug 2026 09:45:38 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Sat, 01 Aug 2026 09:45:38 -0400
X-ME-Sender: <xms:gvhtaoWBjBbtqUn0DdvCBHMJRlVScwUicEwrGeIA1Wqyos8amHUGAg>
    <xme:gvhtanZ3W24P279CaMyfnoTOZVqokdLZwph7UKHtvuuh_XejYaKT4pcYti7tR0YnN
    CLiuXV4fXMiGx0Zrp2pvMMwgK9nswW0g29j_TDzCxeiQRgx2qXhZ7E>
X-ME-Proxy-Cause: dmFkZTGhZF0JA14fCc3GcvcMThpPaf3al1bA7DpSNGb8actjuhdv21NX7EcQtahis3kLDs
    Jll1F1zTRuApKWi2c/XALs6TPAiMcwcNtdEsmu1L0X/it4yFu0h8iKuJvCsbqQhXi5i6el
    UXb+u+lYG5ueAKurasQGVzsHEM6o49PF+P6wpdYoOjDHLQTAGgtE46eVXzy0sEaugImDxh
    krK+OAFCKBvIJqhVNL39f+NI6yugh+33zWzzJpbPCDLpKkF98Xbtwn0DuyWTgkVdWJVN3k
    sTx4U4sPWwr4K8MbEXDQHrGGhPzx9RD1M93B6uWBgz8dHS4i22odqJkS2TOkCL8wbwNRse
    AiN4VUmAfAVFSDxMFNa4AauRts2xuLY+Cra20ID26SzZabNbSZQgYM/qZvS9hfPfGy/yrO
    bLfh9MSjnZfrY6jps9u2fy/wdvM+8u+1J2ZKYIUg6Ml3lkrx/HV/BhueopUGQG1pS9IvFk
    fW97BqpWfyOVXXLCXaWavgtkMm0oZbNUwkLcpSKwfRNa/lDEucEc2xoN4OyZx0/3v1CyyU
    lPXtdTR+rzLDgAwbVpL31OZlhrQjcuL/e7BOfq7J1yIdWnWZZMCvnjIm1loWMTx0TO2HVq
    LrD2rrAEkbjNPslibxHBxhmKMMhCya8nug18Vb+Q2mEqjrdnamIKINlrcwFA
X-ME-Proxy: <xmx:gvhtashkhV7mjPxBeL3FGGgODrd1GhTL0OCBQhCdz69JfEOFu5BPkw>
    <xmx:gvhtat_ys3NkvwQy0yJoDwizdN5upNceB30FKFI-KUqjI34a-BBO9A>
    <xmx:gvhtavoKoI265V8EjQM6dSS7fStWwm6Wb5-PrXq1u3GeIDCNUZ-4VA>
    <xmx:gvhtatWJ6vgMqbMnisDOFYRN2_249QezJ73_j1wP6-Kv6y6op6J0Lw>
    <xmx:gvhtamBo0cIYaneUB0sqjAg9ZAXcOOG9M4OdSIs80yB3J1uXCup_fkmo>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 82A8F182007E; Sat,  1 Aug 2026 09:45:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 01 Aug 2026 15:45:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Junxiao Chang" <junxiao.chang@intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Message-Id: <05c5e8f0-20b9-4fa8-8fca-08117188a765@app.fastmail.com>
In-Reply-To: <20260731062423.639771-1-junxiao.chang@intel.com>
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
 <20260731062423.639771-1-junxiao.chang@intel.com>
Subject: Re: [PATCH] efi: add dynamic control interface for EFI runtime services
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Junxiao,

On Fri, 31 Jul 2026, at 08:24, Junxiao Chang wrote:
> Add an interface for PREEMPT_RT kernels to dynamically enable or
> disable EFI runtime services.
>
> EFI runtime services are typically disabled on RT systems using
> kernel parameters such as "noefi" or "efi=disable" to avoid
> long latency caused by firmware calls. However, this permanently
> disables EFI runtime services, preventing operations such as UEFI
> firmware updates.
>
> With this change, EFI runtime services can be disabled while
> real-time workloads are running and re-enabled afterwards,
> providing low-latency operation without permanently sacrificing
> firmware functionality.
>
> Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
> ---
>  drivers/firmware/efi/efi.c              | 31 +++++++++++++++++++++++++
>  drivers/firmware/efi/runtime-wrappers.c | 15 ++++++++++++
>  include/linux/efi.h                     |  1 +
>  3 files changed, 47 insertions(+)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 0327a39d31fa5..f57784a815c61 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -401,6 +401,32 @@ static void __init efi_debugfs_init(void)
>  static inline void efi_debugfs_init(void) {}
>  #endif
> 
> +static ssize_t efi_dynamic_show(struct kobject *kobj, struct 
> kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%d\n", efi_enabled(EFI_RUNTIME_SERVICES));
> +}
> +
> +static ssize_t efi_dynamic_store(struct kobject *kobj, struct 
> kobj_attribute *attr,
> +				 const char *buf, size_t count)
> +{
> +	int ret;
> +	bool enable;
> +
> +	ret = kstrtobool(buf, &enable);
> +	if (ret)
> +		return ret;
> +
> +	if (efi_runtime_set_enable_flag(enable) != EFI_SUCCESS) {
> +		pr_warn("unable to enable/disable efi runtime service\n");
> +		return -EAGAIN;
> +	}
> +
> +	return count;
> +}
> +
> +static struct kobj_attribute efi_dynamic_attr =
> +	__ATTR(dynamic_enable, 0644, efi_dynamic_show, efi_dynamic_store);
> +
>  static int __init efipostcore_init(void)
>  {
>  	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> @@ -446,6 +472,11 @@ static int __init efisubsys_init(void)
>  		goto err_destroy_wq;
>  	}
> 
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && efi.runtime_supported_mask) {
> +		if (sysfs_create_file(efi_kobj, &efi_dynamic_attr.attr))
> +			pr_warn("unable to register efi dynamic sysfs interface\n");
> +	}
> +
>  	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
>  				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
>  		error = generic_ops_register();
> diff --git a/drivers/firmware/efi/runtime-wrappers.c 
> b/drivers/firmware/efi/runtime-wrappers.c
> index da8d296216441..8d1554714e3f4 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -602,3 +602,18 @@ void efi_runtime_assert_lock_held(void)
>  {
>  	WARN_ON(efi_runtime_lock_owner != current);
>  }
> +
> +efi_status_t efi_runtime_set_enable_flag(bool enable)
> +{
> +	if (down_interruptible(&efi_runtime_lock))
> +		return EFI_ABORTED;
> +
> +	if (enable)
> +		set_bit(EFI_RUNTIME_SERVICES, &efi.flags);

This interface allows enabling of EFI_RUNTIME_SERVICES even if it
was disabled for other reasons, e.g., a firmware crash or a 
command line option. IOW, the set_bit() path is only permitted
if the clear_bit() path was taken first.


> +	else
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +
> +	up(&efi_runtime_lock);
> +
> +	return EFI_SUCCESS;
> +}
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index ccbc35479684a..98b76008fd426 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1109,6 +1109,7 @@ extern void efi_call_virt_check_flags(unsigned 
> long flags, const void *caller);
>  extern unsigned long efi_call_virt_save_flags(void);
> 
>  void efi_runtime_assert_lock_held(void);
> +efi_status_t efi_runtime_set_enable_flag(bool enable);
> 
>  enum efi_secureboot_mode {
>  	efi_secureboot_mode_unset,
> -- 
> 2.43.0
