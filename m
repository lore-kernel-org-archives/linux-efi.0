Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69621431E68
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 09:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512962; cv=none; b=PEAath03FL3yCZ1zBNphk95uzq6xDJ7xHdBPxrGdNUD/RGIk6+CqXShe8ovyRfUMXqJXXO+oNGn1ggK7g14l9+gsXmmxMFn/HcIDfnvmDQwDhVu2cre5qAvUDOdBHDUFjeNUVuUv+txJ1FDcaJeDUjCSUQZJPvaltHHmgatGGRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512962; c=relaxed/simple;
	bh=RsPcNeEW9LX9xDiaaoN2s8qDIe4S4hnKCxTlT/GgGa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh58uO3QFNfK2StQ72M9AljR+z5rmNEPQZtVhln46aCYgRaNMlJg1+bV1bv5ev8oA6ofiTBLNM+bnczFUs6NoiA17t1OJgYVkj90Wf8rFnl+69VJCU8fAlnlw2VFOR45Jn3IuizJu9kJFVhG3igVBLzGsH17pEdNzYO6iNXKckY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i8VkAOWA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2cdTE9SK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TA2wf43m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ekhS+IQe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i8VkAOWA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2cdTE9SK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TA2wf43m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ekhS+IQe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F0C522B4C;
	Fri,  4 Sep 2026 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6J01y5x3+VPVyGqbdQoKAHZf/LgSXoTgJdgTtvktNs=;
	b=i8VkAOWA451cHk4y09d13B3mx3sGnhcVmFSe0peRvj8YbszQxapZQi2Ix+b55+kf/2i1b8
	HISOsI4lRsdC59eN9IWQMJJwiOCPZdPRNuAW49+N67AuR8Ja14YzFGIDkHEgZAIigKnUrq
	X3w753WJfVrLYY/+q9wriPAr2BkpLiQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6J01y5x3+VPVyGqbdQoKAHZf/LgSXoTgJdgTtvktNs=;
	b=2cdTE9SKn1kmM96JEMEvRdRx8raIo8VsxEX2b0PctcjofIYbaokrLat5DoOLPB1pYTE2FF
	WqB2Ui+DnWRDZYCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6J01y5x3+VPVyGqbdQoKAHZf/LgSXoTgJdgTtvktNs=;
	b=TA2wf43m1i39Z5ARJNNqS6GeLPOySxd/O90T+hbHEtYI7OhT5/wcDSbyjbjCART9M9csA9
	x/ROb6yP43pG7DInwIznOFPJQXap0v9qGQ61jY4gM+WOZI7rM5E8NtXTXkN3BFBSij2Pwe
	rlYtUrPN+krZ9zBDVBKuvu4Vpj8xzkQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6J01y5x3+VPVyGqbdQoKAHZf/LgSXoTgJdgTtvktNs=;
	b=ekhS+IQeOfQp4pia9RFsNvpBWV1nC3fN4fAlZS8DgLvjhdDrNmebURg164VbBWB1SXzzKJ
	Ohr9rCy8LtkWuECA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEFD913869;
	Fri,  4 Sep 2026 09:08:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YBs1MaiKmmphdQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 04 Sep 2026 09:08:56 +0000
From: Thomas Zimmermann <tzimmermann@suse.de>
To: javierm@redhat.com,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	jani.nikula@linux.intel.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	simona@ffwll.ch,
	airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org,
	linux-efi@vger.kernel.org,
	sashiko-reviews@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v4 3/3] drm/sysfb: Use preferred panel size for panel orientation quirks
Date: Fri,  4 Sep 2026 11:07:02 +0200
Message-ID: <20260904090850.43060-4-tzimmermann@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904090850.43060-1-tzimmermann@suse.de>
References: <20260904090850.43060-1-tzimmermann@suse.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Sysfb drivers currently use the given display mode for looking up the
panel orientation. But the look-up table stores the native geometry of
the panels, so the lookup fails if the current mode sizes differs.

Get the panel's native geometry with drm_edid_detect_panel_size() from
the EDID and use it for looking up the panel orientation.

v2:
- ofdrm: validate EDID header before using it (Sashiko)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/gpu/drm/sysfb/efidrm.c  | 17 ++++++++++++++++-
 drivers/gpu/drm/sysfb/ofdrm.c   | 18 ++++++++++++++++--
 drivers/gpu/drm/sysfb/vesadrm.c | 17 ++++++++++++++++-
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efidrm.c
index 3f9cd5d03efb..8b19f437308e 100644
--- a/drivers/gpu/drm/sysfb/efidrm.c
+++ b/drivers/gpu/drm/sysfb/efidrm.c
@@ -152,6 +152,7 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
 	const struct screen_info *si;
 	const struct drm_format_info *format;
 	int width, height, stride;
+	unsigned int panel_width, panel_height;
 	s64 vsize;
 	u64 mem_flags;
 	struct resource resbuf;
