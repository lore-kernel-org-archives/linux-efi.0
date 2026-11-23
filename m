Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795392697;
	b=hSt4Gglf5l/Ne4TCwPT7BcnJc4fF8sg2Jqxaf+KTrkiszpRp31xCsPycDUcn7j7tNF+Q
	 RSi/PiVkIJsM5rDTz2UkOGqFQcPl0yLj8O1bhEBGPiiIQ68s2F1RdHK6YQ+vhrerQhhge
	 UreiCirkqSwbsd7eXEXF098PqJu1KrOYARFyWpNI04sFsO5DHsWYXu32qzdSu838Mv9lv
	 pGNW1mnu7j7x3kSmaZyYZg2jJAS4zQwQowWrTfM6+eje8e4bEt/qtMmUROeRmCHoedQPG
	 AP0DrfBJt6IvFGgxfWHuZDCnOpEw1z2AGy4GT4IAKoFFz2AF2u1qSxFOEUiha19vlBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795392697;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NqEzYxMyXkoECvp9EkrUXstOlbj10uHYcil1snkPLu0=;
	b=ACC9lR28YiDy0dHvhEchWp2vQoB3WzQPHCQD5XW4PaRKy8Y39ru7Y5bubPr7ro+uJKmG
	 TTippZYprFXYfecJZ83JvW+TieBbvBUsuTeZCnK4c9u+XZpKKvf3ZPu7K8fc1zOEzTGsB
	 inch62Dznf/zjLqO/F3FxRA6yq/HgqI+tzDgnFFUmeCLZBrmvGEnn/P/khdm7+u+x735r
	 0rTiWrKfFX4hDPrChVTCpmms2Zl/6AwgE0QVLx6ZzmRlCTFEVjH6oV4fWghKxqhw9Hws3
	 U4HNzkAe+aUcRa6mPP9FwzgRokIGlmnsFqOLAo02YkNiqzu/b4Xm4FILfV76Ff7qU5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4z0SCqJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DD6606A334;
	Mon, 23 Nov 2026 00:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4z0SCqJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C781F000C6;
	Mon, 23 Nov 2026 00:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392697;
	bh=NqEzYxMyXkoECvp9EkrUXstOlbj10uHYcil1snkPLu0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4z0SCqJwiXeH+JjTFx+2bpcUgdjtnDWJ7YBWCiqzsTuYZAbNPbnv5V/WuKAkVldp
	 6jLVE2uamUbxvTZvSnTj+nT+M+BGbRKfCLNq1zY+8gDvNbyLzEeoQEVb02vw0M3tlC
	 3GM4AQ34nH5taxx8kjcx/zbR25+3SHy6BZfHGZxntfyot8A/Iev7K9pnEgMm/ub4vo
	 xD09DCkUfygmxeyFACimfnrko3Dd8xBC0uvu6hVG0XKAhCRRYg5VtUxomtj+fCOMAT
	 Ua53AA4KZNy5VJbptI3J748j8UXBgQlfQlux6E65T8ASSf1qMBToQ3aGUW1q/GT/EK
	 N2l5zNgp+Q0zQ==
Message-ID: <sashiko-outbox-228461@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 02/11] unwind_user: Support Minimal DWARF CFI
 user-space unwinding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261122235757.3456048-3-irogers@google.com>
References: <20261122235757.3456048-1-irogers@google.com>
 <20261122235757.3456048-3-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 00:11:34 +0000
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
- [High] unwind_user: unguarded frame_pointer() call in
  unwind_user_frame_pointer()
--

commit ad18f29bd8a6b46031b3d36b8ae44ab35c61c7c8
Author: Ian Rogers <irogers@google.com>

unwind_user: Support Minimal DWARF CFI user-space unwinding

This commit extends the generic user-space unwinder with
UNWIND_USER_TYPE_CFI to resolve ELF PT_GNU_EH_FRAME headers across
executable VMAs and enables 64-bit and 32-bit compat user unwinding on x86.

> diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
> index 64618618febde..dcd87012ab82c 100644
> --- a/include/linux/unwind_user.h
> +++ b/include/linux/unwind_user.h
> @@ -16,6 +16,12 @@
>  #endif
> =20
>  #ifndef unwind_user_at_function_start
> +/**
> + * unwind_user_at_function_start() - Default stub for function-entry det=
ection
> + * @regs: User-mode register state.
> + *
> + * Return: false when the architecture does not override entry detection.
> + */
>  static inline bool unwind_user_at_function_start(struct pt_regs *regs)
>  {
>  	return false;
> @@ -23,6 +29,78 @@ static inline bool unwind_user_at_function_start(struc=
t pt_regs *regs)
>  #define unwind_user_at_function_start unwind_user_at_function_start
>  #endif
> =20
> +#ifndef unwind_user_frame_pointer
> +/**
> + * unwind_user_frame_pointer() - Default helper returning @regs's frame =
pointer
> + * @regs: User-mode register state.
> + *
> + * Return: Architectural user frame pointer from frame_pointer(@regs).
> + */
> +static inline unsigned long unwind_user_frame_pointer(struct pt_regs *re=
gs)
> +{
> +	return frame_pointer(regs);
> +}
> +#define unwind_user_frame_pointer unwind_user_frame_pointer
> +#endif

[Severity: High]
Does defining unwind_user_frame_pointer() unconditionally break the build
on architectures that do not provide frame_pointer(regs)?

include/linux/unwind_deferred.h includes include/linux/unwind_user.h
outside CONFIG_UNWIND_USER, and core files such as kernel/exit.c include
include/linux/unwind_deferred.h on all architectures.  Architectures like
LoongArch and s390 do not define frame_pointer(regs) in asm/ptrace.h, and
include/linux/unwind_user.h also does not include linux/ptrace.h before
referencing struct pt_regs and frame_pointer().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122235757.3456=
048-1-irogers@google.com?part=3D2
