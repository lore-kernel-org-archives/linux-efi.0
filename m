Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD6D4508E9
	for <linux-efi@vger.kernel.org>; Fri, 16 Oct 2026 12:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152862; cv=none; b=p5HL7rWa8U5OnHt2d/gOICjb16KFVwivBXsv8BlJHqQdr3YMAMfm6u0aEPTTSIlrR0HRCdudANn7gOgBUSTcZbUoUwIZ3y8Jm8aCKCJ/zpHWFMUIk6y4SIHlBWX0UEmF3uFE5uEFfWuqmwkVvqD67aMJgHEy845Zcxjo9SyY0wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152862; c=relaxed/simple;
	bh=N91STIRoJBKZikDLI3znzjcc/Fnu8R6YXCPQBVKhEB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rgEYYaaaI027d5NRRJug4oRWGSqIbC1uJ+EKXPcSCnCgpgG0ov09+w2EmmLUMuGbZ6O+MPg2F2zGbEk0ShTyktUNelsieUr5hIrWzM1+Us7R4xkI4IZCdxbkrthj7yImVKEZfChumlIBqOefHqKrOLmSBeHI0O86qHO+1uNJ/JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DGoMVrGU; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DGoMVrGU"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48de72fc832so1139246f8f.1
        for <linux-efi@vger.kernel.org>; Fri, 16 Oct 2026 05:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792152859; x=1792757659; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O+NQOhqzv2YbuUrbjrP3YSMvBckVI+bztNOXhDG1B+k=;
        b=DGoMVrGUSZiEQbmzuZv2c0lefpUmktzWmFxukcY/eo/C1GHsI+Eh0qFdtv14W3zkuU
         ENoLCGpwz3pQpA3iEQwgG+QnUXGzW6SvXXnXZbDE7VVzyXq/Sy8o41EmHLVhoVuOOiqh
         pLUwQ8ZjGt+UNNcu2L7A+t5aI30KTXval9arjwDmVwwnlcQupszacyfbHNgiuOAovgjm
         FTC1ReFmTbA9Ow4LqQZ24y+YIGGFLXS6bGk5XTtW2wPFllVRkuTCKY1A2KbWbwQHBK3y
         QU1XCuqd52vxFvZrNV6y5/btuYUZdfg+U7CdB0Ne2hzJVtOHaN2ld7UEvyJ42XRFWuJX
         boAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792152859; x=1792757659;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O+NQOhqzv2YbuUrbjrP3YSMvBckVI+bztNOXhDG1B+k=;
        b=bZT+UrNLrCIrn88vOwGDbXs0sOAbF8aKr0YH3HOwpbvm0j6u41kam7VQDN2bFFi4lD
         vvvvVaSO2dZIQApgyvr/eRpEv5A5wcKf7Ym3Z1CU/5iVWCTsRXgMaUEc1+OFcZxDJ6SO
         HRIQsuuoNMCYobAfUlibAnW2PS2sZ6tfNnwBuom5Yx6OpQwAqYdq1gPukv7TvKSBxOWA
         Zwx1UVZbIcqMh1KJ7CLk4xsoZYsrUfrSPsQZmmAExCaWcKCvkI5xbvrx+L+/tDSi/yrO
         X0ZCBR6bvM9S5UxLp0bYVBpZ3ws38PxObtJv1K4oDkY0DmX+vcWBm8ZctafpG+SskGXt
         oLUg==
X-Forwarded-Encrypted: i=1; AKwUvBy0rwPGUtLIJS4oZLczSqOM/X/ClHqkfaz4UHASlnk3lDeDQYJTFsyMM2oZxd+OSGDS1ySEAj0q5no=@vger.kernel.org
X-Gm-Message-State: AFq9FYKdfIYFHAiUknZ3ZTofOBL8ntWggYsE/hY/YiD6/f4jYbiJJhzD
	ZKh7ono8Ac4Cymcz2MIrB64ifr+tZ13aR24UoCExe3g96tO38S6uQu/2dxEgGIvqK9E=
