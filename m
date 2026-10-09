Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406AA3DB64D
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 08:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534694; cv=none; b=XCslN5gnHcD8P7b5rWLQhaVeOJjfQcL43w4Wtt9e0LPmmINAjphLVYe216yQBAW1MZiP3MCPlRrPzQ9dXk3Aac7SuwanbN4UM2P58NYOkZTePhkjFYJcque1Mw5dltGXSTsSu1Ug+QZmQWyaU8HLk1tePpMUM0/idFeOofIalFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534694; c=relaxed/simple;
	bh=WATkgCQ/kmtG5HulqnoTUl0JCJKYR2K92PtDB5Opiv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3WU1HnJz/MBc/It1a2k2cFAiIf3mW20aLpMv/brF8p/gPc46uxNsbgZxFk1ZMO8kPS8Gx97/NzZ4RNo/fTecp1gVNgvZT2Lq+VpA2bmRRa0ATdPuY44ZYQQ4hW8sJuz85yi2bdlVVMhGu/GweK7hS+erjc7FeSr6oD3NLScjTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-92f0b5ed131so463550685a.3
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 01:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791534692; x=1792139492;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+Ti0O2O4lnX/hVbcn12QwKSuhI8bbGy+WYpeuSvKe4=;
        b=R1GLqjVfKBfSXnQgDTo3ZKqRWlM0T7JNmhiE5TU3Kac96RCPqbo9EPzm/+elCFlG9q
         soTe3aY87NVtbHy0RtN8kQUdMcfqC++eZ4Pvt2PWp1s6JpA+tYJL1OpIhwUlJ3lSW4al
         MXlthXaSIHM4OrBJl4zV3zxDDx7pYgZgMiYDHTp6bpmTAcaHdzZ27Zlo6LfMjf7XKCfe
         Pes9EMbgTBKFT++JhhCxm2vlwkfr3l15b42wIjnvfh6QzNuvJEFK4OclZ3X7s2E2ZAEC
         dQvVa1s8HX7DXsoQJdB+F34QRngMxQuha68kwvmp1cGLwL0dBUU8pkf/sIq3+sWa3dw/
         gCrw==
X-Forwarded-Encrypted: i=1; AKwUvBx+16n3KZm5rEHHc+sHCd85Bo3Jgebi8dSITtilRRz4XasxjYHk93kpUsV2BTmouxj4sSblaYuq0IA=@vger.kernel.org
X-Gm-Message-State: AFuF++lbZe2J2KQd2TF+xKNEzyLcMXIVNF7kfjgNjpgv0Q80OhUrDExi
	PAgk9bwmsHSRpgT2UlniabOErQIQdSlCu5NE4P7AoJvJyKq+b9q3FQWv11TFuKT7O4VWZ7AKjwN
	wlTlgeiztyw4wOr3XGjn4fbIL/0ChukN8ofpFfj8xOXaiDcloMuVi
X-Gm-Gg: AYBFou0ptRFmnuOiP3aq32sI0yR8bfH3oVyv6d6Lhiu+2JUwLtvEBjxHzWNHf4uCZ4t
	z3CYo1UBRZJzUxHozAJ+xsTWOj/8ChTuHLldGJA8fFZJk2BhkLMdRohDmlW0PbEqDutbGxkIKok
	+q2eiTZZZt5b3KNhe8cNPosuoVX9ZUfzIVN1xa++xBwBaELXNN+vxb5hp849FvtEKchAACbAymu
	8co2LTdGPlCBJeYgm73jxR4o0Ho6YjtmoAD+ez5wbWmlhKTtkCyIrAwUI1w1cuTrHfA8tEy3oWt
	M+gIqJy7q8vimcS46M2TmWy/09kJlOIi1IHpkBoNIYuu3c+Sz0rV3ftSIUlOXJ8lAKPzk8DJauM
	RGIQ=
X-Received: by 2002:a05:620a:4013:b0:937:27fb:96f8 with SMTP id af79cd13be357-93ebd25c85bmr177526785a.41.1791534692184;
        Fri, 09 Oct 2026 01:31:32 -0700 (PDT)
Received: from cavan.codon.org.uk ([2607:f598:b99a:160:8a88:88ff:fe88:8788])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93eb986adf7sm29407285a.9.2026.10.09.01.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:31:32 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id D784A12862D5; Fri, 09 Oct 2026 01:31:30 -0700 (PDT)
Date: Fri, 9 Oct 2026 01:31:30 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 11/17] tpm: Add kernel signing key creation with audited
 provenance
Message-ID: <asimYsZxxGvPAFiZ@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-12-matthewg@nvidia.com>
 <bd131221bca29b5f8ba348adadf1e3930a5b57fe.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd131221bca29b5f8ba348adadf1e3930a5b57fe.camel@HansenPartnership.com>

On Thu, Oct 08, 2026 at 07:00:28PM +0200, James Bottomley wrote:
> On Thu, 2026-10-08 at 06:20 -0700, Matthew Garrett wrote:
> > Add tpm2_kernel_key_create(), which creates an ECDSA P-256 signing
> > key for the kernel along with evidence that the kernel, rather than
> > userspace, created it. The key is created with TPM2_CreateLoaded
>  
> I don't think you want to do this.  TPM2_CreateLoaded was added in spec
> version 1.38.  A lot of current TPMs on the market today have spec
> versions lower than this and would reject the command (The spec version
> of the Nuvoton in my Dell XPS-13 is 1.16). Since it's really just a
> shorthand for TPM2_Create followed by TPM2_Load, you can simply do that
> instead, which would save us from a load of complaints about this not
> working.

This is what I get for working to the spec instead of reality. Thanks, 
I'll split that up.
