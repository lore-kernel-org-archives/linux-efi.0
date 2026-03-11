Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44D036B043
	for <linux-efi@vger.kernel.org>; Wed, 11 Mar 2026 16:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773245444; cv=pass; b=Eeiit9cd71P410HkenbcexcZ/B6M2sTiI2Bhr+kdxZG9P+x5V9J/xou3lkENFbvAe13I5v0a8+n5PnHKNr2tx5c9lpS5f1djdGnqHdQLYj9emaM7H6GQTvAOsRytdY/srUEXxmsQCvcpnawvzKNDw3YN3fmpMLMuUkkbfc0jXHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773245444; c=relaxed/simple;
	bh=l1VUpQZtDmi4yQeOcXh2KuFrLzzMGuL/W5kUT72VDPc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZbYyWRfpqVe/dbpeQYXSR0bJETIoBgeQt9uDmb7fYj1I6XYj89mbyQ5Jk062251VajtMakpSdzwGB0E64HC9IBvMKQS1iwMC7w8VDYIH2u9ENUj9RmRTR9u1xdcb3HAy1C7XWldiEVlO92QeQdqTT2J5J1MI+jWYjHt366vNn3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jW4xx7U1; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jW4xx7U1"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64ca09f2170so54864d50.1
        for <linux-efi@vger.kernel.org>; Wed, 11 Mar 2026 09:10:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773245442; cv=none;
        d=google.com; s=arc-20240605;
        b=duD8ngM4nUBrhHWiaoUvZOcQD6VfD5UA5YaFQhcRSGKJvgcnKeT8PJLlBYbrdwDvOh
         NQ6wBIX9pJm/Yj3njICHtuaYUv+00OAKkP+LJxcW1sR0RSGCa8zOXu3lhvWOztZnXjzU
         H2kwu8EzcllxHD48RXx6XZ28aDX1MKrjeWZPpJ1Wp/jKEr3FAKbA0WNrH8cE0XCQr4go
         az1ABASCLqjRCNKTsbRny3O36CWX3i9akjdYS8kmYlXmgAbJbw1cCxAWX6sJvlJEinvC
         1LrKKlhwXr1cCC//CW2Ua2RLPXhPOPoJa5qAf4thoF0Bu8t58qLuw7JsUA9j+g+WZhp6
         l5qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ezd2+24+0creudc9aX/kkE5ClcBiKIz+joyV9ZlEgjk=;
        fh=NltGCIvqUJ7l17DtQuz4O5z6SGPlT/IqtAbg72i00Vc=;
        b=UupvMzTFMJYyVBiD15SPtaLefOM5EX/pLMUiBlsrrrPHWCRYRVHzDqu87OTYBMZ01f
         hrF2bwRRIkbh7fhkInWjzRIje8jkHOeGwJLx/bCL8mwOMSv5wQL1PCiQTTIBjuVeC2NP
         ukNa3jnc5bzXE8UwxSkPhhJpmhX8Khaxn0jGrotdT9k6FMIcJUZatlTbkaN6G6j+hrvo
         en+tU3KQBOqwPnDA550i9KFmmkBx9xuULYGDf6pXOfa1dMRWlTBhCtaYCCQ6/Uauifw3
         T+Y2LNTMO0kdu7CM5/s7ZkLpxDYAvagbKf4oNLiuoDa1+73MmfzaLMG3MrbdN654m2wI
         56Bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773245442; x=1773850242; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ezd2+24+0creudc9aX/kkE5ClcBiKIz+joyV9ZlEgjk=;
        b=jW4xx7U189TelB0cTOcUUSnKkjPEhGCj+Z34aV/Xy8YDizS6ayy4J2vloZrU+iMJQl
         uNUeqcVdXWzD6DBB8UK4U9mDgCUrngVu9zpTOVKlbPeDY/qQD/qnbH/51riZtW0usIvG
         MJa4VeyaOOeMd0ZKFPO+LFCwUydOoeNZ88VJ4NhaLZdJCHij9nwFjklIo8Yn4gCylRpx
         NmO365zFK33Pg5P91bvd3mFnTEOGtI62/coSFYnlWEbPJnwXC2GudVQps9D+4COUpkIr
         S6khUKdMukvcRqcXV7zlenVMs0tFRnjDNWQThBOR186JQDnWkCmFUm/zYHg0Ofuj8EQE
         0Kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773245442; x=1773850242;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezd2+24+0creudc9aX/kkE5ClcBiKIz+joyV9ZlEgjk=;
        b=f/ODetZCjvf/81Sr1YiImfBTpd5q41xFYNjKtjIxhxBg2hxfc6plxxtPEQ9Pb3GN+V
         lV5kLe2tmhAT/U/fLm5XhMjN7mGbrW/bD//LiPeJv/0orQ1QKbDmE0dVp2zR9j+4gkSl
         qH9eib2zJG/yCgG643TwIlvxcdK9LygN4OYD+k6Zo85uEllFgJAxIh1lGthpQtibsdT5
         POhiqHRD4wJUAMXccLhu/5Fa07vVqK4BhadnFQ1zApUZFTq1vxPKQ4RX4hzoBxXHpMEi
         LHMv9FFQfg8Usfk3idxkwy3qVq+7p6NWoNEOQZSdh8FrhNflNK3HilElwSxktBUPJzWO
         0cvw==