X-Gm-Gg: AYBFou2HOe4d7jodUxu/0Rdb8GYSH+2mvNezjvkQ7ku5jneCQvV4WwGAUryXS28a7sA
	piDhtSNgLxt5Iild4qLFbuVtDZ9QloeR25zD18MPeAucoLCq6gbe1LKnTJTtqSVQ4cvSB3PS7K/
	64QOH8ItAbLOi7wKchWfO7utzkYshi5cVVw1cNc6ZNuh+imYp+tfL8R7Kwhgg/bV6XkIoPe1Rqr
	uZH70IlOu9sBE/RYQewdAK5y6w7uVoe4ZgbvwgKG+UjvohM9o3i63r/HE/y8IWyHD1NRr9YnDbe
	AVnOu06KbRiLvHf8a9zd1VDlCy+JjQr6c4iuOcHuFKTKO/gV7Nxw5vENhBpc2HmN/SisLcosPhm
	LhOSSyzpojFxMndTC804h/5DrPbAVVm/5kZ/4luzVGz5h0Bkk7Eg0YLSkZKCq8E2ZilS059w/DH
	A/Ygv+R9W64kWHEyzPD80+OAQDj/WI3KVcWSw32lYpsXhJ8j3GOz8spvKXld+uXTTxqaOKKM0KV
	EiCJWY3BTx2c+Fv1OQCdPXcvI894FDMYt4=
X-Received: by 2002:a05:6000:2686:b0:48d:f3a4:610b with SMTP id ffacd0b85a97d-48df3a462bcmr12096973f8f.25.1792152858574;
        Fri, 16 Oct 2026 05:14:18 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:89a9:fd0e:583d:4a53? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd50d080sm4940009f8f.53.2026.10.16.05.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:14:17 -0700 (PDT)
Message-ID: <b17e9924-ca92-4cdf-b5e6-54164039e09a@suse.com>
Date: Fri, 16 Oct 2026 14:14:16 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/22] modpost: emit module descriptors as assembly
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-hardening@vger.kernel.org
References: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
 <20260923-build-speedup-v4-14-73128809a4a4@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260923-build-speedup-v4-14-73128809a4a4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/23/26 7:18 PM, Lorenzo Stoakes (ARM) wrote:
