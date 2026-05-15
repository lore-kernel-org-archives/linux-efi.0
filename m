Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118533F5BF7
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778886356; cv=none; b=u7NLvmkMjL54hm9w+F2sBCdCXiRK1uwSQR4Q0nhbLRIqWkyfPtHnMh2r7qSxoDciIt7d3V50Z18ng34yrxtXvkyL9zAroKcl05B4I0V+mUKlIjGOjh+Rw9ttq9zcFXZEMwDuk36TLNktOuZeRC72uYEB5qbdag0f/AGX0b6gYZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778886356; c=relaxed/simple;
	bh=Efl9eGRUvRUSMKgeJbT5viBCvrEY9UH6Bmru0k/SItc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqo0jC0Qw4nGsfa7zO+ia/Ylgcc+jxD5ZQpNmQin+5O+hqhu/ObieWZ4LURM4pDL+Ob+qNlPJGGQvY1NXykmxisBb/6ns0/bq8+aWTsnEXWY4vsetdawpXLVIQopS6HB87nMTL3mET8lnUrnbFdBuSEJPLEvezyP1t95zvJ8zf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VjGrlCzq; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VjGrlCzq"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8b9f2295a9dso4792166d6.3
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 16:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778886354; x=1779491154; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D7nklUCScqv2NitQOcHmOlp1LpHmTXVfX8MzcU0yUSA=;
        b=VjGrlCzqH+mUAoPngtAUQe7YHCLoMhJG1fiIHQCxDz32VqGSoi3tCJsSFgtxVM188x
         B1I46C1Bx8QQzngPeK7/vA6iCd3CpAt8owSY3Qk2nCELXf16tY5ju7NULVy1Bs7iU46b
         28cIKMzc8eLyongezBRMR3VmA7o08PT5Z7liMeIlm/EM5roeQ11TGTFe8o8pwEKpBde2
         Fsx6ppNY5QSyuK/iYmvX45MZQEdYg6mnwLgbubPjDSn55db4gxyjHGOWFH4aH1iAqKvc
         eCuseZOZeg7y7OGNf1zOhuZ+/BsETUblnI4pCL/GGB+CYb73uPazR/wccxYK74Yh0spW
         gQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778886354; x=1779491154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D7nklUCScqv2NitQOcHmOlp1LpHmTXVfX8MzcU0yUSA=;
        b=VyR8MsEpIcPLUM+PBPJGtHvWmYMJxNnQrkTLAJIiMYHAo4W7DxfY179Ghkg1+SFbtL
         NlQD8smTqFNokzjb6JkJi/hs7oXLTiOWhufY6Iq7Xwq7Zlw5yTbGR/d8pusTRopiuX7y
         Mu9iQdwye3ltoECyB+eglep8AkTKWIRP4R32Zu4OVPM9MneAJYfjFqU/qDZhBI3q4zrW
         CmURC6hhIJEwxR016KcesF7J9rrKENg3iMtatwkKarYs2VLj+Q2IPtxuDvwZkiFAuTZz
         Ml+H/rbAZSZvs2bC4+M/hKbWWaCR/y0SKNMjqX/Oaj4230+4txZZPZB/6Ty1heW+ATuv
         aDzg==
X-Forwarded-Encrypted: i=1; AFNElJ9Ld2+4Sac5w5aIFr29q+xxvVm7fTpyvQgOboBmuwK8ums/IvohJr/fyd5N6HNNKvg5CbHB1ECKNuM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcetlpU+Y+IedCtXD+tYa675aKO8PcODXQXiEl3QppxYssFKO3
	BVVFw6Xr1apCNWb2Xe4kn2WYBVwjFSHjG4L1KB2oGMrzpCVwS951QZ/7U5KjyKIrko0=
X-Gm-Gg: Acq92OEaH/ckyh/2nkWG4PIcru38p5Q5XXQE4+XtfhMiXK7LhgqyE5wexcnNxcUDuEh
	jna+r07Xq9acQDRTBVXzCd5J/0kXdAAGtbi8z5SCu7mI2bbOChkReQ/XYSFAu56tFuH33AEbKqH
	bdFMNBSdaYggBoIwBr5vOG6kjM+sAHFWpbqxaXqYOu9BNgHM9f4rRF1C2o5DFsgGOz8gA41k2l6
	DmdzS3m2LrrBq75UVxQdO6EygFz5bFKc1v01uaRmaGpltfbKJAk+O7T4bwKMfMicbd+LHZNpl4y
	TUCSPzx1LjK8gIUT7eSJwY8pt12hadJxSmYejyJPlZhbkgpNZg+KxxzaXpB7X2t7lWd2mXG69Jr
	6bF9G3zrIfBymmghsceaPpw1AOn2SiYW6bT/fbjfNEYMw9sk/cEb4NhWUwsOBKGyesfsFqxQzYi
	1QQfm5fmpKSpOy5duw8OOWUPgvHAloorQFE7ZVFFJcZjbINjEO0ZveeHo057tztLvY40jPxaJex
	SR76Q==
X-Received: by 2002:a05:6214:1c82:b0:8c2:b36d:4fc1 with SMTP id 6a1803df08f44-8ca0f66afc4mr87385476d6.14.1778886354080;
        Fri, 15 May 2026 16:05:54 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90c374469sm64030376d6.49.2026.05.15.16.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 16:05:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wO1bN-00000008GrB-0jOE;
	Fri, 15 May 2026 20:05:53 -0300
Date: Fri, 15 May 2026 20:05:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Ross Philipson <ross.philipson@gmail.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org, linux-efi@vger.kernel.org,
	iommu@lists.linux.dev, dpsmith@apertussolutions.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	dave.hansen@linux.intel.com, ardb@kernel.org, mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de,
	luto@amacapital.net, nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net,
	ebiederm@xmission.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com, andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v16 01/38] tpm: Initial step to reorganize TPM public
 headers
Message-ID: <20260515230553.GO7702@ziepe.ca>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
 <20260515211410.31440-2-ross.philipson@gmail.com>
 <agemXwxVb9jvAbYM@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agemXwxVb9jvAbYM@kernel.org>

On Sat, May 16, 2026 at 02:03:59AM +0300, Jarkko Sakkinen wrote:

> LGTM
> 
> I'll hold on from actual tags up until there is some consensus with the
> patch set.

This patch set is huge, and I know there is alot of interest now in
DRTM.

Can we please split out and progress the TPM reorg mini-series at the
front?

Jason
