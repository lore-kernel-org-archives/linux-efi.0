Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78094397E75
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777277337; cv=none; b=M8T0yUMcIYWuLz0oFtJ1j5g1CdLlDAo/mGFw0GDVVu0CxWDAilwB0rvNHk0hXgFP1edTEEl71TITkAZIV+5GqlYZSi3o7R2Re3AJS8x6KCPbPLHTY+p3EZtV+IbUbsoYEB+XU1NlNX5DKA7STyhClq+6HQKuurCU4AD4soeuEk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777277337; c=relaxed/simple;
	bh=/JfDdt2I4oLiU/EdbMCnMPt7jdZem/h5K6P8QdniN28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E0Ypa5WCrgNmlQ3bWp+jZThyZU2ljUT9W4jzHeL8sAxzuVUgN8Ex4LyoQUfQifEWjyjs/75XaXEwxYtnJtscVotfmZK7uITX+/RM5tyA0T0euUpaCz9383WDx2QenfFejj6swR2Hi7vvRHF68YhnfQgV+ODReAG5wUuiF8OPSns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aoi1Phd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aoi1Phd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530BEC2BCB6
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777277337;
	bh=/JfDdt2I4oLiU/EdbMCnMPt7jdZem/h5K6P8QdniN28=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Aoi1Phd9conYWXfCjAjEUY/MEj0P1llM8Hbhkn7NIfRqrivk//0sUwbdL1V5d1iW4
	 0l0iTI6q+hBw/R93g1xhXIuFPMNDrM9fAVqBF0G6l+tw/MyZu4UaVTP82wAGH/U7dS
	 dJmu+K+nYtABLEw7aMMK051erGhpWs2nKZZw9pf4gLscHkWn3cf1bgdmQ9e1Z/bNYk
	 /q4afWR5rJpiWKBmnp+4zLIupo85DJAaZS34RYs8bhBrgA0Xk6n2Ld2SltOTufl3ko
	 Zup4zjiduaTURFGdsvX/X5tUwEomXiKxmWygeQOHYQtXNDPpnamAS1pBnKGlTYN5Pw
	 NeSAQE5zA2IEA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ba8472c1613so1371592866b.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:08:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/NtCXZILvy+YxAFb+PjFOIbPTZLDMm95hDDZZQiSU5KIkqJEk0+07rxQzk39Hbjl+BvgS130OM+IM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZOtBx1s09aQS6v3hRyrKJILGYMeHDh01oDvNCZr+8sQH7V2Cg
	/uK5ABh+jXx/z9729760D9boFU4xHFRMbPDilTtKysuZjdQvudvhyWxaJowAGDNGNlzsDzB0xUe
	sGIBkvg4MwQlIwLtvyCexI8UWk6/rpH0=
X-Received: by 2002:a17:907:a0d:b0:bae:c57e:d192 with SMTP id
 a640c23a62f3a-baec57ed203mr406565466b.41.1777277335671; Mon, 27 Apr 2026
 01:08:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427034451.717817-1-r@hev.cc> <20260427034451.717817-2-r@hev.cc>
In-Reply-To: <20260427034451.717817-2-r@hev.cc>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 27 Apr 2026 16:09:11 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6ggC8c=KGOZ4Fo5v-CnWpKUP47nXY9OgD6iLD+dnQTBA@mail.gmail.com>
X-Gm-Features: AVHnY4JvjsXBWK7RINWAsh9GOr5AKrv8meFZUzZQD_0QmJFHtg2mB39HC39y7Cs
Message-ID: <CAAhV-H6ggC8c=KGOZ4Fo5v-CnWpKUP47nXY9OgD6iLD+dnQTBA@mail.gmail.com>
Subject: Re: [PATCH 1/2] efi/loongarch: Implement efi_cache_sync_image
To: WANG Rui <r@hev.cc>
Cc: Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Rui,

On Mon, Apr 27, 2026 at 11:45=E2=80=AFAM WANG Rui <r@hev.cc> wrote:
>
> Provide a LoongArch implementation of efi_cache_sync_image() to ensure
> instruction cache coherency after the kernel image is relocated.
Please also add "()" after function name in the subject.

>
> Signed-off-by: WANG Rui <r@hev.cc>
> ---
>  drivers/firmware/efi/libstub/loongarch.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/=
efi/libstub/loongarch.c
> index 9825f5218137..26495747f69f 100644
> --- a/drivers/firmware/efi/libstub/loongarch.c
> +++ b/drivers/firmware/efi/libstub/loongarch.c
> @@ -82,3 +82,8 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_i=
mage_t *image,
>         real_kernel_entry(true, (unsigned long)cmdline_ptr,
>                           (unsigned long)efi_system_table);
>  }
> +
> +void efi_cache_sync_image(unsigned long image_base, unsigned long alloc_=
size)
> +{
> +       asm volatile ("ibar 0" ::: "memory");
> +}
Please move it after check_platform_features(), which is the same as arm64.

Others look good to me.

Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
> --
> 2.54.0
>
>
