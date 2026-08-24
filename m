Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2457A41F347;
	Mon, 24 Aug 2026 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787576607; cv=none; b=s/YKhWLdmA7w46cQXtAQn+e+h0578nOwwKHJXlqNLELTClzPL7C0GVaf/oLkAYtCnBUD5URhv5LtFRypewm7aZU94E8ZnxXpH+6zmdPap0+b1R5HhJl2DIBfTzwoKUaDt1MjsiMjZcgUHsH/7/7AqhbGCOO2JtA7olAN9W6Fahc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787576607; c=relaxed/simple;
	bh=f2E1nNMDZmb0cz+v7IjRYcKyCW23fV9BtqdWi46vznY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIJwhVMMlF7Oyp8vVt+D/FBIxmnbcAAHF/VIzpU5CI7pG/dzmWAHM3D6+A3UG0BjmkLU00taNla1VhgBRK9idTYHvGuGbg3dewxZ6gvOJjVAdSIA7CIWvDriJwaVeo7d9TYifG03YjgZNc2j8bD2xYr8JPVd72TTV5C7r5eKYAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=PRPwI+mH; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="PRPwI+mH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O2Scpyty4GH+eqGEvARQTzFRBjvGNIS26XjXcBDeF/Q=; b=PRPwI+mHCGcb2sHUsdpeaL+JJu
	X3E4qrt0g1rrtHtkSflkI1EemlwQRZ8iOqWSvqBogthUK9dhLZogyMr0jo+ItJbTizL89gETEgzuG
	13nVdZUvGjF8Z5eSjawkUQnXJTsPV6x4TZGUE5LGoBQi3Rhr7WCV+kpjXmKl0OMh6g04nAr7eOeg2
	Y5CUxEqpoQSOVIoqbbCw1+PeRZUIb+M+Zv6r6UztlHIE8ye/dwTGLkruOj8UbGdI+rgE8Lc9wgbaD
	RjSKX9Y9usd0EAi2ip5o4l/8WMxB1XLzMKBu66AoOcL0VznfvBary2dneWvHkOqGwsd1lBYpwnmuC
	y6uoGmlQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wyUKV-00DgAo-09;
	Mon, 24 Aug 2026 13:03:11 +0000
Date: Mon, 24 Aug 2026 06:03:05 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aow_bfUQWZWh7Kxb@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
 <aoh-3XJw82O8SmsA@gmail.com>
 <aowcYuXEeqdfHmn6@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aowcYuXEeqdfHmn6@thinkstation>
X-Debian-User: leitao

On Mon, Aug 24, 2026 at 11:32:35AM +0100, Kiryl Shutsemau wrote:
> I wounder if the fix would be to make page allocator consume the table
> and not do memblock_reserve() here? So we would allocate struct pages
> for the memory and poison them on init. And your fix by the link below
> would do the rest.

Makes sense. Probably dropping memblock_reserve() altogether, for the
units and the table, and poisoning the recorded frames at
mm_core_init(), right after memblock_free_all().

Roughly what I have in mind:

        memblock_free_all();
        hwpoison_init_boot();
        mem_init();

and hwpoison_init_boot() drives it from the table, walking the bitmap on
the EFI side where the geometry lives:

        for_each_set_bit(bit, map, nbits) {
                u64 unit = off * BITS_PER_BYTE + bit;
                unsigned long pfn, i;

                pfn = PHYS_PFN(phys_base + unit * unit_size);
                for (i = 0; i < unit_size >> PAGE_SHIFT; i++)
                        hwpoison_boot_pfn(pfn + i);
        }

mm/memory-failure.c gets the per page primitive:

        bool __init hwpoison_boot_pfn(unsigned long pfn)
        {
                struct page *page = pfn_to_online_page(pfn);

                if (!page || PageHWPoison(page))
                        return false;

                if (!is_free_buddy_page(page) || !take_page_off_buddy(page))
                        return false;

                SetPageHWPoison(page);
                page_ref_inc(page);
                atomic_long_inc(&num_poisoned_pages);

                return true;
        }

Yea, this seems better in fact. Let me know if that matches what you
had in mind.

Thanks!
--breno
