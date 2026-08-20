Received: from www345.your-server.de (www345.your-server.de [78.46.144.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B7B33B6EF;
	Thu, 20 Aug 2026 18:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.46.144.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250906; cv=none; b=SbXCXLYrYEv0Vah/6Bz0ODLC/dVXZRPySC3z3OCMGLjlpEvl9X1PFL6WggkQmCgz7LFEPk0PM7f16idxWgLslOmGolSYHImG+Cj6fMUvpOr+M7pzzZIeyY4gqMlISO4BqzS+5AGJN8bMkp7T/NzC4eWRzPcbUp8htIll002LPHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250906; c=relaxed/simple;
	bh=SMdx/iOHRmi1Z8kVQZ/h7oFdxdJSzOry9cZyYI1ThvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FC+dc5LJB+uVPCEcJEjLG1uwHkiYTWHJmE8AeohyVgCkXD8XUGod2v6c/UABajC4Absbtsb5Uxcz7ODipEgHo11cZKvJxE3Y7IFhs743eISfkOP18cvOrqCX77Wpc7QCnY7S7hfV1h7nNyioyEjFy3gt62dhzXb8RVFQqbUJCbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tti0.net; spf=pass smtp.mailfrom=tti0.net; dkim=pass (2048-bit key) header.d=tti0.net header.i=@tti0.net header.b=LIti40xN; arc=none smtp.client-ip=78.46.144.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tti0.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tti0.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tti0.net header.i=@tti0.net header.b="LIti40xN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tti0.net;
	s=default2601; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID;
	bh=JNzjv835lyUqrhzNovsIHGPkQXAwt05OC21nFFA3FE4=; b=LIti40xNgGRkhIkUh2yNFZZPy6
	IodQP9HNDPuAJh3LOrquMpaoLeZJuxuzdjy6gDCVVyBkLBhy7otHEyvjs19mV8ibfkq1fYmfoVEgh
	NSq8b3sJmAi4pqdtHPp54sK7F2W3I3awVRjVEreLbFxP3U3nfeRNd9NBawo/WVWLd/Yc8+djD3lmH
	BJbHQAMCP1+oV/d229jzW7I90xKf0X14tboYtWjGL/cy13SsHhtK3HtVyz3IqyRB+G/bb5fq2OCfH
	sgYIpJhkHgHYzkxm241Zkd7s3Lfs03ah2rtBQfyUI8+kxjhbKzhXNAPxft3xyY4YAM1W7DUDbhzWj
	nI+LMDkg==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www345.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <theodore@tti0.net>)
	id 1wx6yR-0005zC-0H;
	Thu, 20 Aug 2026 19:54:43 +0200
Received: from localhost ([127.0.0.1])
	by sslproxy06.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <theodore@tti0.net>)
	id 1wx6yQ-000HOb-0M;
	Thu, 20 Aug 2026 19:54:42 +0200
Message-ID: <04e11e34-1b3f-4892-adc5-ae2ea040c004@tti0.net>
Date: Thu, 20 Aug 2026 18:54:39 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] efi: Make EFI_VARS_PSTORE depend on EFIVAR_FS
To: Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 Tony Luck <tony.luck@intel.com>, Kees Cook <kees@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20260625171214.8058-1-theodore@tti0.net>
 <6ecd6385-37c6-4ae8-8413-53a6e8602635@app.fastmail.com>
 <55870f62-ee17-4aed-850e-790517f68eee@app.fastmail.com>
