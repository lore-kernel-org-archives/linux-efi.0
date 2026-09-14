Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3710363095
	for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789401713; cv=none; b=aWMsWQhNSg/b9ZiMGkkueldXJSa1NLGdVoTX/dd5fqVVIZ8FMm9fXU2Nr1lRaRS9t86AYij6I/NoYZskDDHzqBqhnZtbY+BbmzhsWKcewD2Edii325LUrAvhTkarNrLKP/1L0lCnNYwtinhlrpza179sDUrnsAc0U0XO7kf0vbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789401713; c=relaxed/simple;
	bh=xMRNGFwT5MG/tN2Z4rVlgZAaGoxD3wGYA7E+SDFQua8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uPub6h7t/FM0BzG9IQURnvmFFwgeXyW5LrszuFsAVlwdQ1EFG67SKdZDx0GI0fBnEEZsYO+hUgqaAYnOj4oVUlPN83nxbwjPPHh9radL86VoYc/S3SYzwnvUICMx1MgfSZMw0EhK4ctBRBlQ61j4nD6t90YQCUX++PyvElUerXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PV1lcxwX; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PV1lcxwX"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a60591ae52so3984394a12.0
        for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789401710; x=1790006510; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lW3GLwaZtw2SQDM2dpduYrEemaWK0EaPlBH9/B8yf6k=;
        b=PV1lcxwXzBnD6ykCn9L9ANN9kEi79GBwv1jYa/+WstBmneCyE0gmfM/Hwkuj08MfCs
         1W6fjykHZrCwh+97oeWcMeRT8LPyQY8sSH1IEseEGnU+/Fi5NhicRL/baofQR6vH0KTw
         po2l+YbMr7knd/siLYp+g2QURVqfFDPDMljE4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789401710; x=1790006510;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lW3GLwaZtw2SQDM2dpduYrEemaWK0EaPlBH9/B8yf6k=;
        b=XLnaLhcqtYIq9Eo6VtuaJ9OmDm8gmRfR3UDjPOsK9Qu5icEalfab6NXVHBAZKJUYIY
         6UDTYAOUIBFpg5ijiUqNmkUlnLiN8+o84pHCNtJxOHgnfmSm1cPOdqE/TH6boD3ZC0if
         OyPCFBtxqWHqYgIAceYF3qke0kzS3k0oSzoaw/XNnzBY3yCtagJAjyVt0qFfdbxtAr3r
         ogTegCI8DHrJgbtypegC2RRoqHWhEIfBU+v/CnHpIzCoG0j5UKjaFwuSaYXK7ob9mgXj
         3tRG/Ce9Xl3tRrbRk1B0zZuVraOqgGDQDe+h1tQTm0/Yj3SBmlTTscYldIC7Jo9nEaAo
         LWSg==
X-Forwarded-Encrypted: i=1; AKwUvBxU7z9CqfueObTLnogxOO+hvLJfWaztq/62jtMD9iul98BunD3xH/CegvZQFVkSIUe2HwI7oXW/rec=@vger.kernel.org
X-Gm-Message-State: AFuF++nM6OjJSIcDnyLWt0ksZ3Pg0auDAEL3bn8ds41GtQ0s1RVWxjjo
	mARKsttSb4KpUgT6JnfVBf+vDYCR50JK9YQ2E2VJfDBhZlPWGYW4/GakKXd+myc+f82VMw1/tYD
	gpFmefU0LEnmy
X-Gm-Gg: AYBFou367vWlZDo9jOndG8mulr09Nm5qhmO6Cz3kqbAnvj4KFa5yX8a0/Hh+anxYTDW
	E/KL4fBWGEeHuS73/47M7B9NICz2G6VfESB4FT/N/qFKs/KXVerkaO4UPE2LDB3F+r7QfJ5YXsP
	8vCqdgMn8oTQd4noTZKO52BFfc06bGFVP2Tp86zDgo3seFWH7p7Z5WNETydbkgbxOI9+WWV05zY
	++3j+rPs+ebQ3Sp1J3FxdO8tdSZXngswQ0/nwxhqTMUZ85ZVnYY9Uwl4cru9bllLffAcRJ9RTcN
	5tRGEB6gm2Y2U75oM7fKj2mJx7cgh30Xueb0Tr+O/PKrGHV4CNNX/wjD2cc6uMzzePCifoquLWt
	z1TVCAHvUiCk1Fq69pkH586BniU4XT7E7KYV40vaezK/QbarThXO8HLt+ioaJa7CqBxeejmz82X
	I8hKeBW+GwDCAetV2ra5O+BqWUbb6eb/zBm3x8yTgU0TnvUEB3OUtE18sMtjW6k17OwiNNvIyOh
	8+90+aQT+Q1MSvk9rMHaR7b9wr4Xnh6ZKB1UrCaDiKK4xKz
X-Received: by 2002:a05:6402:4149:b0:6a5:d8eb:da01 with SMTP id 4fb4d7f45d1cf-6a9f61583a0mr5419449a12.0.1789401709695;
        Mon, 14 Sep 2026 09:01:49 -0700 (PDT)
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com. [74.125.225.76])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b58f81f3sm4373874a12.7.2026.09.14.09.01.48
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 09:01:48 -0700 (PDT)
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4834977ae75so1230574f8f.3
        for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 09:01:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzrSoSUF+mzsAx24MSvOiiBNbAMouckgBYDb0ogl3WmI7Yq5OeWg0b/HkdZ2fUFN8U5JyOReWpFawQ=@vger.kernel.org
X-Received: by 2002:a17:907:3f9f:b0:c29:444c:8f28 with SMTP id
 a640c23a62f3a-c29b84c2597mr415053566b.5.1789401247404; Mon, 14 Sep 2026
 08:54:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org> <202609140833.88C0E16E50@keescook>
In-Reply-To: <202609140833.88C0E16E50@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Sep 2026 08:53:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=whB0X28MNAg71it=1SfFyV7rB+PK3qajpRyWoxXHW81fw@mail.gmail.com>
X-Gm-Features: AcwNN1VyLYI7E7T_24gtwZZHDPdmXi1EUi9s9xthPRH35xQepEwWHVnUZ8r6fdo
Message-ID: <CAHk-=whB0X28MNAg71it=1SfFyV7rB+PK3qajpRyWoxXHW81fw@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] kbuild: significantly speed up kernel builds
To: Kees Cook <kees@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
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
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Sept 2026 at 08:41, Kees Cook <kees@kernel.org> wrote:
>
> One area I think might solved via an LLM is the 3-pass kallsyms stuff.
> If we could get a deterministic kallsyms build in 1 pass, that would be
> very nice. A lot of people have tried, but it has eluded upstreaming.

Even the three-pass one hasn't apparently always been entirely
deterministic. We've had random reports over the years of it failing
in some circumstances.

Maybe we've fixed it all, or maybe the failures just go imperceptibly
rare. Regardless, it has definitely been fragile.

               Linus