@@ -217,6 +218,20 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
 	if (drm_edid_header_is_valid(dpy->edid.dummy) == 8)
 		sysfb->edid = dpy->edid.dummy;
 #endif
+
+	panel_width = width;
+	panel_height = height;
+
+	if (sysfb->edid) {
+		const struct drm_edid *drm_edid;
+
+		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
+		if (drm_edid) {
+			drm_edid_detect_panel_size(drm_edid, &panel_width, &panel_height);
+			drm_edid_free(drm_edid);
+		}
+	}
+
 	sysfb->fb_mode = drm_sysfb_mode(width, height, 0, 0);
 	sysfb->fb_format = format;
 	sysfb->fb_pitch = stride;
@@ -340,7 +355,7 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
 	drm_connector_helper_add(connector, &efidrm_connector_helper_funcs);
 	drm_connector_set_panel_orientation_with_quirk(connector,
 						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
-						       width, height);
+						       panel_width, panel_height);
 	if (sysfb->edid)
 		drm_connector_attach_edid_property(connector);
 
diff --git a/drivers/gpu/drm/sysfb/ofdrm.c b/drivers/gpu/drm/sysfb/ofdrm.c
index 9d60db45139c..c41255569854 100644
--- a/drivers/gpu/drm/sysfb/ofdrm.c
+++ b/drivers/gpu/drm/sysfb/ofdrm.c
@@ -229,7 +229,7 @@ static const u8 *display_get_edid_of(struct drm_device *dev, struct device_node
 {
 	int ret = of_property_read_u8_array(of_node, "EDID", buf, EDID_LENGTH);
 
-	if (ret)
+	if (ret || drm_edid_header_is_valid(buf) != 8)
 		return NULL;
 	return buf;
 }
@@ -828,6 +828,7 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
 	enum ofdrm_model model;
 	bool big_endian;
 	int width, height, depth, linebytes;
+	unsigned int panel_width, panel_height;
 	const struct drm_format_info *format;
 	u64 address;
 	const u8 *edid;
@@ -998,6 +999,19 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
 		sysfb->fb_gamma_lut_size = OFDRM_GAMMA_LUT_SIZE;
 	sysfb->edid = edid;
 
+	panel_width = width;
+	panel_height = height;
+
+	if (sysfb->edid) {
+		const struct drm_edid *drm_edid;
+
+		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
+		if (drm_edid) {
+			drm_edid_detect_panel_size(drm_edid, &panel_width, &panel_height);
+			drm_edid_free(drm_edid);
+		}
+	}
+
 	drm_dbg(dev, "display mode={" DRM_MODE_FMT "}\n", DRM_MODE_ARG(&sysfb->fb_mode));
 	drm_dbg(dev, "framebuffer format=%p4cc, size=%dx%d, linebytes=%d byte\n",
 		&format->format, width, height, linebytes);
@@ -1069,7 +1083,7 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
 	drm_connector_helper_add(connector, &ofdrm_connector_helper_funcs);
 	drm_connector_set_panel_orientation_with_quirk(connector,
 						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
-						       width, height);
+						       panel_width, panel_height);
 	if (edid)
 		drm_connector_attach_edid_property(connector);
 
diff --git a/drivers/gpu/drm/sysfb/vesadrm.c b/drivers/gpu/drm/sysfb/vesadrm.c
index 6a67b2d2e451..f6358a0a68bd 100644
--- a/drivers/gpu/drm/sysfb/vesadrm.c
+++ b/drivers/gpu/drm/sysfb/vesadrm.c
@@ -402,6 +402,7 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
 	const struct screen_info *si;
 	const struct drm_format_info *format;
 	int width, height, stride;
+	unsigned int panel_width, panel_height;
 	s64 vsize;
 	struct resource resbuf;
 	struct resource *res;
@@ -484,6 +485,20 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
 	if (drm_edid_header_is_valid(dpy->edid.dummy) == 8)
 		sysfb->edid = dpy->edid.dummy;
 #endif
+
+	panel_width = width;
+	panel_height = height;
+
+	if (sysfb->edid) {
+		const struct drm_edid *drm_edid;
+
+		drm_edid = drm_edid_alloc(sysfb->edid, EDID_LENGTH);
+		if (drm_edid) {
+			drm_edid_detect_panel_size(drm_edid, &panel_width, &panel_height);
+			drm_edid_free(drm_edid);
+		}
+	}
+
 	sysfb->fb_mode = drm_sysfb_mode(width, height, 0, 0);
 	sysfb->fb_format = format;
 	sysfb->fb_pitch = stride;
@@ -585,7 +600,7 @@ static struct vesadrm_device *vesadrm_device_create(struct drm_driver *drv,
 	drm_connector_helper_add(connector, &vesadrm_connector_helper_funcs);
 	drm_connector_set_panel_orientation_with_quirk(connector,
 						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
-						       width, height);
+						       panel_width, panel_height);
 	if (sysfb->edid)
 		drm_connector_attach_edid_property(connector);
 
-- 
2.55.0