Content-Language: en-GB
From: Theodore Tucker <theodore@tti0.net>
Autocrypt: addr=theodore@tti0.net; keydata=
 xsFNBGmHP+gBEACnnPcUqdwqLoLADUrUMkvjz7Nl8+tCr9JRFjnbBiXtBwZ6vijws0sJg3b2
 lktWjyqVK/IxMItoT2zzqOAv7JruY4vTPwuqBvTg6V29b62Pty0SHi9ZyjhPt0avI209ietU
 jYfntiAfXLZAqiN6k6PN11tURqUm4WD4aJh0/JDA0adhAX0B5wgTChRCh6GVbvis29kJYusW
 /OBpUGrpq1vNwDvKdHlSvTbpKEaFftkTLqJdjNroybRClzy/2iNZjA0pv5Uft13AtB/8jNXc
 gmz2AGPvtMKzYZqPzFvrz6IksdU7jwFC/zXyAzGuPTwE8srYHrKMcf+Ir3e9pzJnYWiUtf1a
 k+JJ7eDp3M0Ihdsog1WGei2y85AncF5USJ3ELsSoBxZXok86taowdRwgSgsCmRrdSPS3yCNY
 bkjCGKYY/JtBaeBeXnl6D5OqzBl007IUUNM7PbUUMPi3sfTKyYSPxbPspNrUm7UdKIB0//Pe
 ls0P87Roqy/ojATgEzD+UJJBHEcVPFjB8uA6aZv8D/GDA/nQQZLlz/+OHhHiybSKIFo7jGas
 qsAOEH0XE6HxNRJeVD0p0Qdk8Xx2bJNTaFtAQDknpKStqC70GSck5DCRMypwjahIkETiGs1D
 +FoAZFmq984kRQv6+vmJiDdKteBiGqS84cgnEpA9rMiIqDStIQARAQABzSNUaGVvZG9yZSBU
 dWNrZXIgPHRoZW9kb3JlQHR0aTAubmV0PsLBlAQTAQoAPhYhBPJELXhAeV8EDgEYqySfAQz1
 WPWEBQJphz/oAhsDBQkFo5qABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJECSfAQz1WPWE
 s+gP/1+aqZSH04H1tv8jjo04QH2cRlVRo2O2oC5TBtQ2lk7c2UZmvY7/CHHxl0/kb123zqRW
 AxE2oIaEhnY6aZcodWP7BUvovfcumLf+TpIcwDdeTjEvzNqI2U7wQx2+aLR1kn97cYSSIBwI
 u911gaWZlVLDr006Bj4/Xa0P6EAxC5AD4uSs/jA9dO8ZJU+gBTvHtUVjrs67PD5LMbqGdbpH
 ISU8eXjYb6P0mn24n4/V92z7lQl+yVvKfPD/NiVWltD0B27x1w7oQ9GEIvTVrSt8HirlS6UQ
 tC/mxKCAX3RrAgUnGMAGkXGfJt4L+ul7IuashuyirR+3rv7fY5mAKbiRsUCJyPI6Flph2XSY
 PYn5xz1uYkdK0n1eUtPerX3LRHoiRevPaDY8p5RcaGXzHDARHkX9h9SuKo7mv6bm7v7+3Rq1
 80oV95EQ8Y8iCihuUPgz7VrUvj4bWYBabeeRumibaPbfdDe1VGz+SvM5Y5Tyqevu/IRlf5ps
 zrquf/xSObfHJ/zJC9iNffTi7eEtkJA+lKYPN1LarTk59qaN2nXNr5fOdLJaWSM4ON4MGoME
 pt1on83wdFs9hJGXmNCTvAKw9/oR5iX2t//p+mV1RqTbBFfIo+rGJdoGYvWjJdqpDvscBVez
 +93jOD1QV3A4Jx+7wvPF0xg4luEOXfiecnw9J9tlzsFNBGmHP+gBEADzTiUDLGABhhGM0q+f
 AXSxp6Z5lo5plQwXKsXZ9np3R5b6DOYOJ5zkdUFrQAJJJ4worAYyiQqVjKsBhh+5ux8YFF2q
 eD1znydJYd3fLDxH0gkm0wLE0GWnjL6A/PhAgARbKoowQZ7Tsfh3LAUpM7iv1bfZqMPAFdiQ
 qdAH4+w2I3lFkvkjYcEfLUq4OBGNvp96Dgcckw2Vc3IyHszpyxjaPeFnEQOwCpv59YM3RLb8
 w9dSVQ/2cw+xAr7VIEVGWKOwqaDW0JelqVcftT4YZYxvXCT07A4Bv29C3jEeQFYjn+EEiCgW
 0vK7exq17wRKEe+fEMUcD820C4kNmBiuGak5WDBUtyjdxroV9gxvkRAEWQecwImRCkEzmwVq
 DOaDDTFzgIJpYTp0MdoDX1KY/UaUmX8BnPaUNB8lSFGvV3oshKaoYREUxBMooWJN5KIDdGML
 s5bWq2RiXQdUhjoSnnNruvyvWFWFj/hkbRGztvg4PmfOXlcUqDDCRVTm/MRzfSGa0rWF7AZN
 3TO7fEy43pgnE8erhkLu83dEkn8HX2ZHh1mgvChkRxqrC/xADfirovQ4SBXvN61kNsN5b/Wp
 LhWsmPJxHRRIvGrvXApZASQWzrhVer7uHYufALSQpGmLg+gHzkatwgudIC5b/07sWFYqF6fI
 WDIDPuUmPlk7BSQmDwARAQABwsF8BBgBCgAmFiEE8kQteEB5XwQOARirJJ8BDPVY9YQFAmmH
 P+gCGwwFCQWjmoAACgkQJJ8BDPVY9YTpDw/9EA/0tasC6TKKlq9oaqonaELCoC5DGkJoBglO
 OIComnR/nwgftMvpPFlGmhmbF/bKoEHQQ/Js3chhVZoPAmNO9z9Q14quo2a4BkctAo+72Rqz
 DROnCGkNk+Kx8CWfUmM4WLXBm6fhHY3daIYZP0AeA7bJfWh7gw8tB3sOolqRYQ6ueichQTtZ
 MOQisgFUmCmBDefn5+YIKIybhLV8pcfr8DWnJoSdHkk6Ak7TW/XKPkgOZABrSa0xkVIqRG65
 Rrp52rTZbgRSkBxPDFxgeFpkuqdX4/marYCdyGDToWfxVVz9odsy8tPTyUiWd1MhcE7sfLQc
 sJ44BUIVSYbbxxG2XE6NwY/8l6EeXLtGvBkLu+pPN+YKlyFvMJ3JxCWkJFvNiiETCWcydsLg
 NfK2JUiAMMc45TreZWZ2uekquGgfzCe8OVhjCWwIRPn5qAVY/Ub7E+/O/VF5hqBsvxkf0iEb
 /x1Me9VDOKFYE1chgAYGSqrkZ71odYUV9g2/oK05T1kaAKaXSGT3sJNSTM04SBQIW71jT9vU
 sf0l1NAHBWcjBOiaXqUGxVZVzDs+dD+jSqxHmEw+AVw52yQehVt5g/sBFxc7EqBhHNt7QDBJ
 Mw9TCk2uzzqNKDWK5M5YgT8Zww3tRW8yfDzD1HTM0WV7/lmFRnjj7wYYzZeX4rf+m7pfZlM=
