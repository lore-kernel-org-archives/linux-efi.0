Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793133572;
	b=XSaG7t+sAZO3fEFrNfyLEVNOzAqlolDE6SV1kJy8LS4grhFJ/TSrCU7QcpBC2u27vqP6
	 pZCsDzgJC/1Lf+o3WOFGqnd5NAlqYzTm/evZsAKDpna8w8ZcFD6Hp99mp7rJ3S0gCtee0
	 KSexq1WpkR8x6Yq4pWEzlBvDLOvOzeLXAa79LTslEH2oaHgwX1O0eMXSeMRULcJBIVsTd
	 wxOnZyz92BoSqxGr70fOvIB/AM6bABxnHJOpaBUSa/zkGFtnoHB1bS7WdfsE0SoKsPZZY
	 DNxrANRMxNlQmol+RnK5Uvd69/cLjQqEEXyBiSfEOPJSG5ywI+69HC0s4rX4RxUdjug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793133572;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=roOwYu0f5KwBgODRuBr3gTl9MLGpmNzor9SYb28//4o=;
	b=MfcAq258L1jG6hATZol+/bZwRBxKBAaSnBKOf5qxgSJ1YZPyU+IfdVZfl9hr7mfl/CZQ
	 ffZN50ZZ3jsozFt9p8u0SNzorSbFbMNDadIO3eBEUoxSaNNChZsKYrbSV+YVXUUJF8fzS
	 zwHXoVlZ4DV9oeqJAmd5YWdtJsx2121vKnjo49I63+b6Zwr7lpYRMHWlEtC1h1N1CL4Sj
	 1Rdc1jj2VTN3uRaG9KppQv4bbvNlxf2PPDokghDWNrdsYpUaHD4DIXdngQwaRYj4Z0Ota
	 f06AHODoWDwtKamPc4+1aiBbdLammY1SY74V/uJmBxjPJ7HzolBDv6NET9w8m19BzCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=akK1+Pw6;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Yud68Rxl;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441FA606A31D
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 20:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 441FA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=akK1+Pw6;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Yud68Rxl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793133571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=roOwYu0f5KwBgODRuBr3gTl9MLGpmNzor9SYb28//4o=;
	b=akK1+Pw6QAhpkcxtlACExkkdPBQa023n24AZ7US++Mz705Iu3vo+9YZJZPKDWtQNE98RpT
	4mhHalLOuPoBzFxX0fsOK0RJr1ZFmQmYctf9yuxGMPltIChuWxw0KoapX9NRCDVqsSkpe/
	B+g+McnWvhefWkzsq9iounxCS9miPkw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-GyrULXlwPgOajgIuNXi2Ug-1; Tue, 27 Oct 2026 16:39:29 -0400
X-MC-Unique: GyrULXlwPgOajgIuNXi2Ug-1
X-Mimecast-MFC-AGG-ID: GyrULXlwPgOajgIuNXi2Ug_1793133569
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48dea677afcso132403f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793133569; x=1793738369; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=roOwYu0f5KwBgODRuBr3gTl9MLGpmNzor9SYb28//4o=;
        b=Yud68RxltWRXbksRawyGLsb9m5yTw4huJO/PzLPdrZpZctGkEvhppeJwqJ1JGyIm2Y
         8Zkx48VRjl7Q1u2T6tsOshUrqQdMMtvOGB4Val+ifVU1cOckruygN4ufvG167mQzDrke
         O/sy/P3XZBT8Dnhtri/JXdmEDPuucApXrpaDPhRZCf854Yie7+wdS48Z5/S0uyJDKcxW
         0MG00dCFI/HI5RNTGpubqNEhxNj/fJWw68UHmZEeu9ybIjU8U1ACH7lSC2NoetKvZdvG
         pNYa4LXIZlklsE7YxLzOl+d+3Rm047m45KLnZnxn9WfYe4f9FAeIpOqkp80iXke3MKYD
         Iz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793133569; x=1793738369;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=roOwYu0f5KwBgODRuBr3gTl9MLGpmNzor9SYb28//4o=;
        b=rTJGWR68DiKz0V5iHGc8ve46Oq5xToEwZsV2j4SRFMfKYSyLn5Mrl1vsvE4c0//+LW
         rn0jhTGH0K68fs4Z8ill2XMG4srtU81C3WuUfVdflVwM7FEgKhcD8q0TRkG6u5Ize/h7
         plUJ/jW+qTfZbv4/KExLzKXsXv5A5khSI7Gz+pnfGOIQ/HC2+W0+BxFC9DtFH/j0qn+E
         PR3g807ksDF8043Cmiy5guKS0A5mvO83YBWL5Bg3INwOaDiyD2oZfaGyrhrusdAFgevs
         JWtKTJuU8MbAa01QnKc1cfqw5bBHdKGS6zgjKm1TRQU3n8PaAla9h7kXLcMi+RacWhTo
         2YJQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOtJofxSC4wtJvueOWUNL0PJNJ7BsnRPtUU+lH59/OjIxvF/0C1KSzM2egC8UnIs7tS27ijjzvR08=@vger.kernel.org
