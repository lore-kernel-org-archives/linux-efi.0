Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFA140245F
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 09:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883987; cv=none; b=p/6izkSv2Wp/PpAFYuY/urqTu36jJMIX+W/Ap/oVTneZx/2yVM8MGQJrT0Cdq2NtwPFtXKlyjSLkAsAswcK8gevKj3SZprceM+SXuet1o3MTDW8B8hjD0cpRTTQa1HAuWRc+weauBJTUsn3TNzDUAIpztV45dNGojfScXfz+KTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883987; c=relaxed/simple;
	bh=XXCAheqEwWEeNXTk2daG4fV+KXtS4FyM/T+IAPa7GmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tF9gYYbXSxIPg3b/halcEBeNQF/UDAttGJFXfshN4VF645mYvwdM2gyWzbq/6HWS5Z9RI2aqhuY1MEms88ihQsMkVijmZ5Tmmn6si4XOoWTX2YhqAOIb/HuqRllNf5m+2N7boEBmN61jrTMogQb/ModnwxE18kWpDU9r6fodyNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CcZd1h3l; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CcZd1h3l"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48b9d8055dfso2083388f8f.3
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 02:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883983; x=1792488783; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SnEkf+SshAJve0553z+hLZ8mY5sSHw5Ad0IiJvmX3q0=;
        b=CcZd1h3lVFQd+meUKFFn4V679jpUAQeDvPsMEZVdOdJLPK4kIj8g9iLAseVaVK4qgp
         zbqRxxApNTUfZIYLxESROJf8GQ5/OiucAy6cvtHIkD6xcVfnWDVPVaNEC63dh+iJxkMC
         gz3vYWqBT6AI3yEVCeuFkA2avZ5AqfuyHSDrt8kOmrcFFAQ2UtGy72RbAHy1EA4mFvFC
         OTKSNuooX6pzw8hExVIO1ZSR6gMHGIjSRoO2+SmFS1HXPqmdXuJlZp/53VFSaxs+tqnE
         6JSgVG1LDFUurAWnYL9KH1P7yEFeZyzc0LMTiJEyigEaJ04uCNOFrwrs13SFUzuPkDJg
         51rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883983; x=1792488783;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SnEkf+SshAJve0553z+hLZ8mY5sSHw5Ad0IiJvmX3q0=;
        b=VyjzQKvQTTwyz1oT3va4YOE9yLe0hamvahhSVWlF/N7A5CDaKICJkWW+eGNsUvPPkT
         NsC9Jm2CFQFmgVDyKyDP5K9etjZt44RHXYQWhtz8azVZlfa/kYU5n/QFMfYa57VgeM3x
         BouzcWuuohiFgdwz6CtrnaZvIlWS0kWWEW2t3DgkkyeU4fgFF9RdSuWOrqHvlqMnnBwM
         eun1vl2HUZ6sKWm2SPNBl78VCzfu/TK/eTCP6bTVV9W3AjvMhizzX0y+7Q8VwgP8jU+P
         YMqj/e/8Rrkfn3Tede3q0vGMwkXIaaPscKNZOsUYj0M+KC6T3MQPMN5H8qRC8Duw+z8M
         RNnQ==
X-Forwarded-Encrypted: i=1; AKwUvBx4rUts2nxJv83wiVQ6YR2xZRGnUYRGN3a8yg4xyEd8415l3+JF70Vwh+/avJUiHox5VHwGqq20OIc=@vger.kernel.org
X-Gm-Message-State: AFq9FYIoobWKVs8FAgXrh4GGL44x1+Zgg/VsWNdA7nPFFwnRDl5SYjib
	fq54JYwRcgt67DTZ9w7xWFHJn90OeV3Mkqhvzs5TE1txcmjpoWUVlyCA
X-Gm-Gg: AYBFou2j00NznEvLnZbGxCFRczW0TwIjyfBg04jIkZyz1s59bQV58TpedO04gmb5MvF
	sodI2Auw72fHMIEJWBWtyngUyYja79yQPLgYii6oXRKL/SjxD3ddPzpOR87zkg2npWTlWZQ1T4u
	AqXxLRjxbGjj/n4ZsqYv4L8Tm4IAjxOEKy+tUI9OBei30xE1+MFbNRpiessd+JjWgJTmZloI9ps
	wxecO5lRUHAM0RO2lnikC1S/EmYm8aFp9UnP5aINSROfaNzM0FEhmF4NIzsx1WuNHm/MavoEy+c
	/LQi5gaRwHObSGvGWOYhA6jgkh2j/bd4SS6XRzqZwWe3ZXaNrKhjwzFnSIgi8KeRqyieJwCUqFR
	35yRSZ4XubaTTFSFxxuhnjhTgLKWDUB7gsRpowtlIjqVsaC/6I55SuIeTO9U/NRWbyfweio4iWn
	GXBq6X4Ij9jNn71dZq7wb3ApNTijdn48sK0Gt0zUFu5EHfIGcHhVtX8DqM8vQSXP2qWfi5oK06U
	E0ZfkXPlGSt7TPDMFeNMa8n
X-Received: by 2002:a5d:5f84:0:b0:48b:86:5563 with SMTP id ffacd0b85a97d-48dbaae6f0bmr22382083f8f.27.1791883982560;
        Tue, 13 Oct 2026 02:33:02 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc4ec6sm3986774f8f.48.2026.10.13.02.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:33:02 -0700 (PDT)
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
	Jani Nikula <jani.nikula@linux.intel.com>,
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
Subject: [PATCH v5 06/13] dt-bindings: display: add a boot logo node under /chosen
Date: Tue, 13 Oct 2026 11:32:36 +0200
Message-Id: <20261013093243.505776-7-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013093243.505776-1-maximpedraza@gmail.com>
References: <20261013093243.505776-1-maximpedraza@gmail.com>
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
index 000000000000..bf4121f24f1b
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
+      power cycle, and the operating system cannot tell a stale image from a
+      fresh one. A bootloader that loads no image into the region therefore
+      disables the node (status = "disabled") or removes it.
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
index 321ecb9f5b5b..0d1decaedde0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9174,6 +9174,7 @@ M:	Màxim Pedraza Padilla <maximpedraza@gmail.com>
 L:	dri-devel@lists.freedesktop.org
 S:	Maintained
 T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/devicetree/bindings/display/boot-logo.yaml
 F:	drivers/gpu/drm/clients/drm_splash.c
 
 DRM TTM SUBSYSTEM
-- 
2.39.5

