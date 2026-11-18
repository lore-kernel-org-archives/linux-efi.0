Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020936;
	b=G1TjBs5YKXMBvwqdMaMqQeTb5YuZZX7t63YVDtrp2BIAmoJAhjFKBTQkruehVOpLAz62
	 KPMzFQ9LC1QkqGACAsMd1Q/4Vv0Boyd5uLsANOvzM3FYgyn0DwIA/DISH7Tco1+Wd/Rfn
	 7UMkYdaQ8giBT7tr7j3TADRTBU2CdLXtVnx53hdSr2p6+rfFdYTH7HZ2wKGapzwAxxltc
	 gbK6SYV/auIe++GqYURiarDLfKxWPmCQM1a/6GR+9QAZEQ43alewAqkENXmDnHE8A3hcY
	 gewHnsWJCBKi5kWDRdgzl6hr59pLZ/paAK7bhdbgZX4AFdT59MnyQAhbL1G7Y7GufMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020936;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=TloHPhrhNqY6nCus3vs/KphvMaLLFJryS2oLt1zyZ1k=;
	b=C/o3aQQmbrC/4PwjZtUU6KFyFVuFlhjY45BqgRVuNS8Q7rAgcKa4UHvWnxN3ucEhH+Qh
	 mSKw2ZghuWuKaQ1envpmqW7gxgfsADY49t2pBDOR0ZFUOL83hx+6BDI3VCYgBQ8REQbkk
	 OCjv/AXf81sHjLj6DqQQQodpzh7xyDfFmmDBEyjb6NepLFJcmkwgqTwwD+Frin3Q6pX+X
	 RECPaUv9clTW7yIBMd+W94xqho2vHgixiM8aHza/1DwaIOrdixwqEc8UKt572fF5STiUq
	 rCbXLusSeDHkg0m0/Nbjw4O6YXJZcZv9PpvW4ayvJ/fZ5ecaacqV6r01TmZ9JR2VieQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OamlvOqh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AD9606B586;
	Wed, 18 Nov 2026 16:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OamlvOqh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8401F000CB;
	Wed, 18 Nov 2026 16:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795020936;
	bh=TloHPhrhNqY6nCus3vs/KphvMaLLFJryS2oLt1zyZ1k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=OamlvOqhxirvwC7BPGnV4tj6viuAyxy4mc4WBKjndgezzy/wUZlLmT8vcEREuQ7Sq
	 s2NfOxh2JazHplDPfsO7DCGfRkMYFWsR8HtBrVmI6E6tp+w5Rtb1OSh1+sQyG10Ddq
	 slDuu7us33aFrSTLlwJFxiO/9DiNQtJjtoRFR27Wt3sZqjzTOKtS0dn9s5Wkdlagk+
	 1SadIWtjH81CekbO9wLHRv3hmgIyHJt/r+oomwtmILZsVuC9DYa9tS8bjdy2y+n64b
	 YdPSj8rZKBnWB2FwpO+qOOxmn2jvUqvwzPRku/2lIN35dKPf+xY2jKiE8OZmt9ul7T
	 DuH62QjMkh5fA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7ED0B198003A;
	Wed, 18 Nov 2026 11:55:33 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 11:55:33 -0500
X-ME-Sender: <xms:hNj9atb2-D7NFNGijaaqB7jgP4kEx2RypHQpJkYUoIDHTPzOGGbQKg>
    <xme:hNj9avMwnHrV4kaB8keEcgERyFRqMjr2q1na8YduVgPkWc1Il8Dvta3HnzKGu2fSJ
    hXhz1-ShL4plBjMe5GXw7VAk-6sY_2nWsIp8OZtcWGly-5y0WQ9NIu_>
