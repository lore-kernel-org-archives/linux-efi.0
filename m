Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793789225;
	b=fdfSqlDA48f0s41mgFbrRDpWLrsnmmPROl3tbCBis0vhjBPv7qFT/FcQbmiM276Km4l7
	 bnJJgx+G91CZlQRJmJWpZJfqrtlI1kSBMX+pTNK7lTeETjtnHFhUNMDt5yl2mCMrxDrkk
	 Rquhqsv8sr8qD1XzfYJSKup7jhB+ucGhND5JCqD4oidpXCIMMQ7/W9W28fvFzBLkbqx0T
	 +H2KDlhOGGpdNlgLHilopMcacYJyXWDrBW29kQc/kLLsf1OjGlf6FRRQwy9ZtDPP6v7AM
	 DvCCU1lFxmhhgvTX+X90CVU9n0bh8fmrgEJXJrtRlssZRmsYjGs8eL6Z+P6mfUWoCiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793789225;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=bhOmEa952md/X2FxyjNFbUxSEKG6z2HGY2NSxyblu7s=;
	b=UqKPE4K8/4iFd1Jd6AkM0E/pKnbJHhPaTg2j3Ovl+ykfSHW8LxfZMbm0Uz5nNMC1kx5w
	 tFQCVlQsNknqYhBSlGVIEQKfrrwNV20J5bc4CiD4iQHYbgKYlTDL7xJI/uDRRNl3YbEIn
	 MnW6IDDJYaYwxx7Ikx/KBRhor2CgzpVjdwno/vsHbcm7v648y4EtV0QDPh5Zo8/u5SEOP
	 u7y2TeP92mmYHsxis4PjtfCjUTpEVz4xVaFKCyM5o/G5aIL2grjD6RrdPQqfU6UHn58kL
	 EtQayShi9sMU6wUwx/A3B3MU/z+fYMza7/39LkripRv6yP2gYJTEak0YU9CO1C8nFPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="VJrT2/1Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E977D606A329;
	Wed,  4 Nov 2026 10:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJrT2/1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDC51F00A16;
	Wed,  4 Nov 2026 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793789224;
	bh=bhOmEa952md/X2FxyjNFbUxSEKG6z2HGY2NSxyblu7s=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VJrT2/1QLEtsT7IAJHPVIQ2ISxt4hMdc3map/aD2+trIBN9mSj3nx2Q9bTpfMT3MF
	 cGNw4vlunjJnW2IgqkdannjrufnBjkEyqAdwxHFKLVUEMfE+G1hX5DaeWBXjmWX36S
	 imsPN3k2zFxiGZhrAEtQPYo34cnkB1wIfefgCgCRieHnN8ascqJ5oPN4Fh4QbYtHlq
	 7/wVgTJuM16kHNFu8An5p+QSkHTadJXmkvy+7t9tMNoYCB9OvYjalYNNGUIRajXJbd
	 YN4n/cPqhT0kWRFpjhDg6dKdJbl4dZ4IR8N3yu9oo0FcspYKIrDgWmd+hMBEXfPmLJ
	 lIvFousnuVg2A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BE33A198003A;
	Wed,  4 Nov 2026 05:47:00 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 04 Nov 2026 05:47:00 -0500
X-ME-Sender: <xms:Hw3ranMJL85RL35ZdIqlVZy7B5jeINP5BbPezeQrDi-SF2g1QOUblw>
    <xme:Hw3raswrF1gip8laAtOzF-VI-pmh8_xio3Iv18-kjvZb7gAJgZagRdgIgdR_Z9VpH
    3aGcEn9wEYZRA1vkqbcSrpJfGBueP2SI-2Ks1wLLANcLZGoARC6PFs>
