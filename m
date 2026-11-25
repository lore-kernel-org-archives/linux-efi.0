Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588336;
	b=Q3DcWDqLQ/GILb+6X2QXUCPPVKe3EoN3a8Pjq05nJzOT09Rv8m4X9DHIe0A9KVyXbRki
	 PbZqHvERFR/koqbQgP7rmFRYbsgCENYlxIsbDmTYZzSiA907oOY2TjuxdNiFBNPGtmLDE
	 6Ln/Bzuwia+auNsf6k+65c/GV4dYWrgZvmxNcZK272zCu1RoAWQ6JRvqqf8rSrHQhuxOo
	 VbbsRc1W2Ez75HesjhIOUN9weU+3//6bHmytHfipLBhg/Q6NZAAJsF3fZsQj4eneBb2ld
	 QaPqGQfo8p4pXsTwj2wfSCEamK/ppFUZnM30mIvdS8gkeHyNS/+ZTPClDqeiwjRFdag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588336;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w42WxlIquH/+kAdUoe6zClaCsJ735dV8RKabBKPXtKQ=;
	b=ilPPLoyRmwG6CNML0vukirwHUEIynqhyztrk2XL/2WTKHCN1rsYNf8xZ3vL+mDvMuNjS
	 Mt+/4aOQdwElJ3nOl/E6x0yoyS7CAgrZpPoGuqH43bwgtQUo6dTHC6qi38s5aRUhL0ufM
	 CYQCYMLaMVtWTUzzA6Xb/vTH3g3jV1fgNn88QEywGkzAQfJIy+n2DNl/1aoun53qk5P3r
	 TRX3FhHd2qSJCeYvsxa2qERQCd8PqxRI/iZDSb5Kpj60pn2cdkt4+qqFYFQC5Ee5EzgQd
	 LHI/ZD0Zw0Lg6BTeQKoNY9qot0kBdF2gBEPIaQBeN5mXkvDzd8RQB+fMMoXIpgUpC/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBg7X9YJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0D8606A31E;
	Wed, 25 Nov 2026 06:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBg7X9YJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C963D1F000E1;
	Wed, 25 Nov 2026 06:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795588335;
	bh=w42WxlIquH/+kAdUoe6zClaCsJ735dV8RKabBKPXtKQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fBg7X9YJGxWOaIlkDCmuMZ5QbIpE9INWeuvzdygZHkzDZOrL0SQ47V9z4LzfGdaP+
	 2jtYLKSFPmC6HNt1h42cIWfhdQV0Lgrx5r/zKZ55E49v9ZPY4v+4hkDwWBoe5PRFsM
	 i4UmEYa4HCRsTWg8lZX4O4lBMHho48ijvInJ7mNVbdoocv1bQPOne2M6yzoBG0LWTL
	 6PBo1GTmh2oBMhR9vWhC/KLp77ojlpgnUpd19lcNhXZ+NW39Be/qMql0dbjQG5dRp7
	 /2flIOB6eJtUD9OVkHF5R3WDAMKxMOg0bIpWy7uAb2buiXKwQDe65KnV5LwAFNYON7
	 Gkk75p7U5YFig==
Message-ID: <sashiko-outbox-232710@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 06/30] kbuild: Wire up
 CONFIG_UNWINDER_DWARF_CFI_MINIFY object pass
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261125061523.1540234-7-irogers@google.com>
References: <20261125061523.1540234-1-irogers@google.com>
 <20261125061523.1540234-7-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:32:13 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] kbuild: redundant per-object min_eh_frame execution under
  CONFIG_LTO_CLANG
--

commit 101a56a36516bdc9a2795fbb054e65478eaa7f49
Author: Ian Rogers <irogers@google.com>

kbuild: Wire up CONFIG_UNWINDER_DWARF_CFI_MINIFY object pass

This commit invokes scripts/min_eh_frame on standard kernel objects and
post-LTO composite objects when CONFIG_UNWINDER_DWARF_CFI_MINIFY is
enabled, and records scripts/min_eh_frame as a rebuild dependency in
.*.cmd files.

> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 6127feb970c65..ced0f630f5669 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -281,6 +281,10 @@ ifdef CONFIG_OBJTOOL
>  $(obj)/%.o: private objtool-enabled =3D $(if $(is-standard-object),$(if =
$(delay-objtool),$(is-single-obj-m),y))
>  endif
> =20
> +ifdef CONFIG_UNWINDER_DWARF_CFI_MINIFY
> +$(obj)/%.o: private min-eh-frame-enabled =3D $(if $(filter-out scripts/m=
od/empty.o,$@),$(is-standard-object))
> +endif
> +

[Severity: Low]
Should min-eh-frame-enabled on $(obj)/%.o restrict per-object runs under
CONFIG_LTO_CLANG to $(is-single-obj-m), similar to objtool-enabled above?

With CONFIG_LTO_CLANG=3Dy, composite targets (vmlinux.o and $(multi-obj-m))
already run scripts/min_eh_frame after linking.  Enabling it
unconditionally for all $(is-standard-object) targets spawns
scripts/min_eh_frame on every per-TU LLVM bitcode .o file (where
cmd_ld_single did not convert it to ELF) and processes non-bitcode ELF .o
files such as assembly and Rust objects twice.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125061523.1540=
234-1-irogers@google.com?part=3D6
