Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F704B640
	for <linux-efi@vger.kernel.org>; Sat, 10 Oct 2026 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791667124; cv=none; b=HG+bBpyz5t19OHb5eSu1D5iEsi6LY2Ho8x7yxeGN3ftaCq1JCI9kt7bsoEBHWxX4x98ll42YYCLmDDLjaFeY6YpZSlmHrcT+wLQDOeWUS7npC9zgwGtBanzrgwWj0R5TNhyv9aKNSStYdW3x2WcNdVDKRCA+5Tq1LEHOC3UeAYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791667124; c=relaxed/simple;
	bh=tcL6A5SoUYWty+VXbzXNe06G0pu698TmKup8qJ97Wco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vky+b96gkMHcmdOZHT0ZM0RHiTZEzqDNSEyNLdb+jFQgObV+aVXzoWQhqJHjnIvZkwHhcOWQ3+o5iq1gQPGSJq6G9OG1uz7OVMMKayTEgyIfs7RsLzF4EEysCzoxO0OCsWDOWHgf7EfXPmlnpiUiD6NyY97VOisoSwo1I+QpNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.222.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-93e56c287b3so67274885a.0
        for <linux-efi@vger.kernel.org>; Sat, 10 Oct 2026 14:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791667121; x=1792271921;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WXTNApq6aSI569pIUAzzE6jSpAQWrYRivHcZV0gC9AQ=;
        b=kS2zk9/MJFyaB+0G7Kzj8eBPGewgUBOr/eeCN+WC7co90cfqppBTka5XsqqDz23IAC
         f1v3J5Nj6yELQwbkyglbxNXu0kr+UxxGarlEbthTz8DHuXgpj0QhRr72VYqjao5DebuF
         StIgSMza85zylmV9nHzaIQPLFGleIv0NrcrQ460KiXa8RNQEkUgNuS417K++/ZbFFQpM
         Fbl81M1O0rVuMBteuzAIbZ7elW2tW+bvakG6uI9bVanSnOgIPPEAlC2sKXiJtOb0EyaO
         rYvvdlGKNVMSB42gXqZQYA3UEtgkhb1Y5oVmnSAUIrBfVZH0j+WYf2ACA5jS9KS9D3KA
         i38A==
X-Forwarded-Encrypted: i=1; AKwUvBwgbgAs5vOGUbofkv3YUw1ii0cxGepR5l4YpJa1oP8dA34Lipvf0Sn4JuGrWp+zAkt+hnOJKYIKEks=@vger.kernel.org
X-Gm-Message-State: AFq9FYL1zJ0aFhigbm4O7+9gqPrReq91mje10wYgs199vDQdcvz9qzPW
	SG94PuLEG3sGO4dzUCd7h0f/iSHdmrIFGVzRb8x8tL0fuJbbh0Co15h3Kl51GPviiLamUM8Fr4u
	x5mT6LmeQG4khZX+we8R34Ebp53mnUCxmME0p
X-Gm-Gg: AYBFou3xPZg1yjefRtrID9PlyIwTIhPheJztXKBmjZmyAn94KuHjFUO0s3CRzjF2MNV
	5m94c1ANq4O3H9KGKbg6EoWnCngtF1Q63O9jA1kiRW6mczMZXMRn4jhnEVe1wpDweFjg0bt0F4A
	T8UcauHqHokIM+PXr7SNwlIcfAxA7FTUBa8jfxhRdzoTYnOnOb1a19j0zGtKVi+goDdUBxUelFB
	rVZSiWe+1qzJkLtMgNGj/XpBm0wvnqFg7TNn5kWYFCqJ+V0eN9G+Oqm+wXI9cXa8XLpzrGBtTro
	ZTkMg2qHY1Dkj4h7B4bwO0UF4OUIl4heX2cMUormiQvdaLfrfM6YDdG/4JhUIjr3wjuk3LPixAZ
	rm95/tUsrhDZeS19oZNL64aR48N7gSbA9+JCH//hY
X-Received: by 2002:a05:620a:2b49:b0:93e:83a9:d59f with SMTP id af79cd13be357-93ebd23f1ddmr876491385a.57.1791667121467;
        Sat, 10 Oct 2026 14:18:41 -0700 (PDT)
Received: from cavan.codon.org.uk (207-53-253-74.PUBLIC.monkeybrains.net. [207.53.253.74])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93eb986adf7sm109798385a.9.2026.10.10.14.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 14:18:41 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 273C51287ADC; Sat, 10 Oct 2026 14:18:40 -0700 (PDT)
Date: Sat, 10 Oct 2026 14:18:40 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 13/17] tpm: Add verification of kernel signing key
 provenance
Message-ID: <asqrsIij3KjUWQev@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-14-matthewg@nvidia.com>
 <0e47c22afbce2f94673bcc77d640cd9da410c2f2.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e47c22afbce2f94673bcc77d640cd9da410c2f2.camel@HansenPartnership.com>

On Sat, Oct 10, 2026 at 11:34:10AM +0200, James Bottomley wrote:

> I get that PCR 5 measures boot configuration and isn't supposed to
> change from boot to boot, but what about across things like firmware
> upgrades ... do you have any idea how brittle it actually is?

It is likely somewhat brittle, but: firmware updates may also change the 
memory map, at which point we'll bail out of resume and lose user data 
anyway. I think the appropriate guidance is for userland to unstage any 
pending updates before allowing hibernation.

> If it is brittle, one way out of this might be only to care about the
> last log entries, so make sure the log hashes to PCR5 then find your
> EFI_ACTION and the exit boot services mark in the right order rather
> than caring about exact value match.

So include the old event log as part of the hibernation image? We 
wouldn't be able to trust the event type because that's not part of the 
measured payload, but altering that should fail safe so that shouldn't 
be an issue. My gut feeling is that this makes things more complicated, 
but all of this is opaque to userland so if it turns out to be a problem 
we could revisit it?
