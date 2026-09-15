Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625F43B42F3;
	Tue, 15 Sep 2026 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477075; cv=none; b=heXJ5Bv8/kvN2WWxwxLBexDuupIrAKABOK3HzDC4JaFJOLL+tc+dAGALd997V/kh6kqKMx86zL9DGNShPPXWv4ed76OjDBebv3Qq0K+KqwnIOdUW2Sxd2lW65RY0UqVUeDfrlMf4/XxOyyQ9vZQ7pn+ts8OAJONkDbGrE/48RL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477075; c=relaxed/simple;
	bh=GiH3GbpixJxWQZTib2/+LhbytIGDPVlvBxFpYNkmPeA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fBYFq6mASnh6SAoBVGO0bMs6VXg2cR2DJLwxPk7B3Me0o8As7vPQu1G90Mq96lMjPyqIzb4vVuXd60zhuI7VQC2EdxQeTcgmTgc6HveXLPlffx9dakDy1aF5t1WzMhKI+n2DQYMg349IY/SVtxUhwTX29tkszXZvFwYh7FURU+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPMTw43P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPMTw43P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277B01F000FF;
	Tue, 15 Sep 2026 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789477074;
	bh=GiH3GbpixJxWQZTib2/+LhbytIGDPVlvBxFpYNkmPeA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DPMTw43P1rwYTS8P0EXbdxH9rXiDRFb59gyNqvlhle+JxNlmfssYbTgWzntdEf8+7
	 0HO7EWNVGdWxkTBDOHq1HRl8fY4n2eYstKC0w1Nh4TQI3oaBKFXDRd4wJPWDsOsn5Q
	 huukrddzTV6Q7VCVcibqr4n03efIgjVNpxoXY0xT3J+xttCaK1YUDQAMuDshsMMERT
	 nlpwvUx0EBXwTs7xXGytKNk1Bvjj+WZm0uZZZSeJx5bDBk38PzthI+jSrEw1k9g2eQ
	 BrKvM56sdUGbqDgKQs6p9TfLTemtacuOAhA5E+UXITXM3zcHyGF7hIrQAgKLHH7gDz
	 qF4Bl1KsOqzmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/9] mm/page_alloc: factor out the accept-and-free
 tail of __free_pages_core()
Reply-To: sashiko-reviews@lists.linux.dev
To: hannes@cmpxchg.or, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Breno
 Leitao" <leitao@debian.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Oscar Salvador" <osalvador@suse.de>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, shakeel.butt@linux.dev, "Johannes
 Weiner" <hannes@cmpxchg.org>, kas@kernel.org, "Danilo Krummrich" <dakr@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "Vlastimil
 Babka" <vbabka@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Zi
 Yan" <ziy@nvidia.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Mike Rapoport" <rppt@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "David Hildenbrand" <david@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-cxl@vger.kernel.org, rmikey@meta.com, linux-efi@vger.kernel.org, riel@surriel.com, kexec@lists.infradead.org, harry@kernel.org, driver-core@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20260915-hwpoison-kho-v5-1-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-1-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:57:51 +0000
Message-Id: <20260915125752.277B01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

> __free_pages_core() ends by accepting the block if it is still
> unaccepted and then handing it to the allocator. The poisoned-memory
> replay later in this series needs that same tail for the parts of a
> block it does not withhold.
>=20
> Move it into accept_and_free_block(). This will be used later, when
> we need to accept and free a subset of a order-block that is
> not-poisioned.
>=20
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D1

