Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794452405;
	b=KgEQbhS6EcZVOCaqwgU4iT9zvd3WTrlz8wWExmrnid2A9nvUqSVAYMwjVyQfOGcR4fKG
	 zCyzZ5403sEgbh21bR6tlqLS5PkpCTtHgNdlhfGaU0M/F3wFiFOcS3pverQjVtFBy/sGf
	 saHpGvJgcz9GhAqKr1VzxlbgsU1tfBM88i4wipXM5uOXg4KlbQa7S1MqNho9P1z4n/CIO
	 ZJsSlPlPoeB6wWeiwaMpRY+uXvF7E6rlnSdXsOCvBZ8uAkL/Bxp0YIaZy3CUFdR+9QLIS
	 MhXouR4pwsisAOQqw/RaA7O20K1lMwUnta2O+M+KvtGGvkmKomrfxzVLdwpv5SUsefw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794452405;
	h=DMARC-Filter:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=zYiGSF0ZZ4GiiESqs52zyLdAhl05Iuf9955b3bBWHVk=;
	b=kSTL4kZ3cb4J+n4jSM85nx9WgreAVWBq9eIjqFALgeJ0pV6MOtkZ8Ilv27DkecbttYSq
	 wsVxd7x/WJJgC1ktiydZ5vZ17Q1CmJAOFOLIDDlo8fDGNYZuDpfEUHICncFDxZTcJ5dnu
	 2AINokH1GU7CBI8A0J1CxIK13kxz9eHZqXgTvPsX9wW5re/zIBivqJZlKM4t3hVENn1wS
	 0w0HuCc/ZWyKdtW8rL/cNhs7MQN9k/eKjsf2jbfJTxfA2B5VHbaK1ZeZT+pSCdnfuWQyt
	 h7kz7VRow0/Z69J/CV6jlOWvtnWjKXw0iEEWQaiQdMx0jA+v6K/yhPO08MURpS0kclQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Xkyr5AjL;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45121606A323
	for <linux-efi@vger.kernel.org>; Thu, 12 Nov 2026 03:00:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45121606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Xkyr5AjL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=zYiGSF0ZZ4GiiESqs52zyLdAhl05Iuf9955b3bBWHVk=;
	b=Xkyr5AjLUa+Y2ROZqvr+CuhethrbpdBDV1SLKzPeegs2Iscaw4xmuxXBMP0jL3
	gb2YkC5MNxouMZBE2fryECP/pwuQqsBv67zTrZ7X8QMjVQG8cNaOEYHsPx6+hU7K
	IJnm9ep0d25Yyq6nZU65H6EunR1hdi1fvYic62HIFEofs=
Message-ID: <63d0fb19-b1cb-4729-839a-b9e1f1379473@163.com>
Date: Thu, 12 Nov 2026 10:57:05 +0800
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] efi: efibc: Optionally report panic as a reboot reason
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-efi@vger.kernel.org
Cc: ardb@kernel.org, ilias.apalodimas@linaro.org,
 jeremy.compostella@intel.com, matthew.k.gumbel@intel.com,
 kernel-dev@igalia.com, kernel@gpiccoli.net, kexec@lists.infradead.org
References: <20261108003549.745697-1-gpiccoli@igalia.com>
Content-Language: en-US, en-GB
From: Dave Young <hidave@163.com>
In-Reply-To: <20261108003549.745697-1-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDXHyh4K_VqvdTrGw--.58296S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCFWDJr43GFyrJw45Zr4rGrg_yoWrXF43pa
	y8GrZ8GF4kJa4xWayfZF4UZFyYvw4xJryUuFy3C34UAr4qkr9rtrW0kw4Y9FyxJa4xGryr
	Kw4jqa4kCa1DtaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UIdgtUUUUU=
X-CM-SenderInfo: pklgt4rh6rljoofrz/xtbC7hkBw2r1K3mDxwAA38

Cc kexec list

On 11/8/26 8:34 AM, Guilherme G. Piccoli wrote:
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
> https://lore.kernel.org/r/20220729194532.228403-1-gpiccoli@igalia.com/
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
>  #define MAX_DATA_LEN	512
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
> +	.notifier_call	= efibc_panic_notifier_call,
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
>  

