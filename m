Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4050B48D868
	for <linux-efi@vger.kernel.org>; Mon, 21 Sep 2026 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789989921; cv=none; b=PY46w9jb8MwQ3QQwOfq1AQdq11F0qq0YZubtZdcSmZ501Z1NosYIrmURJ6qdvt+74NHY5aBPZ4M05LFYmRaSINXO77QRHRk2tWR7LZXTidHYJwh/82g1kb+zdvpYBQKY7WfneBOEjoXnoiXAhFfL6L8K2Te33LKwLdXXgvh6fzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789989921; c=relaxed/simple;
	bh=vL7H9bUFob8ldX6kiSUwQbR/mxtlpznZdS9IX5wHg4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fj3ym587+C+29JEe/zP05A6pb632BWnXt9z5Yz5n4eEsZ+LdsQmNC1OW1K2q1adIv1LEmMyd9GHdAFhwgV5flhI2EdeXzPzXBvDV2G3W8fZh2JwX5r9j1dUwHoHabQMxSi+br7Yfo83CvVh2PQHpo5fSb+VrOdRFvhfljBxW/Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vhw7aLhr; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vhw7aLhr"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b91369d18so21074285e9.0
        for <linux-efi@vger.kernel.org>; Mon, 21 Sep 2026 04:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789989912; x=1790594712; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kLlCULrw1v/vSqZnviB/Cu2fC1Y7qRZoJjKlQFtW/cc=;
        b=Vhw7aLhr2hs5mUDvFtaiWafzn0SQAB1KRD3UcypFgjyciceWezvD3sAcaZGlpKQf6W
         1Pkq0qMMKHYM5Rd2B08kzj+uihssv08doCjawZjeQluEFwn+egW/I5Bx/1xkA0HW+f+X
         vz39sSyQ+YoStFTF/niNt3RR3eGt9q/kamO/OBff7CdspOx1OC07psQyi2ANOQ/hk4Qu
         IYXDiJ2YW9IVbqOOYm4EGJHnIxDaezKxS9oDyHdnKSsWxCDjNXdag62eGIuOUJQQOV8B
         oaipJI8lf17IzDe+9hOp2CWXSS0kHWR+gCvGw0TzZd5MPj541wzj/ilXlfAsnpQ//tSC
         U/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789989912; x=1790594712;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLlCULrw1v/vSqZnviB/Cu2fC1Y7qRZoJjKlQFtW/cc=;
        b=kjAGtg8CIeXmN+NeAQ4Op9cjAHMqwxOY13EqC7LGnnPo/CpMknsB9LyRf1CqUaf27F
         SGbiXQJPl/2hOdsTmfWxP428opy/rsAM5/GjB7CA8Wx+3T/kW/oAOPUEcvFpJOyHJP+p
         DUSxc4w39r9RSbhIafpFXqxI3rrM94JbXMzUmDBvmPOQIqRSePPhTi0KZZSIFMO5UZG+
         VJYk95p++pG0YdM4j0NrHBsoVhVoXlf5PS6ssqdw0r2rrAPCzw05me3l2flruZY9lufm
         PABfzf+6mqzUaIfDC4SB5OkubntvnRvawDVclRBSJwsAzkUzWbWJ9XBW/Md94YApqvd6
         T49g==
X-Forwarded-Encrypted: i=1; AKwUvBwnO1h5XiOnhuBVbzKi0cBl69KXzu0ouVpdw6eyl0rQ9O/rcEpRAsrMTigRiIl7NtW5W0+4PSpq5n8=@vger.kernel.org
X-Gm-Message-State: AFuF++nzsUfxPGmoch0bwYU6fFBfHBZnf6etJZKD4uYahZCSlKUFc6i8
	SCgq5am8zVXM6RhD2P88F4JJieN/OxjXK/SGXt6LdOQmJ3gPLvpQERrw3GPyhISkX0o=
