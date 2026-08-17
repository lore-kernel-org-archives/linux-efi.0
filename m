Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE3339B96A
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977726; cv=none; b=NS1kZbYjGwF3sx6Pt10ex1OEOIDopMDDOYRCiZ4E8MkuXfId00TgGLNoX7pYqDZuE2wTDxawkOalzcgf4+gnfnHRqGm9+a2lHer4h/SXwPB7CL/3hx+zrI8k37h+8MZjE2RNtMwm5maPgmsA1AG4Xkz7n8eQ/eYYbDNV8qPtKeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977726; c=relaxed/simple;
	bh=4LT/LIRjRHMnkDcg+Tj8gGxQchYEIeHSdbQ4U3jZKDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wzy2RnAI6eN3/kk7mv5reIjV7SaiRxrsg85LR/gvWj6p5kp9IxK0nZ3oc3MgvNnO8vejqdvX4RZs0DO2g/dyhYD1IW4YGyMInONEK9f8Vuo93Q8kdHOlcAD4a6hVan559PUPgfOxzTOxOreB8GEGBaY3K5mhIfoRUNzzuYJdUdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RQYoB544; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RQYoB544"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92edb12cdf2so281074785a.3
        for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 07:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786977723; x=1787582523; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BCd/GM+SB+20nc87cPYs8vSFqEi5EzWcz9k0G1zmxpg=;
        b=RQYoB544a7KEGXjKAhS9P9piIOWlFMFM7c3DhTf3yjJDxJEn7ZET8T8fyPQljSvj1/
         0B4HfglIlx7uCNdZXKXYXlIXFzzQ80xWrKMcgeBzFIiD/MpK08U3MpD+AvtLKMQj3G/i
         GAWk5XaZh7Rbvx4O3+tsMzRO9y6Yjk2X8KD0nmqYZGyhgsQcqaMuw2lhWhINwlK86OKT
         kOZxZg8cCeESC1+ejj57tezmjxvsUyKQsjdVV0DQ1514h6P+Ep2iNsZ/f7n3hixU6A+d
         BtSjKCTMUfDFMSM/Xug8v5RWM+hefFFYUjj+dJWnAt8E3Q97nwe1UXfjkAnhtxTJvB1y
         62uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786977723; x=1787582523;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BCd/GM+SB+20nc87cPYs8vSFqEi5EzWcz9k0G1zmxpg=;
        b=g08GRMfDWxI2yoX+5n78gHaKVQwnnAdmf3HYlFJC90tVN4p6rIQK1rVPfSZszsTaua
         kRjLNi+i/96EsNoRumw8PQ4PLUrX61HvXXQSOQ0VB0JiJKmxn+7fUmKtc4r+5DXpAIQD
         Jix4MNGp/ybubIag07WsnGfUv8wwWllkRcbshBt+tlDW6eEsZ9zikNuCnL6DRHXBx9hb
         tjDlKZR1JX7p4wxMGinOXBCMOvUeKRTPj2duBpsNuEBUpoEmu+UKdowULl4ZGpRgfB3b
         KfI1wt+wFyjhzE+1btFea7vqwhNzxuZid4eBNG6qOppBzZImESHfv9mtuBluaqt4Vpdz
         ebmQ==
X-Forwarded-Encrypted: i=1; AHgh+RrJO8SGJEDnLA4nxc65hfNXfevgMgageHnNNw/9MQRKh/SGn3m4y9G+LEOpGn9F1rfTulT5g3dbOLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzngR6PuZfCLFbdoVwqcugzw6s2IjPzqm4YP0pXfEL0t+xnkGjY
	LCYlCAx0Yuhu5VGjo2dVllGZMx7WsUbDFShrOG7KHWYxkemrQBuXPpjawP4zATeVwG4=
X-Gm-Gg: AR+sD12ma0UIowZYQHlol2k2Kf9r0QNGV0BChVUvA+rAATJBL0+CsyMLxMfM8oCZbfK
	k8mdm2VWs9XrBAjbNZiCx2INVDFZXVkWKFtYAkIn8zXcYJgYCnR3qjn55u0iYZWBtzxFUdNg1/w
	yOQ0o0ppoks2M3X8YSSiPDOG4DTV6Y4DLHirdoecxeaFjhbflFSx5qM6szgF+Vp1vo6j21Y8HFW
	IhtJ5UZXeQhqj6LslZ4g43x90cSQoRLaai4b18C/qBILaVv9y/pM+avDcZRImbARusbape8FOQq
	tafVJXiaMtMfhKErr1M3Xkqb3h+8VKqm1WVu3BCoxzzolndaBD0dJ7MK5Nm6arJwklQ3dr15jeV
	4Jb13dHCvR6XW3Op+z8lvr/0IMCGPJz2hke8B+wcrfNp0xPygMXdfc4f526/+PHORuXAgj53g/A
	jbqnbGKAhWtou5UWBNSj/OQpQs/F9Luxfn1hsO8wZVj0ST5ZuNjxeCBO8wEXhPM6A37q2EhifhF
	TQCAY+l5Z0qygf/J1T1pldV+9XRl+GswkK3xr39uq/h
X-Received: by 2002:a05:620a:2682:b0:92e:e695:d622 with SMTP id af79cd13be357-936d22ea6bfmr2612870085a.28.1786977723026;
        Mon, 17 Aug 2026 07:42:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937010c3785sm100435385a.2.2026.08.17.07.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:42:02 -0700 (PDT)
Date: Mon, 17 Aug 2026 10:42:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Message-ID: <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
References: <20260811162642.3504565-1-pratyush@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811162642.3504565-1-pratyush@kernel.org>

On Tue, Aug 11, 2026 at 06:26:36PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The term "KHO scratch" is vague and overloaded. It does not accurately
> describe what the memory is for. This was discussed previously at [0].
> The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
> is memory passed by the previous kernel for early boot allocations.
> 

This seems like a lot of churn to just rename some stuff, especially for
a term "scratch" which is very much understood to mean "temporary
working memory region" in common computing parlance.

The boot param name change would also cause breakage for existing
systems that update and depend on the scratch parameter.

Is there a non-verbiage reason to justify these changes?  Living with
"scratch" seems better than potentially breaking folks.

~Gregory

