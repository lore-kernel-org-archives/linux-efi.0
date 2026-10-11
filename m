Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04844349BC
	for <linux-efi@vger.kernel.org>; Sun, 11 Oct 2026 10:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791714215; cv=none; b=Ku4kpYFWpNetmub5f8M8muMLKGWuA8lSg+sa/M68R1duaxr3+25Sj9pUDR7fuJGOXei/c7ZxpBwhCo83haRT2sI9uTvEau/InFNoz60UyaXa0p4KOEIHSECsqM4v2JBOSPWhhzxaYmp6a4+GHMwjaWIzshi/rnNHW5FoFU8P8Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791714215; c=relaxed/simple;
	bh=vpW8/KkGJ7bWQM1agx07Nvt0sF65rPu6xz06pQZazSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjMLrZi35Cvu+Uu+o96NtY90XEMx70lZhsYvkADwME09G9KGFvmHwpPzBXk25qWSK+2gznE79gTUTUK7AuPS0keQz+ZfDq+x7G5Ubp3Wm6jr0HuieRBFZCT9lK3H38CpPQcyCucH4VK7nHgZ618b0nZkR7E+AMbOYSneVjZV7TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3a4c47bb6e3so439061a91.1
        for <linux-efi@vger.kernel.org>; Sun, 11 Oct 2026 03:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791714213; x=1792319013;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GCrU7gKGl9q2lr9szhaNlgI07chMKDnbiy6n8axucp8=;
        b=qI3D8WqVNDiAI0NzGZNrhv7A+LVCT4MVrhTwDykERBg4yuM4LNHjpZaLysU9uxyIjc
         KSTFLL3HNLev+ORf+P+GGBAJq7z2me0lfqfADFu5oOeeAMn12GGZpFOOiT+cWIa6Dzj3
         +DXeZ/2Q2VzKxmgm/C0/3eLZ2mUW9oj64hJOw4DXzTqrRDXrOdaY318nCyeXfLgVV8cI
         Tx1kKO17AYQjpoiZQC9hk3j01bgi1G4iLT/LBev/aFQtjT2jb8WS8KYV7jwKPsi72HMX
         KR2wK/xDJhWhYvSUO9wvZ+POnz7k9BQgJe8Y25FikFvQ/6wN7t6QDFFylyZLzS9Us9EA
         AZ/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxvJY/RiTdEIrEs9AzVZuthi33Zufu2EwECG40VwmHRNIA2ulwPAn/Emd4hwoonhfSBzFE+gZJTrqA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLjJzuvOBmYkQkNMjhxBm2SDGy/tChs9uKEjjt00lFpnbci0jsV
	DONLMw5dpZNT8mZPlJ8rgJhd6lS6UwgIq11Ef/kW9UlFd4tNr1Mn+ZjDY7nrJEdlnU1CndkRZQo
	tQNJBD4i8r9d8RmPQ7HsWi+sg6vZNyewmeKgGhn3MGwD3K1Ly1Ev0
X-Gm-Gg: AYBFou1la8jsPa/O4uBgDP9N14D8mpVyfAV7U4v8gXZY/V1Z7muqmciD0nRVeyZuRQc
	Ih7i99qo7qqFan8WNn+/m2y2Tvt9AKvx/Bvw/SkLB5kg87A5/6VMvUcZgP1hs8HYsvbGpJHldQ0
	mO+1vU9MQn+hvc9YS/JXG2S5xphUNnDgIAShgJgGl8AzKzPmf1AZnQxbkRQjvkgyokXM+UFdjMO
	p6KNG5wkXd0j9sFOl4l5PYw7BVZEDkkOWZXCF8o8Qy+3LpzWt1dFoJQOu3M0st3amV+XZimEhR/
	863DTSx8FrePOA9/bZtHkv0EJpIAVh7l/4Np6EPA/ZZNWzercDuoLVKHdJPcnnvJd7ClCPgjhcs
	FyZU=
X-Received: by 2002:a17:90b:2d86:b0:3ab:3437:554f with SMTP id 98e67ed59e1d1-3ab3a746d73mr5664315a91.29.1791714213229;
        Sun, 11 Oct 2026 03:23:33 -0700 (PDT)
Received: from cavan.codon.org.uk ([2607:f598:b99a:160:8a88:88ff:fe88:8788])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ab36d3f9c8sm4193873a91.0.2026.10.11.03.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 03:23:33 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 6F3CB18A4492; Sun, 11 Oct 2026 03:23:32 -0700 (PDT)
Date: Sun, 11 Oct 2026 03:23:32 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <astjpI65VOyU8xvI@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
 <asqthz69ohnMVCye@srcf.ucam.org>
 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>

On Sun, Oct 11, 2026 at 08:04:27AM +0200, James Bottomley wrote:
> On Sat, 2026-10-10 at 14:26 -0700, Matthew Garrett wrote:
> > Does your log replay correctly for PCR 5? It's *extremely* common for
> > the extension to happen without logging, since logging needs to be
> > done  into the late events table and almost nobody got that right
> > until a few years ago (hence 
> > https://github.com/google/go-attestation/blob/master/attest/eventlog_workarounds.go#L70
> > )
> 
> It seems to.  This is what tpm2-eventlog returns (edited only to show
> PCR 5):

Hmm. Well, that's irritating. Which year's XPS is this?