X-ME-Proxy-Cause: dmFkZTE2zs5coRanx1EBDyVZs62mwS7IWhaCSGi7+opznmSnW6+B6IKnGwccWEU+AGOq01
    pdthN0qhuuVA6uNi6dfg+zKExwl0q1PLnCgB9UML03IpPWOZImN8jM8PNqXDmD73jt9nqp
    /XXQ+Xsk2IM2bjPxqLocC4z0ShVPVAXfxwP+Usu0oMYpJx5riB0WHhtXRwMfkop73zZVqT
    Mh3V8BnpxgP3PhSnSq0xJlSF3Ijv1o2qoKOUIIyhnnzA09Ja1cAg78o+guPaNFVML6eBIu
    Oeht905WKtsfx8rn+FB6tOZq3H/2FeL3g7sknJKKgAPHkgz0B0BI9OEYzg+3o6qHQPPJen
    bvuoA3rHkc0s577IX5uJ4nnWlRQMo1Z2AwoRBXkq6MtzDJ176FvxwINlMSxWcNccDrRaPr
    1nNUFfgcQ8jg3H2eFYwIQvBeeSwPdUvhT4DLSS4BLHbxyGQwQ0CM+c0ufqG8x+ENZ51yDQ
    VjhpddcwXUe3ahNDy/hekDVIDkNkHYbDMj3VtEqMRXVCCoXvFWUZnctIYnJSD1RYI8GqRe
    n9r8IgJjcfipogQyBLFqq504niQ6icNHN0DuEPyKIz+FoycBUImh5KKv2biFWq3P+zDLt8
    fmEqbZwut3YntF5bknf3o6VrwBRHHjjJ6rY3PtFqe78FZ+jwyxQ/iboYh29w
X-ME-Proxy: <xmx:hdj9aqmCY-zK_-5TI1C3-bZKiFHzINht0tKEPEI6MeFZWNUhs55-Ng>
    <xmx:hdj9aqzRihPwlYD98VBjHzH9RLXNmhZOcmqOAj6JwFYC1Bvb4A1gxA>
    <xmx:hdj9akMWRdOD5DBNLqXC3eN7NzNKL9D4BB6xmehOgRBQbJxkAujRvw>
    <xmx:hdj9aurtn51-VjpAeqOL0Lnp3zMv9zcGycXjde_GBx_188zFjduIcA>
    <xmx:hdj9alHjU1WBrY4TQ-Pir8YVr5_QmcZ47eFSKkj_URmfMq-EkHPEj4fa>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id EF430F8008E; Wed, 18 Nov 2026 11:55:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 18 Nov 2026 17:55:11 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "H . Peter Anvin" <hpa@zytor.com>, "Ard Biesheuvel" <ardb+git@google.com>,
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <ab8628ec-9476-4f3c-80fc-b68556803002@app.fastmail.com>
In-Reply-To: <F6E708AE-0476-4E9A-A39D-3DF15E91EB80@zytor.com>
References: <20261111091843.3621782-2-ardb+git@google.com>
 <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com>
 <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com>
 <F6E708AE-0476-4E9A-A39D-3DF15E91EB80@zytor.com>
Subject: Re: [PATCH] x86: Make the 64-bit bzImage always physically relocatable
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 18 Nov 2026, at 17:29, H. Peter Anvin wrote:
> On November 18, 2026 8:18:44 AM PST, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>>
>>On Wed, 18 Nov 2026, at 16:51, H. Peter Anvin wrote:
>>> On November 11, 2026 1:18:44 AM PST, Ard Biesheuvel <ardb+git@google.com> wrote:
>>>>From: Ard Biesheuvel <ardb@kernel.org>
>>>>
>>>>On x86_64, the physical placement of the kernel is independent from its
>>>>mapping in the 'High Kernel Mapping' range. This means that even a
>>>>position dependent kernel built without boot-time relocation support can
>>>>run from any suitably aligned physical address, and there is no need to
>>>>make this behavior dependent on whether or not the kernel is virtually
>>>>relocatable.
>>>>
>>>>On i386, the situation is different, given that the physical and virtual
>>>>load offsets must be equal, and so only a relocatable kernel can be
>>>>loaded at a physical address that deviates from its build-time default.
>>>>
>>>>Clarify this in Kconfig and in the code, and advertise the 64-bit
>>>>bzImage as loadable at any physical offset regardless of whether
>>>>CONFIG_RELOCATABLE is set. In practice, this makes little difference,
>>>>given that it defaults to 'y' and is a prerequisite for EFI_STUB and
>>>>RANDOMIZE_BASE, but it will help with some future refactoring of the
>>>>relocation code.
>>>>
>>>>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>>>---
>>>> arch/x86/Kconfig                   | 40 ++++++++++++++++++------------
>>>> arch/x86/boot/compressed/head_64.S |  4 ---
>>>> arch/x86/boot/compressed/misc.c    |  8 +++---
>>>> arch/x86/boot/header.S             |  8 ++----
>>>> 4 files changed, 29 insertions(+), 31 deletions(-)
>>>>
...
> I'm going to vote NAK on this one... I was already thinking that it 
> would mess up low-level debugging too much,

How so? The last time I proposed this, you replied that you were
planning to do this yourself.

https://lore.kernel.org/all/3f2e8d7c-6029-49ef-8e31-a3eb5efb385b@zytor.com/