X-ME-Proxy-Cause: dmFkZTFcPavaLWIfgpoRM8kguzVyv4s6FUkLYAQNGvkUHQVN3xVxVzv9NryfTRmBx2+1+T
    O8Nt36zML1hPcpqbZ31+TrK5u1pojcuEtJ4d9wGWUhJ3PA4GR64AER0KVm/mg5J8CEvDjb
    87JxU7ByEHQUkd87rjl5YJ6VpVGYEteXdzVHpDfaZbUb25I8yUXHEzXzvTki5YhHrX0+Ff
    dEw6DUI60ChXVG7qPis8rKSRSBjgm3FH41orMrqi8AzmwVObG7DSV0A/n08w8QClZ1o7l+
    535jOrxx7Ryk22b71pTU7piz9TOaOxspVPbT5mctmMzGlgM03lWJfWSB8QGDefxIJWbjYs
    SWRWaf8wtqVtG/y8VhcGvWaXz0LsELuUcWCWXl8uYz0FlppVOkjLlTI83jJnQvIsR6wW9A
    CHbjI9SRCOspRJI14AvVQ1gcqqNFg/aukBnzTQSgDXsMSAvOzAUMquE+WlSukqk5s0kWpa
    njVLPVqOL6PMp5x3IoZtBkRTGd/N3jxEy8pK1FCY/kEv9MN3SOjavcn9IuRnWmh/83Rc77
    6GG8VVWJng4fdcHXdysUYGD2mMNjsZxD/N6+r+yDqOve4t+C3EzK9VWq9skd3rDm5qfSyS
    0v1Q3nZRYNBxw1A74kxjY01EsAfvmnziAM0IIiwwBMPqwOU9vx9fO+TEwqTQ
X-ME-Proxy: <xmx:JA3rarOc2on3e1xb7iUIdCss_xeJ3zdgPplKMTBac8Yz3xu00QXGXA>
    <xmx:JA3rakancmdTtLZDM22WzdIgr8lJQn3ocDdsi_RjrSD_VtAdD8coHg>
    <xmx:JA3ras7McSax5611gqIhLQldHowrwdBi4-xbCgqokzbp7BU_VCYGyw>
    <xmx:JA3rarBd0hh0XKEJUgCfUXIrbQcvdDWVyz9bN0fiE8VImxPs8sd5Dg>
    <xmx:JA3rar7rbi7TJSfdSFS58Fu87suf-sHWjoQzGw8ON1-8MnFv5N6AUirL>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 3A57AF8008E; Wed,  4 Nov 2026 05:46:55 -0500 (EST)
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
Date: Wed, 04 Nov 2026 11:46:33 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Arnd Bergmann" <arnd@arndb.de>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "David Sterba" <dsterba@suse.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-arch@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
 "Mark Rutland" <mark.rutland@arm.com>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Paul Walmsley" <pjw@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Simon Glass" <sjg@chromium.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Nick Terrell" <terrelln@fb.com>, "Will Deacon" <will@kernel.org>,
 "Alexandre Ghiti" <alexghiti@rivosinc.com>,
 "Conor Dooley" <conor.dooley@microchip.com>,
 "Jonathan Cameron" <jonathan.cameron@oss.qualcomm.com>,
 linux-integrity@vger.kernel.org, "Palmer Dabbelt" <palmer@rivosinc.com>,
 patches@lists.linux.dev, =?UTF-8?Q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
 "Ross Philipson" <ross.philipson@gmail.com>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "Song Shuai" <songshuaishuai@tinylab.org>
Message-Id: <cc4d09b6-a56b-44a2-a137-f27bc87e96e3@app.fastmail.com>
In-Reply-To: <20261103160138.GA3165945@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <4-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <20261103160138.GA3165945@nvidia.com>
Subject: Re: [PATCH v2 04/15] efi/libstub: Add a general way to get symbols from the
 vmlinux into zboot
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 3 Nov 2026, at 17:01, Jason Gunthorpe wrote:
> On Fri, Oct 02, 2026 at 08:31:41PM -0300, Jason Gunthorpe wrote:
>> Currently the zboot stub has no access to symbols in the vmlinux. In
>> contrast x86 has a voffsets.h header that allows the stub to know whatever
>> symbols it wants for the decompressed image. ARM DRTM needs another 4
>> symbol locations to work, and it also wants to compile the DRTM libstub
>> code once and have it work in both zboot and embedded.
>> 
>> The current solution in arm is "code_size" from commit 45dd403da851
>> ("efi/zboot: arm64: Inject kernel code size symbol into the zboot
>> payload"). This is neat, but it makes the zboot and embedded cases
>> work differently.
>> 
>> The x86 voffsets.h approach is also nice, but it can only work in zboot
>> since it relies on 'nm vmlinux' to extract the locations. That's a
>> circular dependency for the embedded stub.
>
> Ard,
>
> Did you have any further thoughts on this patch? Did the sketch you
> showed me at LPC turn into anything?
>

I will get back to you before the end of the week.

