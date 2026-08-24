Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EE036AB77
	for <linux-efi@vger.kernel.org>; Mon, 24 Aug 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787584778; cv=none; b=BlkQ4T2cGWG9KCAremQIcB7x4deAECawmvL5knsdXSzNmRitxKv4TRjBqWq9OjoZTK64Sl0PeMJm317e3YNs1XSk88OpsFklBdHElAwSYu/X5UQF99bbN46ljYFgQIvtzxZglQWUk+t5s/ut3NR9D5FKTR489XDoQoQjPGdoL2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787584778; c=relaxed/simple;
	bh=C5l4dokbwqZu1vI6GZJkZkycmcftzDznQp6+gSr1zIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miffyriuBpTSoi05rBbWYemmoiR3Ekg8bihWzWJ+EfQHK1IS9Qot97EG5Wo9LXHRLyThx1lKJ14cDaQHnNBbe22IJ1v3Q/BjXYE7H8D2OP9R+7d9Z2Pwacs39FHxA3V26LkbH0YktBUytsZkiNCRqqreDLbq5ZnCm/pSkrXGkps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LC36phps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LC36phps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B65A1F00A3D;
	Mon, 24 Aug 2026 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787584777;
	bh=KhObASzU+IfR0vAcTNmjdJh1v1AW8fzRga8XEXTHVUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LC36phpszc3Om6N/zbMxn3qMAaW69FAFVObEdERNIgzHvNnwi6kqgufIEU7/UIWsY
	 krth0vZ8KBkoVR2jhi20myZTjDkhMfwj0bh8fKkFO6Cq9jtg6P6nCbqcFUV5jB7MMH
	 Atx4872f1nd1YEddLkLsnZfeA38+HMzpmURbmib3a6OO3LnOhDaSE6pNJTv9+0hTPy
	 Bjrgk9LvrsETUGXLygWv5zpQuxjCVbMH3s6RiwLjTKFOe+Ay7EtwFS2q3XS1NpfRKm
	 8Z0HQsSlyzqvXZSW1e+1oD5IZQqNP9BmPLOW+iaXG9B3F2Jb6iX1rSTgDIYMg+P6Xp
	 8/2udBbC4RLrw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2CABF1980064;
	Mon, 24 Aug 2026 11:19:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 24 Aug 2026 11:19:35 -0400
X-ME-Sender: <xms:BGGMatyGyn3hvJEAL0fFVjsBYh6gFUw65lsJrw_6381KetY-a1qxIg>
    <xme:BGGMalHPhb2XHbU2FL6zGJT2A6yE8C808HEMrw-XsTFRzBkkDK8YaH-6SScXzeiTF
    cj3wzC4PcJqjEIF5c2m5qGUfrfw6Yyhf-ybFPELzuLx8ScJvRHuino9>
X-ME-Received: <xmr:BGGMaiukLLHf90eQribcfkvQllhnvFKo9aofwwJhz8uPgwNUtUoji80uTlc>
X-ME-Proxy-Cause: dmFkZTGmehEwlTpaGnlMoJpjXQ7nDLGKNpzYXa2GqgT7N6wq+ruWxFOqugBXByk4sBfObp
    8DXKoBbmhM2FrtuaF9WZfWUm/XSEbXQJrXuwkZA4vndDzrBzxGCewc1r+D79yU3xB5jMSa
    B+LVxfNdjqdsuQZAIZKPCnVgEizP998OPUYROmwf7705WA1lsJP0FTniXw+j+FTLaPgO0N
    pd/+oAYahWf/yETAcvBK1S8P36SGEYc0d+vgfJCIyGHc08xJ91rRcqKCNPSEZn0qz0TbQ4
    K8qMxtX4Mw5iXxoWJmcxU6EWREGiIjkBV6LuhbNuw0VpdhCn2mkDjHa2YQj/22JhnN6oEm
    4gxVYethYAkikekOYpmmy2wE+3KgV9l0KZncUeQMPVLxTPopcHk7B/t0+PqwsnOycNBrd8
    vq6icxUXHj7Jja6KFHTxcBoUZDXTm8d53gqsszOR2pEv5+etleh6hqokwfs/29Ugy955AD
    ofBgQAbcPGVZP95X6cOumcWEZoV4/S7+8hr5oxlRtC2g5pwOGUXxs6/iwmqb4/tH9V25nL
    73WPOd3sIE52G6iY59hh2iDy+8Xk/ff8vm/m/EawJVtYutWKH2BHuPh7Vw9D8veAMwYHqW
    IEoiv74acRu1a4kH5h9pzMzAk3ntTtdu3nf9xvRv3t3no9eU5wynopTneZKw
X-ME-Proxy: <xmx:BGGMapXg6FcpXm7Cm04GaXfUrtCknQ9pxDcfaUReND3l7ZNV_Ah3sA>
    <xmx:BGGMai6vp9i2vWDcbOdl3gqXrclWdmYwbf4bGbwOm_kT_osDA1thtA>
    <xmx:BGGMatZTApO_0kD9vDLGKSJP-KmLtAz0lFDL5oYGcOjIy26EW-hXaA>
    <xmx:BGGMamBVp9A3SqBBtHKv3fZdBI1PIl_5cHBIM1ar4qVw-wYmajWJfA>
    <xmx:BGGMaupDZcb_xUq5ERgNzieAYNoVrTFRpliEkJTvATSIEQPawMJm24EX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 11:19:32 -0400 (EDT)
Date: Mon, 24 Aug 2026 16:19:31 +0100
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
Message-ID: <aoxgwbsdy0H1OSBm@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
 <aoh-3XJw82O8SmsA@gmail.com>
 <aowcYuXEeqdfHmn6@thinkstation>
 <aow_bfUQWZWh7Kxb@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aow_bfUQWZWh7Kxb@gmail.com>

On Mon, Aug 24, 2026 at 06:03:05AM -0700, Breno Leitao wrote:
> Yea, this seems better in fact. Let me know if that matches what you
> had in mind.

Yes!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