X-Gm-Gg: AYBFou1s5g/1poCOUEMA2tPy0udO1PJ3JVkgoeOdReuJTJRLQwVNTk1YyoZh2/v3wIk
	LOWaz8nZ3K3DKbRQU18zIaZlUZc4OrzbOvCV0Oxsk8vn5DKkcd6FQ8kXBzBjpPYnE8cr/yp0s5j
	T51u6yNtTleqLTRWK5lJwpwyZ1a5GYZMHawr/A9Orv43HeWFKfb5P3h5gkxgB1TrNt2KcXTrq9j
	+O+d+1filNYVTCeenq+vMKbuT/uBii3zfAjVwn8qzBGvF4KuWn4i+aG1mELL5qEbMcwoKgCpUjU
	4LK8z+G4rZJdFF5KMO6p4aLJrz8gJeQuSV84jDsm4jc1Ms22r1bpEtWEg0uZ5kl0iXOEQ3G/L1/
	lEd+00ZQW5Nc3gLfYuBD0xJVb1kLQk7i17ARy4Cn/PVewQshd5wur5apdxZDkJMPGiGSoWlJmXA
	DkhqqIpQbWWhUqRViwcZASL7ic+meXzD2zrQ0IRYHQc88uNDQwT6G8FWlBoswh1tzHNIfxR2tkW
	3ubSknva2iev0ssUPuseuENBsgOG3aq5II9
X-Received: by 2002:a05:600c:4f44:b0:49f:ce73:7a9 with SMTP id 5b1f17b1804b1-49fce730888mr97408375e9.34.1789989911838;
        Mon, 21 Sep 2026 04:25:11 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:89a9:fd0e:583d:4a53? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd757e97esm7376075e9.8.2026.09.21.04.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 04:25:11 -0700 (PDT)
Message-ID: <95baacfb-d8d9-4d2f-bc89-592df6f6f8e3@suse.com>
Date: Mon, 21 Sep 2026 13:25:09 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/21] modpost: emit module descriptors as assembly
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
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-13-39817ec5db23@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260914-build-speedup-v2-13-39817ec5db23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/14/26 11:22 AM, Lorenzo Stoakes (ARM) wrote:
> modpost generates a descriptor for every module in the form of a
> <module>.mod.c file with .modinfo strings, the __this_module descriptor,
> exported symbol tables and (with CONFIG_MODVERSIONS set), the CRC of
> imported symbols.
> 
> These files are compiled like any other kernel C file with all of the
> -include preamble, as well as including linux/module.h, header dependencies
> generated by fixdep of a few hundred headers, an objtool run and if LTO is
> being performed, a link is performed to generate native code.

As a side note, I'm currently working on cleaning up what linux/module.h
includes. This was also originally motivated by an effort to reduce the
compilation time of .mod.c files, though cleaning up that header makes
sense in general, since it is the most explicitly included file in the
kernel.

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

Lowering the data to assembly loses debug information for __this_module,
specifically that it has type `struct module`. It might be worth
restoring that information in same way. A small hack would be to add
something like the following to scripts/module-common.c:

__weak __section(".discard.this_module") struct module __this_module;

> diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> index 01a37ec872b9..75e9effdf02c 100644
> --- a/scripts/Makefile.modfinal
> +++ b/scripts/Makefile.modfinal
> @@ -20,10 +20,14 @@ __modfinal: $(modules:%.o=%.ko)
>  modname = $(notdir $(@:.mod.o=))
>  part-of-module = y
>  GCOV_PROFILE := n
> -ccflags-remove-y := $(CC_FLAGS_CFI)
>  
> -%.mod.o: %.mod.c FORCE
> -	$(call if_changed_rule,cc_o_c)
> +# modpost lays the <module>.mod.S out completely (write_mod_S_file()), so it
> +# needs only the assembler and no dependency tracking.
> +quiet_cmd_as_mod_o = AS [M]  $@
> +      cmd_as_mod_o = $(CC) $(_a_flags) $(modkern_aflags) -c -o $@ $<
> +
> +%.mod.o: %.mod.S FORCE
> +	$(call if_changed,as_mod_o)
>  
>  .module-common.o: $(srctree)/scripts/module-common.c FORCE
>  	$(call if_changed_rule,cc_o_c)

If the <module>.mod.S files are fully self-contained and do not even use
something like KBUILD_MODNAME, would it be possible to name them
<module>.mod.s and skip the C preprocessor as well?

> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 0fd43c8a89ea..b4550b545330 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -2191,30 +2042,483 @@ static void write_vmlinux_export_c_file(struct module *mod)
>  	free(buf.p);
>  }
>  
> -/* do sanity checks, and generate *.mod.c file */
> -static void write_mod_c_file(struct module *mod)
> +#if MOD_SIZEOF_LONG == 8
> +#define MOD_PTR_DIRECTIVE	".quad"
> +#else
> +#define MOD_PTR_DIRECTIVE	".long"
> +#endif
> +
> +/* See KSYM_FUNC() in include/linux/export-internal.h. */
> +#if MOD_FUNC_PLABEL
> +#define MOD_FUNC_PREFIX		"P%"
> +#else
> +#define MOD_FUNC_PREFIX		""
> +#endif
> +
> +/* See __KSYM_ALIGN in include/linux/export-internal.h. */
> +#if MOD_PREL32_RELOCATIONS || MOD_SIZEOF_LONG == 4
> +#define KSYM_ALIGN		4
> +#else
> +#define KSYM_ALIGN		8
> +#endif
> +
> +/* Append the body of an assembler string literal, escaped as needed. */
> +static void buf_escaped(struct buffer *buf, const char *str)
> +{
> +	unsigned char chr;
> +
> +	while ((chr = *str++)) {
> +		if (chr == '"' || chr == '\\')
> +			buf_printf(buf, "\\%c", chr);
> +		else if (isprint(chr))
> +			buf_printf(buf, "%c", chr);
> +		else
> +			buf_printf(buf, "\\%03o", chr);
> +	}
> +}
> +
> +static void buf_asciz(struct buffer *buf, const char *str)
>  {
> -	struct buffer buf = { };
> -	struct module_alias *alias, *next;
> -	char fname[PATH_MAX];
> -	int ret;
> +	buf_printf(buf, "\t.asciz \"");
> +	buf_escaped(buf, str);
> +	buf_printf(buf, "\"\n");
> +}
>  
> -	add_header(&buf, mod);
> -	add_exported_symbols(&buf, mod);
> -	add_versions(&buf, mod);
> -	add_extended_versions(&buf, mod);
> -	add_depends(&buf, mod);
> +/* The equivalent of MODULE_INFO(tag, info). */
> +static void add_asm_modinfo(struct buffer *buf, const char *tag,
> +			    const char *info)
> +{
> +	buf_printf(buf, "\t.section .modinfo,\"a\",%%progbits\n");
> +	buf_printf(buf, "\t.asciz \"%s=", tag);
> +	buf_escaped(buf, info);
> +	buf_printf(buf, "\"\n");
> +}
>  
> -	buf_printf(&buf, "\n");
> +/* See __KSYM_REF() in include/linux/export-internal.h. */
> +static void add_asm_ksym_ref(struct buffer *buf, const char *prefix,
> +			     const char *sym)
> +{
> +#if MOD_PREL32_RELOCATIONS
> +	buf_printf(buf, "\t.long %s%s - .\n", prefix, sym);
> +#else
> +	buf_printf(buf, "\t" MOD_PTR_DIRECTIVE " %s%s\n", prefix, sym);
> +#endif
> +}
> +
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

It would be good to avoid duplicating these symbol-related
implementations in include/linux/export-internal.h and
scripts/mod/modpost.c. Perhaps .vmlinux.export.c could also be lowered
to assembly, so the implementation in include/linux/export-internal.h
can be removed and scripts/mod/modpost.c becomes the only source of
truth.

