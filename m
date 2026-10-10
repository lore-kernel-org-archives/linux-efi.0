Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE47342C9E
	for <linux-efi@vger.kernel.org>; Sat, 10 Oct 2026 21:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791667230; cv=none; b=rVTfZEEcaMLLHWoR4+lWtWdKF2Ok1B/NYgBk9xhjYxZPTzE02naGOclM22WHW8go+BstHVIQJ3/Rd6SYyPJslXi7YhnnwIH+eD2kYQ2lWQi84a30ozjbA1sbIF8pOoaX01pi6URxnCH1rzNNfOgCcoFvYlxC8/9ZZP1ubldaUCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791667230; c=relaxed/simple;
	bh=l2Rg6OHGxNhrquADY2PNe8wejzKKsSn3puAVABR9uw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fshiUCzqrDpJ8L0tuzIlsKMr9cWMTykWb7kRgm2arj21pG3WdwNHLh7Rx/RFPeC61wsKnGEpO4Tn072vXAq6sqhYwyAAG2++JZDtKmpc7m9MecqIGEldyMyCUwWSWPA8uUTnorHK6eP1/ZIwRs353QHC3JqjZVZSzwAgzenzS+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-398b3c37877so333671a91.0
        for <linux-efi@vger.kernel.org>; Sat, 10 Oct 2026 14:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791667229; x=1792272029;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FpfqyCSTiDIx8bI640+p9clkC+s+ooT/bqQ5SHe1jVs=;
        b=GP4tHDGSPdOk+bKgWGzEjWQolLTH5yvHtPvsFw4cMjk6RAdIxsf7xX3+PBwe7RdWnP
         WFTib2W+ojTfLpg6I1rWjh5GFcZGLm2/VaP6jO8m7jbvtiBcFtvIZrte4SXvK04fgEjb
         CAohGN2Ey0am0ygaFvaqfJM2B+BJbWuHfUiDREYxDQc5/PjE64hSW+eIoH8YBJ2PRzx1
         EgXWi2dDVqM6WQl1Cgm2PkjBez2lUHNIImULAkJrhDwDXuXw1FOAEWbaJ9VGaMuGlYqY
         Jb+zeMuDjU9dbQvHT5LVRXkXrr4CGTDIAGnSDCNngqK5mGYS0yyPDKDcADNkB9CBesmp
         tbeg==
X-Forwarded-Encrypted: i=1; AKwUvByUm5RFSYmLhv/7DWOL7W21tq78tAyTXgB07OGnoVLTAqJN2dsx5UOHMQQKkhQs2YZWSbAqAAuyllo=@vger.kernel.org
X-Gm-Message-State: AFq9FYJLteevErbG1XxpAEa1GkQc1F71mpFtVDJSLXjGU7I6d//NH8mW
	JCh6UKluso442WXSAT07/qFtjNdhdp0loKdP+Iv6bM7nqL+YVhqCFm+LsTtoxCEeeG01Xjba4KJ
	6r0UA/0H6lT6LZZDd4SSORAKVQkvGLP3U5uEnslmY+fXB5wGrlqBs
X-Gm-Gg: AYBFou1Vtar/vLg6HeNe9ZG1wQiWYjnmJcApKsTluCSvUILEWPokyKc6v1lPum+AAbK
	q9FvZXEgKfqqWF323Uu2nuj08/D4poHUWkeFCbAZi+yEvcYJijBAgTAg1A8j4Yf120XNbNbOMng
	B9qmjS/66vJg/vwnmLdO3hhcDQBTzzVTTYzsWoT+4KTcxtt5YFaUOjmSS1DYaSk7O3KEiWw6F6s
	XJkWTkmKzJ9YZbWMb/tG/UvA7SJRjSIseWwtZRRxTwO2YxEx2jmsPxBC/a5XeIU4sL9Q872tK2O
	3lzcfGtXaqlERfw8bLtqVm4/g7nLDNV9xjn3nXQLLv8TaJogLDYJTRo0sWfkC5j4wrbLkeotSxJ
	p+GA=
X-Received: by 2002:a17:90b:3d89:b0:3ab:c6d:2bf9 with SMTP id 98e67ed59e1d1-3ab3afdaaacmr5631535a91.57.1791667228755;
        Sat, 10 Oct 2026 14:20:28 -0700 (PDT)
Received: from cavan.codon.org.uk ([2607:f598:b99a:160:8a88:88ff:fe88:8788])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ab3780a473sm3281598a91.4.2026.10.10.14.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 14:20:28 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 0568D1287ADC; Sat, 10 Oct 2026 14:20:28 -0700 (PDT)
Date: Sat, 10 Oct 2026 14:20:28 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 13/17] tpm: Add verification of kernel signing key
 provenance
Message-ID: <asqsHMX1YUUDdy75@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-14-matthewg@nvidia.com>
 <aeedde06c51910afe5231d9f359bb8767c01b5bd.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeedde06c51910afe5231d9f359bb8767c01b5bd.camel@HansenPartnership.com>

On Sat, Oct 10, 2026 at 11:42:58AM +0200, James Bottomley wrote:

> This does strike me as very elaborate, especially the ephemeral key
> bit; would you countenance a simplification?  Since all you want is
> proof that the hibernate image hash matches the one the creating kernel
> made, you could simply create your kernel only NV index as a PCR and
> measure the hash directly to that.  Since user space is barred from
> writing, all you need is an audit of the measurement going into the NV
> register (indeed, it could be an ordinary NV index you simply write the
> hash value to), coupled with a read of PCR 5.  Then your audit log
> directly verifies the hibernate image hash and you don't have to bother
> with the ephemeral keys.

Just to be clear, "ephemeral keys" here refers to the ephemeral signing 
keys and not the generated AK, right? I /think/ that would work, but let 
me ponder that some more.
