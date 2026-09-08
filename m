Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D8D509F19
	for <linux-efi@vger.kernel.org>; Tue,  8 Sep 2026 10:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862688; cv=pass; b=qVXun1eL3K4X2hZg/pJdTDyWeuOcvVntGFnVUdFggQnBziQQp7V+f46CmTb8lvVAlHbTuwNYRY3cmnRaBZ6uM9ZOyPYq1dUVPNoBD95XrM3pbL+1oDk0BfIedSbBvT8yh0zTVl5ko5+JJUDHOuNXb/L9Byo9Z3JYx89zNWI+sWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862688; c=relaxed/simple;
	bh=JWKHM4xhjVVj9o1CYYnXhN5iVw47R++Dsndo96mshq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BbmXnN9HDR/ynQien5K/cFQgTPYz7QNFgBb1laoORYhOW0LIFetlZdXdYh9ioAHfbkxmIMEEmEW71jKa6hAXrgO/GdvlMZKxEzohrpkvLdGNo9PBZ4O1iJi05sJ6XXFz8bssfjSS+lOp6Wg1GVAcYtx+PHxR7InE34puG93sC7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eM+S9Xbv; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eM+S9Xbv"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-861f30636f9so61863777b3.0
        for <linux-efi@vger.kernel.org>; Tue, 08 Sep 2026 03:18:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788862685; cv=none;
        d=google.com; s=arc-20260327;
        b=jO0F73T5s+Oxg7n1G1Bd+jfWpLoERtLcnyKT/MHf+vCWp80uo3AWytYcKHc3y1IYKV
         nM7QULX3tshA0UcU8jqPl8zT6JEl9Ob5Jq6rqRUxhZKYO0b06I7e95A8pg+CjXHkqtN3
         7pIe9dmyHXjuybgDjvSqxIb7UzY2XEQXTnohLUR5XTOB2F1G+SpnWPf+TVkKW8DAktNt
         6X4saURWihrDyhGtsLI4fpFMUPg332ovsn0RyZsT8A6k9sgNaemqiHUmllI5Xo/m3LPW
         pdlPybMMxeuwI5aVWC9MOwqaOtwE3qPNL+TWxuz5IY9zzkA6MemyX5eiiVUU2wLXjB8e
         0kBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cLIVHgmWP92ScbvFBUNRbCINvKyYqSKCdwo7uYzpFHM=;
        fh=Q4FxDMfSio5E1Db0lWhU8KJIOmtSg0NYzVgDw16kB0Q=;
        b=CKOGvbYR4pvGAl29XFNcg74OIt0skfw/WtZbF0XC3DEE56CUcWvNzWJOuu9tpckiow
         ytFbFuUniD4ODkYXlym8/W7ct/P2bkKIvt1P8NfoyvJ8ppHZR52reXnZUzeuQ2ILAkPR
         51fygik19bzF0h5nTePN+R5JJMXlCKrQx5O/s8v0Yg3HpRL9cyCrsc3VgOyhpyqmTwJq
         h9gfpJzdH4TyefE1bIgrU63muCn8bwS/9DPEvm98rVnW1hkbLKB1n7scKQPi6IVhFGR4
         XkyHswp+HzPpZplk+NdgelB9p7hv01nlw00FFTdqYlCbQFDym1UplpeSa2bt9Q+Y4b/7
         Wfkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1788862685; x=1789467485; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cLIVHgmWP92ScbvFBUNRbCINvKyYqSKCdwo7uYzpFHM=;
        b=eM+S9XbvtDNL80ueItEh+MbBwkv7Ct9ZQRnv77MU0MH+674HeDpBd86h3juhgMaihg
         jSDeVc6EEkjNZSpiEmprkSnT7pxW+fr+TMfxBNvrV0e4SM5iU79SNlcR2aOQln13eUIh
         phsKcgtOagx+HosLtNqDZTZ6dD8CpGUVK5YSFNm4q7sXRd+hh1dcBEyVOuilJ6oBSTTp
         Voes9rfvKVexEjaug4KpLzo9xOQ360xvIpE9fYBmV5/NcwjCN/hdmpLkjAE8xLWY1Ecr
         MFO0KtaJhyOd81shINN7JFpSdB4ygyvMCkLJUK3XRh3gOwIX/u/OXCVqyxXitGWkobmQ
         OkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788862685; x=1789467485;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cLIVHgmWP92ScbvFBUNRbCINvKyYqSKCdwo7uYzpFHM=;
        b=ov9LWmefFnAg6HHNvxraO1cf0FPprBF7VSfZWuJptUrQxAplDbBzdEFgdVXORdlHRq
         8CH2UtXFikXRXffGKZhCX+MCqEvI76HIq8bS3/GNJLdc3qmfrGI5G4BHqL/OZKA+ij6u
         adIaFQb6hHtwtm6JgM3Rie8kQFHymybgOa6Vtko7oKD0hpLyKpiRBjneOn4RihnAe6IK
         HKMXRQsfLDeDEHPylVGXlYtk5tWvcKtHwWSCZRr24UN+uTFwKoyPsq48wrzTSjVUlQSd
         +SRfxcBgcBncx3M+P1fgHkvQ6W4ZyGWFnnkwmUD00oj17zv4OP7ujyLBFrRLpyJKNkrA
         byQQ==