> modpost generates a descriptor for every module in the form of a
> <module>.mod.c file with .modinfo strings, the __this_module descriptor,
> exported symbol tables and (with CONFIG_MODVERSIONS set), the CRC of
> imported symbols.
> 
> These files are compiled like any other kernel C file with all of the
> -include preamble, as well as including linux/module.h, header dependencies
> generated by fixdep of a few hundred headers, an objtool run and if LTO is
> being performed, a link is performed to generate native code.
> 
> On an x86-64 allmodconfig build 11,189 *.mod.c files are built, each
> taking ~0.24s of CPU time to compile, and module finalisation as a whole
> 6,300 CPU seconds, or 64 seconds of wall time when run over 128 threads.
> 
> It also generates ~1.3 GiB of *.mod.o.cmd files that every subsequent build
> has to read back.
> 
> Avoid all this by emitting the descriptors as assembly instead.
> 
> The layout required (size and alignment of struct module, struct
> modversion_info, the module's name offsets, init, and exit fields and
> whether the architecture uses PREL32 ksymtab references) can all be derived
> from scripts/mod/module-offsets.h.
> 
> The fields of __this_module are emitted in offset order rather than
> declaration order, as CONFIG_RANDSTRUCT shuffles struct module so the name,
> init and exit fields can land anywhere.
> 
> An assembly file avoids all of the issues previously mentioned so this
> conversion results in a very significant performance win on kernel build.
> 
> As a consequence of this change, since module-offsets.c includes
> linux/module.h, scripts/mod is now built after the generated headers in
> prepare0, rather than before.
> 
> Also update .gitignore and make clean to handle .mod.S files, but keep
> .mod.c files there to ensure that users do not end up with untracked
> changes/dirty trees after the change takes effect.
> 
> The sections were confirmed to be byte-for-byte identical to the C version
> produced - each of .modinfo, .gnu.linkonce.this_module, __ksymtab*,
> __ksymtab_strings, __kcrctab*, __kflagstab*, __versions,
> __version_ext_crcs, __version_ext_names and their relocations - for all
> 8,135 modules of a clang allmodconfig build with CONFIG_COMPILE_TEST off
> and CONFIG_MODVERSIONS, CONFIG_EXTENDED_MODVERSIONS and
> CONFIG_MODULE_SRCVERSION_ALL on, and for a sample built with gcc.
> 
> What differs is what the compiler added around them: the __UNIQUE_ID_*
> locals, the KASAN constructor for the .mod.c globals, and on x86 a
> .note.gnu.property that the linker already drops from any module containing
> an assembly file and the loader never reads.
> 
> None of these have any impact on the build, however.
> 
> The assembly carries no debug information, so in order to keep describing
> __this_module in each module's debug information, define it weakly in
> module-common.c too, in a section which the module link discards.
> 
> x86_64 kernels built with gcc and clang, with CONFIG_MODVERSIONS,
> CONFIG_EXTENDED_MODVERSIONS and CONFIG_MODULE_SRCVERSION_ALL, were booted,
> every module and an external one loaded and unloaded, and the srcversions
> checked against modinfo, i386 and arm64 defconfigs (gcc and clang) and a
> ThinLTO build were also built as part of testing.
> 
> An x86_64 CONFIG_RANDSTRUCT_FULL build with clang, which places the name
> field after init and exit, was checked the same way and produces the same
> .gnu.linkonce.this_module sections and relocations as the C version.
> 
> On the x86_64 allmodconfig with clang 22, "make modules" with every
> *.mod.o and *.ko deleted goes from 64.5s (6,306 CPU-s) to 28.5s (518
> CPU-s).
> 
> A consequence of this change is that the make jobs are now so small that
> make cannot dispatch them quick enough, however the next commit in the
> series addresses this issue.
> 
> This impacts clean and no-op builds with a large number of modules most
> noticeably.
> 
> Whole build, 128-thread Threadripper 9980X, best of N runs:
> 
>                                          before   after     delta
>                                          -------------------------------
>   x86 allmodconfig, no-op make, gcc        12.7s     2.3s    -10.4s (-82%)
>   x86 allmodconfig, no-op make, clang      13.9s     2.8s    -11.2s (-80%)
>   x86 allmodconfig, clean, gcc            342.6s   306.6s    -36.0s (-11%)
>   x86 allmodconfig, clean, clang          340.1s   290.2s    -49.8s (-15%)
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

This version looks mostly ok to me, from a modules perspective. Below
are a few nits plus one more useful comment about handling
MODULE_ARCH_INIT.

> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 0fd43c8a89ea..9d96459e492c 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> [...]
> +/* The name and namespace strings a ksymtab entry refers to. */
> +static void add_asm_kstrtab(struct buffer *buf, const struct symbol *sym)
> +{
> +	buf_printf(buf, "\t.section \"__ksymtab_strings\",\"aMS\",%%progbits,1\n");
> +	buf_printf(buf, "__kstrtab_%s:\n", sym->name);
> +	buf_asciz(buf, sym->name);
> +	buf_printf(buf, "__kstrtabns_%s:\n", sym->name);
> +	buf_asciz(buf, sym->namespace);
> +	buf_printf(buf, "\t.previous\n");
> +}
> +
> +/* The equivalent of SYMBOL_FLAGS(). */
> +static void add_asm_kflagstab(struct buffer *buf, const struct symbol *sym)
> +{
> +	buf_printf(buf, "\t.section \"___kflagstab+%s\", \"a\"\n", sym->name);
> +	buf_printf(buf, "__flags_%s:\n", sym->name);
> +	buf_printf(buf, "\t.byte 0x%02x\n", get_symbol_flags(sym));
> +	buf_printf(buf, "\t.previous\n");
> +}
> +
> +/* The equivalent of KSYMTAB_FUNC()/KSYMTAB_DATA(). */
> +static void add_asm_ksymtab(struct buffer *buf, const struct symbol *sym)
> +{
> +	const char *name = sym->name;
> +
> +	add_asm_kstrtab(buf, sym);
> +
> +	buf_printf(buf, "\t.section \"___ksymtab+%s\", \"a\"\n", name);
> +	buf_printf(buf, "\t.balign %d\n", KSYM_ALIGN);
> +	buf_printf(buf, "__ksymtab_%s:\n", name);
> +	add_asm_ksym_ref(buf, sym->is_func ? MOD_FUNC_PREFIX : "", name);
> +	add_asm_ksym_ref(buf, "__kstrtab_", name);
> +	add_asm_ksym_ref(buf, "__kstrtabns_", name);
> +	buf_printf(buf, "\t.previous\n");
> +
> +	add_asm_kflagstab(buf, sym);
> +}

