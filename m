Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FFE3CDBB7
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 07:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789025043; cv=none; b=OrIime9/n9KjhU/zYjdvZLAJz6E3wavefGejrDsAN3m5MOj5A5GlQgCN2gx6WWKBNKJb0m5WG/zEOQVw0VanUk3/0+PIyoR4/56KHSJdJVzO0PQYjn2Xe386IC4g7FE7qGGeTctIrQqZN0iV/ZMBzHu6hevuvNYl/Ji4RGJ0AmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789025043; c=relaxed/simple;
	bh=WijhfP3pe5Vo2rHR/9rNlAtZfvs4vMhxZdsLb6ZGzIo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pnzGOSYUtjvjLPStKkegxlsG/dRC9ramcp4N/bdAdycXY/AU+b2uZduPilXjl85UZMAth9KmPRtBFJ0t6V2vfJC7osU3P3qnYNfmXkxbsvAuVMdKmF+USP/NeCprVn/2DlxDRUXHZY2SFsQKu23GYx8aE4nZQpxfzn/OExmEqz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jHukHLvA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FWhx6qC3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jHukHLvA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FWhx6qC3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789025036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jz9koIHvC3GBX/XUcgHOfcrwJtKrYjkKEL6ZBTQ6TM0=;
	b=jHukHLvAa/jp5RlxtDiEZvVKpbGbC5MkGYjPZrNDAAr+EagBJssKUXYTlN7Yjtfqsb0LyU
	WdfMYVeNFhbP/YuZzRiy2lDm6WtVFERbnGVTjLBblS0Lc7085PtKc+KwJ8Unwk4V+vJIjS
	FHzmfTRaNiSTUpDgqmOTwSkCWUj8k6A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-U3N3LxwkN-2-7BdLW6skcQ-1; Thu, 10 Sep 2026 03:23:55 -0400
X-MC-Unique: U3N3LxwkN-2-7BdLW6skcQ-1
X-Mimecast-MFC-AGG-ID: U3N3LxwkN-2-7BdLW6skcQ_1789025034
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49b0e6638e3so49890985e9.2
        for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 00:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789025034; x=1789629834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jz9koIHvC3GBX/XUcgHOfcrwJtKrYjkKEL6ZBTQ6TM0=;
        b=FWhx6qC3cYlBfnNNz0OxvQkwKiDCHoPAr9OxQvP8uygSsW6cN/9+k3dQ5ILDI4smCW
         yrC1qxgNBhzXjESCDk3jUeHOf/CkqnhcJa+8BakmFBVnqDnANJuMEPnJPoRmLSds/BTe
         ZNLQGnDGwOfbqKHJw4j01KFgMraX9fauyonNtXgIYzTpCYO+RizbK/VK4ssmcCHpdvuV
         tBLvMEl0QG9awyKw1ZGNKe2LotcGzphKXpafwoTV344adJ0ybSY6gTxx5FgDG785JZQE
         83lUwpQhlo8t7/NDkUEG89kgwvgEoCjoxRfa+oW2u7LZU97NGRpqYjEgArxhkwxQCy2Z
         1lnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789025034; x=1789629834;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jz9koIHvC3GBX/XUcgHOfcrwJtKrYjkKEL6ZBTQ6TM0=;
        b=GL93HD7qw6txSH1Ysr8dj/+/tXpLDEWzfrbG754xYmfaAV2VvRAHoEIhIe8XudYhRq
         wJ0lGDb5F9HhimaP4AKNbQrLgfwv6WQ3FMXL9MrZbOkFIUTukJd7Wtsb1aImUv5bZWmD
         Vypp5HyYVt6UeNwOVgnmGMolsprwLgOHKvmflqulW0QjbBX3YhqXWp0J7IgywaOwLrCt
         2uCUH9SkFt9YVrs0O4TALCLpPXtWw12xv6rf7q5xSHSTOMRUKYOp6z/gU5UuY1P+TK/w
         v7tZaFzHaxWkKVpwvay6qjpFh2vTn1JblNm2iv1KebkdP6661GH9+29irn/7PJxRMzTU
         mhXg==
