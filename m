Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E422C43E48B
	for <linux-efi@vger.kernel.org>; Tue, 15 Sep 2026 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494978; cv=pass; b=jFMTka+o88nKU8txcUEt9al3fGsRPPX8B/3ckKA3QNbvzDxgdP9VAaO8NNkR3bTPkMZk0KVYNsAfNxhq10k0i4g6I7ASGGBe5Q/IIOZGjfJnFQ4+neHDK5GqKNfjEvvm06KB+ALa3IDjDvFatIH8QnzRLUZJ8kefXFpBBFEd74Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494978; c=relaxed/simple;
	bh=P7a2zFFMvnl7AMMV9J8HoSFvOnO26MuCDolXpy7oTxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6FNTUBI58CPtx3lxbtPXDfSqEelTZUFxHf3dfcm+iXCpejxQJVNzYEfC8c1ORfRyOZSXgF7xe80Dh4A4B7P+PsZels0AKZ/qgQl9xM6MPTLczLGIJeSe2PU6hfjh+yXgY4hoNwlVvREbxbcLALxE+SRSBV4BoMNoMLSVc1hNWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a6KqVcGU; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a6KqVcGU"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4843e397f74so707076f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 15 Sep 2026 10:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789494973; cv=none;
        d=google.com; s=arc-20260327;
        b=V7fpPH/dCxYClOuryn3JHTrJKCYLLnpRlt5QqZnea/UAZGjoIvx+LQm0s1UbWSnfI/
         XS5eThE4oLann1cLyDBHuKvIOk5tU1clY1uXeRtyeK9IBOwEljqxlzHlAQyyJO7iI7dI
         Z9ZAMsEZn4AUDMp+wNBAdbOqRbn5XAVaVHZkhKsaTiKbxQ9z0xju5sZrqkUOiQfYmd6A
         EriAZOAXEZfb30I27dIng9tv1zlHV7B79azjiZ9zXhj/WHpvSbreftdAmYaadgwfqlUw
         vE7p8e7kQbjixsVAz4CamHIV9IAvaVVi9pMPNbdy1bJAbPkBr/RPjKOdfWJx+Qa7vnot
         snQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GXjIVxCi/wI/JEAgJbDGbjdOXMojQ1soppHskXz6ugY=;
        fh=raHuL3mjbBbITjFoR3oJMutWJzqcktReQd57NFAfG3c=;
        b=jvg9dm6Bvcmd+KlxzWikFvp9eJ3a5MlkeEhYKJlV+KpBjK+Ua6l+74POF9s53RvIvg
         KpOEDQ1e5DWa4XBWs1bhCt7uTmKuTWRAo3p+olsUQ0oP3ZYdU4SMNkpZV9X9s20F6YKt
         ZH+MYh5R7TnEnRbMgCt4a1WS+bY1XfIu07ncnwRKwr693I4jqfiT/6LDVCWzQw2eJjIB
         krO1Cci2RE1g1P1IvbNuoKITFHTrH0wHx8DV9loQiXT6iL8unoG6aBsmsskEunS1savr
         q1qj7EkZVzXQohxvBO15qYO9qygEtq2rbrJdZnDOQUVggZMezp8VYVVquymFYWMvTNdM
         R1XQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789494973; x=1790099773; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GXjIVxCi/wI/JEAgJbDGbjdOXMojQ1soppHskXz6ugY=;
        b=a6KqVcGUw2fLFtF1Hm9cc5yrvLvRY7YxPEhLHNJIfcavwgt1rbW5yhhfaSMX9+BAED
         DGIeBSCgb1PlyB68lxCyUYa/zeD7s7Lo+A6Qmv93dYvmxfOjOqiT4T0+b7iIrlo89kl3
         YmXf3optvEP5cx8oa/c2vYZz/Cpd/9YBfStzMILEteq521PB7cv0n4n8ZyMgrCmgFcCE
         lMSUEJYprCL+/e4j6Ny2nYOmfUuoU2z79ZlpeYGa4QTjMUcNXGJrHFAK5pWg2+Dyb0Pk
         ebFFkqcbAhZKuXXO3iWlS5mmW4BKwKJfkzmb/CfloFnTWbyEEabpV3Xv4BxGONXxY8dZ
         5NfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789494973; x=1790099773;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GXjIVxCi/wI/JEAgJbDGbjdOXMojQ1soppHskXz6ugY=;
        b=sW+Hh/KmQd2iKSAzDyEsJwXSHZDTx0pM2dvylNYRuzus/8valwju66YeCXUCjkIHi/
         GZZQm4C+IO6VnHIYk70bW8kTfMd/MLG4FqZN0xUt0oyTyLkNyjTwgHaECRGFGppbo2a5
         c6CIcSwERml6nEBmPvXznV05t2nWguN/r7BHeNobIXJH5FNvr1SIaWdFU5/CyEvDgh1u
         JBk1tey+n27J+jY9vl9z8D+y1Q9GoycQXJkWX+RjXeRRNYauRkO8i8TcLXedSnZfH61Y
         5NsSOleVwIltDZ5eOXPsMKftyrahvRAt9LhyoNV6Z+wKQu0k4NLvTgeuBPmsgTGPu6KR
         9L5A==
