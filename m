Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794790289;
	b=U81oU0sdTDJIHb3DZRnwiJ62Hus0FOYbB+5nh5RKCkH4BzoECipGL11vlcfYhslTN8PV
	 vK7Laxuk5ADJe8MF/OMIJwJqNLDxj47Dze895r8t5D+Mg/nN+JYxBNzW5ooMVSFf7UufU
	 sdk0c3U7j/7r2ffmza42cIVC2GOBD9ga/HUhsm1McCbiQYD7nvIcZztFitxaRyKDaiVTb
	 tJHNxew6CwyUTT5pKDreZwxeWq+meZGdlubmhqzdFj3s/8qlm+Nn+i+glgfdsqQpfzmqA
	 SM9pEpIFGQ1roaw68E4b9KnuI5Z2AgYm4KyllFhWqui49vF7nfLsoCPy0AP3XJLMEgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794790289;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LUSLjfnp5TqRZRnw5R5Q+hAEcOAQAbhF6INh8GwohFM=;
	b=yxQVOPV5wRulD3lywRaQduX4dBYeOaHmoqTfloOFJrARvwC6NJzA+yQ7LXlH+DVgJjhv
	 ewjpt4LHkpFnE895XDl1c8Al0yoWHJPP8WNq0rAmhd52YbM6ji5GAt22xzMKDxtvHtrdN
	 fq//psmnVWPw1fNe2VqUvv1J0KEyjrfAp+713/taNd3MJOO99aQzD0/IWxa2xMrGLi6F4
	 nAMe3nQUPnz52uRNIlotMvZKG9WOqKQ0MGyS2mHxXHOPebdc+GqnKxA6V+3IxLXM/CmeH
	 /pTOsoLIe92JJlRqrx31Hihz7WIlizLqIZAlPWr/ei7X/Z0FLyCIhfHkW9bXGMVYIFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lsjxaxPx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87D1606A333
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 00:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lsjxaxPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83C11F000C7;
	Mon, 16 Nov 2026 00:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794790289;
	bh=LUSLjfnp5TqRZRnw5R5Q+hAEcOAQAbhF6INh8GwohFM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lsjxaxPx7h534VLITV1qkGvb/Lu7j7wSrUh6viDw0GCQt903nlBbLvnMeSgCozt7i
	 RQucOy1/k2tCScpx3BRRMOdittRfta259aMwPiGcq4FKZVMG0kxv07Ody9feEO3DYt
	 KXZ4pYkkmKDHMC8i/CIO/lumPKzMiDfl9xQZZdmOlUHtccxHN17HG2Nu6wxdPaMASq
	 +X76HCageW+rWCbsJNvnGwGLq8s+QHsDPwKHkccYHUMDHuMpDs+MvE6+cwRUhF/3Hu
	 ySSnV18LWOq8j16KJWRs6+DI1yW+9L/RxBfYuLz9q7q0T0djuwmKfmvXafChL+tl8T
	 Y7W5uOq5LaAhg==
Message-ID: <sashiko-outbox-215973@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/6] drm: client: add splash client
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TcOgeGltIFBlZHJhemEgUGFkaWxsYQ==?= <maximpedraza@gmail.com>, "Maarten
 Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>, "Thomas
 Zimmermann" <tzimmermann@suse.de>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Ard Biesheuvel" <ardb@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Helge Deller" <deller@gmx.de>, "Peter Jones" <pjones@redhat.com>
Cc: "Francesco Valla" <francesco@valla.it>, "Jani Nikula" <jani.nikula@linux.intel.com>, "Mario
 Limonciello" <mario.limonciello@amd.com>, "Javier Martinez Canillas" <javierm@redhat.com>, "Jocelyn
 Falempe" <jfalempe@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org
In-Reply-To: <20261116002156.1027726-5-maximpedraza@gmail.com>
References: <20261116002156.1027726-1-maximpedraza@gmail.com>
 <20261116002156.1027726-5-maximpedraza@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:51:28 +0000
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
- [Medium] drm/client: splash: stale modeset kept when probe finds no
  connectors
--

commit fb1584c86189774bc202b28de7ab532767373aff
Author: Francesco Valla <francesco@valla.it>

drm: client: add splash client

This commit adds an in-kernel DRM client that displays a solid background
color, an EFI BGRT logo, or a BMP firmware image until userspace takes
over the display.

> diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clien=
ts/drm_splash.c
> new file mode 100644
> index 0000000000000..d54cf628cf17b
> --- /dev/null
> +++ b/drivers/gpu/drm/clients/drm_splash.c
> @@ -0,0 +1,1032 @@

[ ... ]

> +static int drm_splash_init_client(struct drm_splash *splash)
> +{
> +	struct drm_client_dev *client =3D &splash->client;
> +	struct drm_mode_set *modeset;
> +	unsigned int fb_count =3D 0;
> +	unsigned int i, k;
> +	int err =3D -ENODEV;
> +
> +	if (drm_client_modeset_probe(client, 0, 0))
> +		return -EIO;
> +
> +	mutex_lock(&client->modeset_mutex);
> +
> +	/*
> +	 * Collect one scanout per usable modeset, or per tile group. Each
> +	 * scanout records the modesets it feeds by their position in the
> +	 * list, so that the second pass below can find them again whatever
> +	 * was skipped in between.
> +	 */
> +	i =3D 0;
> +	drm_client_for_each_modeset(modeset, client) {
> +		struct drm_splash_scanout *tmp;
> +		struct drm_splash_scanout *scanout;
> +		unsigned int idx =3D i++;
> +		u32 format;
> +		int id;
> +
> +		if (WARN_ON_ONCE(idx >=3D 32))
> +			break;
> +
> +		/* Skip modesets without a mode */
> +		if (!modeset->mode)
> +			continue;
> +
> +		id =3D drm_splash_tile_group_id(modeset->connectors[0]);

[ ... ]

> +	/*
> +	 * And point every modeset at the buffer of its scanout. One left
> +	 * without, whatever the reason, is switched off: a mode without a
> +	 * framebuffer fails the commit, and with it every other output.
> +	 * Never the old one: a probe without connectors leaves it there.
> +	 */
> +	i =3D 0;
> +	drm_client_for_each_modeset(modeset, client) {
> +		unsigned int idx =3D i++;
> +
> +		modeset->fb =3D NULL;
> +		for (k =3D 0; idx < 32 && k < splash->n_scanout; k++) {
> +			struct drm_splash_scanout *scanout =3D &splash->scanout[k];
> +
> +			if (scanout->buffer && (scanout->modesets & BIT(idx))) {
> +				modeset->fb =3D scanout->buffer->fb;
> +				break;
> +			}
> +		}
> +
> +		if (!modeset->fb)
> +			drm_splash_modeset_off(client->dev, modeset);
> +	}

[ ... ]

> +static void drm_splash_rebuild(struct drm_splash *splash)
> +{
> +	struct drm_client_dev *client =3D &splash->client;
> +	int ret;
> +
> +	/*
> +	 * Every hotplug starts over, with the outputs there are now. The
> +	 * scanouts on screen stay there until the work or restore has
> +	 * committed the new ones; with some still waiting for that, the
> +	 * current ones were never committed and can go.
> +	 */
> +	if (splash->old_scanout) {
> +		drm_splash_free_scanout(client);
> +	} else {
> +		splash->old_scanout =3D splash->scanout;
> +		splash->n_old_scanout =3D splash->n_scanout;
> +		splash->scanout =3D NULL;
> +		splash->n_scanout =3D 0;
> +	}
> +
> +	ret =3D drm_splash_init_client(splash);

[Severity: Medium]
Does drm_splash_init_client() rebuild and commit a stale modeset when all
connectors are removed?

After a commit clears splash->old_scanout, drm_splash_rebuild() moves
splash->scanout to splash->old_scanout without calling
drm_splash_free_scanout(), leaving client->modesets populated.  If
all dynamic connectors (such as DP MST outputs) have been removed,
drm_client_modeset_probe() returns 0 before calling
drm_client_modeset_release():

drivers/gpu/drm/drm_client_modeset.c:drm_client_modeset_probe() {
	...
	if (!connector_count)
		return 0;
	...
	drm_client_modeset_release(client);
}

Because the old modeset->mode and modeset->connectors[0] remain in place,
the first loop in drm_splash_init_client() sees modeset->mode !=3D NULL,
reads the stale modeset->connectors[0], and creates a new scanout and dumb
buffer for the removed output, so the final loop sets modeset->fb to the
new buffer instead of calling drm_splash_modeset_off().

Clearing client->modesets with drm_splash_modeset_off() in the else branch
of drm_splash_rebuild() before probing would avoid reusing the old
modeset state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116002156.1027=
726-1-maximpedraza@gmail.com?part=3D4
