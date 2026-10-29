Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316435;
	b=4lp8JNW3dOZjW3EDufwr2o3Q83pjFxofm0fUK5y4FiVMwaeJV0ZGBlIfKgA7Yi5R7dQ0
	 DD/jEuPOiO9DQUjxbJ+B12krY4e/TesIxIrTtzfgnLONhA4zfI+pTf1tMXxWGI/hB32ke
	 WKinXlAPPPLFfz4epZFVEk1bzLPsLsb9TwUxrZ+emHslzeoOfUZVRTvl3+OmkxhYmDUdH
	 JI1UEox6DT63NSCmuuOwR90zI2owRApQaFuqAXKqFlpFLHZsvoljV21Jd8T4HBrLXOGYS
	 UU3CmTVztoDze8cnf3yonuzxAJZ63GKkMN8bjYKPrIPX3tj+6DqzZau/sy1+Iub5ncA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316435;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lSRz3HvItzCZqhNF30mlwnIBVEYrLAXRuap3P041BZo=;
	b=Gi60Kb0I63Xkw7AuTB+NvnsK1w0y3iQPB3habi4zcYwt9a53SVl4rR91JoqYbxlMNS0x
	 cs7Bp0JPGrNREPb7yE1WNdUPsVkIfkSngD7GtMEUFezSoc+754WZpz5PyELdCAr3LPdGV
	 zPKhu/SCbOFR2GlWQSFOuEK6iLnGCaw9xzxKoD9GubmINAnhm7ZoG3KCe3OU4EWheU1x5
	 w0j/ICfmriTGpullhJCRuJwR5dIUW5N51co0w9k9O+j9BrPvQZvN+o4/UO+OaAbkXVjKo
	 4B38MOOkQ+yoRvI6ljx57NFyibFsVI/QiJYuWyVgou1Ckt5EznfJjl6L1b91stKNr/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9wdoBeI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE129606A31C;
	Thu, 29 Oct 2026 23:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9wdoBeI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927621F000C1;
	Thu, 29 Oct 2026 23:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793316434;
	bh=lSRz3HvItzCZqhNF30mlwnIBVEYrLAXRuap3P041BZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E9wdoBeIMEgNrJ/M87gFdpcU26QwzTU4gRwo7mNkWk8y2pJDcaudPPLCEjm7k4mbY
	 +NUTULgwncND2jF7rMxDbuolnyw6sbTZyHiFY2GliQgfCEp09B+31r/+IGkXXsUN18
	 q9Lk9iMZb5hAHHptS1qG2THSbEVDFb5ZhIdABOjKnbrCongO85yCBkhrTP6pWVxiJR
	 hTygE53NLulPMCw37qbj/qlndT/nkqhNSkKn1b+0W1IWr9GxQxChSDJVpHAJQVNypa
	 fnluTvrm3LHRvIOPNAL8uLC9BRaUeVtIhXCGJ7+3d3m9QHmghlrf3UcnRjO/N36kpj
	 ojSqmGJA474DA==
Date: Thu, 29 Oct 2026 23:27:09 +0000
From: Conor Dooley <conor@kernel.org>
To: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
	acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com,
	ardb@kernel.org, james.morse@arm.com, lenb@kernel.org,
	palmer@dabbelt.com, paul.walmsley@sifive.com,
	robert.moore@intel.com, sunilvl@oss.qualcomm.com,
	tony.luck@intel.com, zhangzhanpeng.jasper@bytedance.com
Subject: Re: [PATCH v5 5/9] riscv: Add functions to register ghes having SSE
 notification
Message-ID: <20261029-pond-tribune-6e7a7f66b7cb@spud>
References: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com>
 <20260924073714.1650588-6-himanshu.chauhan@oss.qualcomm.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6NxvPHBpBf4dT3ef"
Content-Disposition: inline
In-Reply-To: <20260924073714.1650588-6-himanshu.chauhan@oss.qualcomm.com>

--6NxvPHBpBf4dT3ef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Acked-by: Conor Dooley <conor.dooley@microchip.com>

--6NxvPHBpBf4dT3ef
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCauPWTQAKCRB4tDGHoIJi
0soNAQD5B+qEK3gQyhSLjuOiXTqGo8e2fRHLKAUlPFmcrq5V4AEA/OoNMbWJ87z6
s82IA6MAgUDpTysT+Qgkk0p+eUjSmg0=
=sYju
-----END PGP SIGNATURE-----

--6NxvPHBpBf4dT3ef--