add_asm_kstrtab() and add_asm_kflagstab() are only called from
add_asm_ksymtab() and their logic is fairly short. I suggest merging
these functions.

> +
> +/* The equivalent of SYMBOL_CRC(). */
> +static void add_asm_crc(struct buffer *buf, const struct symbol *sym)
> +{
> +	buf_printf(buf, "\t.section \"___kcrctab+%s\",\"a\"\n", sym->name);
> +	buf_printf(buf, "\t.balign 4\n");
> +	buf_printf(buf, "__crc_%s:\n", sym->name);
> +	buf_printf(buf, "\t.long 0x%08x\n", sym->crc);
> +	buf_printf(buf, "\t.previous\n");
> +}
> +
> +static bool export_is_kept(const struct symbol *sym)
> +{
> +	return !trim_unused_exports || sym->used;
> +}

export_is_kept() is only called once from add_asm_exported_symbols().
The condition can be inlined directly there.

> +
> +/* The exported symbols and, with modversions, their CRCs. */
> +static void add_asm_exported_symbols(struct buffer *buf, struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	list_for_each_entry(sym, &mod->exported_symbols, list) {
> +		if (!export_is_kept(sym))
> +			continue;
> +
> +		add_asm_ksymtab(buf, sym);
> +
> +		if (!modversions)
> +			continue;
> +
> +		if (!sym->crc_valid)
> +			mod_warn(mod, "EXPORT symbol '%s' version generation failed, symbol will not be versioned.\n"
> +				 "Is '%s' prototyped in <asm/asm-prototypes.h>?\n",
> +				 sym->name, sym->name);
> +		add_asm_crc(buf, sym);
> +	}
> +}
> +
> +/* Zero fill up to the offset. */
> +static void asm_skip_to(struct buffer *buf, unsigned int *pos,
> +			unsigned int offset)
> +{
> +	if (offset < *pos)
> +		fatal("__this_module field at offset %u overlaps the previous one\n",
> +		      offset);
> +	if (offset > *pos)
> +		buf_printf(buf, "\t.skip %u\n", offset - *pos);
> +
> +	*pos = offset;
> +}
> +
> +/* A non-zero field of __this_module: its offset and the name or symbol in it. */
> +struct this_module_field {
> +	unsigned int offset;
> +	bool is_name;
> +	const char *value;
> +};
> +
> +#define THIS_MODULE_MAX_FIELDS	5
> +
> +static int compare_field_offsets(const void *ptr_a, const void *ptr_b)
> +{
> +	const struct this_module_field *field_a = ptr_a, *field_b = ptr_b;
> +
> +	if (field_a->offset != field_b->offset)
> +		return field_a->offset < field_b->offset ? -1 : 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * The fields of __this_module which are not zero, in offset order. The order
> + * is only known from module-offsets.h, CONFIG_RANDSTRUCT shuffles struct module.
> + */
> +static unsigned int get_this_module_fields(const struct module *mod,
> +					   const char *modname,
> +					   struct this_module_field *fields)
> +{
> +	unsigned int nr_fields = 0;
> +
> +	fields[nr_fields++] = (struct this_module_field)
> +		{ MOD_OFF_module_name, true, modname };
> +	if (mod->has_init)
> +		fields[nr_fields++] = (struct this_module_field)
> +			{ MOD_OFF_module_init, false, MOD_FUNC_PREFIX "init_module" };
> +#ifdef MOD_OFF_module_exit
> +	if (mod->has_cleanup)
> +		fields[nr_fields++] = (struct this_module_field)
> +			{ MOD_OFF_module_exit, false, MOD_FUNC_PREFIX "cleanup_module" };
> +#endif
> +#ifdef MOD_OFF_module_arch_fixup_start
> +	fields[nr_fields++] = (struct this_module_field)
> +		{ MOD_OFF_module_arch_fixup_start, false, "__start_fixup" };
> +	fields[nr_fields++] = (struct this_module_field)
> +		{ MOD_OFF_module_arch_fixup_end, false, "__stop_fixup" };
> +#endif
> +	qsort(fields, nr_fields, sizeof(*fields), compare_field_offsets);
> +
> +	return nr_fields;
> +}
> +
> +/* Emit one field of __this_module, returning its size. */
> +static unsigned int add_asm_this_module_field(struct buffer *buf,
> +					      const struct this_module_field *field)
> +{
> +	if (field->is_name) {
> +		buf_printf(buf, "\t.ascii \"%s\"\n", field->value);
> +		return strlen(field->value);
> +	}
> +
> +	buf_printf(buf, "\t" MOD_PTR_DIRECTIVE " %s\n", field->value);
> +	return MOD_SIZEOF_LONG;
> +}
> +
> +/*
> + * The equivalent of:
> + *
> + *	__visible struct module __this_module __section(".gnu.linkonce.this_module")
> + *		= { .name = KBUILD_MODNAME, .init = init_module, .exit = cleanup_module,
> + *		    .arch = MODULE_ARCH_INIT };
> + *
> + * Everything not listed is zero, MODULE_ARCH_INIT included, except on m68k.
> + */
> +static void add_asm_this_module(struct buffer *buf, const struct module *mod,
> +				const char *modname)
> +{
> +	struct this_module_field fields[THIS_MODULE_MAX_FIELDS];
> +	const unsigned int nr_fields = get_this_module_fields(mod, modname, fields);

The const qualifier can be removed from the nr_fields definition to
match the usual kernel style.

> +	unsigned int pos = 0, i;
> +
> +	buf_printf(buf, "\n\t.section .gnu.linkonce.this_module,\"aw\",%%progbits\n");
> +	buf_printf(buf, "\t.balign %d\n", MOD_ALIGNOF_struct_module);
> +	buf_printf(buf, "\t.globl __this_module\n");
> +	buf_printf(buf, "\t.type __this_module, %%object\n");
> +	buf_printf(buf, "\t.size __this_module, %d\n", MOD_SIZEOF_struct_module);
> +	buf_printf(buf, "__this_module:\n");
> +
> +	for (i = 0; i < nr_fields; i++) {
> +		asm_skip_to(buf, &pos, fields[i].offset);
> +		pos += add_asm_this_module_field(buf, &fields[i]);
> +	}
> +
> +	asm_skip_to(buf, &pos, MOD_SIZEOF_struct_module);
> +}
> +
> +/*
> + * An unresolved symbol without a module is not versioned; one without a CRC
> + * cannot be, so warn about it.
> + */
> +static bool skip_unversioned(struct module *mod, const struct symbol *sym)
> +{
> +	if (!sym->module)
> +		return true;
> +	if (sym->crc_valid)
> +		return false;
> +
> +	mod_warn(mod, "symbol '%s' has no CRC!\n", sym->name);
> +	return true;
> +}
> +
> +/* One struct modversion_info: the CRC, then the name padded to the end. */
> +static void add_asm_version(struct buffer *buf, const struct symbol *sym)
> +{
> +	buf_printf(buf, "\t" MOD_PTR_DIRECTIVE " 0x%08x\n", sym->crc);
> +	buf_printf(buf, "\t.ascii \"%s\"\n", sym->name);
> +	buf_printf(buf, "\t.skip %zu\n", MOD_SIZEOF_struct_modversion_info -
> +		   MOD_OFF_modversion_info_name - strlen(sym->name));
> +}
> +
> +/*
> + * The equivalent of:
> + *
> + *	static const struct modversion_info ____versions[]
> + *	__used __section("__versions") = { { crc, "name" }, ... };
> + *
> + * for unresolved symbols.
> + */
> +static void add_asm_versions(struct buffer *buf, struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	if (!basic_modversions)
> +		return;
> +
> +	buf_printf(buf, "\n\t.section __versions,\"a\",%%progbits\n");
> +	buf_printf(buf, "\t.balign %d\n", MOD_ALIGNOF_struct_modversion_info);
> +	list_for_each_entry(sym, &mod->unresolved_symbols, list) {
> +		if (skip_unversioned(mod, sym))
> +			continue;
> +
> +		if (strlen(sym->name) >= MOD_NAME_LEN) {
> +			/* Only the extended table can hold it. */
> +			if (extended_modversions)
> +				continue;
> +
> +			mod_error(mod, "too long symbol '%s'\n", sym->name);
> +			break;
> +		}
> +
> +		add_asm_version(buf, sym);
> +	}
> +}
> +
> +/*
> + * The equivalent of:
> + *	static const u32 ____version_ext_crcs[] __section("__version_ext_crcs") = { crc, ... };
> + *	static const char ____version_ext_names[] __section("__version_ext_names") = "name\0" ...;
> + *
> + * for unresolved symbols.
> + */
> +static void add_asm_extended_versions(struct buffer *buf, struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	if (!extended_modversions)
> +		return;
> +
> +	buf_printf(buf, "\n\t.section __version_ext_crcs,\"a\",%%progbits\n");
> +	buf_printf(buf, "\t.balign 4\n");
> +	list_for_each_entry(sym, &mod->unresolved_symbols, list) {
> +		if (skip_unversioned(mod, sym))
> +			continue;
> +
> +		buf_printf(buf, "\t.long 0x%08x\n", sym->crc);
> +	}
> +
> +	/*
> +	 * A symbol without a CRC was warned about above, and is skipped here
> +	 * too so that the names line up with the CRCs.
> +	 */
> +	buf_printf(buf, "\t.section __version_ext_names,\"a\",%%progbits\n");
> +	list_for_each_entry(sym, &mod->unresolved_symbols, list) {
> +		if (!sym->module || !sym->crc_valid)
> +			continue;

This condition must match the logic in skip_unversioned(). It would be
clearer to keep it only in one place by calling skip_unversioned() here
and adding a "silent" parameter to the function.

> diff --git a/scripts/mod/module-offsets.c b/scripts/mod/module-offsets.c
> new file mode 100644
> index 000000000000..a336dd47aa33
> --- /dev/null
> +++ b/scripts/mod/module-offsets.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Layout of the structures modpost emits into *.mod.S, extracted from the
> + * target headers as devicetable-offsets.c does for the device tables.
> + */

The second part of the comment, after the comma, is superfluous. It is
expected that the various parts of modpost use consistent mechanisms
where appropriate.

> +#define COMPILE_OFFSETS
> +#include <linux/kbuild.h>
> +#include <linux/module.h>
> +
> +int main(void)
> +{
> +	DEFINE(MOD_SIZEOF_LONG, sizeof(long));
> +	DEFINE(MOD_PREL32_RELOCATIONS, IS_ENABLED(CONFIG_HAVE_ARCH_PREL32_RELOCATIONS));
> +	DEFINE(MOD_FUNC_PLABEL, IS_ENABLED(CONFIG_PARISC) && IS_ENABLED(CONFIG_64BIT));
> +
> +	DEFINE(MOD_SIZEOF_struct_module, sizeof(struct module));
> +	DEFINE(MOD_ALIGNOF_struct_module, __alignof__(struct module));
> +	OFFSET(MOD_OFF_module_name, module, name);
> +	OFFSET(MOD_OFF_module_init, module, init);
> +#ifdef CONFIG_MODULE_UNLOAD
> +	OFFSET(MOD_OFF_module_exit, module, exit);
> +#endif
> +#if defined(CONFIG_M68K) && defined(CONFIG_MMU)
> +	/* MODULE_ARCH_INIT: the only architecture where it is not all zeroes. */
> +	OFFSET(MOD_OFF_module_arch_fixup_start, module, arch.fixup_start);
> +	OFFSET(MOD_OFF_module_arch_fixup_end, module, arch.fixup_end);
> +#endif

I feel it is a bit of a layering violation for modpost to know how
individual architectures need to initialize module::arch.

For now, this is probably ok. I would just remove MODULE_ARCH_INIT from
include/linux/module.h and arch/m68k/include/asm/module.h, along with
the comment referring to it in scripts/mod/modpost.c.

In the future, this could be avoided by having the m68k module support
look up the .m68k_fixup section at runtime, as other architectures
typically do for similar sections.

-- 
Thanks,
Petr
