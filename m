Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B766A46AA61;
	Fri,  2 Oct 2026 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790937851; cv=none; b=jxnd7KzrqBuojjhFJRrHXiATJkAd9Oe9rZt420omqZc6RqpHelKPcxwImDjc42B8mShpZiWH4XQBDvMTeLXeS3we2ZN3LBxOf5HuhrD1oxmoXJxYqU58ELMHikCvvP0+suUgzXTYGVAnSoSb5rX06QgXvhVvtwMTzdXdKpu0U70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790937851; c=relaxed/simple;
	bh=PjVwAzQCYGwPKJzDeGxqId1aM2ZU3GoeWQRCOEC9spI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=juVyWB71y94NutLTQGRVb94WCzgAJDLfXyfk1Cy1uOIRgZ7xzHmocIRfH3Cgpdn3m79nA0FEuel9jD1oSgxKswr0+ZPh24N/8FROtEmwBX7HNmFFDHRCM12K1AR0CtalDx73fRe9T03HfXyNJ02cayDMt9mtNtX3w/lslVQGUT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqyL+NJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqyL+NJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B2C1F000FF;
	Fri,  2 Oct 2026 10:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790937850;
	bh=h7N9N0HQ+Zh/gY8vIC7G35LJ75G5/SbSrtWyyePbhUk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=jqyL+NJVbKRZpwVzBRVfBtMkeH/Q7Nq+qvy9RiMFROqZ5ox5cWXhzqis9zXocX5uf
	 UzKzQE+PO8/7lo7lT2TeVh0jhjY1eci+LDaSxI5jn9jRl2pwmMkSkEF+94nzagvrJ9
	 6mkOHVagEwV3ZGbu7+6s3LW5rWKDkAfoi5rJAeNa1grp2ZvCTKSfEPIDtBE2tAv4AZ
	 tJcpF7ZmxQzznB0+LmqaE7dOeWqrWBl24aCETdN/s5Vil1pdWInQWt3y8Uch+GOXGT
	 EFSh+W5koi2wA4qJ3acfsMpCtJkXEkwkhnsosoN1gfM0CnUbe/U+ZsQMPkb1ygc6CA
	 2jh8uZttdHN7Q==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id E29DA198003A;
	Fri,  2 Oct 2026 06:44:07 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 02 Oct 2026 06:44:07 -0400
X-ME-Sender: <xms:84q_akNtFc_m8IqPCfS01lwOwwnlb6iwWNsSeaP5LZ8Jjrp2-u3vaQ>
    <xme:84q_alyLnBtn5FwbzjNapuvaHdpW6B-9vMFARV_dsiXL0fQeSzgwbddu0dCiSkc9Q
    8a2BM8XfbeYmeTnHApNqSlnH258O4q4an5JOkGoh9Bf2h4vXoUmWHXOXQ>
X-ME-Proxy-Cause: dmFkZTF7v0Xj1DEnpcO6BUVol6zWmZrAP6o7CWAwbHkhXdIDi5sSS7yp1xr9ZZPwIBhJBB
    GkXBQz9VF+JXcH7vt+0sFjJAGbofjSSmv/RNp/LtXy9wWYXx2hZ+b1RMskCVZPHKUMdb/m
    ZOatOHoCpXj0a+5ph5ldA1jKzb1ltDN2+7xxma8A6JrRxHKh638T16bFurO/dM3C7Lti8D
    l/JWE5GelKR6yNokvgG58ndMj85oi1Q3eGlSCRPSxw3CuPN09v6V+xYj8U2BkOzdi/fyBS
    Xeh6AuR5w7wBeoV114P0zZ9HmLX+orpjQGx0T/RZyJ/U+SYak5JNnunLMEXnRZNElXI3XV
    OmfKF7I5/l5lJnHfEL1ffIWJ6vZSfAFCrcfhH2R4hURERo3ZLyFgUBJy6AkKWfx5oahjhO
    kjKgD+tn6FMYK89N3OwEmM57+lmjU8qMO3A9WB7oNAkRwqmBeA0AGLLdfJqFVcdIYOYwDV
    eOzEY0V5ipQDOL6KuHdtjC2oOw5qfkEDmH14PvAQ1UL/G99OsCNlKojPtxe2MiYvhCEFXd
    ogosyg4Dsto/Hmajt8Kjzp/RXiqy1ufa5tQqCnEpscgFXTTte47mdqfwnxJ+2KgJLVZsNF
    M9zx7lZhfKryMkBBxV+1yQBZIpjjYmZmVW2IPzuUKeoMh4/QNIgBPgM2vR4A
