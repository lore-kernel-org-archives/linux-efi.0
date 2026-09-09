Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B954A47F795
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788968088; cv=none; b=EdW+VyncwoitSJUaH3rtnVv6pbQzp+ZlpcenNd/XTuYXRkdXInNCDTTK9HFb6AaR2fQEHobl+ZS2efjg5WRvCPD8uwOQE6IQW2wxOPp0ckHotroBnPLGfHtctOcHTkklv7ZN4qP/CcAUptSG4KGq6eeIu7PbeDTJnpyCvH+FDlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788968088; c=relaxed/simple;
	bh=t3yqbvSqtFoLUHow+WwPXXOfeaEh7bClm80fMM9rQTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jSMP5BUwH+RQI9XUR6/NqbpxoSmJtfdTksfey+Ls8vFu1VIWxqYnua/t8W0HYIEQ/urhAujYxk8z1CXJIuRq6jxO/Jr0/gJdEJX3GPSk6ESXFbM5PvCmRGI2NixIzK0cy/zlhdgykCExxIG8QmuTttWRJcROQG3dmlHCES8qhog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hyCr0qkQ; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hyCr0qkQ"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b8996d65a3so351590e87.2
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 08:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1788968085; x=1789572885; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/FowYqhA2IUhImtOTNUOvZbuU0tnu+Lv5LcROnzCHgI=;
        b=hyCr0qkQwD5W5QB0lyqpO9ccqVTukbFh0TeNNFCg9Qf9gfjG6eLLw7B5favjjNigbF
         7qPBorPYkhaXHnK+0UMeBp+wfkRiC5NivxAmE1OpVQcKaGbHtmmSB7Pw5/O8iRPlfODs
         PcjBGBKB9a0NFjSUE4oW2OSLoBsY7gmmrJrXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788968085; x=1789572885;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/FowYqhA2IUhImtOTNUOvZbuU0tnu+Lv5LcROnzCHgI=;
        b=bSF0W+NWZMB4vvPMJ1glZ0OPHvijCqoxjJf6bOaqAK0A1XqV3q/Zl/wJPgIpEkORU+
         m90uVIHTXQ5UTffNnpsxPZWdW1m8rg/ns6UGhk7jYmLuuScykSRI0o8facXW0pojTpLH
         uTYFcvruBrVOFRmybvRhKeA0jenQoMk8nV5FT6tjUtrc0wCB9CX+EqMDGu+/8KPT7OXi
         w0jJa2grKiBFNVlLRyFVkQVKdhQ3L6IDmfgZ6A0e5LJbmdD63Hv9GD9vlHhjJp3bYoiy
         YQ0CNYLyb9cmdPPwdU1VRLLbKXnk3RCWgrVmjewt7VHM/RCwReLqkUCwcmym9SOjlZCU
         JFlA==
X-Forwarded-Encrypted: i=1; AKwUvBzg3DF2DTGLkPrTfrL2Oz8Iy5iV7Cl6+qQQOjzet2ZGxw1zpmoEp6MRetd2cJEwJcmYQbcFCYAWRPY=@vger.kernel.org
X-Gm-Message-State: AFuF++lm6bsJV/GJR9Dviu4Z+kw8jRGT0MLHsqnlGVYgvM6eqgBumaec
	gbE3fLGQJxOcqtM/L2M8orIRGBoUVl/dZGkt2YBW6Y+dj6d5pzHPxkCH7MOMTkx2oHQIUftZDPF
	+gtX9c/Urxw==
