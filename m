Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742932DA756
	for <linux-efi@vger.kernel.org>; Tue, 17 Mar 2026 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767670; cv=none; b=upVs7qtcu8XJyIZUzhW1rGLv3qsvd/vgun4UoyYSAbSmR+lz8Aoyg4TRjQjgcinlAtWdPqIt/UxZi78Ac3fV6rlWPC3kmOxpw11omnricwHoKX0a3Uvhlgnns2xkzCHbwiPGBIG0O3Uw0ZQTmbAALf53fRDJH8mIQIej8XfSb+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767670; c=relaxed/simple;
	bh=SgMZNTr7eiDdRK0c6nHHbt9yANr1xsIuSarJONAu7V4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MytBIbNJ6/o9Qv6PuvPWVxkxOe9gY4fK7zGFncrTHHQnDQHCiF02JFx1PcYsroSVaNrIROe+3/bVphpxVhedgf946pjeFmlHtR8LrGZM/P+K6bJ4kOlTP/zHa/yWsoXElt/+ECBjdJK+2tu3hVdH8gizrwO7X1XA7QC6J1v92a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/SrFkhE; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/SrFkhE"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1279eced0b9so8343941c88.0
        for <linux-efi@vger.kernel.org>; Tue, 17 Mar 2026 10:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773767668; x=1774372468; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7fZGlThRHKOZEcqCV8UkZyE5CKR9QF/JZoCrQJeiv38=;
        b=M/SrFkhEeT1NzcF7fejqGxblFhqej5lE6d8Xdfznod1EhIGGJ62Ew08nEgfML7UzMo
         Cpapg4nYb9izUsYdIaDVj7TSGJLsFy+yKrPL40sCtsfiV9F6rRfLFNExbBeKmgEEtYas
         rWgccsSQMC9eRi2q4rdSojLexsPA2IsC7utAovu5IM2FOU//BgUHNI/glRT+wI0vi3pk
         WJpt4/x+Gv7PKI2BWM7R1H6gyCMFj6OlUDtsD4wqMcFFiMc1Nk7vGV1GHBhh7eiroyce
         EHhGNqOov4MeX82lpuyMcfSxCY9ufPOZIgiGoYjqCi53OhMgew6dNMTm8WgdLiBSg2Fx
         KPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773767668; x=1774372468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7fZGlThRHKOZEcqCV8UkZyE5CKR9QF/JZoCrQJeiv38=;
        b=dwdeEyPx8/O0EwiUt9vznr4BREih+PYl1ZVatfr5inSxXcCDZEiv8/WkKhAuGa3cbj
         YetVr2CMOWBmbjmx6Vx0bpnI7yZkqDl+yR5pWyJ7PiuuIlOPn1SeMJmtcpK0B1HceqSD
         Hm1G0ES77SPGT8AsAn2dntlWEFlPZdIM88cCcKBeEqfr8cKiB6pYB3mRvop7u+/dZ8s+
         9mQBNtn7y3kZmYVYYHaf8vap4SsAraOUZnQJ4XlO6idMAatYW5vZZlDFxf82T/t9+i7S
         eXVbCz5Jdm1W6Sarqu2FEh+78IohUVr6xVmo81WNqXrw5ejfpMzylvbPDZ7CSpKKcwHr
         bsbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvpwMPGdkQJm1UGENW9HNgbqYRjAdPpz50jS3u16IMaq/ZyOm4x/mXpcqEr8CQaM23Y+X+N1lefMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YymYlZvZpRdyaw3b4e8gOSQc3kvuNDjHwOF+EOoR1ogtv4GesZJ
	O4mxz+sA21/L7e1kLjNvz+C1+5Oikwd+cs33LNpk/plrxf5JbpwouxTb
X-Gm-Gg: ATEYQzzegg+FeY3yzVM8gSUFihjRdF9v1Pytnc0linmZAMN/BkYmpUqj2W6juxHDwb/
	nj9Hfd6UAbLXD8nLhg2iTy2UR/Pt/VM7Gaz+yFaNoYtWTxtO8Wpoz978D0lkG7l49dx6b6g+TeD
	CenNu0Q85lTWXKDOdGIvcoGNW+UVPLzBOSSCRYZsMYHXpg7NH3FQPJ7S2OTAlmxy0zve7ee8eR8
	0cPOX70ccYUqYjxeGWaQ8IwnQGSQHIa8aGg6G8ZFOsRhNYCklIkffFht/CO6gXB1WubkydPMedC
	0aqsdpREmFB7SdK+zHAcdipPcu/hhx6grUVs9USr+BPMtLhvsmGGKAN/sxnFXFcw9MZzkjeO+R3
	YXvZYb8EmExJP4rlBokk4xP7D9bnI4OVHBZwqYpj1iWTVwfuoC/NQLw2nZcqh3HafDLq3DR4IaO
	/skgbt5otOWHjJlJUcXr/xV9pqUKjjv6bVr4j9
X-Received: by 2002:a05:7022:60a2:b0:128:d20a:2f40 with SMTP id a92af1059eb24-1299baa02e9mr144968c88.8.1773767667391;
        Tue, 17 Mar 2026 10:14:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-129b41289e7sm174147c88.10.2026.03.17.10.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 10:14:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 17 Mar 2026 10:14:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, acpica-devel@lists.linux.dev,
	linux-acpi@vger.kernel.org, linux-edac@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ankit Agrawal <ankita@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Breno Leitao <leitao@debian.org>, Hanjun Guo <guohanjun@huawei.com>,
	Huang Yiwei <quic_hyiwei@quicinc.com>,
	Jason Tian <jason@os.amperecomputing.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Len Brown <lenb@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v6 1/4] apei/ghes: ARM processor Error: don't go past
 allocated memory
