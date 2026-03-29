Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FF1264A97
	for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774806720; cv=none; b=Mrzey9xnDpGXpWjBlP6TgTna/xIskxRoYh+llVc3o/Iq5F5UxnOupbgDPg1Ig5b0pLIXPn+UuXef9FsblnixmfPuIsqe1KS/NpUJUNJQyoXwwDRCybvVB/anc0CNISxkkuKNT1go1ypvBDs9bZQlOhgTVbbdVTqDLteq6Uyy1V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774806720; c=relaxed/simple;
	bh=2e+M2+2Bg9MqmfrQeh6rX+OFqRZkGEQinf9Q5RZUktU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXgOvc0kJFewv+Qy/7YVY3fOzMNeQ09T5FIm34lTNQGOdpJ7kzqTcWynXHoUjYw/5ii8JNli/zAnRjQFhXZHC0zqtG5ZIlWCMUPDVc6kNKZBcYp2mNQsDGT+z2oa6GfDwg+FPFQ0mnpK6XGa1NvA195C97mxXG+o/gO6a+GFVbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Yd2ZMgJH; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Yd2ZMgJH"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cfd44fa075so540490485a.0
        for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 10:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774806718; x=1775411518; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CGnGKhV5zb489dStMiQgEbxuhffvfA5BGbsg9GGuJkc=;
        b=Yd2ZMgJH2HgbyoJ2TkfgP48RWQ8JCSfijAv2zBbG/AJSnXuSpUZ2DINkfNEP/s6p11
         A9bOm/681oEpyptP/uKpd9LoB+Ipl7XbQ5QSvUJ7QkWjW82TQiTRwgheNvFrpNUG/wKN
         jPDEm6wIRCtt/p3I7J1wNGEae4vPlsi6hAa0WDdwHu9cHBllpdnCvChxfnh6RHuXG+ND
         laOOdN754XBzArmq9UcvIMJ36JAfkVH8V5MIjfKjElbEufGUni6DuijDJoBvI59QQy3k
         9W+2rV6TBCylbzWCOPyvbzkGSf+hiYD8JCbWo7z0jLyT1KBmHkh3OzzHJzhjxfCDdBNp
         Um1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774806718; x=1775411518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGnGKhV5zb489dStMiQgEbxuhffvfA5BGbsg9GGuJkc=;
        b=BZElT3Bx2Q7902ClukToZ4onCCCMJ81j3HD/vQDlYgXIvev/qSAPFLYGLv0hc8vQ3z
         15zmBhJUnm7OShNGGaxMXV+0pV8DD2gsNlcSPSJRE2OCEW2SNL1dBURrmrooroDPXmqB
         oUfqDjG3RvRSjlcaaCZt6yzsLT5w1FuC3uz6gSpqKuYNHvXU5E5ZHjUE+/PIzHN05ulW
         orHKoIktD2XwyqQno3v148yxPC/y1/S4n+KB+uEpBejANLMb0cl0pocc3I1pUQgxAv6v
         egOpVC0Bb9YOBfy5sz5omCd9ebQfR9RIWeoIjLNngBNnzGZW/kseZj5vyf3tmobCzi1v
         NjpA==
X-Gm-Message-State: AOJu0Yx41wS8gegBRIop3sbXhPs62jiykMS9hasfwQTl65xhyGhP3nhy
	GakjlcjFS4CYcVJGRwKvIOY0nrlyil5mfq3+Zomt0NuDAoewXgW6OciNSAtlur1tXWs=
X-Gm-Gg: ATEYQzyaUYk5CABpRG4AqthuH95r6R2VC8OCV5PFSK7ZaUgFdcfNgNGxOEPOO0KlRhp
	2rkgkTZ8xRZnvMv0brB8howVeQD5AL/l2oBXixz0SMiQT8Xf/Gc6fHLpsL90TgBguc4puiHeYit
	PjF2DKT5Edec3rhkdwA0ij3s8LsYRvOn/NxPXNIxanMZxW9xl5VmXlB+cnmwLFu1oxphqAEt227
	AcXyL7xcpeQ7Cy+y5eMJGGLDU9vByIFWRi9ZCVLkBTBkCmrsp0uLuSmTsUEwTzADa3iODuvvMTY
	cHkhxBH0WP5ANLO9RlN68EqsvkPBJrcmOOtJiNQg/zrgeA8v/BAPuM6ll5pIlM46PMXIYAo97XQ
	J0KHsyE7779swhTILFHMEOKEoYnJojkXwJd7MctviHSxxDrKIbPGU6OV+kUVLADB7lVRtbI9cl8
	wNvOk2AFDG8Q4DiOIJkYw0kFtqnRg2YmQC48ScKsQdPj+3/BnLMpox6XJr0biDVe6EzTk36vYdS
	hyqWdA=
X-Received: by 2002:a05:620a:4145:b0:8cf:e32e:89dc with SMTP id af79cd13be357-8d01c314588mr1318827285a.0.1774806717634;
        Sun, 29 Mar 2026 10:51:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-68-72.washdc.fios.verizon.net. [173.79.68.72])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02806a37bsm407108985a.34.2026.03.29.10.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 10:51:56 -0700 (PDT)
Date: Sun, 29 Mar 2026 13:51:54 -0400
From: Gregory Price <gourry@gourry.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH 1/5] efi/memattr: Fix thinko in table size sanity check
Message-ID: <aclmumCA5ADfT7-Z@gourry-fedora-PF4VCD3F>
References: <20260326132655.1733873-7-ardb+git@google.com>
 <20260326132655.1733873-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326132655.1733873-8-ardb+git@google.com>

On Thu, Mar 26, 2026 at 02:26:57PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> While it is true that each PE/COFF runtime driver in memory can
> generally be split into 3 different regions (the header, the code/rodata
> region and the data/bss region), each with different permissions, it
> does not mean that 3x the size of the memory map is a suitable upper
> bound. This is due to the fact that all runtime drivers could be
> coalesced into a single EFI runtime code region by the firmware, and if
> the firmware does a good job of keeping the fragmentation down, it is
> conceivable that the memory attributes table has more entries than the
> EFI memory map itself.
> 
> So instead, base the sanity check on whether the descriptor size matches
> the EFI memory map's descriptor size (which is not mandated by the spec
> but extremely unlikely to differ in practice), and whether the size of
> the whole table does not exceed 2 MiB.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

The 2MB limit is a bit odd to me - but then i don't see a legitimate
reason to need 50k+ entries here unless the system is doing something
absolutely nutty - it would mean a wildly fragmented system and most
likely an indicator of a bug rather than a legitimately intended
configuration.

Otherwise, this does seem like a better check regardless.

Reviewed-by: Gregory Price <gourry@gourry.net>

