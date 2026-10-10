Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BCC33EB10;
	Sat, 10 Oct 2026 09:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791624161; cv=none; b=cha+g2SfrX4SlYqacek7TNVxe+qg6bCKJCm6UB277BATgqgrf8bUyOlSkrCASGJ6iIgw2AP5Q46zdTmC/Tv9xDSJiNXifzYPe4cLJnFJUge12GAk2q6E8hydSvsEghDMJq5zqgkyiYBWsjsGWerOD2WcwCi6MicbzY3f3GWnF/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791624161; c=relaxed/simple;
	bh=NAaEPaB+o1Dm/fm+7bezAR2jI1G44dpDFT9mWVuNpkY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B24xzj5SDAsV/O9JNQrt6xIy4H4LDOVCN7e/ntLFqoAVdtAnQKifJ6ynYVYB6vN05A/TBYRcD65khe0FSocNNVMEnbiFK2xzHBf9EPjwH6L4EzllFOzHiNtLkZ6UfAD0/GdwpyQTxeu1l3rZZgqUMRwKoC4Jr2dKqwVDhKELLH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=ad+GAUPS; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ad+GAUPS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1791624157;
	bh=NAaEPaB+o1Dm/fm+7bezAR2jI1G44dpDFT9mWVuNpkY=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=ad+GAUPS4Jx2gG2f5gc+BjCLeBUGhqY0SmbZvdyQx241DPA+80DRKcZv+SHJKQ23I
	 4nNm34PbIVmflPKJbNfZ0cHH26p25vVinpZBquZGXeQLaOr/0nm7uJd8iBlQCM1WIJ
	 T1l881uZ/CUVeQeqfa1Cjgw09Z+fzP6UhrfUCTWM=
Received: from [10.23.23.39] (unknown [80.188.228.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 814011C01AF;
	Sat, 10 Oct 2026 05:22:36 -0400 (EDT)
Message-ID: <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that
 can't be modified by userland
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <matthewg@nvidia.com>, mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org, linux-integrity@vger.kernel.org, 
	rafael@kernel.org, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Date: Sat, 10 Oct 2026 11:22:34 +0200
In-Reply-To: <20261008132532.1155166-2-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
		 <20261008132532.1155166-2-matthewg@nvidia.com>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-10-08 at 06:20 -0700, Matthew Garrett wrote:
> TPM NV indexes can be used for various purposes, including using them
> as PCRs without depleting the limited number of hardware PCRs. It
> would be beneficial to have one that's under control of the kernel in
> order to be able to prove whether certain TPM operations occurred
> within the kernel or not.

I've been thinking about using this as an approach to creating keys
which can only be unsealed by the kernel.  The "natural" way would be
via localities, but non trusted execution BIOSs lock all the localities
except zero, so they're not really viable.  An alternative way is to
have the kernel populate a NV index on boot with a randomly generated
authority it knows and then tie the key to a PolicySecret of that index
... which means only the kernel can unseal it.  My property
requirements are similar to yours: userspace can't be allowed to remove
or redefine the authority of the index (since it would be empty I don't
care if they can read it or not, but I don't mind if they can't).

The reason I never really proposed such a scheme is the rollback
problem (old version of OS or non-Linux OS can create the NV index from
user space bypassing the kernel only block) which you try to solve with
PCR5.  Do you have any data for how widespread measuring
exitbootservices is?  I know edk2 does it, but I just looked on my
XPS13 and I only have two PCR5 events: a separator and the GPT table,
so it's definitely in violation, but if Dells don't do this then it's
indicative that many other manufacturers might not as well.

If we do have a problem with lack of manufacturer compliance, one other
way I've got on my todo list is fake trusted launch: now that
Trenchboot is heading upstream, we have the real trusted launch, but
that's usually too fiddly for most people, so I was thinking if we
could get enough of the TXT launch to happen to open the localities
(without bothering too much about anything else) that might be easier
and give us the ability to run the Kernel in locality 2.

> Reserve NV index 0x014c4853 for use by the kernel, and filter
> commands submitted through /dev/tpm* and /dev/tpmrm* so that
> userspace cannot undefine or modify it. Blocking definition is more
> awkward so let's allow that for now, not being able to modify
> ithttps://www.bbc.co.uk/sounds/play/p0pfxh72
> means there's nothing interesting they can do there. The filter
> simply validates which handle the relevant set of commands is
> referring to and returns -EPERM if it's the kernel one.

As you say there are several other use cases, including mine above and
NV PCRs, that can only be extended by the kernel, so I think this
should be a range from the get go.

Regards,

James
