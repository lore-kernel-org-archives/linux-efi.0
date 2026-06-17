Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63BA1CAA68;
	Wed, 17 Jun 2026 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781700129; cv=none; b=KD5Iye3XJNVDDHr5xdDpjhpT+RY16oaSlBr8GTHMZeDYOCX31ySDxF1niCe2kFcxxokG4N3Ky6UUvwtj5OefrpvRdzNurE3WHGcOKNRsrLJqZKgtkWA+oFCorgve90/CowcgnQF8JTq4dHdQHVbeW+0ffPFWzN+XidsUdxwgwO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781700129; c=relaxed/simple;
	bh=sv9bDDMyUOTluObut285uOPrMWsldCYsk9y2aD3AE+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkBMVBwxtn4HuUBUOqcweDvrDlMK0dSq/UjGb3tZF16rGwiCG9l/JzxqwvOoIdFu4Y44Qtb7LU+kWlckLmAM8bMqSnhILHMzy2Lmj7Btr+wB6bXZpnp97GhK+v4PvS4iH+xxF9aS6Xa3l9RxveaoJ6C7dyw1lbxzKE0G3Pjhjxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Im0bG8Am; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Im0bG8Am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643E41F000E9;
	Wed, 17 Jun 2026 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781700128;
	bh=shMcTxpz7Iae4CMErv9/x2nY1BGPOVWbdpSfFAc09vY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Im0bG8AmD3bgsJUqZdYGdopEe5rvENwOqhRGA6LfcbikFOn2YUPQXBJWxsK3aAa3F
	 IKOG49MBRGBJ1Mar6LZ2Kju1FxOKtyMrE//+MnE4N9/Z71fGW3gauigkbzrv2V1kZP
	 1FNp162R2Z9QvBsI+njynVaaI0fNfgYS5ai3uG8OmNg5itH6o2+k7segaCwH+SbOb5
	 zOcIdHYuAFv7ORTp8+4nDfybUyv7DTPv3xm7a9kUQ+vj1V5p2XZfw7CYh7IqwWcWUs
	 ypezZIGEaKxUJ1MkpzhGlNdEe4jZuo9Q/Bc1arqIHR5rd7H/I68vBRL6fPgiqclkJT
	 0u72NIrlwde9g==
Date: Wed, 17 Jun 2026 14:41:54 +0200
From: Christian Brauner <brauner@kernel.org>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Magnus Lindholm <linmag7@gmail.com>, linux-alpha@vger.kernel.org, Vineet Gupta <vgupta@kernel.org>, 
	linux-snps-arc@lists.infradead.org, Russell King <linux@armlinux.org.uk>, 
	linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-mips@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	linux-s390@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/19] init: discoverable root partitions, a.k.a. an
 omittable "root=" cmdline option
Message-ID: <20260617-irritation-rollen-wirst-7d636cbfec92@brauner>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>

On Mon, Jun 15, 2026 at 06:08:56PM +0200, Vincent Mailhol wrote:
> DPS [1] defines GPT partition type UUIDs for OS partitions and
> attributes that control whether such partitions should be
> automatically discovered. The specification states that:
> 
>   The OS can discover and mount the necessary file systems with a
>   non-existent or incomplete /etc/fstab file and without the root=
>   kernel command line option.
> 
> DPS is already implemented in systemd-gpt-auto-generator [2], which,
> when embedded in an initrd, indeed allows automatic detection of the
> root filesystem through its partition type UUID.
> 
> This series adds this discovery feature directly into the kernel so
> that people who are not using systemd or not using an initrd can still
> benefit from it. The implementation follows the same model as
> systemd-gpt-auto-generator:

I happen to co-maintain the DPS. It is userspace policy and complex
userspace policy at that and does not belong into the kernel.

This also implements a really tiny portion of the spec. It deals with a
lot more complex concepts such as automatic partitioning during
installation, verity, LUKS, containers. This is really not intended for
the kernel at all. I mean, it's great that this spec is being used but I
do not want this in the kernel just for the sake of auto-discovery.

The DPS is completely generic and can be implemented by tooling other
than systemd (util-linux implements it and so does refind iirc). I think
not wanting to use or build alternative userspace tooling for this is a
really weak argument for pushing this into the kernel.