Message-ID: <1f87994f-22cb-44b8-9878-7ff375325a43@roeck-us.net>
References: <cover.1767871950.git.mchehab+huawei@kernel.org>
 <7fd9f38413be05ee2d7cfdb0dc31ea2274cf1a54.1767871950.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fd9f38413be05ee2d7cfdb0dc31ea2274cf1a54.1767871950.git.mchehab+huawei@kernel.org>

Hi,

On Thu, Jan 08, 2026 at 12:35:03PM +0100, Mauro Carvalho Chehab wrote:
> If the BIOS generates a very small ARM Processor Error, or
> an incomplete one, the current logic will fail to deferrence
> 
> 	err->section_length
> and
> 	ctx_info->size
> 
> Add checks to avoid that. With such changes, such GHESv2
> records won't cause OOPSes like this:
> 
> [    1.492129] Internal error: Oops: 0000000096000005 [#1]  SMP
> [    1.495449] Modules linked in:
> [    1.495820] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted 6.18.0-rc1-00017-gabadcc3553dd-dirty #18 PREEMPT
> [    1.496125] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 02/02/2022
> [    1.496433] Workqueue: kacpi_notify acpi_os_execute_deferred
> [    1.496967] pstate: 814000c5 (Nzcv daIF +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [    1.497199] pc : log_arm_hw_error+0x5c/0x200
> [    1.497380] lr : ghes_handle_arm_hw_error+0x94/0x220
> 
> 0xffff8000811c5324 is in log_arm_hw_error (../drivers/ras/ras.c:75).
> 70		err_info = (struct cper_arm_err_info *)(err + 1);
> 71		ctx_info = (struct cper_arm_ctx_info *)(err_info + err->err_info_num);
> 72		ctx_err = (u8 *)ctx_info;
> 73
> 74		for (n = 0; n < err->context_info_num; n++) {
> 75			sz = sizeof(struct cper_arm_ctx_info) + ctx_info->size;
> 76			ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + sz);
> 77			ctx_len += sz;
> 78		}
> 79
> 
> and similar ones while trying to access section_length on an
> error dump with too small size.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

AI code review feedback inline. I don't claim to understand the code or
its purpose, but it does seem to have a point. Please have a look.

Thanks,
Guenter

> ---
>  drivers/acpi/apei/ghes.c | 32 ++++++++++++++++++++++++++++----
>  drivers/ras/ras.c        |  6 +++++-
>  2 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 0dc767392a6c..fc3f8aed99d5 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -552,21 +552,45 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
>  {
>  	struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
>  	int flags = sync ? MF_ACTION_REQUIRED : 0;
> +	int length = gdata->error_data_length;
>  	char error_type[120];
>  	bool queued = false;
>  	int sec_sev, i;
>  	char *p;
>  
>  	sec_sev = ghes_severity(gdata->error_severity);
> -	log_arm_hw_error(err, sec_sev);
> +	if (length >= sizeof(*err)) {
> +		log_arm_hw_error(err, sec_sev);
> +	} else {
> +		pr_warn(FW_BUG "arm error length: %d\n", length);
> +		pr_warn(FW_BUG "length is too small\n");
> +		pr_warn(FW_BUG "firmware-generated error record is incorrect\n");
> +		return false;
> +	}
> +
>  	if (sev != GHES_SEV_RECOVERABLE || sec_sev != GHES_SEV_RECOVERABLE)
>  		return false;
>  
>  	p = (char *)(err + 1);
> +	length -= sizeof(err);
> +

Does this code subtract the size of the pointer instead of the size of the
structure? It looks like length will be larger than the remaining buffer,
which could allow out-of-bounds accesses in the loop below.

>  	for (i = 0; i < err->err_info_num; i++) {
> -		struct cper_arm_err_info *err_info = (struct cper_arm_err_info *)p;
> -		bool is_cache = err_info->type & CPER_ARM_CACHE_ERROR;
> -		bool has_pa = (err_info->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR);
> +		struct cper_arm_err_info *err_info;
> +		bool is_cache, has_pa;
> +
> +		/* Ensure we have enough data for the error info header */
> +		if (length < sizeof(*err_info))
> +			break;
> +
> +		err_info = (struct cper_arm_err_info *)p;
> +
> +		/* Validate the claimed length before using it */
> +		length -= err_info->length;
> +		if (length < 0)
> +			break;
> +
> +		is_cache = err_info->type & CPER_ARM_CACHE_ERROR;
> +		has_pa = (err_info->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR);
>  
>  		/*
>  		 * The field (err_info->error_info & BIT(26)) is fixed to set to
> diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
> index 2a5b5a9fdcb3..03df3db62334 100644
> --- a/drivers/ras/ras.c
> +++ b/drivers/ras/ras.c
> @@ -72,7 +72,11 @@ void log_arm_hw_error(struct cper_sec_proc_arm *err, const u8 sev)
>  	ctx_err = (u8 *)ctx_info;
>  
>  	for (n = 0; n < err->context_info_num; n++) {
> -		sz = sizeof(struct cper_arm_ctx_info) + ctx_info->size;
> +		sz = sizeof(struct cper_arm_ctx_info);
> +
> +		if (sz + (long)ctx_info - (long)err >= err->section_length)
> +			sz += ctx_info->size;
> +

Is this condition inverted? It looks like we add ctx_info->size to sz only if
the context info header is already out of bounds. This might cause us to read
ctx_info->size from unallocated memory.

Also, if the header is completely within bounds, sz does not include
ctx_info->size. Could this cause the loop to parse the register context array
as the next cper_arm_ctx_info header?

>  		ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + sz);
>  		ctx_len += sz;
>  	}
> -- 
> 2.52.0
> 
