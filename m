Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EE73E5EEB
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 08:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534789; cv=none; b=FldkqGFN3mkQ5K7u18zujlEoEqQQpqWzY+lvDazneLbyECtI7IsXEzD+u874/fT2MJ4unwsIg7Ogi7A5BR9ivbfiPgU/bQP0o1s+kx0bHzZ2GWQfhsB5lgBLsplf+AWXLv6mbYsYsFo9tP/znggzCCRSrlY1GfB03+yeF1twX+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534789; c=relaxed/simple;
	bh=J4a7upmFwO+cU/sHwsmNf67cBdZkLVJd4Qid6QJFvAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Evt1ZCGUG0aVtByzMZJej/mzex31qQQtxGAJEqZjFr5tMnGm7Re2hzJp3+zrmegwGQrT9POrEtut0Jbztcwlop2OEBXH7eDnSsx36lCJsoq9Gxe1KaZevzEOsUTRxGe6lWnfZ9rjovQPfLjrwFgu/9uy+ER32MegmpwA1/RzFIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2d560775ca2so19788185ad.1
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 01:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791534788; x=1792139588;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5SJdflHLsTV8n6Eka/t1oY8KzfLbWWcjpATxg+lrvcw=;
        b=Pc/bwZOV7X8lrA0uIobCyIGHjMHpR3QgrCufc2VgqTVlt3QPcZTMDqNBfBm++/Qaq6
         KxnLWBnGa07v7rBLdL4kAOUTfuQWQoaYaqVbpHu7KeDXxn6C2s6mchHThsPLGeiS4F07
         Otr6TW6gVgP0PT3LyyIWzQGFdnglpkC/aeXoPJzQu/FG416VTNvul7DUxZSHfpRBNSRO
         OGS/pN3yr/bwqkRX2iRoP4nZEI85gvHQj0PrL/dYiWbVA07DLne8M1OH5JMEXViNeKHx
         oeD5IDru5m3o6eybsZf4Ao61Ea2P/0BU0OJVQ9duiqLfBMQl23p5BjqFLaJGpN/mNHGW
         Rnlw==
X-Forwarded-Encrypted: i=1; AKwUvBz4/VsFuJHliOclBe930FQKylEeJSG/ws51H6weexR9Rbi0JdbPgiHdDQG7a8gKyvbzpYO51/OTbdU=@vger.kernel.org
X-Gm-Message-State: AFq9FYL2TFOdaRmtWcaH0DJCczd4wUwrq/PI41GE3axGp4V8AbdtEMfL
	bg8HEfBeREKu1mE4evU5oOcoL/uwypirkGQ6pQZ2C9xOGv3UP+z+gUrzEEajUvfP04zXcjjZv4K
	rfVEgNSboBWSfhVuGpPsr6PGKNOtrVDUaPK+J
X-Gm-Gg: AYBFou0ySLFGzEdxUQXB0jnAYwyZIvq00jXgoQwGp2izCz85Frw4xgnJwroh+kqppHd
	l1dwlRxA2gIOz+Mg9tZa3MIHmaB0Vm3+nZxM6G4mt8E4J/uXxDZMBRIfzZoCLDqE1qDkZ57y4Rn
	WG6EfABHTx3mLLIlBvGyPiNRurgPze8sKrX1vDb7iJHsaE1yUQdHrIovLPVIkJcapPue34trUyt
	tx+XEdS2j0Uv2e5NrHf/p2E02h2rlnwSTn0HoDINHGeAI/Li9Zs0l1SSf0o8rYYq866mkWfQLoq
	nxDTk9IoTpEsCyspxLX2chN6Z3SQAumPoizRF85jNmoH57W/aggw3KRTmSI3Dc1pt7Br0tiSCsl
	a1Y93bMxwTjJ/Sfbo74s9utsdrCpFa5QErcQuZh5U
X-Received: by 2002:a17:903:32cd:b0:2e2:d7d6:6563 with SMTP id d9443c01a7336-2e842ce162fmr8538245ad.43.1791534787870;
        Fri, 09 Oct 2026 01:33:07 -0700 (PDT)
Received: from cavan.codon.org.uk (207-53-253-74.PUBLIC.monkeybrains.net. [207.53.253.74])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2e841f88d23sm606575ad.22.2026.10.09.01.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:33:07 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 2332C12862DD; Fri, 09 Oct 2026 01:33:07 -0700 (PDT)
Date: Fri, 9 Oct 2026 01:33:07 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <asimw1D5J0ZqM4i3@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <asfDZiuFKCuuRysC@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asfDZiuFKCuuRysC@kernel.org>

On Thu, Oct 08, 2026 at 07:23:02PM +0300, Jarkko Sakkinen wrote:

> > +static bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)
> 
> This function could have less generic name.
> 
> tpm2_dev_is_kernel_nv_change?
> 
> I'm not a huge fan of this name either but it does say quite clearly
> what the function does at least. Just a suggestion.

I left it that way on the assumption that it might get extended at some 
point - maybe that's not a big concern.
