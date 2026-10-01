Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78328493D36
	for <linux-efi@vger.kernel.org>; Thu,  1 Oct 2026 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790884747; cv=none; b=BNUFls4fixDAFyU0ABTOnM59YRKFeX8y3Aarn7abd2C0CyPlf6DHlkYNlKH2APv41iOSsPn2k/rCSrwpm8+XeYs6za8HM/00JUrYYHI9lEamKLjq4oFuZh8aIBwuPoTSZchQYQQYUVhQsAV0hKVmiwgNVwaC+dplecae0OwoPYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790884747; c=relaxed/simple;
	bh=JZ01Th3ji+UDWuIdJncvqkyGNUsBQsDbISwghdWjw8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESxEYrH2V2uhBUCBRe0zOXp6xM93GeNqSHplC9tPw9f0RRpauNs++AkbLlxnCuzxyZaTkf8xqGua7OqIMGoCSk8T9L7NGM6Etcx0LnK/bwvGs8ryUhHcf9uVV75UiT2a6CFDOA4PgWkPVqTGEMLO8e3xSsshBZL52apLduyTj+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gmJCYruw; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmJCYruw"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a0280d4f56so874005e9.2
        for <linux-efi@vger.kernel.org>; Thu, 01 Oct 2026 12:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790884742; x=1791489542; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F5gSObUG4A86e9xsmVWSsZDHJwq+aLyLkpSINxUvpqQ=;
        b=gmJCYruwTMbcqdmM7LSAINPtaAj3VLsg/KmshAEk4XcqSjDmu5G/I38lUZMqRdGA1Z
         HQCLQmzSBub2Ta4Six+4SXbJwNzrG5cPMZodrFhb3vVmnbkkX2AINMYwkOiLPJS4zK+7
         QKt7nEDZzklCGQh5tMJW2nf650T8qXXGTUS3Xr/7u801+NU4WXVu/dVD3LZXdGem3DDI
         DBZCdR8hrQNI5CVnrZ5dFhrZDrnmGSfwC/cEGM3FizP2okcWb27lozucPe+5639b6yk8
         2WxO8IznSGXjnTLol9XEUveOu7nnsfjIpAM5WTlI/8p7wqXdZMmOedt7o+pbbAASARTe
         wiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790884742; x=1791489542;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F5gSObUG4A86e9xsmVWSsZDHJwq+aLyLkpSINxUvpqQ=;
        b=loJIHEqMSEZ995r0Eo3axpB+hsdj13wQOVCOLElxHhUazSVzt3/ZPLPyijfnEvVpsC
         QoNazHH9x9dkbx9lGwIi9GuMDofC3y8JqGLzFNjZAiVYz2hRDb4X2KB1VOqm1OzH+Xsl
         7znMc8gpejDJOxernuNZDAyLgSfBq3qVCdhkQ/OzMMD0NXvhqSkD1sVr8G1Gk4fd4yg/
         FynNOBDI+8z1eIUTWSBKSvvBcwv7AjKHEoDFW0g4am03Ip3QIfbkyMckLA4mVlbHm+bD
         toM8E6rMgHsUkTBuwQYHJbTo+k1kNlqMAdbpaVdBRmLMxATJL1prGY4dlt6/PR+RxC0D
         3JRA==
X-Forwarded-Encrypted: i=1; AKwUvBzDikeYeqOQ1lfZhKDJCIf6CQSbvhGvOlFOuLN0mkrFvDTVplK22JeAFmx7ViFyQggBXJD1NDZr3Ho=@vger.kernel.org
X-Gm-Message-State: AFuF++kcOssdj06ueEVLw7eVYqrMJJ+YnrDKPYNLNEwgxnJ0zuxRewq9
	zWaGeHCYGPIkJmTK5/VHiw8En9vLm0thbIikWasMHyLnM7WosrqrMjpr
