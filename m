Received: from mail-ua2-f12.google.com (mail-ua2-f12.google.com [74.125.226.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747513C988D
	for <linux-efi@vger.kernel.org>; Fri, 25 Sep 2026 19:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.226.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790363881; cv=pass; b=MLuJOlY7uZEwiAtvCl7jqlj6/iGOEcZQwZ1xScqduoW8RE96MtndVX2+lYQ58w7jbL0jaOiogcHdfPxoBinsR+aCeDFmeESfJuPrdGCuf2gXV2+s17jawUUP9FNby3f2Y9eTFnPNhkHZbguZRNGI1HYJUA8FkmYwD/vUcxmuiU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790363881; c=relaxed/simple;
	bh=0YXk1p2g+BspsukgpRLeUnT1mCwteMBiEo6KobR3WE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RbDbI1NP15zmCm+mNXNSeu4+KprhJXnypbnLE7b6bS3fJgGUAiOEPAXj89lPTIDArChi/BMaXR2/OdD3YHHuDqjjftWhI1M4xtXW+Mb5UKhAsSW8alu/4mEXsiAhl+0dl7Ru5z4t3QxTk4AhGm29wGa5tnAKDft05ZjKmNsy1GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N4+TN+qe; arc=pass smtp.client-ip=74.125.226.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N4+TN+qe"
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-97e96a8ba8cso851262241.3
        for <linux-efi@vger.kernel.org>; Fri, 25 Sep 2026 12:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790363878; cv=none;
        d=google.com; s=arc-20260327;
        b=GMoVgRVdzXs8EwA5qJ4Bo4JerRD1alS6upmw+o6aocmCNT6WcY5L05WY+Vqu+FfheM
         arKbTIm5aE96CVB7uVv/1IUc8474JfdbyjCEdwunuKb+iI6XVqY6NNr604hbdhh+CM/a
         j8gzx65+PtpuvIRmP3V+XQ9iYfER6fhCgP56nwBnQpFs7ywHu2u8RBoPLN7g3GOAxwYv
         8PxwPYmVSvaMuPh5egfVaWK5jNRA63XmSeO6fRAIAacl8/5UtHTwtKG7jYTuMF4VCeb8
         ZNGckjQrubXlP4mwdhrdZx6SM0IMnbrS0aHnLrzUZCro28eaEI9hRRp3C6vxv0hMWDF/
         qgvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=68/mkRd1a6DliLdoLvTqX92EpyDhdssnV15ZSAj23lc=;
        fh=A5iiEP2+ePKXmYLTzrsEP9885GKnC8knXvqo+IQ36Rg=;
        b=Mny7SdsvE83iQQx0tirFJjjjBJAWSV134EmM6udJt5aq+6mmuQJEWuEyX1vVnFzXgv
         gsiRcGUnIREPSH+aYmRtXUZ1TW8GaZItZmD8JtZQuwEkCqZFomiKYooWc11oCg1MEAQA
         7hOYGSME/7+QZ1RRslpBpWfrTBj5TGb1C5taDPH2EunpLQutpRa8uU1KTBDoDtNvkHbQ
         JqE0qPsejTbs9YoE3qo54QcV+VLWKYnpT8m+qvoczxW+BxIX8ft//J3rP43O7tFceI+P
         jDZgtyPzTKlRuRDJWp9NnomTaymi4z1I+AwuqHFaf/YqrNFKB8mtEb/hcBIgAgPJXXfm
         U7Vw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790363878; x=1790968678; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=68/mkRd1a6DliLdoLvTqX92EpyDhdssnV15ZSAj23lc=;
        b=N4+TN+qePb/0u5ajv38dlgbED0FFOtVewN/faWBmtfYDhcOb/0hSadfEwGcwTaDjBb
         bII9vSXU7k4YttNcFjPW+Dg9C4YV2S7UibqHmUKdtKLRfzapSmCSVQyXbJYaAqnDTgFY
         H+Zaaq322+v4udwDq1ObyFU8NEPx+CSmQW7+uc0n6yG+Ra7DKQV6ZFKgAJ8PP71GaY7c
         QqsJjY6bedzj7A6qGM+vx8QeYT6/aPRVI3tOsbx/GXFX0yqNcnk2zWA8386ou1gC8C1T
         9WT3GQh4u/+LD2+HLi6iup0oJbzYgTFLTdS0yRoIOkGAWTPpQtWFZLhoD6LpEycz3IkL
         4y8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790363878; x=1790968678;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68/mkRd1a6DliLdoLvTqX92EpyDhdssnV15ZSAj23lc=;
        b=JapP3A58adMywrnluuABoYF8xCoD6S3Ppuru0SF/PCbbdjqgbboIN8VwwqsnAUJcwx
         iC5uBuaUmt/326VjYyIHEB6zSxSYMUGBrVgo0+8UWVvUPjdJkUua/+8W7HQToH0abBTb
         h4NaXr5YFBw9OQBo0QFVCr49ZzKk6myVgg/AJLtSFibedvV4lGD4AW5oAGQ+KNSrX9Un
         VP+uBM7qg/KfmS68Ils4Xt27HlSY0V4xlt6Y0TpVvHzNSvYsyTZO6CbwKWGhf9bIX0ep
         AVfya0Y/SssSnFhSLf1uYFfbUsrHqWdwoRhWvrLZSgcE+CtIOivpF4/urkwLemRoodcw
         MdRg==
X-Forwarded-Encrypted: i=1; AKwUvBxRsE8KM/p1miYz72VnottO+4i20Yrst95KXyQzPgYvWwdxxw6IbcbR1fvrHAwQpEEAdDx0TlEExaU=@vger.kernel.org
X-Gm-Message-State: AFuF++k4L3Ikj7X32wcnn+IdY+r1/ODSPg0kS4k1bsF3gUESWiHKq8Qh
	/Jc0Sq5TVGT6oJ7pbL46vrmsksrYMTxm/n1A7HWCcQtWJZk7G1R1QllLULEDfMCZG9QfgqYk3Dw
	ruaSCIdOrUWyeqTYPMQgOTWJVoyIMAQrVW6n8hrQ=
X-Gm-Gg: AYBFou0tNpsLfMjmdoKxpX7WaQE2czFJPYLVXLFceW+1TiHhafsfduk8fYcFzTEnAUB
	NVT1jRp48+l1/IlGT3QAXEAOK0lDJ5cjLHkT+gLGPnz+OVhVALZJnRjcYYV6hCOfoIEZjjvxBqb
	iPi7BhYIWN0rvxpKqheh1h5voWwjXPwhMCOsiERMuf+geHuK3npP/NxmAgqMslLwcH8KQWnoHrh
	0RM4angQEV0BiTIRdRWTfwoU0gLumihnulsx/9NB+nR8qx8OTsmaudGtpW8vLyW9FdOkajcgX2s
	k+wvnoBOYYoGcWxHBFI4VSIQOKyINveDChVjVDKFuU1VIoa5wtjvEmHpfzIHFAv40ruvd3RSicV
	bDjBaFRWs2Aj8eTJayHvDc0VnnC5+voevp0fRDOsmTjaEJvWaRYOh
X-Received: by 2002:a05:6102:3f06:b0:7a7:3485:33e4 with SMTP id
 ada2fe7eead31-7af1f2fce8cmr3602978137.33.1790363877295; Fri, 25 Sep 2026
 12:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924-b4-arm64-callops-kcfi-v2-0-587865b6d991@linux.dev> <20260924-b4-arm64-callops-kcfi-v2-6-587865b6d991@linux.dev>
In-Reply-To: <20260924-b4-arm64-callops-kcfi-v2-6-587865b6d991@linux.dev>
From: Bill Wendling <morbo@google.com>
Date: Fri, 25 Sep 2026 12:17:41 -0700
X-Gm-Features: AclHuK-u3uiT0pgSiQWlUPghLSJFY3GErd8b-v10N2yzXEaY6_RjJUbwQB3czv0
Message-ID: <CAGG=3QVs=e5JtAs-D98vDsj2ax9H0gH-_rPc0oKhx-vNpq_RyQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] arm64: cfi: Use CONFIG_ARM64_FUNCTION_PREFIX_NOPS
 for the type hash offset
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Justin Stitt <justinstitt@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Xu Kuohai <xukuohai@huaweicloud.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Sami Tolvanen <samitolvanen@google.com>, Kees Cook <kees@kernel.org>, 
	Leon Hwang <leon.hwang@linux.dev>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	Ben Cressey <ben@cressey.dev>, "Florent Revest (Anthropic)" <florent.revest@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 3:37=E2=80=AFPM Jose Fernandez (Anthropic)
<jose.fernandez@linux.dev> wrote:
>
> Make cfi_get_offset(), SYM_TYPED_FUNC_START and the BPF JIT use
> CONFIG_ARM64_FUNCTION_PREFIX_NOPS instead of hardcoding four bytes. kCFI
> kernels with CALL_OPS need three NOPs, or five with ThinLTO and BTI.
>
> CONFIG_ARM64_FUNCTION_PREFIX_NOPS is 0 on every CFI kernel today, so no
> functional change.
>
> Reviewed-by: Ben Cressey <ben@cressey.dev>
> Reviewed-by: Florent Revest (Anthropic) <florent.revest@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> ---
>  arch/arm64/include/asm/cfi.h     |  8 ++++++++
>  arch/arm64/include/asm/linkage.h | 11 +++++++++++
>  arch/arm64/net/bpf_jit_comp.c    |  8 ++++++--
>  3 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cfi.h b/arch/arm64/include/asm/cfi.h
> index ab90f0351b7ae..03f02d4614c23 100644
> --- a/arch/arm64/include/asm/cfi.h
> +++ b/arch/arm64/include/asm/cfi.h
> @@ -4,4 +4,12 @@
>
>  #define __bpfcall
>
> +#ifdef CONFIG_CFI
> +static inline int cfi_get_offset(void)
> +{
> +       return 4 + 4 * CONFIG_ARM64_FUNCTION_PREFIX_NOPS;

*drive by review* Could you explain the two fours in this equation
with a comment? (Feel free to ignore this if it's obvious to
developers.)

-bw

> +}
> +#define cfi_get_offset cfi_get_offset
> +#endif /* CONFIG_CFI */
> +
>  #endif /* _ASM_ARM64_CFI_H */
> diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/li=
nkage.h
> index d1f7a16729d25..14bc3c67c38b3 100644
> --- a/arch/arm64/include/asm/linkage.h
> +++ b/arch/arm64/include/asm/linkage.h
> @@ -39,6 +39,17 @@
>         SYM_START(name, SYM_L_WEAK, SYM_A_NONE)         \
>         bti c ;
>
> +/*
> + * The compiler emits CONFIG_ARM64_FUNCTION_PREFIX_NOPS NOPs between a C
> + * function's kCFI type hash and its entry point. Callers check the hash
> + * at that offset.
> + */
> +#define __CFI_TYPE(name)                               \
> +       .4byte __kcfi_typeid_##name ASM_NL              \
> +       .rept CONFIG_ARM64_FUNCTION_PREFIX_NOPS ASM_NL  \
> +       nop ASM_NL                                      \
> +       .endr
> +
>  #define SYM_TYPED_FUNC_START(name)                             \
>         SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)        \
>         bti c ;
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.=
c
> index c18e005a41dbe..7ad14d9847138 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -185,8 +185,12 @@ static inline void emit_bti(u32 insn, struct jit_ctx=
 *ctx)
>
>  static inline void emit_kcfi(u32 hash, struct jit_ctx *ctx)
>  {
> -       if (IS_ENABLED(CONFIG_CFI))
> -               emit_u32_data(hash, ctx);
> +       if (!IS_ENABLED(CONFIG_CFI))
> +               return;
> +
> +       emit_u32_data(hash, ctx);
> +       for (int i =3D 0; i < CONFIG_ARM64_FUNCTION_PREFIX_NOPS; i++)
> +               emit(A64_NOP, ctx);
>  }
>
>  /*
>
> --
> 2.52.0
>
