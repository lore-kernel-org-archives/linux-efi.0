Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784925;
	b=e8Tfhpu3O6mwcJglpO8V2Hkd2Oo6r8YXwUB4ScZQ2msNWoHaO9R9kMPmSKsamWP/Zk3d
	 G3h9xnwj8oHgce9lbz2G9q0PC+t+VvnTDS3VBtjVYvXSupYkbrOTbtvrs98PJOfcpty4R
	 Ox4kv+yXIIVkTN0NvGTuXz7W4M1yzJoBXWNqLfEvnZP15cd7awc4vpKGrCZ1S3znW+58A
	 yANTSUlKXJrg3junjjrREVNu3c6l2lsNgzeg6Tzma1ItBghjKAkucby+4wfP2XeQRIndy
	 MWSKHeFaXbtyHjRp7Y2gBA2EtH1IJ43nSLxrNGoLXbF6kERlZ6oAQTeAyUAYtQrkY9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=zAejWuLH6A6kWbjxkZ2dzmDOuVhvhpj01tnf5xLhIOA=;
	b=yImfkaZtQNIrU23A07IIIcL6wlMviHqV77ejnbO5vdj03YyUdUOVMvGF6ywY8qPVD/W8
	 w4KzQkUQB4AsBUgx07XtC6LlT286p4nd6zBex6gHTuRK3HjqdGvO1iMCgOqHGfsfyCWLm
	 wQEEwO+mREDVnb7SXupmiqtNldXK3e5j/1sqvRVM7E/3HQ5a1aqt0G86THq+Lz0vSKuaJ
	 /KIq9Coc7bx0QbhLYUAvMwz8U52JwAQX45JLZZ6zcFpJ+mcZiOuJEmaoDdiRk7sywCb5h
	 +nMPNN99V6CfkIvwfhD5SxgukUFfQGXBMKNdryG+vLEYLYysNG1g14oJl+d4Np3pBdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L78fOILN;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65585606A33D
	for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 23:22:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65585606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L78fOILN
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb68c197c7so10530265e9.1
        for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 15:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794784923; x=1795389723; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zAejWuLH6A6kWbjxkZ2dzmDOuVhvhpj01tnf5xLhIOA=;
        b=L78fOILNmFl2yRucuBd+RTaXWGuOJvcIykScC6o4ql3NvgDtxFGSzvX7Wb/mtz1gB+
         VvaUY7a1I3RjWNeLCZPU5TYNEbggTLRKhVo5HzyHvA8mEYBsCXX1Do1SMe6lOraR0yq2
         YsZczkGxxNJ7SwdmGEVRjrgeFxTY5GIJf/h9eu4rnRPyKFrJPkRH4VP4WjVUgAm1s2kI
         wIaZ8A0Ymt/FxMFyg5/Hq8uZrKPvAGYW+39fg/TNnXdk1kdJGJ+7erQ48zxTdAY3/+S/
         mSiUuFj7yJ3nw5LFjtA24ETQM6Rb/xq+GSOodQMTAtS7v534rN3gvysBU4hcu2/y33TF
         Q7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794784923; x=1795389723;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zAejWuLH6A6kWbjxkZ2dzmDOuVhvhpj01tnf5xLhIOA=;
        b=FXjvDthmsotWNYUPg3xTVudf33+YAEYIF4NKYM8HYB0JADc2kN5noXfjF5IlJgN753
         SIMIWptO7sBpRrG3EpicVUud5MH5WNeLEvQYJGG4gNt7c1467DB3uMHDtHQZgnHbPZ4g
         GaBeUQ7FXBFQeWeZK669dFUFkIRH8SzIo114d4diXUE/vdRbuU7JorrIT6hWI1rwOrHz
         rrswOVzsuM4IlyGtNA5RceD1pG9Ci7Ma3OgRKLGeCKxzdL2f7X8w7aXux1B9mphpvWt2
         cBN+3Mqfh4ikqFtIf3lSDXdEYsTH8suw/n/Z5uxpRFacle/RJbsS0umlnsyPTILIQJ2V
         rsbg==
X-Forwarded-Encrypted: i=1; AL+hErEWWvAI+s/+uTvt3xvkUw/G8BrRn4itROShGNnzNU6QEiqkZltDAIF+VMdSyaud09mVQDQgRBLIIFE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/XKvXizMxVyUJGFmxTA05PVP/f1LVLifxetRkzBWdAxcv0g9j+
	ri8QNzt+a5OAKahdGJTplCDs8RmKsahAWO/4NbhiK6rthixzzv3nni22
