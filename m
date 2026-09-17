Received: from mail-lr2-f22.google.com (mail-lr2-f22.google.com [74.125.230.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB07518143
	for <linux-efi@vger.kernel.org>; Thu, 17 Sep 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665747; cv=none; b=EhEzDd/zCJ0zRVvOH9HlsYRbcvdosk4sJjzDnod9B2KoX/+qDFCqtp9NWVWuNJezmRbIW2Smkj1YjPaPFkkJ8gC9oL1PRYRJs6S6mJD5nk1+vrqrFRiDVV0aa1nPkJV6v9402LjIOxd6OtyFuf+G91//G16Swo/e0yLlsFZ/Gqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665747; c=relaxed/simple;
	bh=biPMv+ofFeAlNkpuoiheHfcM5OSqeT3TWtGH022bAOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nmbEz+ekLr4b4t5iUP+5WTWbZWmf/NcUK/5bhKoiDqeNYZ14J7wJa/BiUToRhEFXx9ngDT6kL08GlACk3xxXFuNEIcky59tmtGPJhGKzqKcHc86T0FGDS/1n/6sEBbONd0o1YA5ZMMFPFdXZjosKBR9aA3vEfv0vDOgL/jGlQT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HPWlAjfk; arc=none smtp.client-ip=74.125.230.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HPWlAjfk"
Received: by mail-lr2-f22.google.com with SMTP id 38308e7fff4ca-3a2ff04155bso9340041fa.1
        for <linux-efi@vger.kernel.org>; Thu, 17 Sep 2026 10:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789665743; x=1790270543; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iCKe0geuwZYO+S2TeH6s+a22CWM7gde8UuWVtmH3l0g=;
        b=HPWlAjfkRbGRolOpuK/a8NoPLBGKAcEaUOaj0cov+bRkb8O+G2PDTSSKg16s64nNz/
         g1CWCPElIpW1tR/KEx5GT3b6jhgSYyLe88Myu0kCaQ/fMtvN4KfdpKyjmPbs/Ur8l5Mx
         bTG5y4phoKvNEBPvgYzhrofPc20xKqJR8/WdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789665743; x=1790270543;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iCKe0geuwZYO+S2TeH6s+a22CWM7gde8UuWVtmH3l0g=;
        b=WdtKV6GsrOMiBo33z4f8drpSH87mHCMYTepmcLimu5Xja8PbK/MrkWJLcw1+tCcQps
         tT9VZaHLH8RwDhzT6UL+YMrkaXtfBnHUGLiFioEvJGgavRZCD/M0jd5PEqU6Ka0H0Y4Z
         KYUeRgT65xjzIeewup4b9YU5pJQ631NQRb0MmQY7XWqhuFAoooVqGs9eaKVY2dgOOLnF
         VPy7r5wTDxZKCRYOj/QsrinSlCErL7StL95PyUs2/1HGl2shMx38m5CTp8q/iHqWMGlN
         VtV18yJzBzPWjuC/SxR4lAHewNTcGL7t7lTpGAYmE3ICa29KuCoQTCEXK4hL3tkRSNeV
         /ocA==
X-Forwarded-Encrypted: i=1; AKwUvByEzzkvYLmQ+SX+BFearffixuABrVOs1bO+YY2Jm1Hgpi9tpbHD/baA26ATva0Hb9sjqQl3pqKQPWg=@vger.kernel.org
X-Gm-Message-State: AFuF++klEN1OPgj98bpUbnJeOvk14GmizUl7JdN8qRIYvopzj2SbDAXL
	Yq+cZKBTqqsbd/C+fBTe4eTG2qkdf719c3KLTs2ToP7q0zmmNpLQCcSUJc8Xadby5P2XRQP+EK+
	IW66UkDFl4A==
X-Gm-Gg: AYBFou2cyxhfJveWusXHguQa0Gtl/gzT+ihAJFZCGGxma1RWzwaTtbJ/3jU6wcmj04y
	6Sv582SkzK70BOw+fgXWo8RKXTOds+5ArQ2QOsBVa/fwqOltsW6FXDzGVgdwsxsbGPrtQ33FRHL
	ThbPfVTzVBGrlVXKwi+kFh2C9Byc7QEevJotp69VIxI0vL/aU5zfyJJ1li4CLuoxG/NUol6A1yP
	lVAfE6wemMcd3xvnv8p9Eyx02AFJe+wedLK8eSPX5OjtPd9e8UHP/x/+i79JY5gVoyG5gmP1CpV
	hUS5pzNiggGsILvkbKgju+0KoqK1bjNX2Lg/HsmmcVboXBbsdfRqo3MekTFZlReMofs+B/pO18s
	6hEa+bbHUM/xSEnSjQ3+CkOl9fAOER0wL+M0Y4dlSvGn5yQofxKV+SP0FfJb2o1s6A35PlqhNbi
	PnXlWYXZC+XelU24m6IjrA9Z9B8ZAU07U/sn2YoPX+RmGEAz70LLc/cQ2aqD8jleupIydWmU9ve
	GxB2yf89rQIiYhrvVBiCCs4esFqWE+CTWKyvmZE8+NkD+oEhg==
X-Received: by 2002:a05:6512:3d19:b0:5b7:9782:1e62 with SMTP id 2adb3069b0e04-5b8b66489bamr2152959e87.49.1789665742733;
        Thu, 17 Sep 2026 10:22:22 -0700 (PDT)
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com. [74.125.229.204])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a5f914249asm765971fa.34.2026.09.17.10.22.22
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 10:22:22 -0700 (PDT)
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f1b846so1407628e87.0
        for <linux-efi@vger.kernel.org>; Thu, 17 Sep 2026 10:22:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwcRVMcGxM0bDw0RE/3O7fLtNUqSpuq3obkGYx7axuxi5wTToLoRiGxJFf5RXh1/r6UEV++tY7A6zs=@vger.kernel.org
X-Received: by 2002:a17:907:c1f:b0:c12:e178:9e68 with SMTP id
 a640c23a62f3a-c29e5237e9amr501417166b.19.1789665344119; Thu, 17 Sep 2026
 10:15:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
In-Reply-To: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Sep 2026 10:15:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjwtJQPW+MRAkQCcSGA1EZWehxBTUiEUUhdACCNHSKvTQ@mail.gmail.com>
X-Gm-Features: AcwNN1VkAmOFPymjE_dcKSWc6Q8Z4LvlbW-9yRGSGQmATfVxYq3jdlUQ82g4gXM
Message-ID: <CAHk-=wjwtJQPW+MRAkQCcSGA1EZWehxBTUiEUUhdACCNHSKvTQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] kbuild: significantly speed up kernel builds
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 17 Sept 2026 at 09:06, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
>                 == defconfig FULL build ==
>
>                         before    after     delta
>                       ----------------------------------
> Threadripper, gcc        32.5s    26.3s     -6.1s (-19%)
> Threadripper, clang      34.5s    27.2s     -7.3s (-21%)
> EPYC, gcc                28.7s    20.6s     -8.1s (-28%)
> EPYC, clang              39.8s    32.2s     -7.6s (-19%)
> M2, gcc                 519.3s   512.4s     -6.9s (-1%)
> M2, clang               634.5s   569.4s    -65.1s (-10%)

There's something odd going on with that M2 gcc build. Why is it such
an odd duck?

             Linus
