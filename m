Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB231364029;
	Sat, 10 Oct 2026 09:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791624857; cv=none; b=r4Nf0sdJFM6u6jRjzc9JR+WKW++D2G+DvvTW2BfOtIsnTjft2bq0nd7P5Iwj8j68NMpX4ZG5iiLgMTVB0Hyl6vwCMW/n1O5LZ3yDlfo45F/yt6Fqb/499KEvIYNy1ULjlOOk112vIgOxrZSRFrniKzheD8St76EUhnwXl+x4iIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791624857; c=relaxed/simple;
	bh=UEcdoc2+ODoZqDFaeaKA/50ko2AM9A38LXx4npVCzPs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IvxPl09BTjm+Jklk6jaKmGim9xJSUnbBTGOQgZ/Mi74DEVCuETpXwzymA+4SQ58R4iiIi9DnQlVSRvNAN1EsLNAPsnqQyzZuQUMSAodO0WP2CL4Aj0nbgYSyZ5wc7loNDh66Fcn49JRSz/lVXGcUvkY/uANQmxymb148CXIc3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=ZFGuHu/n; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ZFGuHu/n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1791624854;
	bh=UEcdoc2+ODoZqDFaeaKA/50ko2AM9A38LXx4npVCzPs=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=ZFGuHu/n334Rzsi4Lw7MgRk8JZqV5bDcxJarcVfI3NoXl6/6zVz+obi8BuXFeCcJS
	 Ss5JUQuTpc6F2IXOIay2WIEAJJtWbtz2e9AuT/1TgayEPGOVPNrXZwP3f2zbYfjp9F
	 UyEvJL5J0euyyddcemQYxnNTPCrGUKpfj3Cuh1Yk=
Received: from [10.23.23.39] (unknown [80.188.228.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 40A131C0347;
	Sat, 10 Oct 2026 05:34:13 -0400 (EDT)
Message-ID: <0e47c22afbce2f94673bcc77d640cd9da410c2f2.camel@HansenPartnership.com>
Subject: Re: [PATCH 13/17] tpm: Add verification of kernel signing key
 provenance
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <matthewg@nvidia.com>, mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org, linux-integrity@vger.kernel.org, 
	rafael@kernel.org, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Date: Sat, 10 Oct 2026 11:34:10 +0200
In-Reply-To: <20261008132532.1155166-14-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
	 <20261008132532.1155166-14-matthewg@nvidia.com>
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
> Add tpm2_kernel_key_verify(), which checks the provenance produced by
> tpm2_kernel_key_create() and returns the public key it shows the
> kernel
> created. It checks that:
>=20
> * The session audit attestation is signed by this TPM's kernel AK
>=20
> * Replaying the logged cpHash and rpHash pairs from a zero digest
> reproduces the attested session digest
>=20
> * Each logged rpHash matches the recorded response parameters, and
> the commands were PCR_Read, NV_Read, and CreateLoaded in that order
>=20
> * PCR 5 was read, and held the value it holds now

I get that PCR 5 measures boot configuration and isn't supposed to
change from boot to boot, but what about across things like firmware
upgrades ... do you have any idea how brittle it actually is?

If it is brittle, one way out of this might be only to care about the
last log entries, so make sure the log hashes to PCR5 then find your
EFI_ACTION and the exit boot services mark in the right order rather
than caring about exact value match.

Regards,

James
