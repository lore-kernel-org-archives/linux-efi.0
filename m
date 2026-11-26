Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694678;
	b=oWc0/HJ+UMesAfGVxNOBd6Jy8eL7qyKYdFMQLillRJr2WDGlTlKJnIz+2HPOSOiGg8AZ
	 8vAe5Ja9dU/VvNt0XoHr80aAKGz4VD9p6rML0ovjlTWt3EpkiWCOW01OoaEUvYU6zCySt
	 8iWM2VJX7ZDQ5YIuJNtWqrpAHgiIwAF8nL0rOpKLzNb3WyhwdlLQbA/cS1BHqK0mfltfc
	 no7MEpyuIad8vWHmNel1gBrWiwJ2/EOLK7ETGHfr3cC4gOVJ6JVXUaKznx58d3TZGK8sA
	 X0Pp4hRSF8U+tRT8G/q1GwpmHq674uUocQey0w0f78xlt7StwYA4rKso6Aa8sFWrmxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694678;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3dUYzLV/td3yOtQmZ0QB4MKkO835tg4L7TOKfdmw8Ow=;
	b=JqPp7xluKGgkULJZC8HLELDM6TvgzHaAdkOcrd2xBKHPJa406N7BXmGRUF0dhCQYz/HL
	 OWo2FY7gsXahs3P6g1mLu39BuMPnMMQRR87Qs2wGP5/UbLDjy/pgkB5HLYIusd/AFwxg2
	 zOIGpTSRvuIjnk3O5mSA2rRFK/tD9J7at1CXLSqsFpl4k5MD3QOo6Iyx536LafwCLm1tJ
	 c/FCVxDZD+edrYc0mnTzRCNokDtt39bwZRy3nFfi+/q0SFkR4qcwoDgOfBT4hhI67z+9h
	 9hVZ4Rmb91WeXauJpmt3bM7DXK4sjH4F5tnbkod0QeH49iGQcfVL1mPd9Pj7ZOMPWGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TlgeGOir;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F32606A31C;
	Thu, 26 Nov 2026 12:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TlgeGOir
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05BC1F000D1;
	Thu, 26 Nov 2026 12:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694677;
	bh=3dUYzLV/td3yOtQmZ0QB4MKkO835tg4L7TOKfdmw8Ow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TlgeGOirwVIGCy+faEKzfzOtYCzU0Hcbc+IGO4+zce+NfiNtLjqkU1aQvo7aORyWM
	 2f1pNlQOGkWu0l+TUWcv7Ah7CNFSHdxdZoIbulcEGwI5vJve/M89G8jN2NJO96BHXg
	 31IRzV0ut0y77Q7sRDsipP99W6JMPJ5Ctsj9ZS2w+qwidHTcrGxyF0LUov3Dfm/MEk
	 5vtp8F6aZ/F7DmH0Sodyf9Q8Cix3HrwoZlYeUGbUhOd7i6bDB/tLPZJg23ocdacasc
	 paJ5jIpAQMgUJ0Jxlj3CNqvVW039zOyXCjHjxDoWyJj8swOb3uh94LvH5FpyV1oQA4
	 2f8xtvWOwHe1Q==
Message-ID: <sashiko-outbox-235472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC v2 07/13] ACPI: TLBI: Parse domains from table
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S3Jpc3RpbmEgTWFydMWhZW5rbw==?= <kristina.martsenko@arm.com>, kvmarm@lists.linux.dev, linux-efi@vger.kernel.org
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Anshuman Khandual" <anshuman.khandual@arm.com>, "Lorenzo
 Pieralisi" <lpieralisi@kernel.org>, "Hanjun Guo" <guohanjun@huawei.com>, "Sudeep
 Holla" <sudeep.holla@kernel.org>, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, "Fuad Tabba" <fuad.tabba@linux.dev>, "Joey
 Gouly" <joey.gouly@arm.com>, "Steffen Eiden" <seiden@linux.ibm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Zenghui Yu" <yuzenghui@huawei.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Jinqian
 Yang" <yangjinqian1@huawei.com>, "Zi Yan" <ziy@nvidia.com>
In-Reply-To: <20261126114936.864256-8-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
 <20261126114936.864256-8-kristina.martsenko@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 12:04:36 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] ACPI: TLBI: validate_tlbi_domains() allows zero NIS bits and
  duplicate ID 0
--

commit 16b5ea117539549acd04f827b44be9eb240e442f
Author: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>

ACPI: TLBI: Parse domains from table

This commit adds parsing for the Arm TLBI ACPI table to build and validate
the list of TLBI domains and their CPU masks.

> diff --git a/drivers/acpi/arm64/tlbi.c b/drivers/acpi/arm64/tlbi.c
> new file mode 100644
> index 0000000000000..1a4b591f8f706
> --- /dev/null
> +++ b/drivers/acpi/arm64/tlbi.c
> @@ -0,0 +1,211 @@
[ ... ]
> +static int __init validate_tlbi_domains(void)
> +{
> +	u64 tlbididr =3D read_sanitised_ftr_reg(SYS_TLBIDIDR_EL1);
> +	int domain_bits =3D FIELD_GET(TLBIDIDR_EL1_NIS, tlbididr);
> +	int domain0_idx =3D -1;
> +	int cpu;
> +
> +	if (domain_bits > 16)
> +		return -EINVAL;
> +
> +	for (int i =3D 0; i < domain_count; i++) {
> +		u16 max_domain_id =3D (1 << domain_bits) - 1;
> +
> +		if (domains[i].id > max_domain_id &&
> +		    !cpumask_empty(domains[i].cpus))
> +			return -EINVAL;
> +
> +		if (!domains[i].id)
> +			domain0_idx =3D i;
> +	}

[Severity: Low]
This rests on an architecture and specification detail that could not be
confirmed from the kernel source alone: can a system with FEAT_TLBID and
TLBIDIDR_EL1.NIS =3D=3D 0 validly present an ACPI TLBI table (for example,
describing domain 0 alongside SMMU or Outer Shareable domains), and are
TLBIP instructions permitted when NIS =3D=3D 0?

__init_vtlbid_regs in arch/arm64/include/asm/el2_setup.h anticipates that
TLBIDIDR_EL1.NIS can be 0 when ID_AA64MMFR4_EL1.TLBID is implemented.  If
such a system presents a TLBI table, validate_tlbi_domains() only checks
domain_bits > 16 and does not reject domain_bits =3D=3D 0, nor does it reje=
ct
domains[i].id > max_domain_id when cpumask_empty(domains[i].cpus) is true.
In addition, duplicate id =3D=3D 0 entries are not rejected and overwrite
domain0_idx, so an earlier id =3D=3D 0 entry covering only a subset of CPUs
passes validation if the final id =3D=3D 0 entry covers all possible CPUs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126114936.8642=
56-1-kristina.martsenko@arm.com?part=3D7
