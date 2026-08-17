Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FDB442B32
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979754; cv=none; b=tSXWDyQOU6xFriB76xgBBjfpgelqK34kN3UnfvJ7MaCBAkE1g+HFhKQNgTRniq9bIB7Mx3pIGuhMLvOseuqhpCMCoiglzynEoeceMfj1r+WvIi7kt8b3nJoPY5COjj8aFDUYLlp9v2KK0UHr8l2EYkkGFQXAkEGyKDBM8aulkmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979754; c=relaxed/simple;
	bh=/9zL4j7bvEzNHZe+2GnRD64ks0ouO6ge/iHUhPBHSpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O17LmfllVPPv4LQfrd4kwONXYZ35jfw2xlxUJzUvbH/7MQMwa1DcTl8fcSaIkfdqHMNu9OU9xZZbxnLpVbQA9Cbb8htQWZ3q2RdyMMq03jKBXIFADAZJ6pVsprnFI46GGOM33ih2O3haWPE3RroE7Gx1kNekVzNDebzWdQKkw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=nURkaZkS; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="nURkaZkS"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93695893ac1so246207885a.0
        for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 08:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786979752; x=1787584552; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LkIXCvEaOBZrdi7ChK3r5JFweXwKUKZFGDYp1HFtFrY=;
        b=nURkaZkSS1bFk0F9xKIrydT+A4Tbczk/jA4xGpqFU4pBJoP+aZ/Skuc1oMLRGSGl9r
         WO0OCIEPs5emafGVagWsIGAbiNCLo2cD1/eMeFIfqB8+t4q/zD/TDCoqsli6ywNXD7jk
         Y52TD7Gj5oOWKx70Rb/gd3KPYsGMVa5CvRyBZCrCOes71OqXN30YMfzRB/abf0M6fp0o
         RHAAh9MmrqRaY6+gNTqPp2RwexWzHoe5pzaLKR10S7s4rMlr+OwlMWDIEQTYtyNMIH5p
         WdjfJ4csOa+UWGleBQRIlc/r+l79t4gZDgnlScbxETCUATW9YHfV9bP5SHTRagD8YyFG
         m3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786979752; x=1787584552;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LkIXCvEaOBZrdi7ChK3r5JFweXwKUKZFGDYp1HFtFrY=;
        b=PviytdGZF7s6XWEOcCx1BeCi+H5+l6Ha4BFR9if2f5qzuAapRvAypYdq1tGV4Na8GP
         WR/ohIkBtygfPd433K0DtHiUy45y1Rmycvi3CTcdKqbbczXfL3clF0vsVAqKFwf34H4G
         fMbsxnFKT92wRSviAPjp/GbxDsGGLMwoE057wjIiONHydrJf/jYR5YjH+QPhA/guSBrM
         1Fr6N5x19ySFh4+ES/OwVoQpD8DeOR5xw5QdGJ+GnBbpKLob/MFOZcgal/nIQR0UHis3
         i2f0xOjKOjx6yxi2NunOJHdMsSU3RNQ2EhM5f+ErFhzcoLmowUFCaa6tv5KwBBEYyogi
         bkDw==
X-Forwarded-Encrypted: i=1; AHgh+RpNWBgqTKaOONsFI326qbQ9dQukea94UZemaiKsWGCIKbK4a6yxMGFYOBJAi7oK+TbZ6ikQr/tHsRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLkOEpPXWGiYSN5CF+IJIdEc0K+w0EMg8BYpMK30nSW/i0silQ
	z98Y8ieEoHDVg0bbJRgyXp6uiBuvNtAID4ZEPTR7y3HiDztrdDmxNR6UtNkSJFUsEXA=
X-Gm-Gg: AR+sD11HkmWSW7TPGW8n3CUWaS8TV5FSk+hv28A4fSPgO+4+j3+tyn2xOpw0Zki+VXh
	A9K7N/IFMmjUyM7UnpmwiRFwZhsr/FKpavd1XTHhSQTKx6gTsg1AkVoE5XQ50rOg1Sn4nSqFcz3
	eq0qUawDY9i3srOLBTVUcPf5bNwDkwFjeXMD1KD1HjHn4wIQrNCQla/4UDs5guy19cJZfyOxEnN
	SFbHTm/+5BwIpnTxTFEFS+lND0qzvrcdYK4GPhSTGc+88ZLoQEJC7CpiR23hgKrmqRLwRQhjMhk
	LL8ZuB2tiM9zg5zO8llYuj9B6VixqRXxGxC+NAldnetnblJUdkA2x35TycC4dfxWQTNWN/MehVu
	bj4ZsjZVB+lC8YTqX1cl4iYNcQj11KnbpNJ0YHDaDYgXd4/ojE2Mi5jEz2VoUftLgPwN8YG3S9z
	VKdp/sRLoW3SplpY6EVeoN2XYjco7MmdKTtNHfvqw4CMtPBr4hNlSy66W/d0tjiOw//eJhV7LB6
	O8FxDimPh9xgS1oErVVQb8ldXD7xGfRd/3SLtbV8ZC6
X-Received: by 2002:a05:620a:f06:b0:92e:7d53:8e8d with SMTP id af79cd13be357-93704b7d4dfmr142017785a.27.1786979751821;
        Mon, 17 Aug 2026 08:15:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033d2ccdsm67050085a.30.2026.08.17.08.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 08:15:51 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:15:49 -0400
From: Gregory Price <gourry@gourry.net>
To: Rob Herring <robh@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Saravana Kannan <saravanak@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>, 
	x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Message-ID: <aoMlXHFTvcpwOv8W@gourry-fedora-PF4VCD3F>
References: <20260811162642.3504565-1-pratyush@kernel.org>
 <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
 <20260817145231.GA579285-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817145231.GA579285-robh@kernel.org>

On Mon, Aug 17, 2026 at 09:52:31AM -0500, Rob Herring wrote:
> On Mon, Aug 17, 2026 at 10:42:00AM -0400, Gregory Price wrote:
> > 
> > Is there a non-verbiage reason to justify these changes?  Living with
> > "scratch" seems better than potentially breaking folks.
> 
> I don't think these are the first breaking changes. And if the changes 
> are fine, then that means more breaking changes are fine, too. So why is 
> this upstream at all until the design is settled?
> 

Surely we should not break deployments for the sake of renaming
something that is very arguably already aptly named?

~Gregory
