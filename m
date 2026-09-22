Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F74418A33;
	Tue, 22 Sep 2026 08:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065173; cv=none; b=BFEnAHlequ5zsl2lxoxG1L3foZ+UHYGIGEYcP1UYKxGaY6nFW+g31CpHpWfrJiMj/eKKfnnXQR9A8w+ATOrBNHuO5pLmfFtqORy0W/a3x6gMR6cpRwAW1PbS5HBk1Qi9pzdEzvDSAZyJEIzSyZP70fAF5gR1uhzJqBpRkuAEBfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065173; c=relaxed/simple;
	bh=HC4/JUWknuRlDmTPWvUCZL5/IBX6KNizhyFicMFHfRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2DVyT1qaPTxu5yejSNjkz2i5T5Sbw12KeErpKY6pfJ2dZ7BlA10l2HzwV4rTaui0VW2QoeK218g/sanuho3KoxD4wHa+LQsPF+Jre5gZZZum2AicQJyDSiE1CP8wWgY7v6pCkSxfeq+6bo66x9bzUTbB6Tj8BMmVBvnMedewhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kvig3ccl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kvig3ccl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A981F000FF;
	Tue, 22 Sep 2026 08:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790065171;
	bh=HC4/JUWknuRlDmTPWvUCZL5/IBX6KNizhyFicMFHfRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kvig3ccl5HE4pxQr3PQ2Fbl5qfBzi54hak7xsY46yImVe9s8c6x3djMYojEOALfc0
	 6cwbAzDbCILc13LrY0PwRYfva+uonCbGzp8K3ZGUhtwVNL9AYUnM+U/7AbH1zH/4kj
	 1tBuWYOEbdZbpUyzfiss20T3dkcLRgUip8z/ulamXJ1wvlccDStjqDP6Kha0AiR0ru
	 vOSlGl5adOaekke3rvueLgeDd2tksdbcz0mdLxT/2sVEeEA4Wc0jYZMSLLFyvgYRJi
	 YWCtGNvZzgZNq1OvqzUI+kjRr9z2ctehrcb1iisCCbv0FLWYrdMppb+CTT0Uepua2s
	 mTZZgAIbPGgUA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 029161AC56A7; Tue, 22 Sep 2026 09:19:27 +0100 (BST)
Date: Tue, 22 Sep 2026 10:19:27 +0200
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	platform-driver-x86@vger.kernel.org,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Shenghao Ding <shenghao-ding@ti.com>,
	Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
	Sen Wang <sen@ti.com>, Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Andreas Noever <andreas.noever@gmail.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH v1 13/17] ASoC: amd: acp-es8336: Switch to use
 acpi_bus_get_primary_device()
Message-ID: <arI6Dz3lQiiSzWkl@sirena.co.uk>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <2063881.yKVeVyVuyW@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g9wLfpB3a5wcy/uF"
Content-Disposition: inline
In-Reply-To: <2063881.yKVeVyVuyW@rafael.j.wysocki>
X-Cookie: Too clever is dumb.


--g9wLfpB3a5wcy/uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 09:53:51PM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>=20
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.

Acked-by: Mark Brown <broonie@kerenl.org>

--g9wLfpB3a5wcy/uF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqyOg8ACgkQJNaLcl1U
h9AtUAf/WrIx+1IBC/UCxyrfh6fRaiYU9rQ+OYNSO1bYP7b5ypcETGIH5hluHriB
80NoC7AO1Jgl6ZA30C8zMRGGlAw8r92sskZ51+sFEv3SzOegWgM0emRP2hM0H30v
0O4wZVu32zEC6aerkzPsGSthKygZa7hcl0Hy0oD9s6u4OmP7c8+LHadujlcD0uob
slUDG1TpAhDS4Uu5YKUTvqc1yMxvr2O8DfzIPiGHDh0aEeocrtbe5cgnrxQwGJBJ
+pj46e7cPjW3IKg0q8uOEyliL63BAeAaw1VQ49CoIDt2/LE93qGx9DUO1njPeZ9z
Llty1bZVqnhIOR0frCQwA1pyak3New==
=lFHR
-----END PGP SIGNATURE-----

--g9wLfpB3a5wcy/uF--
