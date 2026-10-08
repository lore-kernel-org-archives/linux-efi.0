Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257D23AEF4F;
	Thu,  8 Oct 2026 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791477922; cv=none; b=jBzboD3glNzDkZVJPPi5jOoWTX2y8CA+uJVbst08mp3G8Bt2OUj1LqI7yEANpjPzA8ys870XFqsJe+8qtKZz3haTtLQD7ih+/KfGxuskvygSU1C4Z8mzLMlyPCQajOYxMoqLKIZboDPZ3o09sQzGkSesHaWXZIWAKZQgJkDY8p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791477922; c=relaxed/simple;
	bh=OMOHRU+xJ2Adb/yorn/o8MTrvtiwSFZIvb8OuMXMjtU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RhgqpcRQLUPscuWv1QTOA5iMLMk+hnOcask7f2SjQJhUlnMxTjirAHjS1MNAVgNdBy6dW/SnhVvRuD38KkFOOMsaWe7/IxXE+6GhYCJzmxQOETog6xdCmKv+RwwN84WAyQPwP8VzcvQ8ThCeeceHl/MJSjhbzdvPjE5Vy7kXzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=b+x2uL2y; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="b+x2uL2y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1791477919;
	bh=OMOHRU+xJ2Adb/yorn/o8MTrvtiwSFZIvb8OuMXMjtU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=b+x2uL2yKevnqmEtBmzLXT4bnxSilmpKkdmGLyxQrGTfNyQ+lB1m9mlngDU6GKBlK
	 3eElE2FdK1ydIYgz8g13MbanUril0+VVNPVg6DhQpofD9b2VAkg27VoZLxQ9qpNpVM
	 oSxoj63ircJlfBX76wJ/3hPw3/NMMIBnAm0qK68M=
Received: from [10.23.23.248] (unknown [80.188.228.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 080821C0025;
	Thu, 08 Oct 2026 12:45:17 -0400 (EDT)
Message-ID: <c5d1b69763362db8a681d00d3325dd673c4db08b.camel@HansenPartnership.com>
Subject: Re: [PATCH 05/17] tpm: Add a kernel attestation key and signed
 audit digest retrieval
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <matthewg@nvidia.com>, mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org, linux-integrity@vger.kernel.org, 
	rafael@kernel.org, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Date: Thu, 08 Oct 2026 18:45:15 +0200
In-Reply-To: <20261008132532.1155166-6-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
	 <20261008132532.1155166-6-matthewg@nvidia.com>
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
[...]
> +/**
> + * tpm2_create_kernel_ak() - create the kernel attestation key
> + * @chip:	the TPM chip
> + * @handle:	set to the transient handle of the AK on success
> + * @x:		if not NULL, filled with the X coordinate of the AK
> public key
> + * @y:		if not NULL, filled with the Y coordinate of the AK
> public key
> + *
> + * Creates the kernel AK as a primary key in the owner hierarchy
> using a
> + * fixed template, so the same key is returned on every call until
> the
> + * TPM is cleared.=C2=A0 The owner hierarchy must have an empty auth
> value.
> + * The caller must hold the chip's ops lock and is responsible for
> + * flushing @handle with tpm2_flush_context().
> + *
> + * Return:
> + * * 0		- OK
> + * * -errno	- A system error
> + * * TPM_RC	- A TPM error
> + */
> +int tpm2_create_kernel_ak(struct tpm_chip *chip, u32 *handle, u8 *x,
> u8 *y)

Oof, there's a lot of duplication in here.  Basically you're creating a
signing primary key (technically it's not an attestation key because
they're supposed to be non-primary; this isn't a criticism because the
only consumer is the machine owner who doesn't need to use privacy
preserving AKs because they know all about the TPM in their own
machine).  The primary generation routines that exist in tpm2-
sessions.c:tpm2_create_primary() et al. already does most of this.  The
only real current difference is that it creates an encryption key not a
signing key, but that could have an additional bool argument
(signing=3Dtrue/encryption=3Dfalse) rather than duplicating the entire
routine set.

Regards,

James
