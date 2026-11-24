Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537604;
	b=hlIlTB31FH0bOoAJMbDy3MvHGpOd6nvEOi3tX6QGQYEspmNlMh8Vkx07uSruoQoBOoou
	 SeJd98kduMEnUs3kbLa16sHdXtc7PdYqD+iur53xyyLVUBvQDxMhXGqPzMIA/8giJdr4y
	 rwzXjqIZ6yqqvUMy1HBQOVDEGUvQGc2nYANt7+CubggOuAv1CaZIk5fZi6NTwMXtirDjk
	 cjdUdTHVCwAZSAKhyvN297bfctIKQBFVBLANLgpJ+/0ZgLRjQF2kIJEL5Vw4T59lYfEES
	 13niON4TUq3OE6sj4cnku0cQdqsJZFxCnvR079Ujo3AgFSQ/RpjHcfiHr5ew2CuScQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537604;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=3ieuTKgTmupFxrU1Sy9W+USlkxgIOvC38/mQnd0MGzc=;
	b=4oMB1Tga8Yi9rpkhNLQg+1How1EjvAeUPgqyDfu0Wc8A7gltejOGxXWhk3J0bLceCbiN
	 o0E519OE41E4n0ea24c57ojjqV1zxG1ZylmWCLiYTDVt/jF1j7jS7CVin78WIJPp0FA+m
	 QVtVhkAkeDUsgTvP4e9XThRZNOSFS/evqH3KddQ+alNm9x+5xlsL/mk1TYe9VCNvGgpXO
	 HvkjABVW4KlooCU2Zu2TgL4Bd9qIeh4BQ1yRxLdzjG/6Krtxkr8wUMuXGCqSKmF1VU84k
	 K+W8Wir3E/jhgR5q3wDSfGkLVO9NNuI4RpkU7QXBFrN4eqcb95kKXl5/CBCtEdZ24nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6L1RhGw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFEF606A31E;
	Tue, 24 Nov 2026 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6L1RhGw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254691F000D2;
	Tue, 24 Nov 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537604;
	bh=3ieuTKgTmupFxrU1Sy9W+USlkxgIOvC38/mQnd0MGzc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=j6L1RhGwQsaoRh1nVJn7PuNzvakza5gtaiZLoJq/m+IiguPyeMh3cS3fZfGdgtGlC
	 15ya3i2ujfvmTT44rx95cBNQn3F/KudsUYbdNtueakfQ0ir8Oz2kko/9ervRrrbQys
	 Y4OYIPv1aljxchEfsLZmANOX0wgsnTyR/p74kcdvopIp4Rt8o3kvYV1a4jW2lS6Tpg
	 wCNly5fKgf/CVUZzfp/413J3/6ya4f5XjvqESi090BRzjcgxTqY1YPW/ybVFOfAhRG
	 BZPhoBtQ6TzLTciE+qUV85eCVQfBfdQuyZ3X5lLqMJtESlFLjig3JcWsKVc1UWD9pl
	 PWV3HJs3Ujjhg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 64DFD198003A;
	Tue, 24 Nov 2026 11:26:41 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 11:26:41 -0500
X-ME-Sender: <xms:vroFa1iKzJcRFma2WR9T_8ifmTKzYiLTfc_pGVsghlMf9rOWvhSqJA>
    <xme:vroFa03LEBspPgahUh1xWn3UWQP1ogEsYVLwahDfURdKV-i6Q8XfyX6FtotFDQGpZ
    _BlhJXdIhHZlDXwjiXDKNxeTSlMGumKl1_eMRRfwtk2NouMbKBYqAo>
X-ME-Proxy-Cause: dmFkZTFK1SRhx2fcvvqjUveP2099rvc9Qqgqkm6zs8iZkfpV6opMlmIptApe4Y+xP/FpCz
    ze1RuYawTba3QUB6nX7Y/xW7wxSLien47DLY7uc8GeZFx24VJhLiBZGZPb96x/pDRAU3iE
    4tktzZrZoaIXvZMzKB62mZf9XuuMFTNKutvX8uOtieZ40/qrT7szA49zcuuuXJHYjtQh7y
    ZOA6Sl+gjtYF3XxDxQ8chsK2eEk/eAAlU+yQmdUANx4B+IpWxavF4S/8tBoisLFGAbszDX
    FPUX1luYY6i60WMQq6hQDK9NwAcU1umwoSULVAGjpj1g9U7BKWyorky4VSd4mPYl0pSUtP
    ClTuwjEaarOCEy0WwSVwsrE9WtA7HibLwLn2lCgLyaHlaT1xqwFZZUZmv2CBk8oSyQg1hi
    hZY1j+b9FROUGRItxhIHzKNo30zVZF/hqyMwnwNtallKr3uLdE638aepUS5bRyMCdDmNqs
    8B58vNGUZ4Gtl4W6b/x59i2f4hqND6y7QKGWvdPSC+u5QqaihGPnnOuJS8xtucvntG76Qu
    qaX5jx/on0/xvQH8Dnn9N4x2HTl8fp7Pt2yRplUf2DUDMtn2VPQp7TVXRsEHERJiL2jb+M
    8Dq8Fa8xLSeOuc4lfGbo3i2TAIsyFEGdB0hEEiU/CBe1OQFfIhqHXBcTy7LQ
X-ME-Proxy: <xmx:wboFa8dqwp3xU8riLhiiS2MPpLKE3ocsL-ZO8_WPAlYX4DX7uOQMDg>
    <xmx:wboFa5FcJk-n5Yx9uoDR2iw8DJk_zpFiAehd4yf5gV-MHpnt-t1AtA>
    <xmx:wboFa3v7kQ_dyVuuMXBQ7NPGnhA_rwJDM9nxd-PbwXzw714Jsds4dA>
    <xmx:wboFazrTexgvGU-sWY3wiHdgl5zrUGFxJNStw_GWwNPv3i0rYXDMnA>
    <xmx:wboFa-mJL-5AF4zgmplLqLwhcoa44kTPUMNvfInOskBrDJ0RXPFdRGoA>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7C79DF8009D; Tue, 24 Nov 2026 11:26:38 -0500 (EST)
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
Date: Tue, 24 Nov 2026 17:26:17 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, "Dave Hansen" <dave.hansen@intel.com>
Cc: "Pankaj Gupta" <pankaj.gupta@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, "Tom Lendacky" <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
Message-Id: <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
In-Reply-To: <awW31hUpXuujSAXA@kernel.org>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
 <awW31hUpXuujSAXA@kernel.org>
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential guests
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Tue, 24 Nov 2026, at 17:14, Mike Rapoport wrote:
> On Tue, Nov 24, 2026 at 07:58:31AM -0800, Dave Hansen wrote:
>> On 11/24/26 07:56, Mike Rapoport wrote:
>> > On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
>> >> On 11/24/26 05:32, Pankaj Gupta wrote:
>> >>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the un=
accepted
>> >>> memory bitmap before the command line is parsed. memmap=3D and me=
m=3D edit
>> >>> e820_table only afterwards.
>> >> memmap=3D and mem=3D are debugging tools, right?=20
>> > I wish they were =F0=9F=99=82
>> > But AFAIU they are used to carve out "pmem" or PFN-mapped memory.
>>=20
>> I've used them that way for development, but production pmem systems
>> always had persistent memory in their BIOS-provided memory maps.
>>=20
>> How are folks depending on these in production in confidential guests?
>
> They shouldn't but you can't guarantee that.
>
> But I don't mind letting them crash if they do :)
>

I'm fine with either approach (i.e. disallowing it or doing nothing
at all), as long as we don't pretend that this is something that is
expected to work.

