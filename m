Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB475328CE
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953959; cv=none; b=mlctyaXQ7aSREQO/k8vFrKmhLOVhA98X6yKojDBjmIF7agucQVLlbU0lvnRr7fLYOLt9VrtvrMJdojctifja/Ibj5W3h3z4zIskJiDrXwD5y2nr0OCKxtmZiD+LImkRLd2BLJerLTO6gc7LU3tNKeQDYCaZ3sWUttwTvXH38oDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953959; c=relaxed/simple;
	bh=D0mga59qJMgbJ+iJ8HU3/USnjjnxCc4udmhK8U7gv5E=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=n3sS/wquzSChfV149OjIAVCftdqMIxjPC01cZ1W2SaPzK7odyQs1je0P4n3msgmcyAPBBoSAS90Jd/uZ0TYrT6o2JPucPrJYFH0XtdI5MuF63YTXAOlXvUt+oB7ayYZG07KPSKFHNdWmgSmqobi1z6jV8mKP0xGNwlVE1pv6A6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4JVtg6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4JVtg6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B9E1F00A3D
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788953958;
	bh=D0mga59qJMgbJ+iJ8HU3/USnjjnxCc4udmhK8U7gv5E=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=M4JVtg6igxslKIpTLnEYmKV9b3ABBiPNIIxYuxEMLxFDIV36T5KbmILm/EaIosqeQ
	 rTOElNFxHFhbUkk7kVx4ZzPDOxjLC/NYavCSx78RR+J2KVfPMJRuhQYo3yy7EBbHwT
	 R0pvlOtp2Utsq+odBwq+/agL0l4UxtpQ9Z/Rbc+tMyOGoWt0Y2c7qIrIOz0+YoSR68
	 YZW5js3ASGL7K4hFjv7PxKeM8WvPYgO6KULUHrzvZcEbowz/foUwQyWjKo72HQkM5A
	 x9/RCDkA30Z2gWlsk3pw26bedYKuPmWJHqAvxMTDmHtXWkHTZLGwEFtsw2gKq85udr
	 RYTDS9k+aPRag==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 86791198004A;
	Wed,  9 Sep 2026 07:39:16 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 09 Sep 2026 07:39:16 -0400
X-ME-Sender: <xms:Y0WhavxXfYK8WFPHobVdJ7hy9UptoKA4UIMzHA7GEAukK_HwLF8aRQ>
    <xme:Y0WhaiGySawDblceYPyWcaUVsV3MMpXBCcxcFgyfBni4XliMQs0bzR5xYtRiK1pIm
    g2snn9RNCJN54vdz-kykgPTEUmEMabEbsh2eqqMU9P7C3u_vxerbbnT>
X-ME-Proxy-Cause: dmFkZTFybi/C5/YxjlxSGTSnziYj9BAzTDyTbizX/VEcL5BRF5SgkhV3Yu9EyPyrxUv0Gy
    ujJYe1i3wXIou6mNfzHXrP7zXC/7paFp/vY97IcWSRyFmG2GXApGVDqJv8qT+5Hn6QXlHX
    ktboINvkS14tiJ1bQzb1WFlq4Sj05+uwrpNsRWyXxVX8tWebwD+ifrWNjiQ21F5uHlWVap
    hFX8eBWFUm5LCg/iIzrn0xUTSEEPlQwIKVEdLNNZMOkDPXC5Op3LsBTD+ZvgY08UUIbUHU
    O9ze+JqZ9CmpQ68CM8tFEk3ii9kV+BBNlQKj5WBKbTE+ZnSif0of6l6MtEpqPvSo/1i9WI
    pnzdhKUHc9Mv9Fp7SB+dFYTUkumP4J7j5qq0aDHHkWZnrkFAzTH1su204TGrOwwKfx++Sb
    pKwuHa48jDu/oHCyYPFMpXnl4QtfSF2KM9vszq4Di4E5CJe315/307/QFSUTN3KU+Ydp8D
    lIe0DXkj+id6baBOc0ytw0gowW3a588mnAG1DRsYqSDfXQlyr7t+XFNhOsGa+vAIdoiGkF
    FD0KpWGx6DalFqhc7u+Ahjhu46vgHkGpkViCDCi+3FIzMqYqgqL4iEW3hES7F4JeW3umIX
    2ycbAuvbHO0KAj2u+6il3rR/xrUFlASiTGgmdUxgIqtBX/6HRp0HQm+l5o6Q
X-ME-Proxy: <xmx:ZEWhapXRvh4W7msuW2-m3_jDrNoFxnbFlQglJFnp5m7iUNnUr6ElCQ>
    <xmx:ZEWhapubeP15ChiphSbYLSuAxVOhcgfmMOHjioDq804D7kWb_0I71A>
    <xmx:ZEWhatWM3pL06No70n-MzEHw4-uw4I9kGagY73NekoGlVEDNKIdamQ>
    <xmx:ZEWhakkV1Gi-XLfHbUsbxABGATDIhxi0LkS-t_Gn9uOrCv1GQlXyqg>
    <xmx:ZEWhauazooj7-XCGBJXi6lB2uBF62Fw6xLJeqgQp0dTSM27mIyMwy6AB>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 51EDEF8007D; Wed,  9 Sep 2026 07:39:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 09 Sep 2026 13:38:54 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <50e9d27c-8609-4a2b-87b5-bfe97fadcfd5@app.fastmail.com>
In-Reply-To: <20260908172555.3356-1-mailhol@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
 <20260908172555.3356-1-mailhol@kernel.org>
Subject: Re: [PATCH] efi: pass NUL-inclusive sizes to ucs2_as_utf8()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(drop x86@ from cc)

Hi Vincent,

On Tue, 8 Sep 2026, at 19:24, Vincent Mailhol wrote:
> An upcoming change will update ucs2_as_utf8() to expose a strscpy()
> style API where the size argument is the destination buffer size,
> including space for the final NUL terminator.
>
> Some EFI callers currently pass the exact number of UTF-8 payload bytes
> that they expect to copy and add the terminator themselves afterwards.
> Extend those sizes to include the final NUL terminator so the upcoming
> contract change does not truncate the converted output by one byte.
>
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> ---
> Hi Ard,
>
> I saw that you pushed on efi-libstub-native-utf16 WIP branch [1] and did
> some testing, despite those changes not yet submitted for review.
>


Thanks for the review, but I am going to drop that change. I am also going
to drop the ucs2_strscpy() call from my series, and use memcpy() instead.
The guaranteed NUL terminator is not really needed for a printf() style
function, and it actually interferes with the precision handling.

Instead, I'm adding a ucs2_to_utf8() that takes a separate limit argument,
and putting efi_convert_cmdline() on its head entirely so we don't go
through the input character by character twice.

I'll have v2 out shortly, including your v3 with my tweaks on top.
Please take the time to review on list if you have the bandwidth. Thanks.
