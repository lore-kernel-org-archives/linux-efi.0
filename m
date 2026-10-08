Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7BB49E15F
	for <linux-efi@vger.kernel.org>; Thu,  8 Oct 2026 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466886; cv=none; b=Ur/URkJ92weA2qF48mC2BWzzrg5DTB/1u5YXBlipxofA1FahoOCqtsgFRkmmsR2JpdKW8Ft2JD1YFizbalMgfUOpT+vbNj+PiZDE4rHfo18nz4A32ZzLPlvWxVN/uUa48WwN3WyceOgT34gBg35bWixtRmmrgqCuQRtVsGf0A7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466886; c=relaxed/simple;
	bh=XezWRLY9lxI5ComY59DgZ5KT78+aaYpBiaD6Ktv8gIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VsUYvJDqDw05fbUChPAL2ePg8uNkW63GrYOyTM3NM56YjDpJpvhZ0dpijVJ3WK80fgdmdKBL0tFD1mc8Vj+mYHtCjVt+BW2/NX9IZY+M4jbIhKijxpO6ceLHSVhQqIOGDTJAtIUDXW2OZoQztTJQVxudAO8Y43ih/2ziZtd/lJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2e8246b13cbso2536035ad.2
        for <linux-efi@vger.kernel.org>; Thu, 08 Oct 2026 06:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791466884; x=1792071684;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1j9k5OlTGty7BZhrOeehSiHjb4OZRtbs/bCekRUx6wI=;
        b=SdkI57dVVYkMjjtJCAkKAK1I9GIpOd6KyOCTQP+S7zWtrTf0NrpcHYzXNAb8SMjYPa
         RhWWovb4WF/A6gibU3eVomR3GyBcK4eIfrfGlMkwVaQHsoRVsYCDvKnAxJ2hC8+2O2lw
         C+RKg78tH+of+LRpfiVxV4lbCA8OKENKGAj6sh37lqiMpBM+MSyu7DYR3TTzcWZNHdXG
         XE58+BgeYvh59DNKRak2EFlsh6oByH7mf+ec3B1fsW5XEBkVTY+vb9oJYLr9FXv37Zwq
         RFmw+pog0emIB1MshqmaG3DWb/U8rE8duJJqVvYMoJ6zraQZGoz0Ph2dVgmIjT6O/R53
         W88g==
X-Forwarded-Encrypted: i=1; AKwUvBzYDkJMJ3neutYbLej5cOelwYxncA1K7rwlNU/BPiRcaSyE4FUa+uvtVzm9llY1fUztxOvhzrWM/4k=@vger.kernel.org
X-Gm-Message-State: AFq9FYKgqcJb/hvuiVj/pTVZ6u/qFTexfXAIa68rvPm0/MYxwnXHfniE
	6V8qIYWVJavX6tBXGXUglO3JPYJYwMbZSSZLsVGUSy/Rr9AVYJ3K9YHyr+2++dRHTeYRIShghbi
	n78BKmzg3Df/ZybHOwql2pIkvWNrYnJ4P3VI87q79WdlkxCCzg+OX
X-Gm-Gg: AYBFou2iEQSk+WcRmz2cwM+l8MRBGlWIjshpGQj2cRSesOmIEF9YYuPmcqjALPbxUY4
	Fr33FdlB3jyxHLoBQoUxLYy43RPDpsPieg8tSxXLd9yIoIAmZ22nKBAExnhIZZaZ/R5p+xcVW+P
	Fn2Y/7zHLWbH6nPPrtx1UKo5EgNN6sH0vQLbflXzTMO1zU6Alo6wn8Vcys0P1nZRBsCWSRXuReF
	17Oga6zhZby6a51c/sQG+Uc9cziCJlHDRvhIMaG3bPEoAN7O1YfPs0zNINjhz/XxOt5/nglhW4b
	RoNqXfdlEwMdS/voDuJdEyAAZLHPP1rZPDIkBz/GfG7xJesqMBgkNO4oGegJ5hvibqZY9tMb0vD
	h5Ms=
X-Received: by 2002:a17:902:ce07:b0:2df:7fe1:72b8 with SMTP id d9443c01a7336-2e60038d0e2mr50963895ad.16.1791466884035;
        Thu, 08 Oct 2026 06:41:24 -0700 (PDT)
Received: from cavan.codon.org.uk ([2607:f598:b99a:160:8a88:88ff:fe88:8788])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2e6048443f6sm2131865ad.51.2026.10.08.06.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:41:24 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 37B8D1285603; Thu, 08 Oct 2026 06:41:23 -0700 (PDT)
Date: Thu, 8 Oct 2026 06:41:23 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: keyrings@vger.kernel.org, James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <asedg6XdGkOaQJ_E@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008132532.1155166-2-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:17AM -0700, Matthew Garrett wrote:

> Reserve NV index 0x014c4853 for use by the kernel, and filter commands

I should emphasise that this value is very much a placeholder - please 
don't deploy this patchset anywhere until we've decided whether this is 
something that should live inside the Linux UAPI group range or whether 
the kernel should own an independent range.
