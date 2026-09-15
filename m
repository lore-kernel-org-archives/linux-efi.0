Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DD243E9F4
	for <linux-efi@vger.kernel.org>; Tue, 15 Sep 2026 17:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494471; cv=pass; b=ogOfP4XcAjn7AiBln0oQdvyVCamxBHzEdAacG5/0C+6DPY/ZCfCzQAm1FLFi6V0iwP1Oh4+R3wZPFGwhNtFBEKKtkOwYpa6hagGfinxLpV8Wupveo8oj9TSVXfOrVXbPhN+hbrN9iyO+JHJK1GsdOqV60H5suPpZCjSAHg6Layo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494471; c=relaxed/simple;
	bh=u6Gw0oEc8G0Na/fDm4B5c157a2l4J+0QxPZsDNbgEew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tPg0kU9J7/1n9C52HOlQeAt7+X+D8yQzeg6EtdezMq2VmqVYyFJErHhfS+l9g6LVzfNGqwCx0HPSzMfQjPveiFOrtluWJN3vy0YYKptrkXOJCH1RGVxoe3dURB9eBLgGw7HGWpdqzXrElgkjCqy6Yjl7KtKo+tRZXWFC+hZHDa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SC4kCaqf; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SC4kCaqf"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-495437bb891so8902095e9.1
        for <linux-efi@vger.kernel.org>; Tue, 15 Sep 2026 10:47:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789494466; cv=none;
        d=google.com; s=arc-20260327;
        b=GOti4uoxO4gQoqY60ha96ohU81jPqRMqi8I+DLj7YlK5/uNbvWjhujReuro1flohMW
         lsLVr3UK6EfvunyOLeNmZSCRAStQ7Z0cStJ/qz037Qj6iIi/gXugJBzDkv7o0tBHm5bY
         t5s/ao7P5azPaM7Gv/CFiRfrGGhnQAqCpSDzgNXpf4hMD+mwnWAa2i89UEx6eRqrp5qo
         6i8nPzm/4oA6FqEf3Cvr6Ko9iZgJFmPGR+iKERXJfUmzCk5dxAjsRAIrF7AeRPHY4R+8
         dXN9UA9bNCqRIDU9L/mabWQtvpOOEJDXMkV1vhtN4h4UWJJRuWwZpZsMXlrS+BUITuxd
         01mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u6Gw0oEc8G0Na/fDm4B5c157a2l4J+0QxPZsDNbgEew=;
        fh=7a7dPuCllIZtgjTpa1/xNeFeZquxPSb+lGBQKNrYTCU=;
        b=Ilgw8aw1RsVkGp20h4gj2aM+RDh1NW7epre7XJETeFwZWsZiVFiDUD9ECid3kWwjIu
         pqB7pBrJqLvGZGOZDCfWVDWj8Lj25rGY1UUO9BUlyL8mkbcgzmVnDu1hXAQbmro/yVOU
         3ei5YS2/vfjapJklxFS3UIAaO/IMZHva+aoQWPn1d0zZoolemib65rDkW9MRqR/8VdGI
         j6/I/iGXGV4wYwreQYEgJlR4RVbxz8vGoAi0XK0Jp/v9qYWscqf0p4Ue94tNwhZnPxX1
         c6NJ6LLHkUjxSQ/BUfq/tsJ7uli5YLeFf1sCS3+nE2EzxG8YtdMOuT3Btozg0JPmOaft
         dIww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789494466; x=1790099266; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u6Gw0oEc8G0Na/fDm4B5c157a2l4J+0QxPZsDNbgEew=;
        b=SC4kCaqfVVRGG5CrPQH/SMlPkiIKeXl83D4UvgxjX69ghdnUrnuUqyHeshbHL7v3XU
         MciOzn7JIO9Y1K03tB70Y1eRi39OTU0IszyivUgKVlYAdjxNulv95mjqsR7bnCS8ldRX
         YSkgn4Qvd+FzLDnfI6RWmHgFd8RnJXjiw60CDK6CC3yZbf/T8tyHxKswzKVlpOU1Ifet
         cSas4HSNTNnIrGPq963ZUw9VRnXemCoxAdUi0BmmOeCPgGp1gPpG/dMliWtjlfDpuzkU
         U0Cp5g/97Q5+jtIPfWjlZAOjJDWvnugaRoFqaKUBCzD/GTkVXI9Yfcz6X/9gSZBRg0Ir
         vneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789494466; x=1790099266;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u6Gw0oEc8G0Na/fDm4B5c157a2l4J+0QxPZsDNbgEew=;
        b=DY+ZxfJ8tfNM37Q1CXP5hInDxNj9qV61b851c8FADWj0Ow5XqQfr3yRZYKupOoguRX
         ail9F1n1rJKAC43yXh55siBIb0gxZWjBuTjUcu+09YPrPgZE9hrqiECCeADart1anJA/
         JCazhROoD+mV/HSrbGZK6MWj++369MWQcQnON3bvxDI9LIxTcbdjyJGJFWobm6YGF8Rq
         SKWy/btcwIDxViS4hjKhxWI4Pk0UEmAiQV6JdJe7byBf6DqcYCBwB+mEhdECSJLEVwz/
         Yt79lPhdLVjr1BKGriWUfBPuvCFw84Y2IcJnC2p+uCe8HX1N4p09Zi0nVJkvkjfGUV2T
         WIQA==