X-Forwarded-Encrypted: i=1; AKwUvBxqss+c4hc94YiuynHekChMx/x1YW9S6lOKKOKNhCiBEBrUJvGUm3HMXG33tHFZGf5dTm+qfTycATY=@vger.kernel.org
X-Gm-Message-State: AFuF++lBUjaz8lXNlky459NrU9u0w76d6DzrsRVzUe1A9ni9PW6pnLMz
	ZrPX8Nh6+Uux2bYsimib9SUAiAVB4QIwscPH1I3StYLa4Ob2MUo8iFtGBemp96lWCxfLCcrK/6f
	eyKLEltlvVpE9EaXiIhXUi1j0uuiK0BkU2ZK24p8M
X-Gm-Gg: AYBFou3RdVr7h4fpzMgBJZJVPtau1Eu6RGw+QKRiy4+G+5uAmvzm17Wz5qQHYolrXvb
	pwjLneDHJUDzTS3S3UDPdnOfFxlD9TMxMkTqkauvqPW+Kg5q0xIUTVp16TQQOMgP2Tb+MR1AXu9
	7Y4B4NZ541e0aLak6GXV1TkMnrM209pHBbxrPidXm6GFobNe+LkieQUslPlPz+hfFvLx8QpQfDu
	AWnKpDbKf6GYK/ib8T5krlets3FrFgRtV9UYDtN+6xAscnWioEb4hOj8m+qgiGeTIGQrJE8Ty8w
	UvWdLgb7dRu9DArfapCKzqy2mmKPm0j3HcoNG2k0eCvAxzPJCMukUsd5GN3v9thvL4GpQeJBo5U
	0BYG1woRK5QDsQz2XzzfVbb7KpC1i1bMWdoiteRPyYZgOQuohSWedaEYzsVNVEGV4q6w=
X-Received: by 2002:adf:eec3:0:b0:487:13f:4968 with SMTP id
 ffacd0b85a97d-48705b5d792mr5756089f8f.11.1789494972051; Tue, 15 Sep 2026
 10:56:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-14-39817ec5db23@kernel.org> <202609141056.6AE2C82E@keescook>
 <aqkZvtAKWYf9-1ZW@gremlin> <202609150943.000EC9277@keescook>
In-Reply-To: <202609150943.000EC9277@keescook>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 15 Sep 2026 10:56:01 -0700
X-Gm-Features: AcwNN1WPMMWK_d5_qt02ICUH5UNGl72dPPgrM0zv_mQxUiZh6yRKMNR6HBnx31I
Message-ID: <CAKwvOdms6QWc7RMW6hJb3qzgmpK+aw40C7b_h7eG161ie_Y8ZA@mail.gmail.com>
Subject: Re: [PATCH v2 14/21] kbuild: batch module finalisation
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

On Tue, Sep 15, 2026 at 9:49=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> On Tue, Sep 15, 2026 at 11:44:01AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Sep 14, 2026 at 11:00:27AM -0700, Kees Cook wrote:
> > > On Mon, Sep 14, 2026 at 10:22:13AM +0100, Lorenzo Stoakes (ARM) wrote=
:
> > > > Module finalisation on allmodconfig builds consists of a large numb=
er of
> > > > very short-lived jobs, and the make job dispatcher cannot possibly =
dispatch
> > > > jobs fast enough.
> > >
> > > This "cannot possibly" sounds like a weird LLM language intensifier. =
I'd
> >
> > Again that's my writing actually, probably best to stop assuming LLM no=
w ;)
>
> Apologies; whatever the opposite of the Turing Test is, I have failed.
> :P The AIs are winning: humans are suspicious of each other now. :)

Is there a term for this yet?  Cylon paranoia?

--=20
Thanks,
~Nick Desaulniers