X-Gm-Message-State: AFq9FYKzmTIuNijuSWJaRL8fIxWaqSdUzt2QNQ+bZrcD4lSb7tUSMlXS
	yu7O0n9xWoIZ5D7jKFshYEuIBvEqwpeXQdgZlsiOYzLkhVv6IApx5SvGeEdc3Uf+/3zqe2m0fuE
	0I/Gzl7h0uxkpHiaUS1QbRd5xqWUPVIxeUJTLTQ+rnaPcNVJJy6TRLO+nsylPsw==
X-Gm-Gg: AYBFou3inEfDutt8kPnOM42Cj7XtVnhfanlxcx5rqQSYbl1Zj7oHhGzlxoUCItfpalK
	eeR52e2VKOWtfQOvq9+DTlhxA0YOqHTCUHno0Dp7vk9x+NK1XuDeRLDTQiuJ/iQnhjomES7pkRj
	WlSfUExuAOKOgvsodjJY/s0C3Tyy2TARbFO1j7xpJP0e/iBHF4HzXim0K80TX0qDEpYq5IWEeFQ
	55bUSdf0R7a9cko7Fp1HWIn/NNhzsaD7HZSmiHO/0zsSJP1hiGmEIp2GWRVp9G7j/MC6+Qt1uq6
	DJiJfJR4eBqYXko2txJ33sKDuKAhP9Nl5MI+6GOTlxr7HhwSLOABC3xAAB6UPzdHre4=
X-Received: by 2002:a05:6000:60f:b0:48e:850:c0b7 with SMTP id ffacd0b85a97d-48e5d28705fmr1693106f8f.1.1793133568602;
        Tue, 27 Oct 2026 13:39:28 -0700 (PDT)
X-Received: by 2002:a05:6000:60f:b0:48e:850:c0b7 with SMTP id ffacd0b85a97d-48e5d28705fmr1693005f8f.1.1793133567964;
        Tue, 27 Oct 2026 13:39:27 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdd5b3sm24553225f8f.53.2026.10.27.13.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 13:39:24 -0700 (PDT)
Date: Tue, 27 Oct 2026 16:39:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
Message-ID: <20261027163814-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027051245-mutt-send-email-mst@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027051245-mutt-send-email-mst@kernel.org>

On Tue, Oct 27, 2026 at 06:29:35AM -0400, Michael S. Tsirkin wrote:
> On Tue, Oct 27, 2026 at 02:56:03AM +0000, Kevin Loughlin wrote:
> > This series enables virtio-balloon free page reporting and memory balloon
> > inflation/deflation in Confidential Computing (CoCo) guests, starting
> > with architectural hooks implemented for AMD SEV variants, in order to
> > support dynamic CoCo guest resizing.
> > 
> > Today, memory ballooning and free page reporting are essentially unusable
> > in CoCo guests due to three main roadblocks:
> 
> 
> For me, the bigger question is not whether we can, but whether we
> should. Considerations I would like to see addressed:
> 
> Security, e.g.: does knowing which memory is free leak information from
> the guest? If no, why not?
> Consider CONFIG_SHUFFLE_PAGE_ALLOCATOR, RANDSTRUCT, etc.
> 
> correctness, e.g.:  Linux has init on free (and default on windows), if
> initialized pages are dropped and host can not be trusted, they have to be
> re-initialized. Is this handled? I don't see it in code.
> 
> Also, performance, e.g.: How much does this re-initialization cost?
> 
> Management: it was simple with balloon off unconditionally.
> Now we are in murkier waters with various features offering
> various performance/security tradeoffs.
> What if some guests want the tradeoffs but others don't?
> 
> Documentation: for all of the above.
> 
> -- 
> MST

And to give this a bit more perspective, I present:

commit ab676b7d6fbf4b294bf198fb27ade5b0e865c7ce
Author: Kiryl Shutsemau <kas@kernel.org>
Date:   Mon Mar 9 23:11:12 2015 +0200

    pagemap: do not leak physical addresses to non-privileged userspace
    
    As pointed by recent post[1] on exploiting DRAM physical imperfection,
    /proc/PID/pagemap exposes sensitive information which can be used to do
    attacks.
    
    This disallows anybody without CAP_SYS_ADMIN to read the pagemap.
    
    [1] http://googleprojectzero.blogspot.com/2015/03/exploiting-dram-rowhammer-bug-to-gain.html
    
    [ Eventually we might want to do anything more finegrained, but for now
      this is the simple model.   - Linus ]
    
    Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
    Acked-by: Andy Lutomirski <luto@amacapital.net>
    Cc: Pavel Emelyanov <xemul@parallels.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Mark Seaborn <mseaborn@chromium.org>
    Cc: stable@vger.kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Leaking phys addresses to unpriveleged entities might not be wise.

-- 
MST

