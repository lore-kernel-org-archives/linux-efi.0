Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018018;
	b=oP65D8ichfLL2Y4KS46U81FamOgtE+slWGV4JuZxEwf1Hqx0QwlEwoFcHc6RIJFiOh+q
	 rBcEHoQURRSqtoDq02j5FLCBKAs/XhLmk6u/gocxTToUwWnYBV0dIS6GL5SsaT+mVyJE5
	 IsuAB70RJMFPpMl0FXkTyOtpUhcqXE/lZnm3WT9CUdxbiXOhPex3NWuNgUye5GRhob6PE
	 dTQle0hJky3NGU8d/098x/rrKVyZrUxN3sqg4pP3A7/VKWBAgae9MLiXijz/MUvPQ3wCu
	 TP0bmHkZj5SMijOyfrlDPPUsiMjcJKiP28hj6bxaKOspV3WG3xJXnedAoUV/FlKf3PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018018;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=33mAv7H3VUy7v6ipmNAN/H+V7FHfCLPW/SJICyXtSnY=;
	b=X1bbk+9scPB2a6lgv9Luf+/li/9XABDZkcfWFMJ1gPF78ORvCcpRMQpkVZSukQw+VCD+
	 dpNqjRv0GRRQE5DxMZD0byBGNxl5QPPqsxdV4OVej7I8niAhvGnROrlrIGOSrcWf7RsEX
	 vo76K9AQkMMCD93+LcaK07xU6/nL1IJMSMWInQB67QOf1xcpizKgHNQYOgyiaM5wSfdXz
	 pk8tWQTC9DTVMV38szndWoC4KAqW5BtDoASGAKqpuSrgpVqpvfiecIfkmr+I3CmqQQi9f
	 o56gN58Dl2LzaQAkwmtcFUCzaveOOLZkuuibDd7K74tM0Vi46mIJdDOi5FMbW+qY6dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=xVWQBudA;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1721606A320;
	Wed, 18 Nov 2026 16:06:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1721606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=xVWQBudA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1795018016;
	bh=qtu24fskTUDWBcD5rdt0E6zdsjXsbEIJB+o1SqYVNdo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=xVWQBudAMK6ta07v93pS0G46xtO8VdwAmK8NLQcv88PPnROHOGSMrotILnij48FyF
	 EkmRaYy5Wbms8VGsAIyNrAZxQ7My0g2Eykib931DoX85/cstDNMWVInA0W3Ira7dRQ
	 TPvchbByvDH5RW9MzT0lZb9+9ObSY+at1nO6abwM=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 161F81C081C;
	Wed, 18 Nov 2026 11:06:56 -0500 (EST)
Message-ID: <ba43d150febc8a85247d6c54f57db0835cb8f5de.camel@HansenPartnership.com>
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that
 can't be modified by userland
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Matthew Garrett
 <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org, 
	linux-integrity@vger.kernel.org, rafael@kernel.org,
 linux-pm@vger.kernel.org, 	linux-efi@vger.kernel.org
Date: Wed, 18 Nov 2026 11:06:55 -0500
In-Reply-To: <avnMl7fD156F1fx4@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
			 <20261008132532.1155166-2-matthewg@nvidia.com>
			 <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
			 <asqthz69ohnMVCye@srcf.ucam.org>
			 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
			 <astjpI65VOyU8xvI@srcf.ucam.org>
			 <f002fc613bf0bdcf895e5be02dfd2524b7608787.camel@HansenPartnership.com>
			 <asty4acE2B94t5q6@srcf.ucam.org> <avnMl7fD156F1fx4@kernel.org>
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
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

[Matthew seems preoccupied, so let me try]
On Sun, 2026-11-15 at 17:15 +0200, Jarkko Sakkinen wrote:
> On Sun, Oct 11, 2026 at 04:28:33AM -0700, Matthew Garrett wrote:
> > On Sun, Oct 11, 2026 at 12:27:58PM +0200, James Bottomley wrote:
> > > On Sun, 2026-10-11 at 03:23 -0700, Matthew Garrett wrote:
> > > > Hmm. Well, that's irritating. Which year's XPS is this?
> > >=20
> > > It's an XPS-13 9380 Core i7 ... circa 2019 I think.
> >=20
> > Yes, that's definitely later than I hoped. Bother. I think this
> > patchset is probably still worthwhile because it does unblock us on
> > at least some machines, and the implementation is intended to be
> > opaque (other than the change in PCR 5 measurements, but we should
> > still get log replay) and can be replaced with something else if we
> > want. The other approach that springs to mind is tying this to
> > having distros switch to a new kernel signing key before enabling
> > this and so having PCR 7 be associated with the feature, but that
> > sounds like an incredibly tedious thing to get right in a reliable
> > way.
>=20
> What prevents blocking PCR 5 access from /dev/tpm*? If firmware
> already, does it, this can only add defense-in-depth.

Nothing does, but what's the concern? A random user writing to PCR5 to
disrupt the validity of the next suspend image? This is already an
existing problem for binding secrets release to any secure boot PCRs.
However, if we start blocking access to secure boot PCRs, there's a
high likelihood of unforeseen consequences (like interfering with
unlock once secrets that do capping writes to PCRs to prevent
subsequent releases).

The better mechanisms to address this are probably:

   1. Detect that PCR5 has been disrupted (get the kernel to store the
      on-boot value and check they match) and if so refuse signed
      suspend to disk with a message (this is easy).
   2. Capture the additional writes to PCR5 and store them as part of
      the attestation so the resuming system can prove the current boot
      value of PCR5 matches the attested one when the additional
      extends are replayed (this is a bit more complex).

Regards,

James