> +
> +static bool export_is_kept(const struct symbol *sym)
> +{
> +	return !trim_unused_exports || sym->used;
> +}
> +
> +/* Record the CRCs of the exported symbols. */
> +static void add_asm_crcs(struct buffer *buf, struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	list_for_each_entry(sym, &mod->exported_symbols, list) {
> +		if (!export_is_kept(sym))
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
> +static void add_asm_exported_symbols(struct buffer *buf, struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	list_for_each_entry(sym, &mod->exported_symbols, list) {
> +		if (export_is_kept(sym))
> +			add_asm_ksymtab(buf, sym);
> +	}
> +
> +	if (modversions)
> +		add_asm_crcs(buf, mod);
> +}

Nit: This could be kept shorter as a single function, similarly to how
the original C version was implemented solely as add_exported_symbols().

static void add_asm_exported_symbols(struct buffer *buf, struct module *mod)
{
	struct symbol *sym;

	list_for_each_entry(sym, &mod->exported_symbols, list) {
		if (trim_unused_exports && !sym->used)
			continue;

		add_asm_ksymtab(buf, sym);

		if (!modversions)
			continue;

		if (!sym->crc_valid)
			mod_warn(mod, "EXPORT symbol '%s' version generation failed, symbol will not be versioned.\n"
				 "Is '%s' prototyped in <asm/asm-prototypes.h>?\n",
				 sym->name, sym->name);
		add_asm_crc(buf, sym);
	}
}

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
> +static void add_asm_version_ext_crcs(struct buffer *buf, struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	buf_printf(buf, "\n\t.section __version_ext_crcs,\"a\",%%progbits\n");
> +	buf_printf(buf, "\t.balign 4\n");
> +	list_for_each_entry(sym, &mod->unresolved_symbols, list) {
> +		if (skip_unversioned(mod, sym))
> +			continue;
> +
> +		buf_printf(buf, "\t.long 0x%08x\n", sym->crc);
> +	}
> +}
> +
> +/*
> + * A symbol without a CRC was warned about with the CRCs, and is skipped here
> + * too so that the names line up with them.
> + */
> +static void add_asm_version_ext_names(struct buffer *buf, struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	buf_printf(buf, "\t.section __version_ext_names,\"a\",%%progbits\n");
> +	list_for_each_entry(sym, &mod->unresolved_symbols, list) {
> +		if (!sym->module || !sym->crc_valid)
> +			continue;
> +
> +		buf_asciz(buf, sym->name);
> +	}
> +	/* The terminator of the string literal this used to be. */
> +	buf_printf(buf, "\t.byte 0\n");

This is ok since the conversion aims to be byte-identical. In the
future, I believe the extra NUL byte should be removed and
elf_validity_cache_index_versions() also be updated to report when
__version_ext_names contains more names than there are CRCs in
__version_ext_crcs.

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
> +	if (!extended_modversions)
> +		return;
> +
> +	add_asm_version_ext_crcs(buf, mod);
> +	add_asm_version_ext_names(buf, mod);
> +}

Nit: add_asm_version_ext_crcs() and add_asm_version_ext_names() are both
fairly short and are called only from add_asm_extended_versions(), so
I think they could be inlined into that function. This would be similar
to the original implementation, which does all the work in
add_extended_versions().

> +
> +/* Clear ->seen of the modules that own symbols this one needs. */
> +static void clear_seen_dependencies(struct module *mod)
> +{
> +	struct symbol *sym;
> +
> +	list_for_each_entry(sym, &mod->unresolved_symbols, list) {
> +		if (sym->module)
> +			sym->module->seen = sym->module->is_vmlinux;
> +	}
> +}
> +
> +/* The modules this one depends on, each once, comma separated. */
> +static void collect_dependencies(struct module *mod, struct buffer *deps)
> +{
> +	struct symbol *sym;
> +	bool first = true;
> +
> +	clear_seen_dependencies(mod);
> +
> +	list_for_each_entry(sym, &mod->unresolved_symbols, list) {
> +		struct module *owner = sym->module;
> +
> +		if (!owner || owner->seen)
> +			continue;
> +
> +		owner->seen = true;
> +		buf_printf(deps, "%s%s", first ? "" : ",",
> +			   get_basename(owner->name));
> +		first = false;
> +	}
> +	buf_write(deps, "", 1);
> +}
> +
> +static void add_asm_depends(struct buffer *buf, struct module *mod)
> +{
> +	struct buffer deps = { };
> +
> +	collect_dependencies(mod, &deps);
> +	buf_printf(buf, "\n");
> +	add_asm_modinfo(buf, "depends", deps.p);
> +	free(deps.p);
> +}

Nit: Same here. I think this would be more straightforward if
collect_dependencies() and clear_seen_dependencies() were inlined into
add_asm_depends(), matching the original add_depends().

-- 
Thanks,
Petr
