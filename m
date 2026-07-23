Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747973CBE6D
	for <linux-efi@vger.kernel.org>; Thu, 23 Jul 2026 06:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784788667; cv=none; b=TtC/G29emHSwzLpiPXPrZiCZPGuwdZBP9JW+t9tVW7p+VlfvjTNsQtTEu+++0Puc3X7466I8sKBjCIeNdD2OYSICzYJCjD7puesc7LYkHf6UYS1OjgiCFTDFj9KWWzKxhu1W2hbDM6mG99cb7hYExNv8qylqhvEFk6TfSaJVDD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784788667; c=relaxed/simple;
	bh=HeKn85U2pzaPjioEjIai9a0bVPRz4zMPDn+bodmssrQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Uk+8/Cg/eJpfZdJ6dbRn1QsvBk2Z+2D+gEPZbl2ALRae8PuhPMNfGivmdyUl5BOVfyv8pbDv5Bwh0jCf7VqPeUX9/6bYAk5AhUv3rQcLsrE8Po+RuBIo1QnjGvAUlAxhEQf4KDkQU9vYGfdldO21ctiExR/Xd2uP+CO1SPy303Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAE81F00A3A
	for <linux-efi@vger.kernel.org>; Thu, 23 Jul 2026 06:37:46 +0000 (UTC)
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 73736F4006F;
	Thu, 23 Jul 2026 02:37:44 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Thu, 23 Jul 2026 02:37:44 -0400
X-ME-Sender: <xms:uLZhai6z4NZB4LPaS6-PUV0uvQWSyOnZH7pIXhe5_yr6ZVKawTkOig>
    <xme:uLZhamtynkyX2x5Q7MyRaUjwLTg6nORiwsOtO0TILYE8T4mqvvibg4oJj9U6tIUn2
    7uVkI7xCNQtlLGb9q35Ivpbt9Lb_I13sOvyvJptnaKjoBfAD_5f0JA>
X-ME-Proxy-Cause: dmFkZTEBcFHHNd2Fh1GS8hKpylCaKqn3YnhMQU1Jl0ltDHivxqxfYfz98rzH1T7eEH66M/
    Lrl97t4QdG2qlo+cv4wZ2XPJRfp9Y03hDZrgrKTD6dTneQpXFE9MekQfOzJccgjxN3/M+W
    nWCUxeTtpAdldYn+VobCdmFgGZEbuoWvmgg0757khlJFV4zt1/MorJl+24/Qq9vYMhN/zg
    B68WMu7R+eHvvYWVq7kts9ubZ+WkvhSDjhBVsmd36p2IZPcXvFP1kikD9Szntwv7Fmm9cq
    Xf+YtTtAFRes8CGrXxtuyxk/FOMNQ/RaKJcd/1qcUcui1v1h59b3IwwHd88xjRW9788lls
    GT6YG6HDRHog6LqHsoFx3YKv96+WOaPUq5nlGuMw+brzQDbU+8U6yXyuG6nRoV+no2X3GI
    4p8lqoTvb5RleSLGlG8DANgYTw3khG5PEco9+lCeN/mxb+i6b+yMopipnDf9aJDdtoxHjZ
    6hBeg5qQKmus3xzRjQVd1IIotSdMvJB0Phd3O44bhdYHu4k6jC24PY6GfsVMRBucdpIb1E
    q1H4oI3z/sj3KAtOyNspEmcDaYUEl874ZRv2Oc7Vkz5YuNkkZxOybXX2xYWNkdbr4GYXk4
    sh9SEjFlsNUzj6aQbg+YSZCsCRW4o7kF+5nis1nMk0mZdmR+FTiyZr/jxFFA
X-ME-Proxy: <xmx:uLZhaoF4Hc0FNDCn1FaFJKPNyRU3Pn8EDQN_61zcwJ84aGF3NIg_Wg>
    <xmx:uLZhaqSOuMjdeL-7EDkL7G4gqi0ovS--X6pDNeANMTgrjEgVTggaIw>
    <xmx:uLZhattbJVQO9Zjrl1rSYDW-8KcLXEW2Tq8Cpp-a6uA41Dolg1nGKw>
    <xmx:uLZhaqIfxPMUH_xJrZxgM2c3l64LZWmcrLUU8t2l0YQ0ZvNCwpkSQA>
    <xmx:uLZhaqleCO3PCAHdkhyc53VCg-_O88-DgRLJZTrYkFBLSfkx7m46rYeP>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5B6CA182007E; Thu, 23 Jul 2026 02:37:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 23 Jul 2026 08:37:23 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Junxiao Chang" <junxiao.chang@intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Message-Id: <d107385f-1c58-4aa0-beac-7d536d064600@app.fastmail.com>
