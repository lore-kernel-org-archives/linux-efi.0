Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F84C3EF0D3
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 10:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372836; cv=none; b=oZ+2+9+QVoOBeFHNI33LozZKL/Uj+eyZZNYZBWDPtOdlo1LiNR8ufwoDGkVgzLb3Z8rWRiKwAG0qKQn5EBA+dVHk0DDKJhys6JlkUgd6lukc29EbUCdM1xBEFMRX4cE87KFiOI8PSRh+5VYiVvY3903lWiq6CL14eb/rD6l7IAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372836; c=relaxed/simple;
	bh=UO0a8JKTeHwQCdxbQyMIyH2zwfTJ55ib5bD/sKMqEKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxqL1dvwIILQ4cjxczPDMUv24S+l2HCOLoNoP8kv2ImGV71Fc7Ypn+PU2fE1/7sbTn1K6ppDHNMAaxNS2qppQMn2NCqUE2pP456m5NrkSIoP5u3o5HUjf+HHrnd95YgA0SWa5AJiolvkQM37cYqr3kHBaR7WMlfZcifzWRoTQMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=rPbhMkgH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="rPbhMkgH"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so81089355e9.3
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 03:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777372833; x=1777977633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGAYMJ2fJTRhYeJUAXibOh2+rTPm3qRdaX73BY9yEY8=;
        b=rPbhMkgHYnz9anFbOIHp4QBSFySsRUgzzZ02g3FE1ZieSCIl5QNXRUJaUN0J8oiEIL
         wSRZSO9sifqmRzjJlZQEQ+bKw/Jt9VU7K6ISfr6i7gcNa75WHkseN3Oy5BkSyr8ovYQA
         OvszF0ksrOQj4ox7BlVoKbj89Yj/fE6fnbOs+d6HrImcgR9kMkHlCfim1CXAlaszHYJT
         +oXDaz0FO7MRPJZ9PPVmttPDB8dIhPWxEqLbOQ4xav0xVVaWXoiz5PR62ROduvOYqs0O
         m4dLs8i2mK3yRjhg2sWixZz3kjxoTMaS6OFFAmoGvDVopZ5X0rVya9w2IplxEOJjNbQL
         3Ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372833; x=1777977633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGAYMJ2fJTRhYeJUAXibOh2+rTPm3qRdaX73BY9yEY8=;
        b=lROlov1Zo9WWxLr+eQciY/MO12PirwVFl4FfFcVHwcsXSPyemmJoG1qjLr6rfdr4O7
         u3FuNyhhxQLyIrHTZqV7LNxSM8kx+RTeHjgJv9rqupRf4xgaa0e0ABCfF9QHOU1CSW9p
         FxenjLfXQJdaEOVFlGRGdurRTR3Aeq2aXzE9Mj75069eY5/I/oSMKThRe6TGV9e65Z2K
         eI7uCQop3a/wSp383puLtHQ/T84KPfsbqWDCHL1TcBcTWp1IzZOjgvvAoCdg2SMFBqZ6
         A0QxDIZ1XwKYFZvThBtDitFOXycchDK7MS+mi6zRoKVcGqkkqNfvYrUbFiT2Z3OEZWG5
         duxw==
X-Forwarded-Encrypted: i=1; AFNElJ/dC8ad7TClOMfmfhdlcPBITBJnQN5VIm/8PbwZTuSZa9naZDpEa915Hb4E/vfMx7TI765VqUZudjk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5cJl/eraEZxAGg9XX2q5Zry7iyM8+h/zV0P6mYfYsVDjQnWCi
	nPG3cZsB7RiC+7LdoONaGrVMW6o1mfByKAG7ompS2CFwLkTaqN99XVYZIy/iH8qRXJc=
X-Gm-Gg: AeBDietChGh+jIQu8dD1jyirZARNCwURk1icTTWX1WE8TRTdk/2K//DvGi30ozJQaav
	a9znaf0UbQi3aSGg0HQkTHv5rZjf6v8Ai1pSGNo1krQK+LfhNKA76yBqc8ah5VlnS8mpSR/tR7C
	4uqQjJXGhS7vj02z6WWfq2NCxHetOF+CrfORv7KM+Y1y11WAFhd7d0AIVrx4JaWpiGKfC5JjnkV
	4ORlL/Q66+umIuR6vwkEvyhaIYSg1oFhRYFIpv7pE4yYMlW8ZjqqW5LHW582+QSYWIOiuoWaStC
	0tJdoQ6hrBWr8xGe+gX4XHCx2uYlbvWOLeTY1g4VqHI59Tu3BCg6INuCR2d3oyxrSIyb0o9DY0J
	BMGZ5TQiA5mVVGtUCb5MbRdQpTVaZq/XVDLLVkTonLDR3ZYbsKhygYa6INrZrsS4P2XKiegaPrS
	Cjki4S6rNxE4O5N1b4ooR22d6vwWqunn6RVpkyEAbwzdAbxQ==
X-Received: by 2002:a05:600c:3b13:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-48a77add9cemr37343825e9.1.1777372832774;
        Tue, 28 Apr 2026 03:40:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([185.194.184.52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7748f2d6sm23415245e9.1.2026.04.28.03.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 03:40:32 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:40:29 +0100
From: Gregory Price <gourry@gourry.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>
Subject: Re: [PATCH v3 01/17] x86/efi: Omit redundant kernel image overlap
 check
Message-ID: <afCOndWS-o-TqDON@gourry-fedora-PF4VCD3F>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-20-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-20-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:26PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The physical region covering the kernel's executable image is
> memblock_reserve()'d in early_mem_reserve(), and so it is guaranteed not
> to intersect with the regions passed to can_free_region(). So remove the
> pointless overlap check.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  arch/x86/platform/efi/quirks.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index df24ffc6105d..4d8de7c6ce59 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -305,16 +305,11 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>   * can free regions in efi_free_boot_services().
>   *
>   * Use this function to ensure we do not free regions owned by somebody
> - * else. We must only reserve (and then free) regions:
> - *
> - * - Not within any part of the kernel
> - * - Not the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
> + * else. We must only reserve (and then free) regions that do not intersect
> + * with the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
>   */
>  static __init bool can_free_region(u64 start, u64 size)
>  {
> -	if (start + size > __pa_symbol(_text) && start <= __pa_symbol(_end))
> -		return false;
> -
>  	if (!e820__mapped_all(start, start+size, E820_TYPE_RAM))
>  		return false;
>  
> @@ -343,10 +338,8 @@ void __init efi_reserve_boot_services(void)
>  		 * Because the following memblock_reserve() is paired
>  		 * with free_reserved_area() for this region in
>  		 * efi_free_boot_services(), we must be extremely
> -		 * careful not to reserve, and subsequently free,
> -		 * critical regions of memory (like the kernel image) or
> -		 * those regions that somebody else has already
> -		 * reserved.
> +		 * careful not to reserve, and subsequently free, critical
> +		 * regions of memory that somebody else has already reserved.
>  		 *
>  		 * A good example of a critical region that must not be
>  		 * freed is page zero (first 4Kb of memory), which may
> -- 
> 2.54.0.rc2.544.gc7ae2d5bb8-goog
> 