In-Reply-To: <55870f62-ee17-4aed-850e-790517f68eee@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: Clear (ClamAV 1.4.3/28098/Thu Aug 20 08:24:22 2026)

Hi,

On 20/08/2026 12:49, Ard Biesheuvel wrote:
> 
> Actually, EFI pstore does not depend on efivarfs, it only depends on
> the efivars layer.
> 
> Why do you think it needs to depend on EFIVAR_FS?

When building a 7.0 kernel for x86 with `make alldefconfig` and then 
enabling CONFIG_EFI, CONFIG_PSTORE, and CONFIG_EFI_VARS_PSTORE, I found 
that the EFI pstore backend failed to register 
(/sys/module/pstore/parameters/backend was empty after boot) unless 
CONFIG_EFIVAR_FS had also been enabled explicitly.

I can see now that EFI pstore code should not need the efivarfs, and 
neither should userspace, since it gets access to any logs through 
/sys/fs/pstore. So I do appreciate that my patch may not be the right 
fix here, and I proposed it not as an expert on the internals of EFI 
pstore, but from experimentation as a user. Sorry for the noise.

I eventually ended up using the ramoops pstore backend so unfortunately 
no longer have the exact kernel configurations I used when this tripped 
me up.

Thanks and kind regards,

Theodore


-- 
Theodore Tucker
theodore@tti0.net

