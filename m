Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD041736E
	for <linux-efi@vger.kernel.org>; Tue,  7 Jul 2026 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783430663; cv=pass; b=rZIGtyf9b7jed9V3A0V2Cx5Hn+dsj392GP2R1cyXWw4IMClrs1K0SP8hEVZpliIrdSc5VIbrO8H0YiFqWQ/7afb05nDeFrU0oTi0lmXkAuHNcSiohWHoDB70zzfQEoLMCBPAm9xXYB07Q8VI/ArpmJG4XyTlUI4hQRKGtbAMNso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783430663; c=relaxed/simple;
	bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gYOL3kX0lvt2/8AfC4qWm6ItbxKa5lDsImT+kZYMUXfrI1SjoK31vIUBdm87jOaZNz8w72lam8GRYCI8M9cCkHR3CSIa5y4NVd6G2kfawwbrdAvMtwlbdS7Plk1H/pXaoz5DQdsUeqHLPVuhBp5YUrxQ17qfvA2kFmNvS0t9Tus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h6f3QVV8; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h6f3QVV8"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-664c6304683so4052756d50.2
        for <linux-efi@vger.kernel.org>; Tue, 07 Jul 2026 06:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783430661; cv=none;
        d=google.com; s=arc-20260327;
        b=lB3jmuRI6jFLwKK+TFgp7iIfF1E33S320AGRvyF9tRovnVlIlBxUTKMP6FZA3lQ7VF
         oN075cw7NHdasHk6bqNzeABnTjK5HjrVg5ZD3HlYy7A+esomg+94tr0Gf1wp4M6KOkXs
         JnY5znwqMNh9ECrkAxLlf1zvjvuhyg7XXQI3K21CY/B3YSqTYzYssVs5YMDPXil6s64X
         f6t6DplvtVSF8wH0FzWHYtkzJdyYEA+BSOpUHH1VSxcRUTOEvNanoa+0ATL9fI+2UBzt
         0+C6Bm3m55pcWCDFAi1F9dewOaVSZUaeQVwLqLMc8H2N/UmnZIMWvZZ9OG6WQspH2pTv
         g1/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
        fh=YDlcuidpIJb5eu3CZiU2NiYGEu75EWDCOlm7zUWXjrs=;
        b=mxpUNbBqgwKRfT3+2HieLuUIAOpskiIeE+j0O/syZDmCpq2mAHMDtvgYL6UBtz/5TB
         7wJoJGMtn19/PQWrdRaD0iUZGjGrd+jp/f4nobroDdT1Pmg3Pd2dPbXpabJaT72wySBz
         MMC6832cknJGxUFnxpT9bhl6BG+a2NH5M9j36KAA8K/LYdwYPrI/hIAuGECo5AjqK/WY
         Tr+icVsdLvOCpSJmZw4JNIAyMZxjh3ZeanDlN/m3TQ+6xDec7QqHfdos2ThTPpP068AJ
         EFx4DdfN5+uu6qP21b1HS0agg4uk+Sv4OJ7JYwoFnDESfW3fIA/zyLVpi6PQp1MLIICA
         WHYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783430661; x=1784035461; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
        b=h6f3QVV8r77iq5Zj7UV8opf2QnUbp0+bVJ6XOS9dzuUjYwjeLAm7fBt6LOm3I46ajq
         YROKUEi3AC2F5/1qeV7ZGEHp7h1qlnp8FOXq2fc8VhxA1QIg2NR8wr/uFISg3wh/d4Bw
         ODc4gYUVjJ613psJL2KwjvSWyrQOyKMSs1vv5SR5y7iGRis3ce4SKws1Hb2g0Yl8lSK4
         PYA0U3vkU01zEixWDtaxGz50INOh/UtC8dXUuevvb0mpqrb0Uc1BiAYnYavkjq12Hpnk
         KPcKjS7+KE5DHd2ArWESgk6p56Hyht5plu7GXzFWGiV8c7NdPc75vCYmWDg5+nIksBEe
         lgvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783430661; x=1784035461;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
        b=NU0n4pU0S1YuXiAu6SOG51W/mM6Kya0M+DRVsli60teXaPL2oGzvjP5SQVc9AWrc3Y
         a8IZ7XF2SyLshJxPAdhg1UoQniE4nLRRXRYuEmHcW5XvlfN7xDTgU+ZBUdf1eGXPuQUy
         R8K9/vImmG3Sb9emeUFaLPbnMS2GaPMBqe3OhSK8NMnyS8Dpz16tnPDYQjCdXp67WUge
         r6iMEBebIBdItO7cQXXLgEYlhdsZim32+5dZXQJT4e/9ERAcVWp9aZHG4QiO6SMZmiM+
         5pNSC3qshQjrZrr3TfwLUhFwOTLAi531hGqc7CL0oS1Lo4w/wN3KRyV2eRgZCd+Hngvy
         fGew==
