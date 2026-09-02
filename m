Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1F74A8434
	for <linux-efi@vger.kernel.org>; Wed,  2 Sep 2026 15:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363833; cv=none; b=WIjAIQNjFf2r0cNUZpqa8+KQhksdd/yMSPvOyHpJ3Hk000lJwtA/CDus/PTp08OuZFQxTyU+tvSjFKPQs12et5yfSA7kJQAtazClPIf4QWbRutprR3c+MMckS7HSodgdhT1Z4cL4vu/u0vczXPqyNjBAmJVz1uccuP+N4znCQIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363833; c=relaxed/simple;
	bh=GMNoKQ4iI14wgb4xbEIi1f0vSyV3mDDNdm51wnCdk7o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=mynoDeYuzUzyVSGUV0on3f+Kz0QVZiR4s6bqX9tpD5Q0Lw1VrPq74hCY2ji458CuvYs3bBtFWlpBX7MeHNyVUHRl/8Smoz3fhAhJEBxj2JiG0g+dQtXXHiGyVApONr4sqpe08fIGE4uZCbNDO9M9SAyP4Qalwvlppb0JloOIDoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNl1Nz/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNl1Nz/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9ED1F00A3D;
	Wed,  2 Sep 2026 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788363831;
	bh=8K6qSSkutj6pHrLKr8EdXfF4sFAFJUQ/1Pxv7+fdLuo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=cNl1Nz/finRQJOlIDT3sLZRAZNUGCeeYqqQ76b/jcj22lscfj8dE9BqOl89cS9EAr
	 ZIcH8+UWVuW4XryEjFUi4fKDNCMJ2o9xJEerpyLTDFUInTJ6Lf7nJvb0Br2mj1gZS0
	 GOJTHzFsujX9WgSPf+UsCZSF16jWHGQyeaDL3plVO0EqKwOzXDMe+k8W7ZUsZbj1WB
	 p3W+1rrrL41YTSslhYMRCb6yE3n9UwRBAkfGKolHb3ETnDr3nMGSdEQuHvIV3MmhMw
	 sWM1D4IknomZWvWC5tLLidfxt0IKp5fiCFby+CHsxK9Z0/ViqUSi/8/79D5Bou6CKH
	 DbSbP8D9TTmnA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id B36CF198006E;
	Wed,  2 Sep 2026 11:43:48 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 02 Sep 2026 11:43:48 -0400
X-ME-Sender: <xms:MUSYasiouvoLo_9NAHnyqixhOebbOOXlWTCsnLCHOdWhFIV3jLXrFQ>
    <xme:MUSYav1gDFmOdMrJcOCDzL9PUS2UOsnqvsUXX-dvR36CNMjP4UY-MH9Zr6GoKeOrN
    hpeiy-zqhxsw-D3jcUnAN0mJBpNUY0SlUDiBL2qBNsED9s3-TkpkTwz>
X-ME-Proxy-Cause: dmFkZTGuZY3YmSAQEImWFPYnyorhNYUb/v0Di+W8WVPYg7Fl/RZt9RzYjXTwFbme7148L1
    bqmZ6fDFUVXfLmTp9N6OpeCKGq61vrGRg4ONRES9dnu+d1YvTg9FuKC6HL8QWOEbDWqsX6
    91mMSLi6tWdsaYfL8z9MvpqGn6fEUoBbdz4EIdsZFNiPf/Br/tIyGslcNbcxxLEnBLQ45r
    i83yR6mIlKrOs+FzxBfTXNJu9wHIzdBihnO/bJdfDsOnsJeiGWl3nZ384tYea3OZ+DeczC
    i4z73NDFvdtWYfwAYE7JZoRQNXizD222qlNfC8eVNnh3ajaShYREzBoGgsDFqy1xCFOPW0
    yxrMW1LMLiP7q/GCoF6HLDi2oZGtycEn1eUX+pArVRoUjMBbrbBP3jxHGp0z7EBPt9gB4D
    HAaqTxbVQD0WU9X4YMllwkW6HvFw1+BzXLI+7Fw7uOkwOS104SnAHha227+ZixB2PCXluB
    a1rs8RRVGanhWNWiTyvHrqYkfNyO10Gk0FtVQSEJ2acG+QniqL3SVdsjgCFXwLRa7TCSuG
    9Qo4IoMwpCLlw5LTIa3saXO+2jCkbUVp5jQDgNLmeFI6BGNQ/Pk/gEmPd5GYot0LL4oOEj
    aowffjDANTli1zAA78e5GVWxUhr2PrPt6lrwxUePOcej7BF0veGFU5pYf5JQ
X-ME-Proxy: <xmx:NESYavjUtu9qCB30mQv0hCqp4A0Ly3CBszpClSc5BCFx52bwMjDaTg>
    <xmx:NESYaoVHUWYVmS7ajLhhgHJboUdm1P1G0VKtgMefPg6cBPu4Lx-www>
    <xmx:NESYaguUbpXHu7FZpynYdRqB_Dirrv5JFhKbpKcyFRSlYoCyA9_Jhw>
    <xmx:NESYapapf0aLgZQyhafeI75rCPDTe8EMtEyB5t9rtTWqHspSDunDEA>
    <xmx:NESYah6V4eN6S-LGudl8dTMYFH4mXRYtf7B2KBLKBYD98zLz_m1ZCiFi>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9391AF8007A; Wed,  2 Sep 2026 11:43:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 02 Sep 2026 17:43:25 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Breno Leitao" <leitao@debian.org>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Borislav Petkov" <bp@suse.de>, "Andy Lutomirski" <luto@kernel.org>,
 "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Message-Id: <d32dc46a-c677-41eb-9406-5f41decbe58c@app.fastmail.com>
In-Reply-To: <apftwY062XjcV5-K@e129823.arm.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com> <alDJNWZdBpkIZrcM@gmail.com>
 <alDMRabP9s6Pqhxq@e129823.arm.com> <alDTjHtL5Q4ormKb@gmail.com>
 <alDW8vjjU_f7dkIK@e129823.arm.com> <alD3ZFgfgMj0_qoT@gmail.com>
 <af81fe18-d246-4bd7-b32e-c61ec2e7c856@app.fastmail.com>
 <alS2izWImqj0N_IZ@gmail.com> <apftwY062XjcV5-K@e129823.arm.com>
Subject: Re: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI runtime
 service calls
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 2 Sep 2026, at 11:34, Yeoreum Yun wrote:
> Hi Breno,
>
>> Hello Ard,
>> 
>> On Sun, Jul 12, 2026 at 07:25:19PM +0300, Ard Biesheuvel wrote:
>> 
>> > > Sounds good. Let's wait for Ard's feedback on the additional patches
>> > > [1], and we can decide how to proceed from there.
>> > >
>> > > Link: https://lore.kernel.org/all/alDDv3XGXVdd1mri@gmail.com/ [1]
>> > 
>> > Please send patches against efi/next, I will apply them promptly. 
>> 
>> Acknowledged. I'll rebase the fixes on efi/next and send them shortly.
>> 
>> > UpdateCapsule is a special case that we can deal with separately
>> 
>> Understood. I understand I should defer the configurable timeout work
>> for now.
>
> If you don't mind, Could I send the patch?
> TBH, If we handle the UpdateCapsule seperately,
> I think it seems good to make a exception for capsule update to wait unlimit.
>

Yes, feel free to send a patch. We'll continue the discussion there.





