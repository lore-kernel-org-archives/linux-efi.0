Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700427;
	b=WAdqlzKX7fnAEEzep/l7YnUTCUARqunsPpPXqZwmvg4wd1N9kyE1ujpufomzQCd5ee9b
	 +w4j3q47l+A6ffoej5rfjHNH0OmBPbmvRWIB/vnjzIQ/lZe0hUYUHz3EwqhLPdZ27Frwc
	 bQdXnq8seFJSfuDr1bGx/0NPXloKcrjcvfrsV7eIKw/6kRAJZoo1wDviqgYP694vjVPNx
	 v7vI7gtgSMZzM/W/dbw/nh08Co23HP1uFrz76TH3Tulk+JOtIYKiaH8FIzEf6bDBLG09B
	 QMFbzxvd9dlrAGCBM34TP5Souuk3qx8/TIBqF14nOAf7MK/NC95Lhcay1Cwa4DEQzag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700427;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=yOEv4rlICtm+9MGZIVJit4iJjbb/HbqDxTBh2E0PNYM=;
	b=LNhC64guaf3KjAswSa3mZeOtQ4U+zS7S9s1ElT+kbhyp/ULN+ndbqDkI3FQ4m4I1uLkt
	 M62ys3EdWWnc2ruDCqWk19kL2rvr2xxFzfjwIivmVrI6d+hoBIir6bOmoA+TG/+OGNNvq
	 ACj0DythNFt4WxdkfpHiDAQhpFw1cazFLKVvUh+yGeOgyQH91gyvWFDoHzPpnpaPxqPqz
	 utoHbQUcGi7WnWYJHu0urjtY1KxmQpBnEe5p5glsu22OUv5lQqw4pQkVBFHTWgIRiRDj2
	 XaE7cYTbpkUzViuQVkXs8wTZR6NAKENFztLbYqTYYWezYhRv12wL3U0Wjgxc+XqRG7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=T8GHUIeu;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C679D606A817;
	Tue,  3 Nov 2026 10:07:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C679D606A817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=T8GHUIeu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yOEv4rlICtm+9MGZIVJit4iJjbb/HbqDxTBh2E0PNYM=; b=T8GHUIeuwcDQEX7YFBA0dHaPtB
	2kVj9KSOFPEikB0F9pAaccEJIVjNxbKR3+e0f9oaOThinmGoXpI0EvZVDNwsXfU7AGr9ATQG+ak4X
	z2dA0u862tnlHdxULQMW9u6wC8/34oIlt51HyBjY2ZPhPEqEQ7F2QlBBCab/c1vclkwgOD+hM7I5Y
	Apd1Al26l3U1O8FO7cvKq+udwXcUON4wKT7E1OLcFB1DgsHO9juQDwNhoajOQfbR9TQ7vZZE+8K4T
	LmEzS5pvIZvxQ3GwRaJaAmhojV9r2fEIapcI/uXjfq4sDAf9cLR2RFL0jyHQmO9HjiEpQaLi6OAZZ
	0upLu0Xg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOBPO-006r0Z-0j;
	Tue, 03 Nov 2026 10:06:26 +0000
Date: Tue, 3 Nov 2026 02:06:17 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
	kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, shakeel.butt@linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <aumvVjoHo4KeuyEp@gmail.com>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
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
In-Reply-To: <aumt-4kfGGtoXuh-@kernel.org>
X-Debian-User: leitao

On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> 
> We've been splitting internal.h to smaller headers, maybe it's time to add
> "memory-faulure.h"?

Ack. I'm happy to move the "mm/memory-failure.c" section out of
mm/internal.h into a new mm/memory-failure.h, as preparation for this
patch.

Since this patchset is moving slowly, I'll start the header split in
parallel as a separate series, and rebase this patchset on top of it
when I respin. Is it this ok?

Thanks,
--breno