X-Forwarded-Encrypted: i=1; AKwUvByCJL/FiL7ztOIFMk0lvItiZPpL++8fRwuhWCfEkG/dg9Uc+KcAGR15AILZk5wxlNUxRyQ9ag3yphA=@vger.kernel.org
X-Gm-Message-State: AFuF++k6oHlUzxp3Bp6zSq/cjC1HQ+6jZjTZk/UbpTEk1tEBeMgdl7fX
	mN+D2+6Ys4NdKJeUJCXrNosAsJLvO/SnYfVA1NoKU3DiJpzSJO1W9D/uVWbydJ0AJE1GMxItKqb
	6dDJ7osyGijpWPZMg9KN7BgwTeD+vuHifFiLJ0D90JuFh9NUF07HmSkdQtP54Mw==
X-Gm-Gg: AYBFou0Pb086BeYdW9+srkxPFU/UVre+5UKlzlEzuMIRqD/tHC4Qw70w5FzEIfP24Mf
	iCREVuvRG2MZ2StfZrynVWRaYo1YjPZTjiLWZ09WEv/ri767pWVON+ih6k1OC2C765o9DQtGMtm
	44QBkOzLNze8gae71YJo5hZUn0HfgSlCHC0hYB9pw48iPCKbtP/7b/YOA2e4V14nWv+kyNK+n/d
	l08b53SZ4YGI2FngyzN/G9gNx7yB15RLRfYcBpNXQ+cDsFXOOR5tOeeNXCLBbFmd2us7bwyCQIO
	7kbaPaoCaNYjgUB/DJFpaK3NTVyLl1khXFb8ZA7wfTX3RIYPNa5h0wY3hdPXgjLSMjI8AiNqEUM
	Y7L+rEVgwfOVfqbt7MDSRhZstH98lNjA/EKdRMdE3WodOu8Vys5B4yto9fA==
X-Received: by 2002:a05:600c:46d5:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-49d258d8be2mr48295495e9.9.1789025034250;
        Thu, 10 Sep 2026 00:23:54 -0700 (PDT)
X-Received: by 2002:a05:600c:46d5:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-49d258d8be2mr48294805e9.9.1789025033597;
        Thu, 10 Sep 2026 00:23:53 -0700 (PDT)
Received: from localhost (62-151-111-63.jazzfree.ya.com. [62.151.111.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49db038401fsm19301115e9.13.2026.09.10.00.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 00:23:49 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, ardb@kernel.org,
 ilias.apalodimas@linaro.org, jani.nikula@linux.intel.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v4 1/3] firmware/sysfb: Remove rotation quirk for Lenovo
 D330
In-Reply-To: <20260904090850.43060-2-tzimmermann@suse.de>
References: <20260904090850.43060-1-tzimmermann@suse.de>
 <20260904090850.43060-2-tzimmermann@suse.de>
Date: Thu, 10 Sep 2026 09:23:48 +0200
Message-ID: <871pb1efi3.fsf@ocarina.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thomas Zimmermann <tzimmermann@suse.de> writes:

Hello Thomas,

> The Lenovo D330 is a notebook with detachable display. The display
> is installed in landscape orientation, but the display mode is in
> portrait orientation. By default, the display output is rotated to
> the left by 90=C2=B0.
>
> The sysfb quirk breaks the display by swapping display width and
> height; and thus mixing up the display geometry. Fix this by keeping
> the display as-is. The sysfb DRM drivers, usually efidrm, will pick
> the correct panel orientation for the display.
>
> The exact behavior might depend on the version of the BIOS release,
> but the exact version numbers of broken and good releases are unknown.
> Users are advised to update to the latest firmware.
>
> Tested on a Lenovo D330-10IGM IdeaPad with firmware 8NCN43WW.
>
> v3:
> - mention possible dependency on BIOS release in commit description
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/sysfb_efi.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysf=
b_efi.c
> index 685283bb7327..2338de73c62c 100644
> --- a/drivers/firmware/efi/sysfb_efi.c
> +++ b/drivers/firmware/efi/sysfb_efi.c
> @@ -301,15 +301,6 @@ static const struct dmi_system_id efifb_dmi_swap_wid=
th_height[] __initconst =3D {
>  		},
>  		.callback =3D efifb_swap_width_height,
>  	},
> -	{
> -		/* Lenovo D330 with 800x1280 or 1200x1920 portrait screen */
> -		.matches =3D {
> -			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> -			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
> -					"Lenovo ideapad D330-10IGM"),
> -		},
> -		.callback =3D efifb_swap_width_height,
> -	},

Agreed that is better to rely on the information provided by the
firmware, instead of having this quirk. Specially given that it
breaks when the firmware provides the correct display geometry.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

--=20
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

