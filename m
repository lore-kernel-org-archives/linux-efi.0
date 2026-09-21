Received: from mail-ej2-f38.google.com (mail-ej2-f38.google.com [74.125.228.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE6049E5E0
	for <linux-efi@vger.kernel.org>; Mon, 21 Sep 2026 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997613; cv=none; b=AJetZcPbPyyoCSFlGzHC6cQkIhF1zv636ywa0EHE1SSycUrB7Yy48RdAoPFwhPsyRgagZTA7SZXEZYlP/qu3cXAcdJ0zE+pWCcOWODpngC6Kz1WeySAdYDm/ezc+vpsWmgCa3bOgLxsSZRpj5tDIka1sAlRVK6RlnRWrbqwQhxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997613; c=relaxed/simple;
	bh=A9wcNuC9U23eMCWltny9C1/4A+hHO9hclqKdjl3fFpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFH6bPcRKM3vXTAyWbW/83qW6UiDU5AXcHP9OfS3UdJyxkfHEd0h7LmDAHBkvjkvz0t78Afcp5cNqxMMk+f1IppenkwUXZlMbzcKimWQfN1uYkObH2g2E92hwy2gwMJcUIxZD1K4Y3yvzJ6DHADJZ5zakzWs6noO9iYR2DhGd54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iycBymeK; arc=none smtp.client-ip=74.125.228.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iycBymeK"
Received: by mail-ej2-f38.google.com with SMTP id a640c23a62f3a-c254f560398so453330066b.1
        for <linux-efi@vger.kernel.org>; Mon, 21 Sep 2026 06:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997609; x=1790602409; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RTnU8avJKar63dWMEB037hHMHXQ/IELuodQg6fpsYos=;
        b=iycBymeKIXtl8mOdnKsW7v/neMtweuNvg3dzhms+C+QuPIYxg8rAW4wHgbLk6pSJzE
         e55O1MmjR5q7zOTnBPZs9aHLa+rm93z4IV8J1PD3kc3s946H3VaGKFprpjBtzUrAKExx
         xlSEimk0Jm64u0UwQ5mVQNlxq2EdZ3efIgixcbGJWmfywahZ2CRGaX+UJ0Ueq8/4ux3l
         516bjD4xE3fm1Ldjw0QZO7ObpYra/b98SCKR/ku1A8G5LKB7H2nRL2t6K2qOD4sIEf9H
         eDs4XymsI75Gx10mxgaBOEXg42X/k1Q+ejRaGxyG0coEij3s2tCC1YD77rA0UdvjFpvh
         1H1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997609; x=1790602409;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RTnU8avJKar63dWMEB037hHMHXQ/IELuodQg6fpsYos=;
        b=pXyGDzK8s04hHaUVc+5KAuYLsr7Ijmmigq0Rthps+Qzg8Endv4MHJh0+NDd7mwmAFh
         3uWKLj/Qkh0nR+QpBY4oLedMNfr3LSpZw0ckKeni8DHbnetvFY/5yzqFJJT2SytoRRLe
         dcUqVE7fjwPdNo7i8q0jN3cjcP3HMtYHrJxpdLBEwTyxAtZxltfXQeOA4wqqYLzuFXoo
         lR8abtP4sEDNDidS+vXt62oTfjvV5l2WuSzWMK5ED3Xcpv6PlpcH4Me1PmLBAq73JlF/
         p7ZYjoWI6dg0rQ/UXFMQr1hxv9H8fGpa3wRkpOTgk6HD1aMYhhLE0VRuE8eTibubV9xt
         y1aw==
X-Forwarded-Encrypted: i=1; AKwUvByDNeRmOXodVAfX7NS90XE9lN0xdzIMQlIKAk5v5VZHfRAmC7vvD8pVvVZomAVmkrqT8DXu+UL0AKI=@vger.kernel.org
X-Gm-Message-State: AFuF++k7KElICYF6hgYbvWz2jCEpDCk5V9Ti3va5Gt/12URJAy6E2rkV
	kdF+UPGhNTaO/BdWdFDvMoIaeq5DqsrLxVGCGCaplizhGE733Dibnrg1
X-Gm-Gg: AYBFou1yHa6sEmjR907kJURbFwnfgoioVYnbR1a9mRBUF3XCiMjUfQUc/kr15VWTUR2
	kzMEn/EMp6ojDlGN/0WZy9dDysyiCbAAebHTsQQZt1LPdrCqikA6zCIwHTa9RZqbsyMyDCgVSIB
	JeNjeHzrlBSNLyWiHyXsm9uZ9JtUG9zfOZC9W5LRpnU8MjexRykd5jAtgPYSs9/QZX/mgGa+p/4
	GytFdm0lRZcoA0aR5HGUHkJ+i67VU1fWHMoNKCAvrkvlHX1QF/BUwZmiXP9EroV5enxA69ln+pB
	sWsINNowuw0NGOpikQ8jovrOyOWASG+r6+l11M2uw8Km/5msIoLSl6rrnZo4vC048P/NsPXb8xP
	EMfjsvYplkanmMUmlcqdq/bYu0at63zmRC5oNrp3Frc35ZcSnqx0O8XuNnxAvAekPSsVqL81Wi9
	ydNjTzcqduGCORt4ecIWCQt5jRE3LW016pxXhzBJCR2nRdRMV0N7Y0Y0N7sVsGAXpXPPJOxDnhD
	y+3OQ==
X-Received: by 2002:a17:906:c10b:b0:c26:19de:9139 with SMTP id a640c23a62f3a-c2a15cf8ea1mr1009022566b.44.1789997608820;
        Mon, 21 Sep 2026 06:33:28 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a358e31fcsm300270166b.59.2026.09.21.06.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:33:27 -0700 (PDT)
Date: Mon, 21 Sep 2026 16:33:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Muhammad Bilal <meatuni001@gmail.com>
Cc: ardb@kernel.org, ivan.hu@canonical.com, ilias.apalodimas@linaro.org,
	mingo@kernel.org, matt@codeblueprint.co.uk,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi/efi_test: bound capsule_count to what the int loop
 index can hold
Message-ID: <arEyIsRJKRa7seUh@stanley.mountain>
References: <20260919192410.272516-1-meatuni001@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919192410.272516-1-meatuni001@gmail.com>

On Sun, Sep 20, 2026 at 12:24:10AM +0500, Muhammad Bilal wrote:
> efi_runtime_query_capsulecaps() only rejects capsule_count == ULONG_MAX
> (to stop "capsule_count + 1" wrapping the kzalloc_objs() count to
> zero), but then walks the array with
> "for (i = 0; i < qcaps.capsule_count; i++)"
> using a plain int i against an unsigned long bound. A capsule_count
> between INT_MAX and ULONG_MAX - 1 lets i wrap through INT_MIN instead
> of ever reaching the loop bound, and capsules[i] with a negative i
> indexes before the allocation.
> 
> kzalloc_objs() would have to succeed at that size for the loop to be
> reached at all, which bounds this in practice, but the check should
> not rely on the allocator failing first. Reject any capsule_count
> that would not fit in the int index up front.

No, the it's fine to rely on kzalloc failure.  Don't bother trying
to silence this false positive.  Fix your checker instead.

> 
> Fixes: 092e72c9edab ("efi/efi_test: Prevent an Oops in efi_runtime_query_capsulecaps()")

Certainly, don't add a Fixes tag.

> Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
> ---

Regards,
dan carpenter