X-Forwarded-Encrypted: i=1; AKwUvBws0bb3P+f+YO9Td/Y9EJCirW34VhTvdL6Q+OQSHznZtUww7y3kiPj5+cUYaRF7TzLE9oWyAyRfihM=@vger.kernel.org
X-Gm-Message-State: AFuF++ltqa4vHsJv+nvRtp1W9Lkjee7qHB8HOXIy65rMrM72UgJmuVwX
	NqKw7gR+MHHth9n4TxOZoyGWIS/H1Nwp07eAuQQFh2Hpp/E8s/9AMnFaf8mPP/q57qVgT7iXX43
	sIaNzv9IvGLOUChYcEw42DQEBvXMJ5ExdldvGXzmyWA==
X-Gm-Gg: AYBFou3MVwCBykHIoavIi4/YbAhr76mJUzLf7T6gnp/yQ6tBphmW8PhGVUmsJc/wKYW
	H5bfqjKSAohj9OXAG5WPmJPCvoSZLajuQg7g9L7XJp1fG0IwWlAAHJJ6dKe2Ph3rboQYui12upL
	jkU60q3r/3262vxtb2GgoWounAMo3tLD3C4esH9nQ5Ma/giIzpnwTN/FLqwLeSHW+soxDeL4urS
	NLTESv87ZLUZGSv89Xb618D/wpDmiX/vO9WekPIq6WGq/aNeFwZ8JvaqKdxki4WOM07KDSr+zCb
	Qv3s7DF+prkH9KXdW1sE17QH2xcHc7Oko9/g0Kk5av1HYebHMk3fh3fiN3CIdrp/3dgRz9yfnf9
	dfBM8cysdN4FQE3utmQ21f7D4avQDQokTddXjkn+zKdun3wwEE+VnryHg+XIKl+jIIIIEtM1Kig
	HxLYLt12jrt3njVOIpl89qWzrJd0SRpZUYROWZOIUtVRrP7ov+ugdPOWQ91jwSJmC7YtPrhzG2H
	/UuPVNTgMflWgZBKmva9KEKyO49ZEA0fMexXAOEF2xp4Y/IDu0qN9pFaiW6fYeZPYOH7rHQ3xpC
	SbWdZQ9eBYGMtFgWbrZYsNxrA+SLsDgBLzzFbXlKr1T9qRx5ISJ74U+QcIXTE4ESCDJKElVtl8S
	LSHIsD+PnTHfyJq08vNO+AFzJ02GYa5IUgF4Kmd8cLqjM
X-Received: by 2002:a05:690c:6602:b0:858:d6fb:2b9f with SMTP id
 00721157ae682-871221ad847mr97459367b3.5.1788862685448; Tue, 08 Sep 2026
 03:18:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
 <20260815095057.2461943-1-junxiao.chang@intel.com> <be731d49-398b-4b5b-9de5-b94d53177f94@app.fastmail.com>
In-Reply-To: <be731d49-398b-4b5b-9de5-b94d53177f94@app.fastmail.com>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Tue, 8 Sep 2026 13:17:29 +0300
X-Gm-Features: AcwNN1VCPP6_XNPrA1Kh1llyOtPA4jWMwQQl3eSQ2tuDlYnGbLuTpGFYmwCQdBw
Message-ID: <CAC_iWjLP1rXqw8dAUzPcZUK=pr+aOXY4w0zEW+WjTC2Kmfya1A@mail.gmail.com>
Subject: Re: [PATCH] efi: add dynamic control interface for EFI runtime services
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Junxiao Chang <junxiao.chang@intel.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Sept 2026 at 13:08, Ard Biesheuvel <ardb@kernel.org> wrote:
>
>
> On Sat, 15 Aug 2026, at 11:50, Junxiao Chang wrote:
> > Add an interface for PREEMPT_RT kernels to dynamically enable or
> > disable EFI runtime services.
> >
> > EFI runtime services are typically disabled on RT systems using
> > kernel parameters such as "noefi" or "efi=disable" to avoid
> > long latency caused by firmware calls. However, this permanently
> > disables EFI runtime services, preventing operations such as UEFI
> > firmware updates.
> >
> > With this change, EFI runtime services can be disabled while
> > real-time workloads are running and re-enabled afterwards,
> > providing low-latency operation without permanently sacrificing
> > firmware functionality.
> >
> > Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
> > ---
> >  drivers/firmware/efi/efi.c              | 31 +++++++++++++++++++++++++
> >  drivers/firmware/efi/runtime-wrappers.c | 28 ++++++++++++++++++++++
> >  include/linux/efi.h                     |  1 +
> >  3 files changed, 60 insertions(+)
> >
>
> I've queued this up now - thanks.

Apologies for the noise, resending as the previous one was dropped.
One of the things that changes with runtime services is mounting the
efivarfs as RO/RW.
I am pretty sure nothing bad will happen, but is it worth the pain of
remounting it on enable/disable?

Thanks
/Ilias