X-Forwarded-Encrypted: i=1; AKwUvBzvHpodtQ/3cz2zxoV98io22Dp5qcLKsfriEy0GlC0GusUrVmcdwdJfuVeRFoJF33r+h/tgt3J1wrw=@vger.kernel.org
X-Gm-Message-State: AFuF++nSdHGK2NH2CVyYN8fiEAqKELD+MjorqPHVKGJChf8shK3p0Vff
	c/Rpx0EowWm4x+Xo59CMDn9+6e/Eubs0vjJlk0CJpPfnxFo6fPINKIFhMfU0V6kfcqq0j0GfEU7
	RiBUGL8+8cY6XA6mfx8MLqmJ7oBMgoF4wtGPr6wtE
X-Gm-Gg: AYBFou2YE5JqoEqKf1m5syoLXGEorBpU6+ctEY9H9e/pHeNqX8K+metNqDS3hdjj0wg
	kGzWe+QJ1Ey8UssiJPU3scfxIQ1hdh57+DY3PEw3fjFv0o2yTJo+hzRm5r7cyhTiUoGvL2j/6/3
	SuWhtx8lA6H485x8Pni4mv4fWQkUvDZflvNkiVtcv8TVHGda5T3G8GmXlYzmtcvXvCZbKb35+to
	V5s0A++G2nnDmogHdGuYn3buVb/UxqAgwWqwXnXcec7LGcGuRmmjb0JawuJPar1aro2wVQb0aoT
	JwiiRMc9XOuYIVXk/IEvafYzLPbnLWcIwGwYZAh4S/X9udiRZJFzEsdkzMwpuy92K2nq/LyCS0O
	iUHLyj6LwyN6/gpNvbTvtlemnilJ34U42ZvmIhIyqDuF9wGCQf6VDKaC+SpXd+wggCnQ=
X-Received: by 2002:a05:600d:84ca:10b0:49c:ff66:7d88 with SMTP id
 5b1f17b1804b1-49e7d725e6fmr51370615e9.7.1789494465544; Tue, 15 Sep 2026
 10:47:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org> <202609140844.FA7E848A@keescook>
 <aqk9gakQhxToLnDI@gremlin> <202609150955.A51C9F7A20@keescook>
In-Reply-To: <202609150955.A51C9F7A20@keescook>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 15 Sep 2026 10:47:34 -0700
X-Gm-Features: AcwNN1U4CY7rpoxX3OGd9mqCs-kE5osRcDbnjG2lLmWDcf89pyFwGTPPrVzl7qI
Message-ID: <CAKwvOdmgeyqivO4pVa=30XDWpXvdRzBR8f13rfuPzDx=LJ1Tsw@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if available
To: Kees Cook <kees@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Bill Wendling <morbo@google.com>, 
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
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 10:31=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> On Tue, Sep 15, 2026 at 03:30:43PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Sep 14, 2026 at 09:39:07AM -0700, Kees Cook wrote:
> > > However, parallelism needs to be set. We can't let it eat all CPUs: i=
t
> > > needs to respect the -j make option (and make its CPU reservation kno=
wn
> > > to "make"), which we already have a solution for in
> > > scripts/jobserver-exec.
> >
> > The only place where it's invoked is vmlinux.bin at the end of the seri=
al
> > tail, where all the tokens would be free anyway.
> >
> > So I don't think it really buys anything at all?
>
> There are 2 things I'm thinking about:
>
> a)
> My main concern is the lack of respecting the -j make argument. In my
> mind, this is a blocker, because it means a build will now _always_ spin
> up max CPUs (not what -j has limited it to), and for CIs, shared compute
> systems, or whatever, this violates the requested parallelism level. For
> example, if I'm doing a long-running Coccinelle replacement in one tree
> (which uses half the CPUs), any builds I launch I'm asking for the other
> half of my CPUs to be used so they don't thrash my cache.
>
> This is the kind of "why are all the CPUs spinning up?" question I
> helped track down with commit 51e46c7a4007 ("docs, parallelism: Rearrange
> how jobserver reservations are made") forever ago.

Parse -j from MAKEFLAGS (https://stackoverflow.com/a/76517886),
forward it to pigz?

--=20
Thanks,
~Nick Desaulniers
