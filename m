Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1347D464;
	Thu,  3 Sep 2026 10:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788430144; cv=none; b=M4E6YJtCsay99Cnz6IUfzEJ8XysW+V/XHohC94HzFJMHrbHuCmnAzE3BlgmHV9GkW5f7SJairp+778rP7XRqGz1sMPKma2LZEfGvfP8riItL9stBg1X9lOwXOnGWAVczcCgO6zl1xQYNMr6jclVLGUBZ2uqxYhQ1Tt1FH1gHDg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788430144; c=relaxed/simple;
	bh=eLiA+dfqzAKYKV8yKHzqWUpb8kkjZfPVAUu41IzUDBs=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=rVmko3FTwbpbj4Fsx2o28GIUCJJuxOOiZo3zMb0zI763pncEiGbKHVIfv4h3Bsp09+9yLH71ehKGUtDu6teDJCLqTio86Ma++xeXJuxny4wccQPKk7rmyyf6I6xLnm+An90FxkzvTL6vy9/s9cLsz0hiru6soSCTK61obdRMgaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZycu/qB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZycu/qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46E01F00A3A;
	Thu,  3 Sep 2026 10:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788430135;
	bh=7GZpEYA1fzOE0or0jFhZas3y3yHVIbVDr7LtGH35Nxo=;
	h=Date:From:To:In-Reply-To:References:Subject;
	b=FZycu/qB7z2MxAtm4snw84F5W7cREL2VRw3U0peDO4BNP3Hpmb1oKCTs4xo+yXwPt
	 P5d1o9bsvrVMNTs19xs2CJOYHCqU0fVAdSQXsC/8YHVg08O8MLgL2CX963fWd78QRH
	 op0W6xUfAxtsuQCNYUnIeDgzWrzY8TPhDEVY2RWpmRz56ErFtG91rbDio9l8K7yhNk
	 dtD6xWzKFztzFVsFYx39OYLbbYvN2MljEHp4JvHZ4jsIxyCHZRNEqQujxTGKUc4G54
	 SNrsQVqw5iOL+Of1sLqHKG9wY14fKZ7TlbWaNNs4NiyYLah9cVxkT9tNWPoU5XxZkm
	 WPgIhQuHbkfsw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 876D11980060;
	Thu,  3 Sep 2026 06:08:53 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 06:08:53 -0400
X-ME-Sender: <xms:NEeZak27UzLJVXp3U5JDe5Nv8Mg66icJmb-609lrL-ubmPm2CYjX3Q>
    <xme:NEeZap7BePTLcXkzf_Jor39qcOJBT7mukIh7KEpi7veL0pkCR9c60G7pith1PFGXP
    yb2P8nfUuaJQk7NjLPMfYkvasbdj_ZK_QjQ-xtpeGwrYGTjEBAO5RA6>
X-ME-Proxy-Cause: dmFkZTFP4LVkGs/6Eiz4ZWjuAu6PeA18gXzhVOzmUmVLlvNYCU1KYv8NnXrdaXPnwk7D3P
    wcArjmGwpfnDSsgJvtf71KxLi5eZjOeEo+9h4W7BvSji9MAVn31b0XsH3V0F/cKN1KeXx6
    gVO83HMADDlyKCKGg9gCprVStjAM2oKXdYoYUU8DWf6iQu3V9JhtU1S8p03cF4mfK+3OYT
    7rYmz4W22pkuuMhzG6ZouE2Nk+YBWREpgUJjPgNTgbngqkql6/8+48qH3+ZGQ2XXzvPhbL
    yEcGGJI3lrKKpFGBHcyLeTaiNzXk7subvLXvBZep4PMceh+ow1cIGetPr5Ave5HYRQJrks
    Mv/zwATDdfIJYBB8iKiA7wgBpciwx097Eb6iZfM30UA5Ovgt0oM0p4fNluTYjLp3ovhQ3r
    +ktVijxXZ6yLwG3vUwMm7b6Ges9BM331hu3XrQ6GOod45cAqnrV1AVtqddMFca7HOwUZSO
    rw1posppYWuSy0fzVxscZARry4QTCfbVTF0bzoV6l+wsWKPBYNBMJOV5157O/HjL+pCEst
    lKfx1VJslf2OhHGHwLz2dPZAb3MPOg8iLJwi3XdyLjAfuhK5C5yW/uPjqtNKQI/TV5o3kx
    WD+d6/t1kjZYW2kfnoa4RkC9H2SrfIo2tsZMJxALOln56oeSXVj5CmS8fDjg
X-ME-Proxy: <xmx:NUeZahA3Xou0EyZ_aibInu-K2q6U7eLJ-g36794umVlnfMXXe_8o6Q>
    <xmx:NUeZaocrUqP4yDXyaj1JkBBchQ2uJE2zcVqGghUhAAtLfkDb6XgsJA>
    <xmx:NUeZaoIaxeVxb3Icdx0iYBJ5Ztl3AGh9ol3kqz7GB7vqNdEBzIRyVw>
    <xmx:NUeZar1WBg5xRtVyrlnj_Ti4PbGxx1NLVAspPhgvQimIbg4cLpdH_w>
    <xmx:NUeZaigXoM8udZhW_1NTPPW_AAnr4EGulAgdAiPkDIQPzjV3eAs0gg1a>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4131DF8007A; Thu,  3 Sep 2026 06:08:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 12:08:31 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Junxiao Chang" <junxiao.chang@intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Message-Id: <be731d49-398b-4b5b-9de5-b94d53177f94@app.fastmail.com>
In-Reply-To: <20260815095057.2461943-1-junxiao.chang@intel.com>
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
 <20260815095057.2461943-1-junxiao.chang@intel.com>
Subject: Re: [PATCH] efi: add dynamic control interface for EFI runtime services
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 15 Aug 2026, at 11:50, Junxiao Chang wrote:
> Add an interface for PREEMPT_RT kernels to dynamically enable or
> disable EFI runtime services.
>
> EFI runtime services are typically disabled on RT systems using
> kernel parameters such as "noefi" or "efi=disable" to avoid
> long latency caused by firmware calls. However, this permanently
> disables EFI runtime services, preventing operations such as UEFI
> firmware updates.
>
> With this change, EFI runtime services can be disabled while
> real-time workloads are running and re-enabled afterwards,
> providing low-latency operation without permanently sacrificing
> firmware functionality.
>
> Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
> ---
>  drivers/firmware/efi/efi.c              | 31 +++++++++++++++++++++++++
>  drivers/firmware/efi/runtime-wrappers.c | 28 ++++++++++++++++++++++
>  include/linux/efi.h                     |  1 +
>  3 files changed, 60 insertions(+)
>

I've queued this up now - thanks.
