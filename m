Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096669;
	b=xJf0XgzHXI65xZqky9vFlbcVRCGHwO12J/A57kU9AUWfNxp1ad1MuiPvGQ9vmY72/IvU
	 J889v8Ngg8ZItm3yG+yyvSlvRb4SRet4pMUd8YtzinamCV3WYqIxYADRqr7AC/V2a8Pas
	 4YabhumiHxO3NCO4krkVPb+q9cq9Io5lp4eomt1zp/mMBTkoqyvujMSSG8mu5PPfGgD+v
	 PuHBdd8nbIkjPylNBq4GQ5FP3b/Irsj1NC+5pmUtBepvF/2+i4bbjkDRH6OTqLrA4Ow9N
	 lVe94j+GBEqKDcq7qM1QmzZchY9C2tlzz6/0ZQpiSQpSGSDJEy6RmhMSWbET111LJUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096669;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=S0tdVInouOdohOf3y3ROcnEUNe5cSySDwSAP8SJS+UY=;
	b=TFMRX4wXP0V9hIDaTC/JLFZQot8fe8dar9aAxb8P3ip01HF1SisBcR8P2O/5AZjJ935v
	 iwSeMZJgRbxEn46fFBwOijN4YpoAoI/xjyhko8S33A9IHccbP0rNbKqzV0l46duvj95Ic
	 NMt/p/HGaLpNWZERs7ZP4l9OGsln5yzkvs8ud0QxCOMK/rQ2DBgIW60Jp91QQj5va4CiO
	 YtH6QyliquaJzky6XETdRlnt/Xu8wqpaLX/XHmlyPX2kXimas9he6+5+4X+x/cpor2e5J
	 czYvqgYdL9V/qQFrbpAgbmQnIACHx9INYzz0geslJVm2lCbdShUaZXkLcKUVjN/n4Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTG05IaB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937EF606A336;
	Thu, 19 Nov 2026 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTG05IaB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988861F000C5;
	Thu, 19 Nov 2026 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795096669;
	bh=S0tdVInouOdohOf3y3ROcnEUNe5cSySDwSAP8SJS+UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VTG05IaBXiNOGB/UkOhNVLsvEyO1G3aax/eBEIJw9xXmsKjV6/n5DSpfuj9mDebv0
	 dxQVA8CW32RvLNpK2dEueLPZLmwmldzvE6lEigS0dfr82/2clgcwsYzgQBftx7n14t
	 pbkqPDWlSLY+b0qLHIXigaWQfBwFn5QV20gw6/J3TXcfgjDRllgZ8v1Se5REO1upH9
	 GFuzBvRUejwpN3SyhXUHRLhLasaMVZrK1kcwxHs1LbSQfdhUOHC+EsjL0cgvsGIpdE
	 oMB9nZu68h8x5RA3aHlOhrW6mARVPeFPsWOZ1zYHYR8jvwCzmIl0Qw/RmBzdvT/oCG
	 WJaj1eJ7ISgsw==
Date: Thu, 19 Nov 2026 14:57:43 +0100
From: Christian Brauner <brauner@kernel.org>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Dave Hansen <dave.hansen@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/7] init: discoverable root partitions
Message-ID: <20261119-grauhaarig-wachleute-rockkonzert-696e45cdc27d@brauner>
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
 <20261110-fachlehrer-anhaften-unkenntlich-86fc48b56f8f@brauner>
 <182e7cc2-43cd-4858-99ca-5f243e2c9eb5@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <182e7cc2-43cd-4858-99ca-5f243e2c9eb5@kernel.org>

On Wed, Nov 11, 2026 at 04:24:35PM +0100, Vincent Mailhol wrote:
> I would appreciate hearing whether these use cases and the limited
> scope address your concerns.

I don't think they do. The scope was never the problem. DPS is userspace
policy and a subset of it in the kernel is still policy in the kernel.
It seems just wrong.

>   This is useful for booting a kernel manually, for example from the edk2
>   file browser, or recovering from a lost or corrupted bootloader
>   configuration without having to supply the correct root= argument or
>   load an initrd from the bootloader shell. Finally, it allows systems
>   that otherwise need no initrd to discover their root partition through
>   DPS without introducing an early userspace environment solely for that
>   lookup.

The kernel can already find the root partition without an initrd though?
For example, via root=PARTUUID= and root=PARTLABEL=.

And if you want to pick something in the edk2 file browser and have it
boot then pick a UKI. It carries its command line and its initrd in the
PE binary so there's nothing to type and no second file to find. And
that initrd can do DPS just fine. Everything beyond that is bootloader
or early userspace policy.
