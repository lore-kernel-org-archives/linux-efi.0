Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794516301;
	b=ieCF0w5QtH5yUP+1HaWziaPp3NyT0p/cMMpHBB29p3m22fw0EP7RvYNDUyNF95hr+4LZ
	 DtM/zRCfyFf38gejKexASJlBDGSgZsIBzNd0kfTHAFzQnN5y9/HpZy3fub3qT+OF6+yNs
	 4EUcTrDLxW+/ZrPlDkHNqK0+Enye9++PWWj8z3orMptumjFmyK4FHYn70sn6r5gbt+CEX
	 zTT4D9i5WHkFKKnyIDB/Hl37e/TCKO6k/ACGs9uVRt3YVi1XcW8C7246sA5LyF1ULTBbN
	 40oBcTw0cxInbKiri1HSjoMj8g01F7NgJUrKcIvALzQp1SGOduqMVhEmU5OQCE7/xaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794516301;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:Organization:MIME-Version:
	 Content-Type;
	bh=XALDFth3/fVsMANY2AjeE0oUkefOPYKHibrcEmJC1Po=;
	b=UL44yRSWsWTJrBphaoSJmjJzUk8tfAXWQsoYH5wTQm1vNTKNuwD+cwV83vpQGlixum+I
	 htqDXdZuFsoTcbyjTpkOecFygAAHmG4AIL6MYXy21ak1Wdy9w3d7hdqoGXb0Y/VtVwIgX
	 iKuXpanMx77Q5R3GbzYXM5SYMY0cdJXAqalmyd0iNQaxzMDInZ20ACBt8W3SflcsN1VyF
	 y/ff2siFnLav6lM8kgdemq61a5qHQ6/NYNIV100KII+lKbJ5Bl4ySah/7Hggm7TmzJ7Ob
	 lSOrf/aOIuUEffRXC7JxpfKwWqS+GRn81a6kI2c/7nmsBXOtdkS3xHm2z3tl4a/aLpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=M3K7fAX0;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74EA60A2604
	for <linux-efi@vger.kernel.org>; Thu, 12 Nov 2026 20:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A74EA60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=M3K7fAX0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794516301; x=1826052301;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=/h+UsAOF3BA39O3ylY9Xo+VycLTtRnVqSkiMX/MzdL8=;
  b=M3K7fAX0oyqJyJWNvpBEck0miPtcAimbTfGrP50M+bi+95D3XOaKoudQ
   6aFNyQLjkMTY8N1ex8YN7dqMqtXVGGA4gMkRDPAwq+pWbBcTG0WR5VIQs
   rCj/WZzMrrA+EJ7nJgXBUhLjuSvaTuRXXXdFejSYYJVgdENBfIgy2JJgS
   xqbVNKfK0D+GMJPyBaJTz/Hs4J4pGs+VbZvbyAsklas32TkEWHhroEXfy
   fMl4fSIqiwitIalWl9yB9M13zoBf18BVZnnB30VeaG+R8iCniXEPUhX79
   W4tYVkuXQuUsGB+fkpufDnIUnLt2uUuMJHsnsOYtqnIZM596lqrF9hc4a
   g==;
X-CSE-ConnectionGUID: F9ThBr7jST2jkv782bel3g==
X-CSE-MsgGUID: IgD0uwDUT562huG3Nh07qQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3346270"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3346270"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:45:00 -0800
X-CSE-ConnectionGUID: mnbooYO2RWeAkJOzNo5tqQ==
X-CSE-MsgGUID: nf4D0vXJQ32fQEnm1N4YEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="9088166"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO jcompost-mobl.amr.corp.intel.com) ([10.125.111.183])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:45:00 -0800
From: Jeremy Compostella <jeremy.compostella@intel.com>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-efi@vger.kernel.org,
Cc: ardb@kernel.org,  ilias.apalodimas@linaro.org,
  matthew.k.gumbel@intel.com,  kernel-dev@igalia.com,  kernel@gpiccoli.net
