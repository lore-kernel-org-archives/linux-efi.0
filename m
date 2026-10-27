Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793127560;
	b=SM49DYo7QIOvkcoyXwTaecferE99SoNBWU7PchM3BVDMPtMUIT+LKH00r/G3MqwnLk6N
	 Nhc2O7eOxL+TSVQ4CA6ReLlOmTxGialIM7gK3EA7r2T16V5/3cSt7djwI/Q9+0xKl7VRE
	 HcJrYXGc3THSgHNYzLiiEUAjW1uJkHIdQJ/IPquSXc/mCdmfE/k5HdRwJqehbBFiqmn0E
	 7W4/upJ9AC5HTErvslH58Zu7ofByvtThsBiwyP9ixueNxZ1eXiDlghKxNiG/oAwUjstD+
	 3z3kYmqPiLWHhPBVfK/Fq1Xg/ukgeYBhFOUxIg0Brl4z2QSVTjKpi7sbdsInQLVAQpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127560;
	h=Received:DKIM-Signature:Date:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:From:Cc:To:In-Reply-To:References:Message-Id:Subject;
	bh=dQ+cCxuwh8Zl3zbw4eqIfOHayKknJP6gyts2HlafbsQ=;
	b=zfZqSTn+wgP1X2loiFNS361lVnUfcNkfgJor/jaEHcohM9O80/k6PmTcdo9Gr3zAXSuH
	 zUHJyfF3neInlOef3vb93DourynhCUtAEfNdhg0luG7VsurXh9Lag7lS8zBHGPrzoepy6
	 rxGc8tBJwmpDcXwsZO3Ekyoix1ZuhqKuGiB9xTn7y5ZaNf70O0GW1rJN5w3A/8Zfp9Uqn
	 xRT6ig8HiY8WbwN4zzXz+xCbNSNEYaxNPecw1w4iRl6eerPfilns6LIGh5CcVHRByEyA2
	 NeG21R/I9if0qQrLFwvPolQ3nAE79uWYc2idDasvD1IsiXSvnzB0VZAGyAC2gyppeDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Luhdb2cJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63767606A31A;
	Tue, 27 Oct 2026 18:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Luhdb2cJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B456A1F01825;
	Tue, 27 Oct 2026 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793127560;
	bh=dQ+cCxuwh8Zl3zbw4eqIfOHayKknJP6gyts2HlafbsQ=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject;
	b=Luhdb2cJRg0tQy9wrmxUhuSF4OlugZTomN5BeG4ucjo9tjm5hWhP+JiWmXDmF6ajd
	 rXTJSDiNxKj0+pXKlZeX15BhG8aIKOE5aISdW0h9BhBhaVIiX042ZYUMuL9isdm0gs
	 p1XiJFS33DA/WCZCh2cqp0xExWn1cdsAgYFchbxJDJU9yi68zL3G6UWRCFllM39TrF
	 HE+qsC1FzN/rakkcvbeXTUMXepXqlOmnYcvueLMn2dzdnU7u6K0WMv/BClVAxz9Mgb
	 r6XzBSW2XaL7JactruIWVXTy0AojaC1d2vRfzo/cfcPGTP97m8At6TN9PyMROMjuFo
	 nGufISP/pu4/Q==
Date: Tue, 27 Oct 2026 13:59:16 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-doc@vger.kernel.org, 
 Mario Limonciello <mario.limonciello@amd.com>, 
 Thomas Zimmermann <tzimmermann@suse.de>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Helge Deller <deller@gmx.de>, David Airlie <airlied@gmail.com>, 
 Javier Martinez Canillas <javierm@redhat.com>, 
 Ard Biesheuvel <ardb@kernel.org>, linux-embedded@vger.kernel.org, 
 Francesco Valla <francesco@valla.it>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Peter Jones <pjones@redhat.com>, 
 linux-fbdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 Maxime Ripard <mripard@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 linux-efi@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Sam Ravnborg <sam@ravnborg.org>, Jocelyn Falempe <jfalempe@redhat.com>, 
 devicetree@vger.kernel.org
To: =?utf-8?q?M=C3=A0xim_Pedraza_Padilla?= <maximpedraza@gmail.com>
In-Reply-To: <20261027135342.2003632-8-maximpedraza@gmail.com>
References: <20261027135342.2003632-1-maximpedraza@gmail.com>
 <20261027135342.2003632-8-maximpedraza@gmail.com>
Message-Id: <179312747851.232790.4690032223617337169.robh@kernel.org>
Subject: Re: [PATCH v6 07/15] dt-bindings: display: add a boot logo node
 under /chosen


On Tue, 27 Oct 2026 14:53:34 +0100, Màxim Pedraza Padilla wrote:
> Products built on the same board often differ only in branding. On UEFI
> systems the firmware hands the operating system its boot logo through
> the ACPI BGRT; a device tree system has no such table, so today the logo
> is built into the kernel, and each product needs its own kernel image.
> With U-Boot's Falcon mode the device tree is the only thing that reaches
> the kernel, so it is also the only place the logo can come from.
> 
> Add a "logo" node, compatible "boot-logo", under /chosen. It lives
> there because a logo is configuration handed over by firmware rather
> than a description of the hardware, as simple-framebuffer nodes already
> are.
> 
> The image is a BMP with 24 bits per pixel and no compression, the
> format of the BGRT image, so that one file serves the firmware splash,
> a BMP loaded as firmware and this node alike. It is carried either in
> a "logo-image" property, which dtc fills in from the file with /incbin/,
> or in a reserved memory region the bootloader loaded it into, named by
> "memory-region". Exactly one of the two must be present.
> 
> "logo-position" takes -1 on an axis to mean centre on that axis, which
> is the only way to say it when the device tree does not know the image
> size, and "logo-offset" is added afterwards. "rotation" is the one of
> panel-common.yaml, degrees counter clockwise, but turns the image rather
> than the screen, so position and offset stay in screen pixels. The
> optional "background-color" goes with the image, since a logo designed
> for one background looks wrong on another.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>  .../bindings/display/boot-logo.yaml           | 156 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 157 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/display/boot-logo.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/display/boot-logo.example.dtb: chosen: 'logo' does not match any of the regexes: '^framebuffer', '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/chosen.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20261027135342.2003632-8-maximpedraza@gmail.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

