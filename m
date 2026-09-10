Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF9C3A6EEC
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 07:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789025626; cv=none; b=TxvhUyPzHrKu2tyBxIFipppFk4lB5sVZ3f5hPLZUrfQMnyA1vvXkn5IJvLIhYePXLyXuRCa5/yveDlRey9xEKOYZVPNcwt5wCGXIme9n+U5Gj5OWSgcsAgqVT3lPlmYo5PYdfpTpxb9uBDAQgILjK9KnkavB2ViZQE6nvdgIHy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789025626; c=relaxed/simple;
	bh=Pf3HZBBEF+9h15SHCm35up+fwk41VfMyDzQOFqO1R9k=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=pnoEksSlQeUXJjfmgm+1r5E47wxK8ftmv8WtSgjIZWqvuYSfhVWMzxkwMKOEi3NJyXMvBlet1vQNmRtvYc8XT1SYK7o1X7Q7v0H1eNFdMl5RpDAcg9oLAlredtWF2J1IUkUKLbJ/y1BybBvKYczDvm43+H07A6tubhhIRG6soqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYkaTNog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYkaTNog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23D41F000FF;
	Thu, 10 Sep 2026 07:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025620;
	bh=kHBIS98tui19QlB+Qy4l90svkBpYwDMGk63JNQvC2pg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=SYkaTNogiCApZeCimGQ4WYNE/UCTSgVjzltzjeBko8/41T9EkRDvRZRfKqZP9dzMe
	 6pv6M8DKIghj8rRZaSc6PVQZ2fbLxEdBeVOYjLZ6NtsfUT7SxmEAXe+N4JSZI0VNAy
	 dRVob+OvP3oeja/xj7QLui3+rA97BIYSBuAg7sBjzzmB8+0/B8F6zmvyprInNRROOv
	 bFjE386jVlUDt9zOIaJwM4SYNNlB9vvJA83UV+tzBif9yuGNCFJWZ10Ezd3+X127ZE
	 nedt/B+61XOoq4xOEcDUTWVdMUD1klc+lmT7dh24+J953+1ShZSlmDVQK6PXNSwEZi
	 8Io2iFbKflHoA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6DDF6198003A;
	Thu, 10 Sep 2026 03:33:38 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 10 Sep 2026 03:33:38 -0400
X-ME-Sender: <xms:UV2iauShsNFZEQu9NCHQ2gb7MSXcu8jYcNQnL0HEo6J5imp-DCTNRg>
    <xme:UV2iaumZZssFwB5PCYNinY9M6eK_GPkfmznKnDvlVZpjnESOUeKg0EzRv6gtCKv-C
    iWixsX429XvoraDnJaL1tuA9CG0GjDCCg_Ej6DKQOg_VlzXjOZ8f_x1>
X-ME-Proxy-Cause: dmFkZTEsukaUZh49mKtNEtj4RH0Wyopa7oOwqByrpGZsWQuUogfifVhVS6t09JaZ9Z8GpX
    mKd07dITkXBvyLGuhENEzxBGqtJBdPqDnoH5Nu39CEjA+ab6rQ9Pqt/p96VEZ18hnDAnxi
    lKbGQUimOQvRHHl7hxzbMjGmKUaDYCuvjkpHPt7OHI3x4xpXtxXMVVMEXwQhoZDUbn/1ZE
    DkzNxfRW8/af7LfOXWdGEa3L7Alj89RTlCNc8s2j8Nv6EouHsPZzo/DqZGkxzSUdFWmeeB
    7/iiD0N41fNbTfMjL32dl5UP6pJbN34d8y5b4r7rQDzj9uR2LyN7MSpwT15QpVYZ2bdso/
    bfvpGdiW+FTmOZeHQhpk0Q2Kq1qvqd+0IncFg7bJXolryc9Zk2Tctzx0Vapii9nvkkM5nw
    1u9UepZ3p4V53n26GBlTG/OiP+uElmvyk28dqQwx/87ZCLFrCyVukmzLe/XKjjKNH0FI8d
    Hn2XD0pYB6hXkdxmPshGxzaMlmPrhjXOQHoe2w+plZrxioaFEu4YOA5XXMk2LPLHhmCdud
    ko7jdbH6G1Gws0J1mJ/wWsG4MoMPUZcU9wGKpl7JHttDNpTQzaSULy2kLOB0QavXObsBTK
    LLQcVL6n58haOFVH8KK6gEgABxHwAYNPE0Do5VBHLoAXT7cnh/L4Buxlkk7w
X-ME-Proxy: <xmx:Ul2iat6S5qfeMQ1qve1VVaee2Mmtqn4nPccWwiel3lwfRViLiLD1_A>
    <xmx:Ul2iamVKXtzc_QzZXPMZSd_h2JlbBLYyEGWSpHkfUWIhldra6PGX5g>
    <xmx:Ul2ian9-Az7yna645plsczgKrr29Bnl2FdRTm_YQ1VwosqGpQLPoqA>
    <xmx:Ul2iaqncY2XvHHxGtzLKTNtHifJkuvGKLj4rJphLPPp3GQXoTWwXqw>
    <xmx:Ul2iatVco4BqBl5WTEuJzLn-qbPLWtR5APBwz1fhREUzNvMPu0HuYIOs>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 05214F8007D; Thu, 10 Sep 2026 03:33:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 09:33:15 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Hemanth Selam" <hemanth.selam@gmail.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <85a1dfdf-e3da-43b0-92d6-c7dc2631bcfa@app.fastmail.com>
In-Reply-To: <20260904112009.33620-1-hemanth.selam@gmail.com>
References: <20260904112009.33620-1-hemanth.selam@gmail.com>
Subject: Re: [PATCH] firmware: efi: fix typo "existance" in comment
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 4 Sep 2026, at 13:20, Hemanth Selam wrote:
> Correct "existance" to "existence", reported by scripts/checkpatch.pl using
> the misspelling list in scripts/spelling.txt.  Only touches comments, no
> code changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  drivers/firmware/efi/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 0327a39d31fa..846179b23160 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -8,7 +8,7 @@
>   *
>   * This code registers /sys/firmware/efi{,/efivars} when EFI is supported,
>   * allowing the efivarfs to be mounted or the efivars module to be loaded.
> - * The existance of /sys/firmware/efi may also be used by userspace to
> + * The existence of /sys/firmware/efi may also be used by userspace to
>   * determine that the system supports EFI.
>   */
> 

Queued up in efi/next - thanks.