X-Gm-Gg: AYBFou0mT/ci8BYLf0gjX5kvLn3YKbZ1b7Ps/O4Ztozk4Nif0JJ8Z1yHbxP6XjABquw
	BrIdE/CgmaU6XMvqY5lggj6nutRZPOENE9Bx27JV8D9NaU3P6qr/aRAC38pyx4sgIDgVD0UcmwP
	sih9XS57mvhp9XKEYZmoTyEfqTnyxx6zTw0WXSKXC98jBtLH7pys9OWXM27JaKglaec99Lwe7DD
	Ba/kQJel2LYxJibWMBjLe0JZQKazVTvPbx1MISZSH9NBjt3dvxAhiskjGOOiaOvOFZST49yBHMF
	uA0CwityUddNo1pDIwebP2LqRQ+WLxhLkUfSwvCrsPMgBGgld0PKCHfjJKxQ2inCWNPxkbSseq4
	BABdsdyXMzMX0jX3ffFkQgav8VETJDOaLKbNwVi3JTTRaJQY4oLIJ5w1t2f0PM5gQWA8HBoOJ5F
	iJazVD4uzJPlSkjHQTcwREUIcIM6HQWSDKuDCyt22J0Q4pUzrVU03ZXQhPGB3TM0iobc/Oirfnp
	U4efy6WgEqRkDCTzD9Y445eU/ttY/c+T3yck1pfGUxkqkXZX9H+G17F4CeuOeVSiXziNwyzjqU9
	kEldqz12ZmI32Cl7er56mWFFz1MJu4pzcz3OyZjk9Fj2mEnqqZ5HMmA=
X-Received: by 2002:a05:600c:83c5:b0:4a7:7d22:c50c with SMTP id 5b1f17b1804b1-4bb55a23b36mr182171115e9.2.1794784922517;
        Sun, 15 Nov 2026 15:22:02 -0800 (PST)