X-ME-Proxy: <xmx:94q_ak_C4KXvsHtNobGGfNaogyMfAk7tajGtMizHpGLeRGI7KN3JPQ>
    <xmx:94q_aqL784SESyq09pYFL_dX5zdWPonTeW-K4xVghEmHPEnLG2wN2Q>
    <xmx:94q_ap9rnmPKD8H6SvD-Ar5lpL9lk22OtJkTznBkS8wPTWnTfhtGWA>
    <xmx:94q_amFF_UHjAHVfwQESOn13ThpYvSt5tGXuLALn_hdrm_xAzwHLAw>
    <xmx:94q_apMIXONDJhbdtCTvo8nI1N2KYDTGljkHYRXIG5A1aaccZY-RK2sY>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 99395F80090; Fri,  2 Oct 2026 06:44:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 02 Oct 2026 12:43:43 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: =?UTF-8?Q?M=C3=A0xim_Pedraza_Padilla?= <maximpedraza@gmail.com>,
 "Jani Nikula" <jani.nikula@linux.intel.com>
Cc: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>,
 "Conor Dooley" <conor+dt@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "Francesco Valla" <francesco@valla.it>,
 "Mario Limonciello" <mario.limonciello@amd.com>,
 "Javier Martinez Canillas" <javierm@redhat.com>,
 "Jocelyn Falempe" <jfalempe@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
 devicetree@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-embedded@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <9cf259a5-6083-433c-8544-ca3f6286334e@app.fastmail.com>
In-Reply-To: 
 <CAEUXW=GKRstrsZniQSU0un6r--a2VrRjpZCe5meUyyxunJ-E7w@mail.gmail.com>
References: <20261001195847.141192-1-maximpedraza@gmail.com>
 <20261001195847.141192-3-maximpedraza@gmail.com>
 <5c92c6f27b0778124d2365603374f70bd9b69b8d@intel.com>
 <CAEUXW=GKRstrsZniQSU0un6r--a2VrRjpZCe5meUyyxunJ-E7w@mail.gmail.com>
Subject: Re: [PATCH RFC v4 02/13] efi: bgrt: export the BGRT table and image size
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Fri, 2 Oct 2026, at 12:31, M=C3=A0xim Pedraza Padilla wrote:
> Hi Jani,
>
> On Fri, 02 Oct 2026, Jani Nikula wrote:
>> Data is not an interface.
>>
>> If these will be used more, perhaps it would be better to wrap access=
 to
>> them in functions? I think most of the time it will help with
>> maintenance.
>>
>> And you can add stubs for CONFIG_ACPI_BGRT=3Dn where they belong,
>> i.e. include/linux/efi-bgrt.h instead of drm_splash.c like in patch 11
>> of this series.
>
> Agreed, and the same goes for your comment on patch 3. For v5 I would
> replace the export with accessors in efi-bgrt.c, stubbed in
> efi-bgrt.h for CONFIG_ACPI_BGRT=3Dn:
>
>       bool efi_bgrt_has_image(void);
>       phys_addr_t efi_bgrt_image_address(void);
>       size_t efi_bgrt_image_size(void);
>       u8 efi_bgrt_status(void);
>       u32 efi_bgrt_image_offset_x(void);
>       u32 efi_bgrt_image_offset_y(void);
>
> The splash client then drops its own wrappers and stubs, and the
> "static inline" in drm_splash.c go as well.
>
> drivers/acpi/bgrt.c is the only other user of bgrt_tab and
> bgrt_image_size. I can move it to the accessors too, so that both
> variables become static, if that is wanted; otherwise they stay
> global for it and are no longer exported.
>
> Ard, this changes the patch you acked, so I will not carry your
> Acked-by unless the above works for you. Both variables become
> __ro_after_init either way, as you asked.
>

This sounds good to me - please cc me again on the result and
I'll take another look.

