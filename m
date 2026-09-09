Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0BB489FDC
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 22:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788991768; cv=pass; b=iA3JNWqpLw8FJ9CPEnPDWx/2nZ+GnFL/sC97hC2B783RwcBbfH0o7daYf5ns3sdVbYneOLDV6iYtMfPkmsRANyRyqaqEzt2gobzKlE1D3TGhCZSGxy5eAAD7fizgZsKon+bz0D3/bg8xf6as9dLLVivcCrGRn8bQz5kK85VJ3CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788991768; c=relaxed/simple;
	bh=bvzxaEfHxbnbItUGjnix/CzOoHNfP6Agb5FNfRpjWL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ksag1Lc8A1xXBAt//LLeoWZiEYUFIiEbZTJBZbs3tyiJJmces6UoLj4Mw78MTcMOw4Nvr+lXolw6oqPCkFuQRYVac3LpfYPTEoNBgPWdFIP4Anyef/DEKIyJEhD+egt5t719inCUOX6z/JeGuusVNWojzPv4P/+mhO+24yQSdYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hJnHmHhe; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hJnHmHhe"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso52327885e9.0
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 15:09:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788991763; cv=none;
        d=google.com; s=arc-20260327;
        b=e73r2Vxx129BmyV8HpaZWQgy4viW/cbbYeVMZfjOh8V1lQFhTLyHjHvxKKD7wCqTmr
         VEMwlGcldedt2VHikVNOTRjdygXCptAORnDERrHpmlgN2euVYCl2szAwvMqxpDx9sCi4
         yQdFsHEd+7T7CpkyoFfS/ILusAC4rkD+Qm4xWGY0TEkHn3XqlYIeD8LR5DVY9ApYFryT
         tkv6s1JpZVCAhDpfU/kML4s8RJ/GSk+hvGnTKFX7BhC2nWwQvDQveTx0TG6pgZfpoDJU
         USDtuP9Dv0xxjnSh++xK/SkxNz/SVLCWCKGIxQLRl0qotCTODC07tlaZu/CKhiuAMV/V
         0pYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bvzxaEfHxbnbItUGjnix/CzOoHNfP6Agb5FNfRpjWL4=;
        fh=WCjJPE9xQMVBOcSuINpWeDNwtO6wLhlPA65qdaKJdE4=;
        b=IW8uL0c6PNXo1usnmPW5HZLylpWHDe+oplYMVoB9FaEA3jlV+E4W7TnB6nsFRtvrSJ
         orUjEBX8/mF4nbZkJIxx+nzYbECEyj9xJX0rxHx7FwsNhCLHsYzwzE6ILUpkJhhnaYEP
         yjHqKxFIFofoVUqYjmFtXcln4EZeKYDIDlwdLTLmmSES5u2ra//Yqd79XT1SYTq0tqMw
         0tjdcdTNNz5mMl9ehgtIz0gfd7qBGM+issp8suc7P3eEJZj1gb9+yyW/VLkesNBEXzw4
         PpuDXasNPJOeKlcG0JszGHhNopLKl9UF55OQ89JhS1CW8mlehrOxa8edNm+Dh7e85WXu
         diOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788991763; x=1789596563; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bvzxaEfHxbnbItUGjnix/CzOoHNfP6Agb5FNfRpjWL4=;
        b=hJnHmHhe+3Z3B/o1b9i3gNkm/aDnbsezDcQyviqY7dy1zsxKPyI3bYCDtR1pjVAytV
         yhiu4H+vtxVlBhhNE1bQlb6f7a48UllOzIPrYLGGCIAN4VhfSbAXPRCETqRmpiSPDTOv
         rWJDZaqFYHjuluIDtrEYzUPixzXiqxS/D9IuWtdGQYfHep7KfZZ14736P7EXNQpqVW08
         pKn1RBFdnG2451tR/nrEy7dEFMergprk0ekp8fLZLbsiP5bXRvyDoJRneG3y2J37tiN7
         kc+HMdzfao1r9BRM3SH3gaRbanbA8Sf7jUGn/rPWRtaAzSNYEBIxyhaqePlgxLqEmC+C
         bNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788991763; x=1789596563;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bvzxaEfHxbnbItUGjnix/CzOoHNfP6Agb5FNfRpjWL4=;
        b=S4gh9+6SlDwpt89zyp5eeUjjjaekrHIYgaIVPZMtitVC2ETU5YdOkxKEAR1IU5ISQj
         2u/9YGRcIv/phcJHftiNxMbzZNuY7eGP+LnUs5qdjsTKK6hakt4iNyI752Oxaj5jnC6A
         eg6U8hKxJGgSb4XyRxHDwOU3D/ozNFkXAeQF2EhGNKFnPns3Y4DvDnufsIncR6y5sGE6
         yMmuBzu77JrOAfDfQfrJJC4OAZuhtOeToaOpxCii1kHSddg4LasnRaauXQzI467L0Rgi
         y3AuQ6hDQO1r7WlXwkOYoqGgHdj4k8/fyDUN+jTioEz7AVUxyHTUDoQMruaHojmauflY
         oKHA==