X-Forwarded-Encrypted: i=1; AHgh+RqhVxNKhw3R2muUYHBE2Ft5n94gtIHunXK22BaYg/lYLpqtp3R3xxuF2b9MsNFC2EL6/NvKqGbxAV4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1KIfYUlCzS3xEfW52+KF2OYwKrMjX71kHhKJRMOkQBv3xYFm6
	XjUaFEO1WOuMFJbZE7/4PCsV3ZiUSfuO9ML69BkE1wYYobtKdXqCUpTxvtHULz7WIYTAjS73piL
	HK7Y7AVe80BKtGJlodyq753luzPBnkI0=
X-Gm-Gg: AfdE7clhWgq5ZOdOP1kg8go0i8lvE5okolunbuK9CijUHLEtTzg/nzrhRoSOzO7XB45
	yePNN05vt3lZyre9O/gJ9W7Qax5fRVUr6pRU1vzgWC9f8O0fBZDVlwqO9zubDxWM0VdtJO6PE7q
	T6yfe6zPRblCsfBGR2opSUAP3bFw33a8YduSRzHyicBM1KMSL97iiQq0Ak/v9HQGbvRa6FTWXfU
	b9/vR7ZcbuFbaaxSi2ajIS+Oa9J5r+KGv1l79Yrpz5KUCTjM7ZZPsOne6UTyClSFZYueQ==
X-Received: by 2002:a53:adcf:0:b0:667:8b90:2ecd with SMTP id
 956f58d0204a3-6678b9053c4mr1264848d50.108.1783430661475; Tue, 07 Jul 2026
 06:24:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706163753.193875-1-ekffu200098@gmail.com> <akyZ5DhIV_Grn1Kc@kernel.org>
In-Reply-To: <akyZ5DhIV_Grn1Kc@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 7 Jul 2026 22:24:09 +0900
X-Gm-Features: AVVi8CdmNSJCGxYOGWnK5wJL_8NTvAWhpJlXJNdpTu_SgODQvmfDBt7ZZCk7fE4
Message-ID: <CABFDxME7ig1SQDB39TUeUXoAOA2jSRhg6h-bm0kUHrHzGYeE-A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve()
 return value checks in early boot
To: Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, Chris Zankel <chris@zankel.net>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Rich Felker <dalias@libc.org>, 
	Thomas Gleixner <tglx@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-mm@kvack.org, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Tue, Jul 7, 2026 at 3:17=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> Hi Sang-Heon,
>
> On Tue, Jul 07, 2026 at 01:37:48AM +0900, Sang-Heon Jeon wrote:
> > memblock_reserve() can only return an error after memblock_allow_resize=
()
> > has been called. Before that it either succeeds or panics, never return=
ing
> > an error.
> >
> > Before memblock_allow_resize() is called, the return value checks of
> > memblock_reserve() are unreachable and can be removed.
>
> I'd rather keep these checks.
>
> Removing them relies on internal details of memblock_reserve() implementa=
tion
> and the existing event sequence. If the code would move around relying on
> panic in memblock_reserve() may not be correct.
>
> And the few bytes and cycles the change saves do not worth the churn.

Makes sense to me.

But most early boot callers of memblock_reserve() don't check the
return value, so I thought we already rely on its internal behavior
anyway. So the few remaining checks just looked a bit inconsistent to
me.

Would you still prefer to keep these checks? If so, I'm fine with
dropping this patch series. It's not a big deal :)

Thank you for taking the time to review this series.

> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon
