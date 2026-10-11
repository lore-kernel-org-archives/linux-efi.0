Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE6617BB21;
	Sun, 11 Oct 2026 06:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791698675; cv=none; b=mr29qir0m87GN35yKxGfjdMM8wrtQthMHBrpr9ceygXOk1I8/S7fHf3fe0cXI52rfGu9YRL4ydTKTKasCmvSahfO0ta5wo8atLJaVpbq4LiSWehPfs6LYIfBMejTYxGe1av1PhBQ8UePFetVFVvCBD09wPdGBdX7gHOLtyojs9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791698675; c=relaxed/simple;
	bh=qQmjMVGfaoMxzHce3jAIh0i8dWumuMSkvNeLa89ofOg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IXuMSo4E5DtVa+jEm41CGqybyb9fASeQihWK4VfR1zwpSZ5InGb7Wns6M/QcsJ5MIDUx+helMnURQgMymBb09Bkc9xxXZ8xbNRWHECsqDcCLhLWpUpGMwgsnxtBLfiQR5+MNwmtOvuP0khg0+9YZXlhfMqRBMJA8/kdN9oFhR8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=OlyHu7sq; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="OlyHu7sq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1791698671;
	bh=qQmjMVGfaoMxzHce3jAIh0i8dWumuMSkvNeLa89ofOg=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=OlyHu7sql5n1DPvf0QO7QrverNqxwTSplVcPTSLUjdQNjcIKpFO/T8AwNREvVS5at
	 JYbKrz7+kY1AkngO8sGlCngMT2OVL9ZX6tWEFBSSUVZERO2J7SRDHt4sFIvZYru8Kl
	 FU7U0lBg+nweVA+UfeQLxDli8Z7iEMdzG0MhEJGQ=
Received: from [10.23.23.39] (unknown [80.188.228.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 8A9D51C0374;
	Sun, 11 Oct 2026 02:04:30 -0400 (EDT)
Message-ID: <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that
 can't be modified by userland
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org, 
	linux-integrity@vger.kernel.org, rafael@kernel.org,
 linux-pm@vger.kernel.org, 	linux-efi@vger.kernel.org
Date: Sun, 11 Oct 2026 08:04:27 +0200
In-Reply-To: <asqthz69ohnMVCye@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
	 <20261008132532.1155166-2-matthewg@nvidia.com>
	 <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
	 <asqthz69ohnMVCye@srcf.ucam.org>
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

On Sat, 2026-10-10 at 14:26 -0700, Matthew Garrett wrote:
> On Sat, Oct 10, 2026 at 11:22:34AM +0200, James Bottomley wrote:
>=20
> > The reason I never really proposed such a scheme is the rollback
> > problem (old version of OS or non-Linux OS can create the NV index
> > from user space bypassing the kernel only block) which you try to
> > solve with PCR5.=C2=A0 Do you have any data for how widespread measurin=
g
> > exitbootservices is?=C2=A0 I know edk2 does it, but I just looked on my
> > XPS13 and I only have two PCR5 events: a separator and the GPT
> > table, so it's definitely in violation, but if Dells don't do this
> > then it's indicative that many other manufacturers might not as
> > well.
>=20
> Does your log replay correctly for PCR 5? It's *extremely* common for
> the extension to happen without logging, since logging needs to be
> done  into the late events table and almost nobody got that right
> until a few years ago (hence=20
> https://github.com/google/go-attestation/blob/master/attest/eventlog_work=
arounds.go#L70
> )

It seems to.  This is what tpm2-eventlog returns (edited only to show
PCR 5):

---
version: 1
events:
- EventNum: 20
  PCRIndex: 5
  EventType: EV_SEPARATOR
  DigestCount: 2
  Digests:
  - AlgorithmId: sha1
    Digest: "9069ca78e7450a285173431b3e52c5c25299e473"
  - AlgorithmId: sha256
    Digest: "df3f619804a92fdb4057192dc43dd748ea778adc52bc498ce80524c014b811=
19"
  EventSize: 4
  Event: "00000000"
- EventNum: 22
  PCRIndex: 5
  EventType: EV_EFI_GPT_EVENT
  DigestCount: 2
  Digests:
  - AlgorithmId: sha1
    Digest: "bcd4ef027ee6b70a1ce07b37378da7ad02bfc545"
  - AlgorithmId: sha256
    Digest: "ed5eaf5ac436743417c862277ac71e1f202e6ff734fcf9a4ecdabc0d045d20=
a3"
  EventSize: 484
  Event: "4546492050415254000001005c000000de83a7fd000000000100000000000000a=
f129e3b0000000022000000000000008e129e3b00000000fc1e83487e221840b908f829a235=
f48b02000000000000008000000080000000983fc1db030000000000000028732ac11ff8d21=
1ba4b00a0c93ec93bb131ae393c3797438f4a8bf58beeaef50008000000000000ff07100000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000af3dc60f838472478e793d69d8477de4cde1b4fc71d4a245a89533bb0b5=
24e9b0008100000000000ff0f5e3b0000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000006dfd5706aba4c44384e50933c84b=
4f4fb29b70a77c1da04da9d7f36291c77dc000105e3b000000008e129e3b000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000"
pcrs:
  sha256:
    5  : 0x9c41c9e22fb5275e84b88f7eda8a764961f67ede9dfad9626e84208c9f7de63c

and

jejb@lingrow:~> cat /sys/class/tpm/tpm0/pcr-sha256/5
9C41C9E22FB5275E84B88F7EDA8A764961F67EDE9DFAD9626E84208C9F7DE63C


So that's a match.

Regards,

James
