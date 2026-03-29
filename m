Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9AD38229B
	for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774806794; cv=none; b=BocsxjK8GhFpwXp9uZBduBM+yphrx/E/SIS15gpHgBpP4G6e9b5XE/1WP1Qlc5K6RkRTqvH9QSwBu7yBjIvZ2pYujr/8bRA5TXma9CU3XqRqhDUouJ314x9kyTz0KiGCNFV+Ctacjhuguyg+drA4JLtKkHdNv2sp3dvSzFpM1u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774806794; c=relaxed/simple;
	bh=h5JxgwKAs02DbPGEChovlNoCuMErME9nRRA7+eOfVKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/XnUxL49S6GJJ4kpsAaoLltiydc3TngUTlahEtfVvyqa6p2R4k+JkNUfa5U5aLFCzae+X+HDetIBldSL817xsTnIoxmx8H3mllKo48ZsSfTJpAvfzALxQIPjfirKcZMrYMbMCqlhGoKg9u0wfdLpaJgsE9lHN2XO9RjzO1s6hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=thRYVMTV; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="thRYVMTV"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cbb6d5f780so437232585a.1
        for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 10:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774806792; x=1775411592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4a0SC/0eHAsPLkQ7t0zRuSMGofgxMILY/shcs2+r7HY=;
        b=thRYVMTVDNrWz0WFqKGDAnn0cmgpSD2BOD+2ujcTLemTfENuAUOezKN5MGWZJ9ExBK
         HMA2NArFM4rEyF3VMLEhz+7uG20Rdaf6/Fr5t8stgbDgUnh+RRA3mZnMYJWFwjGowNva
         wsCM9I5ex3eJBdmwTzftdaNL8oZQOt8REkslafd/VtSO8nU0SCYeQneT7oP48s/uN4hr
         g1M+dSr2XPrESwntfEySv3sNWwgCRFV8QcmdiQ4Ik4HzadQTUte23twvafb4yfyHIuwX
         hzGkuDEZaff+CjRr9bFKU6Hg340uDQSgS78foI60l6Fy5CnCWdEDvgOQqhEq7mQMRyje
         FgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774806792; x=1775411592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4a0SC/0eHAsPLkQ7t0zRuSMGofgxMILY/shcs2+r7HY=;
        b=NIPcumZmO6j008WHs3Pm77CTDAbS2VdwfAmQ9XNadgGoSRAkKTRh59rcccjqPfNMxf
         O3TMlmgc7gGalz9uG7KgwTxxHisq/aHAZdmqwtdpjvAisZ0SbqQHAeFSrY7RyEphFEjh
         ZEeqXhx9MxfGgCUiMygJBZS7PWgn1ThVoYyx3dcDXVEOTePv7utnpvrItwcdgEeMJ6Ug
         d3nYgVmVv0rIRVkRTJuBnSglPH2dZeLbDBU4YVe+I8NAiQjxI5mOc5b3+a9/My5kkNWC
         1+rg8vWh5iybeFeO3GW/fKf0RxcLVZRkHVSN5uzAHGpfU4JRUVZZVgzjovtzZsbKNfzw
         Vuwg==
X-Gm-Message-State: AOJu0YxQVlD7TtA3j4Wjo7IO6e9jWalZqsIQgY/OmSOLzjocuOc7LJGo
	HaMhK7wjeot2lLR4jhFp5SuqDRKQsi2whHIiC35OPgwXzqYZbdjN7VCjEeU9QrjXc8w=
X-Gm-Gg: ATEYQzxfQxCi9tzsvzxqYyEFBjOrBrVMZGONvG7YabcgyA5BUB54tsgjDbdsIIQsTRG
	WdyaT6xO1ee+3yoU46B+2Q/+KLwo/xSKh04QpQl/B6XO5xnoPDPp73A9iB4RLvB/E1os+9fC/Yc
	viXx6yb89pAKePpQexy/FCUHMa/FrDL7oa//qWR1Y8E9+y3xjqk2qlqbKO26zK/vL5c+dYhyyg5
	PdgxPG55F9aqiCejxNgvGKS4YtXt5kgMIj8quT4xRaEKgAdTqjr8Ev8/lE/gXTZ+fyPhE7ij2kC
	ADY9dfApGUiQojjJdyoCvAUti/n3i2GGZQJPCsyA3XokZg03fQM0Zf3qB5ILI477TtbTDSN0qtq
	VD2SKRtPvhd7C7UXVtbJW3lsNYR+nFkJ4UUIJnSFvh9QCEeG/1+sFjMcrwC5r7yiWWh3EOs3BKn
	H9spC3cxCVtSZouR6ehDe3b+bKT43aPZuGLw9qFV8j7b7KIR6TwvmnUe/4DtW5b1sXJ358FKDSH
	P0hClM=
X-Received: by 2002:a05:620a:2908:b0:8cd:8938:f01d with SMTP id af79cd13be357-8d01c616b27mr1326878085a.3.1774806792274;
        Sun, 29 Mar 2026 10:53:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-68-72.washdc.fios.verizon.net. [173.79.68.72])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02808677dsm422382685a.42.2026.03.29.10.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 10:53:11 -0700 (PDT)
Date: Sun, 29 Mar 2026 13:53:10 -0400
From: Gregory Price <gourry@gourry.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH 2/5] x86/efi: Gather initial memory reservation and table
 handling logic
Message-ID: <aclnBoGgJQt08Mgv@gourry-fedora-PF4VCD3F>
References: <20260326132655.1733873-7-ardb+git@google.com>
 <20260326132655.1733873-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326132655.1733873-9-ardb+git@google.com>

On Thu, Mar 26, 2026 at 02:26:58PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Move the back-to-back calls to various EFI routines related to
> processing of firmware tables and reserving the associated memory into a
> helper function. This is tidier, and will avoid the need to add yet
> another function call there in a subsequent patch.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