X-Gm-Message-State: AOJu0Yy93mkZVANrNYsUMYTX3Vg7BWf3jNVAvFl+mvVI4DOO97a9LToC
	2gmF+M5hPWs0homLaVvj40uMMoop/ieTlP4HOtQ60tJ0Y553NpHmUWxhOQ7zCyM+LXUHHP6VVwP
	wPNhysOdKvHQ4fHRxHnJKmvqV0MePLnyX1V6zlcHE1Q==
X-Gm-Gg: ATEYQzyel8bBuOiGLtvhBpvXAyn3f+3coW+JznFQnZTkXfrNWASn82uYGuyA5THKu4n
	RN6t8rIl8Qt0Nrge0pe/G+lZi8Kk9GngWIXviQ9uXNGvqWbjMA4SQW/Lcn3kghsBUiHS5EBRucK
	3Ow6Ms3B+rE01v7L8GHoFD9anlSil9WuAF9od+8VhH37Ifuuy5zPdF2EHt1O8ezvctTTUR48u6Z
	1735ATh/lFyTN7HcnMJsSNJijzNLkkiNiF6WJHZgFYvx3LZoBKujM7RKAY4OctuZxmgqn+BQf63
	Cw+adStQ7ejVkvFkXNZMz0cbm1Xnp22s0scUNxyq7Yk/Q7o/rCe6E937S9S/qnB46J/m6sCvUsc
	gdf7TRNqdKgsWCyGKSJDpQlrXHC9/PZocYfsMVsvpqK3kdqxcIYlJrGzKIa/f8f4yjwO3kl0yEC
	lSqUxPIpvBfGjwnwcgBWrmZwjpwzGUYPAn1MDr2Qs6Bjlu/fajQ8P9nB1VvpZaQ7bJDREhXXkjB
	xvWmO5qDPUfNVrfpdGHIkaOnQAi26ol6wAsE3EG1/nt4WS4otrXZVgzEDtEde0ym8Ix0EmhcIF9
	Y5f8OJeaSB5rx9L26a+AQJ0k/KLkez7fDxp0M9lU2g==
X-Received: by 2002:a05:690e:1aa7:b0:64c:a3de:57c7 with SMTP id
 956f58d0204a3-64d6578aba2mr2057317d50.58.1773245441096; Wed, 11 Mar 2026
 09:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309125324.1876754-2-ardb+git@google.com>
In-Reply-To: <20260309125324.1876754-2-ardb+git@google.com>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Wed, 11 Mar 2026 18:10:05 +0200
X-Gm-Features: AaiRm512Fc8-rjMY4ffuswQouTnJK7SBJ62jtQmKRg4-8rHchod1d4JKyAxuOg0
Message-ID: <CAC_iWjK-DnCaUJvfGe=h2-+Tno_d6Md1jDB18z8uwJ2F1NbpYA@mail.gmail.com>
Subject: Re: [PATCH] efi: Drop unused efi_range_is_wc() function
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Mar 2026 at 14:53, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> efi_range_is_wc() has no callers, so remove it.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

>  include/linux/efi.h | 21 ---------------------
>  1 file changed, 21 deletions(-)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 664898d09ff5..72e76ec54641 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -832,27 +832,6 @@ extern int __init parse_efi_signature_list(
>         const void *data, size_t size,
>         efi_element_handler_t (*get_handler_for_guid)(const efi_guid_t *));
>
> -/**
> - * efi_range_is_wc - check the WC bit on an address range
> - * @start: starting kvirt address
> - * @len: length of range
> - *
> - * Consult the EFI memory map and make sure it's ok to set this range WC.
> - * Returns true or false.
> - */
> -static inline int efi_range_is_wc(unsigned long start, unsigned long len)
> -{
> -       unsigned long i;
> -
> -       for (i = 0; i < len; i += (1UL << EFI_PAGE_SHIFT)) {
> -               unsigned long paddr = __pa(start + i);
> -               if (!(efi_mem_attributes(paddr) & EFI_MEMORY_WC))
> -                       return 0;
> -       }
> -       /* The range checked out */
> -       return 1;
> -}
> -
>  /*
>   * We play games with efi_enabled so that the compiler will, if
>   * possible, remove EFI-related code altogether.
> --
> 2.53.0.473.g4a7958ca14-goog
>
>