Received: from ingenieria31.oficinasStQ.local ([79.117.0.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571f976esm127920955e9.3.2026.11.15.15.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 15:22:01 -0800 (PST)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Helge Deller <deller@gmx.de>,
	Peter Jones <pjones@redhat.com>
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
	linux-efi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/6] Add splash DRM client
Date: Mon, 16 Nov 2026 01:21:50 +0100
Message-Id: <20261116002156.1027726-1-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the seventh version of the splash client, which I took over from
Francesco with v4. As Thomas suggested [1], it holds only the part that
can go in now: patches 1 to 6 and 8 of v6, with the MAINTAINERS entry
squashed into the patch that adds drm_splash.c. The device tree source
and its binding, the placement and rotation, and the connector
orientation will follow as a separate series on top of this one.

The client draws a splash on every output, including those plugged in
later, until userspace takes over. The image comes from the EFI BGRT or,
failing that, from a BMP loaded as firmware, named at build time
("drm_splash.bmp" by default); with neither, only the background is
drawn, in a colour set at build time. A BGRT image is drawn at the table
offsets, a BMP loaded as firmware is centred. A BGRT whose ACPI 6.2
orientation bits are set is skipped for now; turning it comes with the
rotation in the later series.

Changes since v6
----------------

From the reviews of v6 [1]-[6]:

  - MAINTAINERS: I am listed as M: and Francesco as R:, in patch 4
    (Thomas [2], Francesco [3]).
  - The firmware source is DRM_SPLASH_SRC_FW, and its Kconfig options
    DRM_CLIENT_SPLASH_SRC_FW and DRM_CLIENT_SPLASH_FW_NAME, since the
    BGRT is a BMP too (Thomas [4]).
  - The drm_splash_fw_load() stub returns 0 (Thomas [5]), and
    drm_splash_image_load() does not call it when the firmware source is
    disabled.
  - Thomas, I have kept your Reviewed-by on patch 4, as you said [6].

From sashiko's review of v6 [7], and further review:

  - Patch 4: restore leaves the commit to the work, which draws whatever
    is missing first, so a restore that comes while the device is
    suspended is no longer lost [7]; a forced restore stays forced across
    suspend, and the work commits even when no scanout is left.
  - Patch 4: a hotplug while userspace has the display waits for the
    next restore, as fbdev does; only a lack of memory makes the image be
    drawn again; unregister cancels the work before it looks for a
    firmware request, which the work can now make too; the tile group id
    is read under mode_config.mutex, which an EDID update holds while it
    changes or frees the group.
  - Patch 2: the image address and size are 0 when efi_bgrt_has_image()
    says there is no image, so that they never disagree on kernels with
    32-bit physical addresses.
  - Patch 3: the comment on the DIB header says that a negative width is
    invalid.

Testing
-------

  - QEMU versatilepb (pl111, 16 bpp): no image, and the BMP loaded as
    firmware, compared pixel by pixel.
  - x86-64 with OVMF: the BGRT through the new accessors; with
    CONFIG_DRM_CLIENT_SPLASH_SRC_FW=n, with and without a BGRT
    (bgrt_disable), the background alone and no error.
  - i386 without PAE on 32-bit OVMF, with the BGRT replaced from the
    initrd so that it points above 4 GiB: the background alone.
  - QEMU virt arm64 (virtio-gpu, 32 bpp) with KASAN and kmemleak: the
    driver bound and unbound repeatedly, a crafted bitmap offset, and
    the firmware arriving only after the unbind; no reports. With
    lockdep too, over several outputs, tiled displays and the bind
    cycles: no reports.
  - Several outputs, one of them off, and tiled displays from 2x1 up to
    3x3, 4x2 and 2x4 tiles, in several CRTC orders, simulated with
    DisplayID tiled topology EDIDs on virtio-gpu heads. The layouts with
    more than one row and column need a fix to the client modeset code
    that is not part of this series.
  - The error paths, with a debug patch forcing them: buffers and formats
    that fail on one output, work queued while suspended, a restore
    during suspend or with a master, a hotplug with a master, a fill that
    fails, a firmware request made by the work and raced against the
    unbind; no WARN or KASAN report in any of them.
  - An AM335x board (tilcdc, 16 bpp), booting over TFTP and NFS, with
    the BMP built in and from an initramfs, an 8 bpp BMP that is
    rejected, and 5 unbind and bind cycles of tilcdc, checked by reading
    the scanout buffer back.
  - W=1 and sparse clean; every patch builds on its own on arm and
    x86-64; checkpatch --strict clean apart from a quoted modpost line in
    patch 2 and the MAINTAINERS reminder on patch 3, whose new header
    FRAMEBUFFER LAYER already covers.

Open questions
--------------

  - Unbinding waits for a pending firmware request, as it cannot be
    cancelled and its callback uses the splash, and it waits under the
    device's clientlist_mutex. Normally the request is long over; with
    the sysfs fallback it can take up to the loading timeout. Not
    waiting would mean giving the callback its own refcounted object;
    I can do that as a follow-up.
  - The BGRT offsets are for the mode the firmware drew in. When KMS
    picks another one, the x86 check taken from efifb leaves the screen
    without a logo, and elsewhere the logo lands off centre. The offsets
    could be used only when the scanout matches the firmware's
    framebuffer, and the image centred otherwise.
  - The splash is a DRM client, so a device using it has no fbdev
    emulation and no /dev/fb0.

Based on drm-misc-next-2026-10-23 (cf5d8e390e2a).

[1] https://lore.kernel.org/all/066197a1-aa2b-455b-84d8-4e2215fad764@suse.de/
[2] https://lore.kernel.org/all/ed28619d-6ca7-46aa-82c0-c83f30a836e3@suse.de/
[3] https://lore.kernel.org/all/avTjrfIEPgyvPDti@bywater/
[4] https://lore.kernel.org/all/8eaf9955-485f-4908-bb65-1e0c3184fb36@suse.de/
[5] https://lore.kernel.org/all/c2cbc13a-a58d-4c0b-87ac-62daa6de6fba@suse.de/
[6] https://lore.kernel.org/all/4762a951-5b37-4e7a-8569-f55a4683c912@suse.de/
[7] https://lore.kernel.org/all/sashiko-outbox-186719@kernel.org/

v6: https://lore.kernel.org/r/20261027135342.2003632-1-maximpedraza@gmail.com
v5: https://lore.kernel.org/r/20261013093243.505776-1-maximpedraza@gmail.com
v4: https://lore.kernel.org/r/20261001195847.141192-1-maximpedraza@gmail.com
v3: https://lore.kernel.org/r/20260510-drm_client_splash-v3-0-a9aee9f0b2fc@valla.it
v2: https://lore.kernel.org/r/20260106-drm_client_splash-v2-0-6e86a7434b59@valla.it
v1: https://lore.kernel.org/r/20251027-drm_client_splash-v1-0-00698933b34a@valla.it

Màxim

Francesco Valla (2):
  drm: client: add splash client
  drm: docs: remove bootsplash from TODO

Màxim Pedraza Padilla (4):
  drm/clients: Kconfig: indent DRM_CLIENT_DEFAULT with tabs
  efi: bgrt: add accessors for the boot graphics
  fbdev: efifb: move the BMP headers to <video/bmp.h>
  drm/client: splash: pick the image source in one place

 Documentation/gpu/todo.rst                    |   17 -
 MAINTAINERS                                   |    8 +
 drivers/firmware/efi/efi-bgrt.c               |   76 +-
 drivers/gpu/drm/clients/Kconfig               |   80 +-
 drivers/gpu/drm/clients/Makefile              |    1 +
 drivers/gpu/drm/clients/drm_client_internal.h |    9 +
 drivers/gpu/drm/clients/drm_client_setup.c    |    8 +
 drivers/gpu/drm/clients/drm_splash.c          | 1060 +++++++++++++++++
 drivers/video/fbdev/efifb.c                   |   49 +-
 include/linux/efi-bgrt.h                      |   39 +-
 include/video/bmp.h                           |   40 +
 11 files changed, 1330 insertions(+), 57 deletions(-)
 create mode 100644 drivers/gpu/drm/clients/drm_splash.c
 create mode 100644 include/video/bmp.h


base-commit: cf5d8e390e2ac2cfa24a50645efdbb9f0eebe65f
-- 
2.39.5

