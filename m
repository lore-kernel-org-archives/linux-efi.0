Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DB5399039
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777277353; cv=none; b=BN8cbztwjjejoLeNKZ6Y+0oIgZmms53YlZHDC8fAIPvwQzXbREaDkkvBE1tBvfousAsWFqBFs7F2ZJTtARdMqchAvjLJVM2fkxEOeRXu0iAShuCs07/CvAjq67oRqOiXI5ZknLNoJ/Iaa6hYgCJCSPzMOQB1md/nPwc4P/4bbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777277353; c=relaxed/simple;
	bh=tlDJUHAv3bs4YHGfPiJQCEtb2tmHcIfreZyo2SAVGJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cRCq3VqlH+lJvLij7HHFc6IsaOYApMOWDb+aLrayXAVfRPBgoJP1IcNp5bWsMdgBkjyjJ5gyQo3OgNVBM+05joMuSC2Xtm/SjaNNtaPe/6+CxohtasVlJpjLsl/XiVcR30rRF3JGSFpNgPp4E8SzSOy5dYgk1Lc/AVb5roZhRFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DlUmEC+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DlUmEC+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B255C2BCF5
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777277353;
	bh=tlDJUHAv3bs4YHGfPiJQCEtb2tmHcIfreZyo2SAVGJo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DlUmEC+MI8XlyPw86HvuPF4QVJj5d3CVEzic4tHTM41mV3JQI4x/vFswwZxKrtpZx
	 F/aUwIHvvHaFTIbn/0D6bnnG4x25ifsEsQwqekKWIJBnAs5HuhcaLHmmPXyqwF3R9w
	 WDuaC67ZajYRN541t+n2OOugMxwgw7r/MC1s/HVfPHEACD0a3J1igX3Ziy+clQ3tQx
	 vjtP+oAzRZ7ubsYj3Nbw1iQWVlnSW1o4SQjp9xdO+4tC8lEDpEifxg9/uKUckgFpr8
	 AERnbO7NZtqCwBdXKgPSDSRhA/AHx2LIQFnAYp7itoDw7IEI5osUC99KDYVNTEXuCA
	 bh6bVn8K45rZQ==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6763cc8775cso11200480a12.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:09:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/YmUt3tZLLzvvY4bqua+oCD8shv6ySLCz7OBl972ljgdj5HwJJ6e+1zb47Xo8Bk3QSjG5C1j5EDlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnGjfch+QZVrZ3i5rMhF3Q6MAAZVCeNUujvAF3jVoScQgK5waE
	unoq0NuzGWFy0DhegDtX+8kHjOsljJh+ng3UD4TGGVPigL9LlAN7BJn0hqA6iFmD98QpiQ7S1Xw
	n5Vv4EBbQ2FHoMgckwyUD1bDElxtm4lg=
X-Received: by 2002:a17:907:9495:b0:ba9:30a4:537b with SMTP id
 a640c23a62f3a-ba930a45439mr1289288266b.18.1777277351461; Mon, 27 Apr 2026
 01:09:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427034451.717817-1-r@hev.cc> <20260427034451.717817-3-r@hev.cc>
In-Reply-To: <20260427034451.717817-3-r@hev.cc>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 27 Apr 2026 16:09:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7zGFjzBTCLMZvE+etd2J9Te1+9Xr9GwtjvBSXgGYfQEw@mail.gmail.com>
X-Gm-Features: AVHnY4KCB1-pOIIrSQIlFfTO5n7_wXLFN1dkGTAo14tPjpI2E_CYUoJmYTC11UQ
Message-ID: <CAAhV-H7zGFjzBTCLMZvE+etd2J9Te1+9Xr9GwtjvBSXgGYfQEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] efi/libstub: Synchronize instruction cache after
 kernel relocation
To: WANG Rui <r@hev.cc>
Cc: Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 11:45=E2=80=AFAM WANG Rui <r@hev.cc> wrote:
>
> The relocated kernel image is copied to its new location using memcpy().
> On architectures with separate instruction and data caches, the copied
> instructions may remain stale in the instruction cache, leading to the
> execution of outdated contents.
>
> Call efi_cache_sync_image() after the relocation copy to ensure the
> instruction cache is synchronized with the updated memory contents before
> control is transferred to the relocated kernel.
>
> Signed-off-by: WANG Rui <r@hev.cc>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>

> ---
>  drivers/firmware/efi/libstub/relocate.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/e=
fi/libstub/relocate.c
> index d4264bfb6dc1..913b425d089d 100644
> --- a/drivers/firmware/efi/libstub/relocate.c
> +++ b/drivers/firmware/efi/libstub/relocate.c
> @@ -158,6 +158,7 @@ efi_status_t efi_relocate_kernel(unsigned long *image=
_addr,
>          * have been allocated by UEFI, so we can safely use memcpy.
>          */
>         memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
> +       efi_cache_sync_image(new_addr, image_size);
>
>         /* Return the new address of the relocated image. */
>         *image_addr =3D new_addr;
> --
> 2.54.0
>
