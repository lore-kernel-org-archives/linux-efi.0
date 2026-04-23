Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925C4369204;
	Thu, 23 Apr 2026 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776958954; cv=none; b=rZrQdm+/XGmJkU0gjq4h4/qvgSDX8pzw1QCQVGKSpom594LfoUJnqZsZbX8D3Htnd7pql9zF2JpbbuRcKPzCZ/fHFxqk/PjawAaLNKLjR0mWOvcw6Btqz6LUlsdCKC6NBRX1A+65jdcFqvN5EoKGyBPsOyJqxbvj5Bfeb/HMUbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776958954; c=relaxed/simple;
	bh=bAo999kxv5pqyr4x2V7DioqTFgZGPHHa0eUWfLX4OT8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=SkpBZ77GbXaNz6NwYmK+pdEGeiIoFc3RrEMSuliWCAEHdQEyQXemayDTwSe5oGdl1mqK/7C7A1O5soMgY0UHSSx7q0Saof+ktSarIiEfgIVRut6QwV46PVGDjIHAtAOONIiQCxTeAW87U4UyU7fCThuqhPOxoOQThkYAjnpyK34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LR9V/yFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LR9V/yFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C4DC2BCAF;
	Thu, 23 Apr 2026 15:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776958954;
	bh=bAo999kxv5pqyr4x2V7DioqTFgZGPHHa0eUWfLX4OT8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=LR9V/yFpv+xba5bbbsHEHmfTx5QaDXRqZNs0nJZA9bL8dwE24+RO5A94f5Kc31UUs
	 dFavesLm2vmnTDmXoathj+0Us0luOWfDu9CB06UlUi/CfAqgR9bVwi8he6grFEEb5z
	 KEPCrIjRYA//9r0c8Bm8dklAA9ZZwGq8uCCDuvi0afSEmCG9XB26DZpm5jBRoNSo7q
	 RfbeVwygHif8wEFxqg5oR5I/V4RZQU0FsMe1ZoL7Hd7GTxXSr3X69Vl5Ztmqkmj6/7
	 R/S/Fua4Xcb1RZJ5t8WtKdqOaF9R/g6z4K5DGxESNo2K4MjT8aAsHLW4TxANv0CPIE
	 Ke+c8jsi2VDuA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id DE9CFF40068;
	Thu, 23 Apr 2026 11:42:32 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 23 Apr 2026 11:42:32 -0400
X-ME-Sender: <xms:6D3qadAnxa6A33hsGxLVtNd3Ay4c4EbGsrD5zmvUBV4_HWAFkfVxzg>
    <xme:6D3qaWWnBXt2Sp9TIHtYeYnpWY-1Mog97g1tyAX66L4BqOQbWKZw-y1rY7LMbClsT
    yGXQVuS35KpJGuMSvdYitGyf8-3GzncCdSJ0JZygvHMVhhW1ly1kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeijeehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepthhhohhrshhtvghnrdgslhhumheslhhinhhugidruggvvhdprhgtphhtthhopehjkh
    esohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrd
    hkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:6D3qaeqpsCkX4z09-y6S4jmpxXa5k2gWaVWEPPqOJUUTMpOOjw0jUA>
    <xmx:6D3qaYHiLlcyFuF-ZZex1yZuuUo1L_DYy31ryYQzkjxNTjuDHmCTxw>
    <xmx:6D3qaWtqTXPnhaN1_sCzbpnz-aePchi69BTdX2qgNVxcf04PFZnJtw>
    <xmx:6D3qaSVYY6WJmuMdWHIqI8opnIrCCIoVJbKLiRDIabJoCzRcDiguZA>
    <xmx:6D3qaaFYrKcY8m5PrzBmG4kNKiqoyNcdw_Q0SYebH38F-G9Dm7PZRUHo>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C10AD700065; Thu, 23 Apr 2026 11:42:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 23 Apr 2026 17:42:11 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thorsten Blum" <thorsten.blum@linux.dev>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <7a5f145c-9094-426b-9fa2-79c853cb04f1@app.fastmail.com>
In-Reply-To: <20260422122525.99460-3-thorsten.blum@linux.dev>
References: <20260422122525.99460-3-thorsten.blum@linux.dev>
Subject: Re: [PATCH] efivarfs: use QSTR() in efivarfs_alloc_dentry
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Thorsten,

On Wed, 22 Apr 2026, at 14:25, Thorsten Blum wrote:
> Use QSTR() and drop strlen() in efivarfs_alloc_dentry().
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/efivarfs/super.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>

I'll queue this up once -rc1 comes around. Thanks.

> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 1c5224cf183e..95a685f022e6 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -192,12 +192,9 @@ static const struct dentry_operations efivarfs_d_ops = {
>  static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
>  {
>  	struct dentry *d;
> -	struct qstr q;
> +	struct qstr q = QSTR(name);
>  	int err;
> 
> -	q.name = name;
> -	q.len = strlen(name);
> -
>  	err = efivarfs_d_hash(parent, &q);
>  	if (err)
>  		return ERR_PTR(err);