X-Forwarded-Encrypted: i=1; AKwUvBwpCUiO2xmtSqLdKPH74b8bVHO5En02buY/PrAofpSUFmIeqQaCWOAuaMuD7XC6hcTWxL0aCX2ttng=@vger.kernel.org
X-Gm-Message-State: AFuF++nPKcWScBslE62CoPUEra9RKKJMOSlgqJv8dPFKN3dfjyRIoh4n
	9wQoloQYsKAMuW+/2JTmJo+Ljt96w3sPDpdx7skevtj4fnA4u7UElEVF/S37g9krgDy7mMyavXd
	lF6V4PfrpSEdgbr8un1v0jzzDXQvQDly9kvZteqHz
X-Gm-Gg: AYBFou1MEPRUaYqXZs5RxrO+95LymmfGLXV4yKqybSqXMjOTdXNAhi3xkH8ZZC2GHSK
	0xI2iGxPoPz4SJFX9rhYzlsA6jKqQYBWwVF/j6dBM2sGSul1j4GX0nHViypjaL/CC+FnDTfVU4d
	0XiISqICUf3wgwSxDqgJo0SfiZfcs0NYr7g/qgsfN1AMRD7cmqFHypy9+o0mA5B8crRYTajgqWT
	ASq0Oj0mhiAMQpJvv+vjhNcV/w02qSfX7LZBT4E77cxi3L/cyhmKesZTIOR7cbpIYtnNDtEZJXI
	XTJjnxS1nPPXG6uIgBgkv2er2K4JdGquXpTK+5C+zrtpk4p0GJP8X8k/o1uChTAglW415nNnGAV
	ZrdG8D9WOTLU/3IBXVUBOyOpOffB+DI+mipJTIcB5+grDVrRU8kVdXzWSuNklOJBovK/TG4I=
X-Received: by 2002:a05:600c:81c8:b0:49d:1f10:8b9f with SMTP id
 5b1f17b1804b1-49d1f109802mr74781425e9.7.1788991761946; Wed, 09 Sep 2026
 15:09:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <CAKwvOdmdFdW8=y+s5NLoNeKz4LVbmW8tr+JqJ26wqYFJDdARFQ@mail.gmail.com> <aqFptJRjLZIL-NX7@gremlin>
In-Reply-To: <aqFptJRjLZIL-NX7@gremlin>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 9 Sep 2026 15:09:10 -0700
X-Gm-Features: AcwNN1VBBOSItlzf2aBfQ1Tsn20Bkz1vl5nUIWxayca3KAiKBTvQ_pPLoFqBSq8
Message-ID: <CAKwvOdnMuwKxPB_SXDcwmrAiwZFXWUAgcS1TdAkW+bqhYEZ=ZQ@mail.gmail.com>
Subject: Re: [PATCH 00/23] kbuild: significantly speed up kernel builds
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nicolas Schier <nsc@kernel.org>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 7:17=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Tue, Sep 08, 2026 at 02:06:18PM -0700, Nick Desaulniers wrote:
> > It would be cool if your LLM could generate any visualizations of
> > what's going on during a build? Seeing what's serial vs parallelized
> > in perhaps useful. Particularly when you can compare the before vs
> > after.
>
> Great idea!
>
> I asked it to do exactly that, attached. Came out quite nice and sums it =
up
> nicely :)
>
> It also provided an ASCII version:

unreadable, but the pictures you attached are worth a thousand words.
Particularly exciting are the speed ups to the usual edit+compile+run
loop.

For the blue graph (the top one, first), any idea what that dip in the
middle is? That's always what annoyed me.
--=20
Thanks,
~Nick Desaulniers
