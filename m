Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514843;
	b=VssJw9nC5Yoxf6py3jj3ggQ0+3G5jWHzPcvJC+fafZHuP4SZuQf3ZbWKJIbmAIHG0T6k
	 7ZW+M4RwDdgdHLwY+LZeO5bWFKTQgrB2nAAcmeYau6rlqjut15IvgzmSBB5+f9mX+Cpjy
	 4AIPJy9rs4af7yCerX/Vb9/zOffWpuFdem+TN3TZrbMjJJnmfE17mQ4zWK0pmXrHxkZ8D
	 M/xN/R+jK8gGAf4hdCFIUNelnDoUqWJHouijlTlme9MLECFGvzA4AdLh2+Iehfb0D3MTm
	 MUEifIJj+F0nZWhNbmDjc42jLkfwRaFTa9TszN35C9Z8V0efWua/eeYlFyJeoIXRgTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514843;
	h=Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=JRqtFuDuxtmiDxqkWDLmT7asRbopDuvT5Fq2Dr/Rymw=;
	b=KXL+7pQoB2iR8EMVYXTTb+Dw4XGQWkfrgTjhJ+aLnqfhmQQsi4yIKEnWIcb8h78XKQHB
	 VKcL2m4UllN8Em66wLutPwabyu1siTz10eTz+PndIAH+NOAnZ3Jn4Wx6U0XfIECAnWL8K
	 zywMdWZ2bec7r3UWuq2Iv11asWwPAnMKT4RVJQV60OkGvkOiFv6SAPoO++qd5GxRk6aRm
	 +U6nTw1yOlcbZFdnIVwlTMhZV62xLeZ3FAytrHpHy1RgVe7F9TwhgTjZrPNAhDMY+JuS5
	 60zc6m7/52BBo7GPxtvAYj3M5VFCmCu39RHsDhtCuiV0DGuxAmlyk4yakEmHnvTcYXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C6C60A261A;
	Tue, 20 Oct 2026 16:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE311F000CA;
	Tue, 20 Oct 2026 16:47:22 +0000 (UTC)
Date: Tue, 20 Oct 2026 11:46:51 -0500
From: Rob Herring <robh@kernel.org>
To: =?iso-8859-1?Q?M=E0xim?= Pedraza Padilla <maximpedraza@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Francesco Valla <francesco@valla.it>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 06/13] dt-bindings: display: add a boot logo node
 under /chosen
Message-ID: <20261020164651.GA4017884-robh@kernel.org>
References: <20261013093243.505776-1-maximpedraza@gmail.com>
 <20261013093243.505776-7-maximpedraza@gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261013093243.505776-7-maximpedraza@gmail.com>

On Tue, Oct 13, 2026 at 11:32:36AM +0200, Màxim Pedraza Padilla wrote:
> Products built on the same board often differ only in branding. On UEFI
> systems the firmware hands the operating system its boot logo through
> the ACPI BGRT; a device tree system has no such table, so today the logo
> is built into the kernel, and each product needs its own kernel image.
> With U-Boot's Falcon mode the device tree is the only thing that reaches
> the kernel, so it is also the only place the logo can come from.
> 
> Add a "boot-logo" node under /chosen. The node lives there because a
> logo is configuration handed over by firmware rather than a description
> of the hardware, as simple-framebuffer nodes already are.
> 
> The image is a BMP with 24 bits per pixel and no compression, the
> format of the BGRT image, so that one file serves the firmware splash,
> a BMP loaded as firmware and this node alike. It is carried either in
> an "image" property, which dtc fills in from the file with /incbin/, or
> in a reserved memory region the bootloader loaded it into, named by
> "memory-region". Exactly one of the two must be present.
> 
> "logo-position" takes -1 on an axis to mean centre on that axis, which
> is the only way to say it when the device tree does not know the image
> size, and "logo-offset" is added afterwards. "rotation" counts degrees
> counter clockwise, as for panels, and turns the image rather than the
> screen, so position and offset stay in screen pixels. The optional
> "background-color" goes with the image, since a logo designed for one
> background looks wrong on another.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>  .../bindings/display/boot-logo.yaml           | 151 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 152 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/display/boot-logo.yaml
> 
> diff --git a/Documentation/devicetree/bindings/display/boot-logo.yaml b/Documentation/devicetree/bindings/display/boot-logo.yaml
> new file mode 100644
> index 000000000000..bf4121f24f1b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/display/boot-logo.yaml
> @@ -0,0 +1,151 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/display/boot-logo.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Boot logo supplied by the device tree
> +
> +maintainers:
> +  - Francesco Valla <francesco@valla.it>
> +  - Màxim Pedraza Padilla <maximpedraza@gmail.com>
> +
> +description: |
> +  An image for the operating system to show on the display while it boots,
> +  handed over by the firmware together with where and how to show it.
> +
> +  Products built on the same board often differ only in branding. Carrying
> +  the logo in the device tree lets a single kernel image serve all of them,
> +  each booting with its own device tree, and it works where the device tree
> +  is the only thing that reaches the kernel, as with U-Boot's Falcon mode.
> +  It plays the part the ACPI BGRT plays on UEFI systems.
> +
> +  Since a logo is configuration rather than a description of the hardware,
> +  the node lives under /chosen, next to the other things firmware hands to
> +  the operating system.
> +
> +  The image is a BMP file with a 40 byte BITMAPINFOHEADER, 24 bits per pixel
> +  and no compression, the format of the BGRT image. It is carried either in
> +  the node itself or in a reserved memory region the bootloader loaded it
> +  into, never both.
> +
> +properties:
> +  $nodename:
> +    const: logo
> +
> +  compatible:
> +    const: boot-logo
> +
> +  image:

A bit too generic for me. How about logo-image for consistency.

> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description:
> +      The BMP file itself, byte for byte, which dtc can fill in from the file
> +      with /incbin/. The device tree stays in memory for as long as the
> +      system runs, so this is meant for small images; larger ones belong in
> +      a reserved memory region.
> +
> +  memory-region:
> +    maxItems: 1
> +    description: |
> +      Reserved memory region the bootloader loaded the BMP file into, starting
> +      at the beginning of the region. The BMP header says how much of the
> +      region is image.
> +
> +      This keeps the image out of the device tree, so that it can be changed
> +      without rebuilding the device tree, for instance by loading it from a
> +      partition of its own that userspace can update.
> +
> +      Memory keeps its contents across a reset, and may even across a short
> +      power cycle, and the operating system cannot tell a stale image from a
> +      fresh one. A bootloader that loads no image into the region therefore
> +      disables the node (status = "disabled") or removes it.
> +
> +  logo-position:
> +    $ref: /schemas/types.yaml#/definitions/int32-array
> +    description:
> +      X and Y coordinates, in screen pixels, of the top left corner of the
> +      image once it has been rotated. A value of -1 on an axis centres the
> +      image on that axis instead, which is the only way to say it when the
> +      device tree does not know the image size, as with a memory region.
> +      Defaults to centring on both axes.
> +    items:
> +      - description: X coordinate, or -1 to centre horizontally
> +        minimum: -1
> +        maximum: 65535
> +      - description: Y coordinate, or -1 to centre vertically
> +        minimum: -1
> +        maximum: 65535
> +
> +  logo-offset:
> +    $ref: /schemas/types.yaml#/definitions/int32-array
> +    description:
> +      X and Y displacement, in screen pixels, applied after the image has been
> +      placed. Mostly useful together with a centred axis, to land the image
> +      somewhere other than the middle of a panel whose visible area is not
> +      the middle of the mode.
> +    items:
> +      - description: X displacement
> +        minimum: -65535
> +        maximum: 65535
> +      - description: Y displacement
> +        minimum: -65535
> +        maximum: 65535
> +
> +  rotation:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Rotation applied to the image before it is shown, in degrees counter
> +      clockwise, as for the rotation property of panels. It turns the image
> +      and not the screen, so a quarter turn swaps how much room the image
> +      takes up, but logo-position and logo-offset stay in screen pixels
> +      either way.
> +    enum: [0, 90, 180, 270]
> +    default: 0

This property is already defined in panel-common.yaml, so you need a ref 
to it. You probably don't want everything from there, so just 'rotation: 
true' here. Though keeping the description here is probably worthwhile.

> +
> +  background-color:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Colour of the rest of the screen, as 0xRRGGBB. When absent, the
> +      operating system uses its own default.
> +    maximum: 0xffffff
> +
> +required:
> +  - compatible
> +
> +# The image lives either in the node or in a reserved memory region,
> +# never both and never neither.
> +oneOf:
> +  - required:
> +      - image
> +  - required:
> +      - memory-region
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    // A 2x1 image, red and blue, centred and 120 pixels below the middle
> +    / {
> +        compatible = "foo";
> +        model = "foo";
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +
> +        chosen {
> +            logo {
> +                compatible = "boot-logo";
> +                /* Normally: image = /incbin/("logo.bmp"); */
> +                image = /bits/ 8 <0x42 0x4d 0x3e 0x00 0x00 0x00 0x00 0x00
> +                                  0x00 0x00 0x36 0x00 0x00 0x00 0x28 0x00
> +                                  0x00 0x00 0x02 0x00 0x00 0x00 0x01 0x00
> +                                  0x00 0x00 0x01 0x00 0x18 0x00 0x00 0x00
> +                                  0x00 0x00 0x08 0x00 0x00 0x00 0x13 0x0b
> +                                  0x00 0x00 0x13 0x0b 0x00 0x00 0x00 0x00
> +                                  0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
> +                                  0xff 0xff 0x00 0x00 0x00 0x00>;
> +                logo-position = <(-1) (-1)>;
> +                logo-offset = <0 120>;
> +                background-color = <0x1e1e28>;
> +            };
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 321ecb9f5b5b..0d1decaedde0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9174,6 +9174,7 @@ M:	Màxim Pedraza Padilla <maximpedraza@gmail.com>
>  L:	dri-devel@lists.freedesktop.org
>  S:	Maintained
>  T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
> +F:	Documentation/devicetree/bindings/display/boot-logo.yaml
>  F:	drivers/gpu/drm/clients/drm_splash.c
>  
>  DRM TTM SUBSYSTEM
> -- 
> 2.39.5
> 