Subject: Re: [PATCH] efi: efibc: Optionally report panic as a reboot reason
In-Reply-To: <20261108003549.745697-1-gpiccoli@igalia.com> (Guilherme
	G. Piccoli's message of "Sat, 7 Nov 2026 21:34:57 -0300")
References: <20261108003549.745697-1-gpiccoli@igalia.com>
Date: Thu, 12 Nov 2026 13:44:58 -0700
Message-ID: <87pkw9g4ol.fsf@jcompost-mobl.amr.corp.intel.com>
Organization: Intel Corporation - 2200 Mission College Blvd. Santa Clara,
	CA 95052. USA
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain
Content-Disposition: inline

It looks good to me.

"Guilherme G. Piccoli" <gpiccoli@igalia.com> writes:

> The small efibc driver can be used to determine the cause of a reboot,
> in addition to controlling bootloader behavior. Currently, this driver
> reports "shutdown" or "reboot" as possible reasons for a system restart.
>
> Add support for panic reporting, gated by a module parameter. If users
> set the parameter, a panic notifier is registered and tries to save
> "panic" as the reboot reason, if the kernel is configured to reboot on
> panic. Note that it is a best-effort approach, relying on the nonblocking
> version of the EFI variable setter.
>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>
>
> Hi folks, this is a 2nd attempt to make the kernel notify UEFI about
> a panic. The first proposal was a new (small) driver, sent here:
> <https://lore.kernel.org/r/20220729194532.228403-1-gpiccoli@igalia.com/>
>
> The idea is to have a simple mechanism, independent of efi-pstore (since
> users could be using other pstore backends, or do not wish to collect
> logs for privacy), to let UEFI know a panic happened. Using efibc seems
> to be a reasonable and simple approach.
>
> The option is gated by a parameter; this could be removed in case it's
> considered unnecessary. I think a parameter is less invasive than just
> changing the default.
>
> Feedback / reviews are greatly appreciated.
> Thanks in advance,
>
> Guilherme
>
>
>  drivers/firmware/efi/efibc.c | 46 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 44 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
> index 345a10aa7086..b4014500513f 100644
> --- a/drivers/firmware/efi/efibc.c
> +++ b/drivers/firmware/efi/efibc.c
> @@ -11,9 +11,14 @@
>  #include <linux/reboot.h>
>  #include <linux/slab.h>
>  #include <linux/ucs2_string.h>
> +#include <linux/panic_notifier.h>
>  
>  #define MAX_DATA_LEN 512
>  
> +static bool report_panic;
> +module_param(report_panic, bool, 0444);
> +MODULE_PARM_DESC(report_panic, "Report kernel panic as a reboot reason too (default N)");
> +
>  static int efibc_set_variable(efi_char16_t *name, efi_char16_t *value,
>  			      unsigned long len)
>  {
> @@ -65,6 +70,30 @@ static struct notifier_block efibc_reboot_notifier = {
>  	.notifier_call = efibc_reboot_notifier_call,
>  };
>  
> +static int efibc_panic_notifier_call(struct notifier_block *notifier,
> +				     unsigned long event, void *data)
> +{
> +	efi_char16_t *reason = L"panic";
> +
> +	/* Skip if we aren't rebooting on panic. */
> +	if (!panic_timeout)
> +		return NOTIFY_DONE;
> +
> +	efi.set_variable_nonblocking(L"LoaderEntryRebootReason",
> +				&LINUX_EFI_LOADER_ENTRY_GUID,
> +				EFI_VARIABLE_NON_VOLATILE
> +				| EFI_VARIABLE_BOOTSERVICE_ACCESS
> +				| EFI_VARIABLE_RUNTIME_ACCESS,
> +				ucs2_strlen(reason) * sizeof(efi_char16_t),
> +				reason);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block efibc_panic_nb = {
> +	.notifier_call = efibc_panic_notifier_call,
> +	.priority	= INT_MIN,
> +};
> +
>  static int __init efibc_init(void)
>  {
>  	int ret;
> @@ -73,16 +102,29 @@ static int __init efibc_init(void)
>  		return -ENODEV;
>  
>  	ret = register_reboot_notifier(&efibc_reboot_notifier);
> -	if (ret)
> +	if (ret) {
>  		pr_err("unable to register reboot notifier\n");
> +		return ret;
> +	}
>  
> -	return ret;
> +	if (report_panic && efi.set_variable_nonblocking) {
> +		ret = atomic_notifier_chain_register(&panic_notifier_list,
> +							&efibc_panic_nb);
> +		if (ret)
> +			pr_err("unable to register panic notifier\n");
> +	}
> +
> +	return 0;
>  }
>  module_init(efibc_init);
>  
>  static void __exit efibc_exit(void)
>  {
>  	unregister_reboot_notifier(&efibc_reboot_notifier);
> +
> +	if (report_panic && efi.set_variable_nonblocking)
> +		atomic_notifier_chain_unregister(&panic_notifier_list,
> +							&efibc_panic_nb);
>  }
>  module_exit(efibc_exit);

--=-=-=--