X-Gm-Gg: AYBFou1LSVL+XJC4NpcWhTlCZ5lx3/vewTXF0NeuU1Tju5t6J8Sal7gIrhjRlJvnSao
	zSNVxN9Sv3iLR7JsMbFyTocc/TImQ9vKWz8PW9B6rNxvJab5gJV9o1/owo8OaOkNWvZ6Xpehj81
	e8jEVenVVu7P+LjhLSiik+2bgzubcNf+igcVbnX2OSPLo27xlmoyhk6KbZ1qBz6ppo1PnoqqytC
	fFZ1fY+KTXZLNaRMbpFWwkpMzaU5vVnklEm07sbI6jBXm49g17bsOpf9jclBMi7aSUr+tqtwFs4
	tBGAUuQ+NLbIBzYQXy9TAoDq2Pq6a+SKbB9ZoUew5uZe7L3DZlh/QqyRjM3MynXVRbZQopKoizX
	VyNl8X8mJBgT6cnJGZtwXNoLXzuSQT5JuNetI51AF/ZZFy5iXyHMVU8zwE4q4ui1WebZcnTsdGv
	5MRWpZ6TWjceBOEzgYvGDOeHdf+3xWpnFdBb9/KevPZJ698G+RzCcN1DYG7JLP5n5JUAHfxP6Uo
	z1pnHxKdR3bL7ia8YNDHRx2sw==
X-Received: by 2002:a05:600c:4ecf:b0:49f:ce78:3567 with SMTP id 5b1f17b1804b1-4a02769ceefmr11636045e9.24.1790884741902;
        Thu, 01 Oct 2026 12:59:01 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0276f92d9sm15031045e9.4.2026.10.01.12.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 12:59:01 -0700 (PDT)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Francesco Valla <francesco@valla.it>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC v4 06/13] dt-bindings: display: add a boot logo node under /chosen
Date: Thu,  1 Oct 2026 21:58:40 +0200
Message-Id: <20261001195847.141192-7-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001195847.141192-1-maximpedraza@gmail.com>
References: <20261001195847.141192-1-maximpedraza@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Products built on the same board often differ only in branding. On UEFI
systems the firmware hands the operating system its boot logo through
the ACPI BGRT; a device tree system has no such table, so today the logo
is built into the kernel, and each product needs its own kernel image.
With U-Boot's Falcon mode the device tree is the only thing that reaches
the kernel, so it is also the only place the logo can come from.

Add a "boot-logo" node under /chosen. The node lives there because a
logo is configuration handed over by firmware rather than a description
of the hardware, as simple-framebuffer nodes already are.

The image is a BMP with 24 bits per pixel and no compression, the
format of the BGRT image, so that one file serves the firmware splash,
a BMP loaded as firmware and this node alike. It is carried either in
an "image" property, which dtc fills in from the file with /incbin/, or
in a reserved memory region the bootloader loaded it into, named by
"memory-region". Exactly one of the two must be present.

"logo-position" takes -1 on an axis to mean centre on that axis, which
is the only way to say it when the device tree does not know the image
size, and "logo-offset" is added afterwards. "rotation" counts degrees
counter clockwise, as for panels, and turns the image rather than the
screen, so position and offset stay in screen pixels. The optional
"background-color" goes with the image, since a logo designed for one
background looks wrong on another.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 .../bindings/display/boot-logo.yaml           | 151 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 152 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/display/boot-logo.yaml

