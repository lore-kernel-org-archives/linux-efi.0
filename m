Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B94306B13
	for <linux-efi@vger.kernel.org>; Thu, 18 Sep 2025 11:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758196656; cv=none; b=Kw8N9WGP2ssI5NGgqPnxaixTFhdvyK94gb2WgbSRpiHxJuCCo3JKVSujkkMyjZViYcXUrgyuOxzWsXVinWSRtnza9G3NSGeKYHqaCkoJ5oXDNdP5bKfmbFC3zKzcojtVZ6KoC7PkaFLz8Kab37q5khGSkySNtup2Fqh08vwLh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758196656; c=relaxed/simple;
	bh=QnCGG1F/hqyhQaGreicIO5t9aXuxNFzDWO6EGQXut+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R0LmXTVMNffoxAoYjbbteGDspszFs7Xtiy83WktqQfrE44LKB+lkilKbUHXeJ8LbKVzuCYyXR5mG3JIATvrxQhaepr/BFn/XJHmiFpaaPp3ICzaRn33sFpsh4CbrevqTjhYrgKIYr9476F0/aJp15ZyA/3NcCZHOjbCmQDa69K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5hKn77i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5hKn77i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8259C4AF0B
	for <linux-efi@vger.kernel.org>; Thu, 18 Sep 2025 11:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758196655;
	bh=QnCGG1F/hqyhQaGreicIO5t9aXuxNFzDWO6EGQXut+Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L5hKn77iLZnqH2V8qLIMIipq7e2jhxcKM2rUX/sebVosDrQZLHFeBCjxk/cfX2H5y
	 /QWfVKJ1ilXILb+r95fj6GmtOaICVSj39OQOORutfLLdSMudLcJWp+M/yy17UJE73s
	 l9fB5hXNQguBHpNXprZNNrusoXaO8tbTr1LJdP+Wde0Pd5kEofQNq5Exrr5QHq7iGn
	 c9Qi4ERaTz79nzOaSPtEHKWq6zCkpJp67bMiXwi3+pxosnrqdOeaIs4CcLyAon9ot5
	 B+cv1w9BHDMYpdQEW1uaxPiQNkES+oVZZAZ5IMbqEX1f8VYQDNa0RT+7HcLPSeE750
	 bdguiUEvr/odg==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-570d0c280e4so1055906e87.0
        for <linux-efi@vger.kernel.org>; Thu, 18 Sep 2025 04:57:35 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw1kEXT8KdD9OX/9LqJ3J8yP77FjA7yzw2Kobs3H42M5lfoxt2r
	9Xx30xrdBQ6nKh2XwBgq3NtAzqGi7h6zM0kwW/YXbM7EgIsxVaKJrP/X/Pd5/q2huc5BSxnlMb1
	epX01nRqJ8SAmUkB70gCrg0ziRc4Ffbs=
X-Google-Smtp-Source: AGHT+IHYPtDHABOS+XktnkbTA9g5LgHepKlyYBaYIJE5P4XpCc/WpYv7sbOdTy9UHPafSUFpUFHKJcQW3E4vVmbVLVU=
X-Received: by 2002:a05:6512:3b8e:b0:577:9ee:7d55 with SMTP id
 2adb3069b0e04-577999d49c0mr2000638e87.28.1758196654077; Thu, 18 Sep 2025
 04:57:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918103010.2973462-10-ardb+git@google.com> <20250918103010.2973462-15-ardb+git@google.com>
In-Reply-To: <20250918103010.2973462-15-ardb+git@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 18 Sep 2025 13:57:22 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE+hvMQLU6UF3QvTyo9Y1eUjCnPcPnMU9bOe4FDZ-N+EQ@mail.gmail.com>
X-Gm-Features: AS18NWArWnMLbH2kRQX7johssD9UyrnwA4cP-veatvN2_G57llXGRNMEAsjOnCY
Message-ID: <CAMj1kXE+hvMQLU6UF3QvTyo9Y1eUjCnPcPnMU9bOe4FDZ-N+EQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] arm64/fpsimd: Drop special handling for EFI
 runtime services
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Sept 2025 at 12:30, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Now that the use of kernel mode FP/SIMD is generally permitted when IRQs
> are disabled, the only purpose served by the EFI-specific fallback code
> in fpsimd.c is the case where an EFI call occurs from hardirq or NMI
> context. No such cases are known to occur in practice, and it is
> doubtful whether calling into the EFI firmware for any reason under such
> conditions would be a good idea to begin with.
>
> So disallow EFI runtime services in such cases. This means all the
> fallback code can be dropped.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h |   4 -
>  arch/arm64/kernel/efi.c         |   8 +-
>  arch/arm64/kernel/fpsimd.c      | 121 --------------------
>  3 files changed, 6 insertions(+), 127 deletions(-)
>

This patch is incomplete, the following needs to be folded in as well:

 arch/arm64/kernel/fpsimd.c | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index e543dd569bd7..c846161a002b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -180,13 +180,6 @@
        set_default_vl(ARM64_VEC_SVE, val);
 }

-static u8 *efi_sve_state;
-
-#else /* ! CONFIG_ARM64_SVE */
-
-/* Dummy declaration for code that will be optimised out: */
-extern u8 *efi_sve_state;
-
 #endif /* ! CONFIG_ARM64_SVE */

 #ifdef CONFIG_ARM64_SME
@@ -1086,36 +1079,6 @@
        return 0;
 }

-static void __init sve_efi_setup(void)
-{
-       int max_vl = 0;
-       int i;
-
-       if (!IS_ENABLED(CONFIG_EFI))
-               return;
-
-       for (i = 0; i < ARRAY_SIZE(vl_info); i++)
-               max_vl = max(vl_info[i].max_vl, max_vl);
-
-       /*
-        * alloc_percpu() warns and prints a backtrace if this goes wrong.
-        * This is evidence of a crippled system and we are returning void,
-        * so no attempt is made to handle this situation here.
-        */
-       if (!sve_vl_valid(max_vl))
-               goto fail;
-
-       efi_sve_state = kmalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(max_vl)),
-                               GFP_KERNEL);
-       if (!efi_sve_state)
-               goto fail;
-
-       return;
-
-fail:
-       panic("Cannot allocate memory for EFI SVE save/restore");
-}
-
 void cpu_enable_sve(const struct arm64_cpu_capabilities *__always_unused p)
 {
        write_sysreg(read_sysreg(CPACR_EL1) | CPACR_EL1_ZEN_EL1EN, CPACR_EL1);
@@ -1176,8 +1139,6 @@
        if (sve_max_virtualisable_vl() < sve_max_vl())
                pr_warn("%s: unvirtualisable vector lengths present\n",
                        info->name);
-
-       sve_efi_setup();
 }

 /*