X-Gm-Gg: AYBFou394c4JOPhE4YlMHZnqeXLDBfIjD1QdvXgl855J+cv5/UuHCPYG5U7GTLUoU0y
	2uxw1l/O7kZSO+8Fso4Cd68EkEvFiJsdUgqkEidJNQST5ocHCeeFPQv2zwCw1IoZdKaYdc2zOJC
	c1gh8TzPzTCeCZK5hOxwIMwOwWuitSm2mBSMaP4CV1iQWWLUunKhsYQLhyMt+XRf5JNnpe+CQ00
	9TsuKyA+zhX9+3ecuuJeH0e54z7Oue8e7DKxNHnBBkU6tYMBjdPV2VdZ6Wo5kK/1hKnF7G0AVat
	7I2Jgx+hCv0wRoo7GE/m7HQdX6/A4gNiqe4rBn/szNZSpZMmHjhy5f2BpU6+YAwt9wt33S71vbj
	cJi1zhnK5gCl2+3b636N+1ut88CkI26En/ckFMxdJkE4GygGyT5BX/6LWss+yZOHOuwem3WQnGy
	HLwhs0kSLi+Nyr0htAMa7YDxEe6Sirfb+jkGbAux+aPgAERlS/+vJvw67tS5oyFzHBXNl8IXHve
	H3EgVbvz36SOi2waIUjzjSN4dzZ/JdhQecej9GSbVNmWArH
X-Received: by 2002:a05:6512:23a5:b0:5b5:e7a8:9b1f with SMTP id 2adb3069b0e04-5b616f41fc8mr6297980e87.20.1788968084675;
        Wed, 09 Sep 2026 08:34:44 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b6166fbfacsm3874916e87.42.2026.09.09.08.34.44
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 08:34:44 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-482e067e908so4748863f8f.2
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 08:34:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxnj/HEgESII5ppFWXYc5w2rIa9YeQoiQ0Crhi7qAoCCb3Npw19RlZsxWiBtwsH8k2fykRyFFmrXQM=@vger.kernel.org
X-Received: by 2002:a17:907:da4:b0:c26:1649:47af with SMTP id
 a640c23a62f3a-c26164955fcmr1368813666b.37.1788967618809; Wed, 09 Sep 2026
 08:26:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org> <20260908-build-speedup-v1-11-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-11-5dc1ac01672d@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Sep 2026 08:26:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiA_UJbKiu8fOezKV=MfEcaFuzZiuk8Fto-Bc1KrA=43Q@mail.gmail.com>
X-Gm-Features: AcwNN1UWYYtk4z7iDc5cI-l9BNT1_XTZBZ1EzZVT-QGEk4RrzSdK76DVFXE4iKE
Message-ID: <CAHk-=wiA_UJbKiu8fOezKV=MfEcaFuzZiuk8Fto-Bc1KrA=43Q@mail.gmail.com>
Subject: Re: [PATCH 11/23] kbuild: implement and use depcheck to check
 dependency timestamps
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
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 13:57, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> Each object's .cmd file lists its header dependencies, which often
> consists of over a thousand dependencies.
>
> When little has changed in the tree, this is what make spends most of its
> time doing, spending over a second, single-threaded when parsing larger
> directory trees.

Side note: from some kernel build profiles I did long ago, I have this
memory of it being made much worse by the fact that we use

    "$(wildcard xyzzy)"

for all our config header files in those .cmd.o files. That then
causes extra work for 'make' for all of this.

And we do that 'wildcard' thing not because we want to actually match
a pattern, but because that was the only way to have 'make' not
complain about missing config headers.

I'm not even sure the original reason for it is relevant any more -
this is all a very dim memory from years and years ago when I actually
tried to look at profiles of 'make' itself (normally when I do kernel
build profiles I only look at the what the kernel part of the build
is, not user mode).

I just tried removing the 'wildcard' generation from
scripts/basic/fixdep.c and the kernel build didn't care about it at
all. The whole 'wildcard' trick goes all the way back to the original
commit that added that whole 'fixdep.c' phase.

Maybe the whole thing is entirely stale now and should be removed. I
probably just didn't trigger the situation where those extra
'wildcard' things matter. That whole thing is from a quarter century
ago, and nobody has dared look at that code since..

Or maybe 'make' is better at those wildcards these days - or other
things have shifted.

From those dim memories, make spent a lot of time doing filesystem
lookups (directory reading  and 'stat()' calls - the wildcard thing
triggered more getdents calls), but even more time just in string
handling.

               Linus