In-Reply-To: <20260704003341.3923900-1-junxiao.chang@intel.com>
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
Subject: Re: [PATCH] mefi: add dynamic control interface for EFI runtime services
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(cc Sebastian)

On Sat, 4 Jul 2026, at 02:33, Junxiao Chang wrote:
> Add an interface to dynamically enable or disable EFI runtime
> services at runtime. By default, EFI runtime services remain
> enabled, but they can be temporarily disabled to improve real-time
> latency.
>
> Currently, EFI runtime services are typically disabled on RT
> systems using kernel parameters such as "noefi" or "efi=disable".
> However, this permanently disables EFI services, preventing use
> cases such as UEFI firmware updates.
>
> With this change, EFI runtime services can be disabled during
> execution of real-time workloads and re-enabled afterwards,
> allowing better balance between real-time performance and firmware
> service availability.
>
> Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  5 ++-
>  drivers/firmware/efi/efi.c                    | 39 +++++++++++++++++++
>  2 files changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt 
> b/Documentation/admin-guide/kernel-parameters.txt
> index b5493a7f8f228..533213101f808 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1595,7 +1595,8 @@ Kernel parameters
>  	efi=		[EFI,EARLY]
>  			Format: { "debug", "disable_early_pci_dma",
>  				  "nochunk", "noruntime", "nosoftreserve",
> -				  "novamap", "no_disable_early_pci_dma" }
> +				  "novamap", "no_disable_early_pci_dma",
> +				  "dynamic" }
>  			debug: enable misc debug output.
>  			disable_early_pci_dma: disable the busmaster bit on all
>  			PCI bridges while in the EFI boot stub.
> @@ -1612,6 +1613,8 @@ Kernel parameters
>  			novamap: do not call SetVirtualAddressMap().
>  			no_disable_early_pci_dma: Leave the busmaster bit set
>  			on all PCI bridges while in the EFI boot stub
> +			dynamic: enable EFI runtime services, which can be
> +			disabled via /sys/firmware/efi/dynamic_enable.
> 
>  	efi_no_storage_paranoia [EFI,X86,EARLY]
>  			Using this parameter you can use more than 50% of

I'd prefer not to add a command line option for this. If the sysfs control
is useful, we can enable it unconditionally, or depend on PREEMPT_RT.

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 0327a39d31fa5..18d5d99fab821 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -81,6 +81,7 @@ struct mm_struct efi_mm = {
> 
>  struct workqueue_struct *efi_rts_wq;
> 
> +static bool efi_in_dynamic __initdata;
>  static bool disable_runtime = IS_ENABLED(CONFIG_EFI_DISABLE_RUNTIME);
>  static int __init setup_noefi(char *arg)
>  {
> @@ -115,6 +116,11 @@ static int __init parse_efi_cmdline(char *str)
>  	if (parse_option_str(str, "runtime"))
>  		disable_runtime = false;
> 
> +	if (parse_option_str(str, "dynamic")) {
> +		disable_runtime = false;
> +		efi_in_dynamic = true;
> +	}
> +
>  	if (parse_option_str(str, "nosoftreserve"))
>  		set_bit(EFI_MEM_NO_SOFT_RESERVE, &efi.flags);
> 
> @@ -401,6 +407,34 @@ static void __init efi_debugfs_init(void)
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
> +	if (enable)
> +		set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +	else {
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);

This is racy, no?


> +		if (efi_rts_wq)
> +			flush_workqueue(efi_rts_wq);
> +	}
> +
> +	return count;
> +}
> +static struct kobj_attribute efi_dynamic_attr =
> +	__ATTR(dynamic_enable, 0644, efi_dynamic_show, efi_dynamic_store);
> +
>  static int __init efipostcore_init(void)
>  {
>  	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> @@ -446,6 +480,11 @@ static int __init efisubsys_init(void)
>  		goto err_destroy_wq;
>  	}
> 
> +	if (efi_in_dynamic && efi.runtime_supported_mask) {
> +		if (sysfs_create_file(efi_kobj, &efi_dynamic_attr.attr))
> +			pr_warn("unable to register efi dynamic sysfs interface\n");
> +	}
> +
>  	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
>  				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
>  		error = generic_ops_register();
> -- 
> 2.43.0
