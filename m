Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4703955E4;
	Wed,  7 Oct 2026 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791389163; cv=none; b=bgxmDeVvXQ9OUwwx02q5v8molrvPo7AZQh8sWrBccHSVebtzUPbSP/BVgGQ2whVKBfH2W7ebVCwu/mFafwofK9p8TU8yWoFPtJ5pCRbmes2zpwoILcJjC2iUkYaflTCvAvnuSTxheZ0cpt1wlboJwk4JIrjGEhOncB4h7VdMWuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791389163; c=relaxed/simple;
	bh=SNwoczUlbJhSaPjEidfvs8i5PH2UxuuMtIzSeyvh6V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HvjP+sBZgcPu95ciri0hlsw5b9IgMFUqUEWZ8VZCe8zERqBApMycYhQbW27M5SQ+L8bhiQBusAlV3LBbItWXPKVUw51wLzsVgscvPUfngyptI7zaNuRru4phu4NBbm+WHT8URJahgdhuA2DCkLsk1EevaDYanfX38Lfq8AjBxUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=hUbaOL4A; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="hUbaOL4A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1791389158;
	bh=SNwoczUlbJhSaPjEidfvs8i5PH2UxuuMtIzSeyvh6V0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hUbaOL4AnRF1V46hn2wfSdDjvnPSxpVmFLPE5dGeyA0zARLs4bAQaZSo2g5jbuuoH
	 v4xuZhJSgxBoI+Kl31aWidh1wg7V27hr7T0JZES+wQCQxcnF6I5NNxr2AMX+EGLX1X
	 Vh90HMYqDE10MqIz6VZjGE4xP3sIbasErY1wFgAQ=
Date: Wed, 7 Oct 2026 18:05:57 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] efi: Constify sysfs attributes
Message-ID: <939a7bbd-a082-4cab-b4b7-2640d3d47cdd@t-8ch.de>
References: <20261007155130.2112665-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261007155130.2112665-2-ardb+git@google.com>

On 2026-10-07 17:51:31+0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Implement Thomas's suggestions to constify sysfs kobject attributes.
> 
> Cc: Thomas Weißschuh <linux@weissschuh.net>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Thanks! But some remarks.

> ---
>  arch/x86/platform/efi/efi.c | 11 ++++---
>  drivers/firmware/efi/efi.c  | 34 +++++++++++---------
>  include/linux/efi.h         |  3 +-
>  3 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 0c39adb96b91..d8fe93770c2a 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -891,7 +891,7 @@ bool efi_is_table_address(unsigned long phys_addr)
>  
>  #define EFI_ATTR_SHOW(name) \
>  static ssize_t name##_show(struct kobject *kobj, \
> -				struct kobj_attribute *attr, char *buf) \
> +			   const struct kobj_attribute *attr, char *buf) \
>  { \
>  	return sprintf(buf, "0x%lx\n", EFI_FIELD(name)); \
>  }
> @@ -900,11 +900,12 @@ EFI_ATTR_SHOW(fw_vendor);
>  EFI_ATTR_SHOW(runtime);
>  EFI_ATTR_SHOW(config_table);
>  
> -struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
> -struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
> -struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
> +const struct kobj_attribute efi_attr_fw_vendor = __KOBJ_ATTR_RO(fw_vendor);
> +const struct kobj_attribute efi_attr_runtime = __KOBJ_ATTR_RO(runtime);
> +const struct kobj_attribute efi_attr_config_table = __KOBJ_ATTR_RO(config_table);
>  
> -umode_t efi_attr_is_visible(struct kobject *kobj, struct attribute *attr, int n)
> +umode_t efi_attr_is_visible(struct kobject *kobj, const struct attribute *attr,
> +			    int n)

The break looks unnecessary.

>  {
>  	if (attr == &efi_attr_fw_vendor.attr) {
>  		if (efi_enabled(EFI_PARAVIRT) ||
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index e08ce813a3d4..93d6ffd9bc0d 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -155,21 +155,21 @@ static ssize_t systab_show(struct kobject *kobj,
>  	return str - buf;
>  }
>  
> -static struct kobj_attribute efi_attr_systab = __ATTR_RO_MODE(systab, 0400);
> +static const struct kobj_attribute efi_attr_systab = __ATTR_RO_MODE(systab, 0400);

__KOBJ_ATTR_RO_MODE()

(and the callback prototype)

>  static ssize_t fw_platform_size_show(struct kobject *kobj,
> -				     struct kobj_attribute *attr, char *buf)
> +				     const struct kobj_attribute *attr, char *buf)
>  {
>  	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);

This should switch to sysfs_emit() at some point.

>  }

(...)