diff --git a/Documentation/devicetree/bindings/display/boot-logo.yaml b/Documentation/devicetree/bindings/display/boot-logo.yaml
new file mode 100644
index 000000000000..b540a04deb78
--- /dev/null
+++ b/Documentation/devicetree/bindings/display/boot-logo.yaml
@@ -0,0 +1,151 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/display/boot-logo.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Boot logo supplied by the device tree
+
+maintainers:
+  - Francesco Valla <francesco@valla.it>
+  - Màxim Pedraza Padilla <maximpedraza@gmail.com>
+
+description: |
+  An image for the operating system to show on the display while it boots,
+  handed over by the firmware together with where and how to show it.
+
+  Products built on the same board often differ only in branding. Carrying
+  the logo in the device tree lets a single kernel image serve all of them,
+  each booting with its own device tree, and it works where the device tree
+  is the only thing that reaches the kernel, as with U-Boot's Falcon mode.
+  It plays the part the ACPI BGRT plays on UEFI systems.
+
+  Since a logo is configuration rather than a description of the hardware,
+  the node lives under /chosen, next to the other things firmware hands to
+  the operating system.
+
+  The image is a BMP file with a 40 byte BITMAPINFOHEADER, 24 bits per pixel
+  and no compression, the format of the BGRT image. It is carried either in
+  the node itself or in a reserved memory region the bootloader loaded it
+  into, never both.
+
+properties:
+  $nodename:
+    const: logo
+
+  compatible:
+    const: boot-logo
+
+  image:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description:
+      The BMP file itself, byte for byte, which dtc can fill in from the file
+      with /incbin/. The device tree stays in memory for as long as the
+      system runs, so this is meant for small images; larger ones belong in
+      a reserved memory region.
+
+  memory-region:
+    maxItems: 1
+    description: |
+      Reserved memory region the bootloader loaded the BMP file into, starting
+      at the beginning of the region. The BMP header says how much of the
+      region is image.
+
+      This keeps the image out of the device tree, so that it can be changed
+      without rebuilding the device tree, for instance by loading it from a
+      partition of its own that userspace can update.
+
+      Memory keeps its contents across a reset, and may even across a short
+      power cycle, so a bootloader that loads no image into the region has to
+      clear it: the operating system cannot tell a stale image from a fresh
+      one.
+
+  logo-position:
+    $ref: /schemas/types.yaml#/definitions/int32-array
+    description:
+      X and Y coordinates, in screen pixels, of the top left corner of the
+      image once it has been rotated. A value of -1 on an axis centres the
+      image on that axis instead, which is the only way to say it when the
+      device tree does not know the image size, as with a memory region.
+      Defaults to centring on both axes.
+    items:
+      - description: X coordinate, or -1 to centre horizontally
+        minimum: -1
+        maximum: 65535
+      - description: Y coordinate, or -1 to centre vertically
+        minimum: -1
+        maximum: 65535
+
+  logo-offset:
+    $ref: /schemas/types.yaml#/definitions/int32-array
+    description:
+      X and Y displacement, in screen pixels, applied after the image has been
+      placed. Mostly useful together with a centred axis, to land the image
+      somewhere other than the middle of a panel whose visible area is not
+      the middle of the mode.
+    items:
+      - description: X displacement
+        minimum: -65535
+        maximum: 65535
+      - description: Y displacement
+        minimum: -65535
+        maximum: 65535
+
+  rotation:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Rotation applied to the image before it is shown, in degrees counter
+      clockwise, as for the rotation property of panels. It turns the image
+      and not the screen, so a quarter turn swaps how much room the image
+      takes up, but logo-position and logo-offset stay in screen pixels
+      either way.
+    enum: [0, 90, 180, 270]
+    default: 0
+
+  background-color:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Colour of the rest of the screen, as 0xRRGGBB. When absent, the
+      operating system uses its own default.
+    maximum: 0xffffff
+
+required:
+  - compatible
+
+# The image lives either in the node or in a reserved memory region,
+# never both and never neither.
+oneOf:
+  - required:
+      - image
+  - required:
+      - memory-region
+
+additionalProperties: false
+
+examples:
+  - |
+    // A 2x1 image, red and blue, centred and 120 pixels below the middle
+    / {
+        compatible = "foo";
+        model = "foo";
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        chosen {
+            logo {
+                compatible = "boot-logo";
+                /* Normally: image = /incbin/("logo.bmp"); */
+                image = /bits/ 8 <0x42 0x4d 0x3e 0x00 0x00 0x00 0x00 0x00
+                                  0x00 0x00 0x36 0x00 0x00 0x00 0x28 0x00
+                                  0x00 0x00 0x02 0x00 0x00 0x00 0x01 0x00
+                                  0x00 0x00 0x01 0x00 0x18 0x00 0x00 0x00
+                                  0x00 0x00 0x08 0x00 0x00 0x00 0x13 0x0b
+                                  0x00 0x00 0x13 0x0b 0x00 0x00 0x00 0x00
+                                  0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
+                                  0xff 0xff 0x00 0x00 0x00 0x00>;
+                logo-position = <(-1) (-1)>;
+                logo-offset = <0 120>;
+                background-color = <0x1e1e28>;
+            };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 44730414e5df..9f057fdb3bdb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9161,6 +9161,7 @@ M:	Màxim Pedraza Padilla <maximpedraza@gmail.com>
 L:	dri-devel@lists.freedesktop.org
 S:	Maintained
 T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/devicetree/bindings/display/boot-logo.yaml
 F:	drivers/gpu/drm/clients/drm_splash.c
 
 DRM TTM SUBSYSTEM
-- 
2.39.5

