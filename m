Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAF334DB56;
	Mon, 15 Jun 2026 17:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781543087; cv=none; b=Ymi+PTGKMzWF8JcTVF73EXAhbBWkyV676XQLbOinj95wiD3KXcnzHBSYzJQ9YI1CNsQmf+IMQeTd44SNvPWBs/kRlkKUZdVvrG3ze1Da5CgAsp0d+wiRbF5cqUK8nE3NBk1gPtc5MCRhjSXVgiBRFMn7efV9r/hxOt6iDe3Icpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781543087; c=relaxed/simple;
	bh=k9wzEDrn8OWY0tjJOa6e5RtLbGoq+IyJnXkfwU07P80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QF6uQEQEHg9futom0hrFQOs9iAFBd2WEcfKDttCLlCD6R0Y/uNsPWnjE6MHD5X8PasxdiQqHa54gITg+3IHa1VtAZ+aNpnwCBPcZv1C4K5OpK+yDoWu2/F++GoHEZ6jDbfrui1TsI8VJq+htd6F1Ds5re9OTUVUXD4hh3rbekcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=SLabnQnx; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="SLabnQnx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=be/KypQX5Q9fujajARM6Q7r9w26ilWIZmzbrtGfAKys=; b=SLabnQnxi8RKG6kB4YLIrRrIte
	+jYEaBgX5DOoDOdPOU6k6ypOK6lDxxOMXQzKEUszFj5yTLPDASBaagrmnsOk8tUGdmzHw2XGk68HM
	2J1tv7+pE0CjbBOIjeYCz0TsyHOIrqFb8Mb1LadfEs+3t0bUVsavfv//KIZ2S3hmTXIBIqEbnE3qn
	zsd3Hxu29/Ylu8C3lRKI+WwMxWxUWcLIz0u0fTGyYSKAR/XPPXo0Rkv03xUIJElu5cOtap9hCSZj1
	74eb7LaTsGudBKuTsb4/IH254uFPRDECMTh8XzLqKRh9ykQzpGUZV9OECxDmxcCHO22vobRU+rK1T
	RNRNGWLQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wZAjg-00000000Vxn-0xg6;
	Mon, 15 Jun 2026 17:04:32 +0000
Date: Mon, 15 Jun 2026 18:04:32 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>, linux-alpha@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	linux-snps-arc@lists.infradead.org,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/19] init: discoverable root partitions, a.k.a. an
 omittable "root=" cmdline option
Message-ID: <20260615170432.GW2636677@ZenIV>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Jun 15, 2026 at 06:08:56PM +0200, Vincent Mailhol wrote:

> Tested with GRUB, which implements the LoaderDevicePartUUID EFI variable
> in its bli module [3]. With this, I was able to boot a kernel with a
> completely empty cmdline and no initrd.
> 
> [1] The Discoverable Partitions Specification (DPS)
> Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/
> 
> [2] systemd-gpt-auto-generator
> Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html
> 
> [3] GRUB -- §16.2 bli
> Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html

So what does that thing, tied to EFI as it is, have to do with architectures where
	* firmware is rather unlike EFI
	* firmware wouldn't know what to do with GPT
	* GRUB is *not* ported to, let alone used
such as, say it, the very first one mentioned at your [1]?

Or is that conditional upon "if anyone wants to design replacement firmware
for those, and if they agree to follow our wishlist"?
