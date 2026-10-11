Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056AD13CA92;
	Sun, 11 Oct 2026 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791714484; cv=none; b=TeEmEZm6B8qOs1++4bDg9mvCpsiGgmjmKFvN3YscH27eTomYJmOxLdZQAqbfIPkiHOwMJ0TC44qHamugYnvX6vMndZ5yVi5celo/odDK4SizCn2dTe3+f2y/4lC8yZSU81syioJxvLMGCt+PwKYDyU9wcz78PV0IapBqGtmLFvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791714484; c=relaxed/simple;
	bh=7rHuVNpV6g56s4A3x+20hFfm2LwZfNegxl2V7i/YoXA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HZbUweeahSZnzNqT/q0eaHOmofWUqP6LJPE9oQpl5rVssWiJk2d7vmbmHo6Y8TklGYDQ5ix2gm2oDHxa37oB6hFcYd5bE1huWz0YGcDYhQ54TY7P2xF7lFOUiWo/a2a6y6BnaoPOPO00cWARiPsEwam1SlRSvA8Pb5ZU8escYGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=C8x4lBiH; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="C8x4lBiH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1791714481;
	bh=7rHuVNpV6g56s4A3x+20hFfm2LwZfNegxl2V7i/YoXA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=C8x4lBiHS1qmQRQVSEfNjkI6wTUbaj6HhQX1mfh4kBiY/kWmQzbvJkS7wY7oKZHsF
	 Aj5owjh2lZX9V+i3u3ke6H5AVcr8K6QVbQpgUWBSBjZmIxNTauXJxG1dDcF3WU+I+v
	 tu3kMdVwhnKVUxqC1Z5mImo2ngPM2/ncvzpBLQu8=
Received: from [172.17.252.20] (unknown [193.85.144.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 8DA491C04D0;
	Sun, 11 Oct 2026 06:28:00 -0400 (EDT)
Message-ID: <f002fc613bf0bdcf895e5be02dfd2524b7608787.camel@HansenPartnership.com>
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that
 can't be modified by userland
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org, 
	linux-integrity@vger.kernel.org, rafael@kernel.org,
 linux-pm@vger.kernel.org, 	linux-efi@vger.kernel.org
Date: Sun, 11 Oct 2026 12:27:58 +0200
In-Reply-To: <astjpI65VOyU8xvI@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
	 <20261008132532.1155166-2-matthewg@nvidia.com>
	 <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
	 <asqthz69ohnMVCye@srcf.ucam.org>
	 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
	 <astjpI65VOyU8xvI@srcf.ucam.org>
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

On Sun, 2026-10-11 at 03:23 -0700, Matthew Garrett wrote:
> On Sun, Oct 11, 2026 at 08:04:27AM +0200, James Bottomley wrote:
> > On Sat, 2026-10-10 at 14:26 -0700, Matthew Garrett wrote:
> > > Does your log replay correctly for PCR 5? It's *extremely* common
> > > for the extension to happen without logging, since logging needs
> > > to be done=C2=A0 into the late events table and almost nobody got tha=
t
> > > right until a few years ago (hence=20
> > > https://github.com/google/go-attestation/blob/master/attest/eventlog_=
workarounds.go#L70
> > > )
> >=20
> > It seems to.=C2=A0 This is what tpm2-eventlog returns (edited only to
> > show PCR 5):
>=20
> Hmm. Well, that's irritating. Which year's XPS is this?

It's an XPS-13 9380 Core i7 ... circa 2019 I think.

Regards,

James
