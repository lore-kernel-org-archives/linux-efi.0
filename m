Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495FE27732;
	Fri,  3 Jul 2026 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783097138; cv=none; b=HE5IFekcL5P2V7VqGT9HfpwReDA0G0nNPbMR+xa41eKRiBfkNtwXDE4HhH0o5JKIe2MtQcAkaP+jvMBxwTc3R+0/ogQ5DBHp/sQo5Ta8U3AsTF3b3q1I8UvTSFnaimb+5omdU5bUYuu2896PenwTHXHhkbL8EaAa2ori44yB93s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783097138; c=relaxed/simple;
	bh=0DRZ2smuBcmNbxpX37Hz2EgOkA+rk2Dh8WvQYelSEMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=InTGwnIjJkVo8wc9jN2EkEtXTFKPyJnTVRgfZO4Fuz6d7uqWZ5BlAuta5b6Om2OOSOt2vqfFCtLbHun0hBD7VcmtP3DczUpeiL6ghnsdp09aGXG8X12V9ytJ67u/76f/UWJTIsilzrMFXHwk3TsslfMDIsk5FGqHxo1+F2X7yH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=E0GDICzy; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="E0GDICzy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oytYUjBSAM6Spo5uHh1E+ruoHlc7Qx0XVI6YVgYR4W0=; b=E0GDICzyxiEzkb1P1PTSVX/dVw
	VmKHeNXg+otnMSNWJGB/XkjhUL0j7yonSPmQAu+C/Udh7xPN+dZemORrAS3b+4D8Gj47HkVri42rx
	GKgldjgD4S4efDLbncRFppb/a/NNFhIhgNpatLLb+KaX2LRbr7BYEfaHnCVtHBuDhIVfXGcU+St7m
	Rrq6y2vJpYduX9hTKjA7Y63IZti8sk7pdikdtC7r0afBHaE72b880h+bJnPFTnGeP5jQVfzU1Nopj
	pbj66BcLAKn5MqITFO2pjdqBSOXxSCqhM3NZl4mZW5T5zFWKPfe8yN6RA6Y1I7GL43fweacMW2/H3
	CvYs1Cuw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wfh04-009XSc-13;
	Fri, 03 Jul 2026 16:44:24 +0000
Date: Fri, 3 Jul 2026 09:44:11 -0700
From: Breno Leitao <leitao@debian.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net, 
	skhan@linuxfoundation.org, maz@kernel.org, ardb@kernel.org, ilias.apalodimas@linaro.org, 
	oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, oleg@redhat.com, mark.rutland@arm.com, lpieralisi@kernel.org, 
	tglx@kernel.org, ada.coupriediaz@arm.com, anshuman.khandual@arm.com, 
	ebiggers@kernel.org, broonie@kernel.org, mrigendra.chaubey@gmail.com, 
	baohua@kernel.org, lucaswei@google.com, james.morse@arm.com, zengheng4@huawei.com, 
	thuth@redhat.com, yang@os.amperecomputing.com, leo.bras@arm.com, 
	Sascha.Bischoff@arm.com, james.clark@linaro.org, peterz@infradead.org, ben.horgan@arm.com, 
	punit.agrawal@oss.qualcomm.com, gshan@redhat.com, osama.abdelkader@gmail.com, 
	fengchengwen@huawei.com, ryan.roberts@arm.com, yangyicong@hisilicon.com, 
	kevin.brodsky@arm.com, kees@kernel.org, jeson.gao@unisoc.com, zhaoyang.huang@unisoc.com, 
	ryotkkr98@gmail.com, wsw9603@163.com, pasha.tatashin@soleen.com, 
	jeremy.linton@arm.com, schuster.simon@siemens-energy.com, osandov@fb.com, arnd@arndb.de, 
	zhangpengjie2@huawei.com, smostafa@google.com, vladimir.murzin@arm.com, tabba@google.com, 
	vdonnefort@google.com, kaleshsingh@google.com, jic23@kernel.org, timothy.hayes@arm.com, 
	alexandru.elisei@arm.com, zenghui.yu@linux.dev, david@kernel.org, 
	akpm@linux-foundation.org, ljs@kernel.org, memxor@gmail.com, qperret@google.com, 
	chaitanyas.prakash@arm.com, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 01/17] arm64: Move DAIF macros to ptrace.h and use them
 centrally
Message-ID: <akfl8VwB-RkHIFgm@gmail.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-2-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703100135.2512312-2-ruanjinjie@huawei.com>
X-Debian-User: leitao

On Fri, Jul 03, 2026 at 06:01:19PM +0800, Jinjie Ruan wrote:
> So move the definitions of DAIF_PROCCTX, DAIF_PROCCTX_NOIRQ, DAIF_ERRCTX,
> and DAIF_MASK from <asm/daifflags.h> to <asm/ptrace.h>. 

This seems a bit counter intuitive, to have DAIF definitions at
arm/ptrace.h instead of asm/daifflags.h, no?

> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 9393fe3ea6a1..cbe2a616c726 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -11,6 +11,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_ptrauth.h>
> +#include <asm/ptrace.h>

..

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 89cb553be1e5..26ea02e7f5fd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -15,6 +15,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/pgtable-hwdef.h>
> +#include <asm/ptrace.h>

And then you need to do this in many low level files, which sounds less
intuitive to have to have ptrace.h include instead of asm/daifflags.h
(which is clear why we need it).

--breno
