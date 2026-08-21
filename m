Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6457446EC64;
	Fri, 21 Aug 2026 12:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787314446; cv=none; b=JLeUmdhC+RXUrVNkKwvkVsy1Yh1KVBnxm3vH0ObtiZGunpCh/hXRRdbQsi+zTBaizkib/xtBvcJLM25da0LnVZ7jVo1r6Q8cqXu5zKhY3DTZyU6sr4hFSQNKn/7MM3MaMwyzSJwMyWq86g6foRLOUg5VFp7oeO+RRjCCNCUb2XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787314446; c=relaxed/simple;
	bh=hmiMBjXqLKgMV0hju98HmsRX3c6u918l8d2M9ySag1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LmWi3abOESV22SLNXRIjUc9yEMY1TK6MjLrlJe88fEuQjgyV0k2WZ3GPoKh5Ubz8lBfvO60w4gmkYbVdiw6nQ9bxvQUTXHya19WPfcxD/9BBI1FWw2hhzcmvQr27oAapyWyeO84CXWI22JMpnXUd/kiHCzkf7w3FTQT+j/LJ/MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9xZm3D5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9xZm3D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC531F00A3D;
	Fri, 21 Aug 2026 12:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787314441;
	bh=CTo43XzM9NUgOXbGuwfipf+ydqi6G4CBeuCh3lZD0Nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F9xZm3D5H0/Uv5L4hcfihUo3fdiP6Hvgp0pL/WqUhjpGaOHM2CVV/0ptIq4eKlwfK
	 FsPGqXS/E+8QkznG0QEk3zwevPO6GmOxy1mZlVl91/S4q7FhQAQfbYxyyAGfWzpB5n
	 OCUpZ77tYtrAeWk/VAqHntzrrgAsg0nQF+R5T9RyLubhklm2BaIwHcpc13hTm7oG7s
	 2e+nAR1EluuhNQzeHyeg6+CzJp31+v3WbFpm9LZh/hmCajLWCfVkwO/q/fiSz2bs8T
	 aREXF6K+WifJQlwID5ssZx18r4UwGI2/7pBkL+tj3EQuicn5+G47E7sP/7Axyyyw5g
	 wwY/BZMJZsBwQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 70C74198003A;
	Fri, 21 Aug 2026 08:13:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 21 Aug 2026 08:13:59 -0400
X-ME-Sender: <xms:BEGIavtIAoKVV-dIUxyA4hb9b8Po-Uu5F4VgIusSrZ-ftBHmlY5jng>
    <xme:BEGIat7ayKzrTI1y15oHrgt9rZjGhVRwJ88mUjdy-2utV-KQfaBZHfbpZRKTOsW5J
    v8M3wmS-gpiooODj0JS8q1hSF7qAOVENRKFg2zDZ0BE_mquNa5yS7e0>
X-ME-Received: <xmr:BEGIaitgIW0wcqLrWhbKFvZzMMlLP3dDs7o6QqHmbf7_EVtuQx_kzbO0wZ8>
X-ME-Proxy-Cause: dmFkZTE9He33vT2aJi4Pjqa5rACtwZDlVpfI4pvolegsHlra2/oFh2wdyqtRnKCr7ywq+M
    g7eAQmzQdACCzrovzxZQjZLPJDG2xAorZP57RC0xH50KqrbUdypzNxr9qdXRN4bTf2+ipG
    8BG+yoJanZ/ks4GQusJQpsrHrqlZ3pkbjRdRuXzpOg+mRn7rz7S4lVv1eYWakrw99Kah4/
    iht0P1kYzC2LkK1mqvZMgZ/fsSwfWQ0upMFvWwktgZqJ8iC+7BRE55Digr9Ry7WRH9JFi8
    Kb8wR85a0slyGHElPl+sDK29U529kPWpZH9uxTUMneVTVAYtIdFqt6xqapZTpJeobCnjZA
    AqhU/FAlDd2ydVSCS0xp0Kdh2Si9jol+Uncq7lTx+VsGBLBu+IKT539uBKtN3GnehctHc7
    PTE77HXSbIUf1+t/VygZXTi6eWofINEX/PrxK5Q5yrLsnEup2U33Y9sEl0T9yP61BGppub
    7ZyzSoH+MLna6iFwrY8dl1VC41tjkoWcU1GuEVkP3F0nTIl2rcNksi99bVv9leCNaHtMsI
    3dcMTXQ7Hlvai1j4eDWW+W8HeLhNHOFJqNIzkL8bA2xvH1EE5/bDmVwuUqT/BokDhXDCG7
    QzPrrMqNBqe3DbycJbEiKK3Rk3nE1WZz0CV1j0ijiJnEAO5aRQTAHZJnD9Qg
X-ME-Proxy: <xmx:BEGIav0shc_srJcckxhEcn5oDMYwQ_YVNN8Y9Pwq-DETg5Yif7W_tg>
    <xmx:BEGIav_NHwxVYGOq7rLRpIKJRpCtPiEYVsIEHb8iVFOJ21eGKAgsiw>
    <xmx:BEGIalABELee1iEoH2WNi7ANrrvQWoPgk9ckhUDbzIpxiLmT6cXcsA>
    <xmx:BEGIalDYjzJR1SxX6hy-1IWiby1sZppN-4yzHtO09zhnV0C29Rqblw>
    <xmx:BUGIalJZZtHDigw0yvLmfJd05hNqkKQNt9tE914dP_xZoOBxAW9zpEUg>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 08:13:56 -0400 (EDT)
Date: Fri, 21 Aug 2026 13:13:55 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aog_uH5fTsJzXjjx@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>

On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> +	/* Reserve the table itself so it survives a further kexec. */
> +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> +			 PAGE_ALIGN_DOWN(ppm));

Hm. I don't think it is enough.

On x86, kernel doesn't keep memblock around after boot (see
CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
from page allocator. But kexec can place the image there.

For !CONFIG_ARCH_KEEP_MEMBLOCK, kexec uses walk_system_ram_res() that
looks into iomem_resource. And memblock does nothing to exclude the
memory from iomem_resource.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
