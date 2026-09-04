Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39B23B19B6
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 09:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512960; cv=none; b=YsYBOoBVWZiQswcJQEPzzTOSykCLsOolpCnhuqeGejTZd4cIRFhZzbMqhpb1IdwTKdgiv6414MmOOMMz8rFsqkoB+2hw8sLhmx6ERq1xa5EP2hz2MRl/VyIXShsT6S/vce/wE7L3lKU1z+MahLvuw0VzWrIdLIMr5Pc3PZNMk98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512960; c=relaxed/simple;
	bh=oqnm19rkd3J2ZnteTN2ZAqHf8qRP9wXzp+9VcC2fAs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4dB/gK3v1gErS+CZDIoN3/+KYXF3uGjZdHvo3wsgFQkBNolmLsT/2CeGXV/hnOPiFxYVTxsfronNaF55X0VlVsqvgFBjppF2XeKrTMjvcA1mWHhhy9tnTj4epEJHhl04v5+3hbZOXzGzPb5+x31KlGtrm2Pnh4+tRaDdGypSwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WAT1lzpr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R8GNL5G0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sCsKlPDd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bfbpJgvW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WAT1lzpr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R8GNL5G0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sCsKlPDd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bfbpJgvW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DFDDB1FBF2;
	Fri,  4 Sep 2026 09:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aBwC/5i+VEU9M87bH9qL56mvxFfX9zRDHR+Or7J9ks0=;
	b=WAT1lzpraOQttjCUcFMnPqf3dDagG4liaO6Fyu3FwYelcJcmCw4h9rRJSxAdRMvkhl/v1J
	6cKG5rEdyAZy5y5a3H/YEb2cZezk5rt8TMI9ZClgGLXJ/dSKNWXbtPnfHyn/07of/InGDC
	WnaV/K2DzwZPMaYcI/G4Z2pSUAkbBNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aBwC/5i+VEU9M87bH9qL56mvxFfX9zRDHR+Or7J9ks0=;
	b=R8GNL5G0TE2t1WjlM8sdHlzP7WIqZYuvdH8O1/gRt566nG0MftBQuA1M7j8jlbzAdWOTyU
	FGYhFEYIbV0i6jAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sCsKlPDd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bfbpJgvW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aBwC/5i+VEU9M87bH9qL56mvxFfX9zRDHR+Or7J9ks0=;
	b=sCsKlPDdvUMI3NqLcGuTsHi80JhjEPkPqPn1+NhCjF0TpYs1rOoQ+P0djiz6c4A6nCF2RC
	I8RnkZSVGbZvsMAkCACCffAm+cPQ8jWBd30e68X2RPbPFeqw4Ybqi0tr4h1LKLvAnljuOp
	nvCbNUIifNQj9F40F2FDtEyfOhBl4uo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aBwC/5i+VEU9M87bH9qL56mvxFfX9zRDHR+Or7J9ks0=;
	b=bfbpJgvWXFJSBXlm6h3UsxVibzz/hTBVJI9wJei6NF/qbLzA9erGD794lxqTxSJIQtweYy
	Pa8+jpEaPD7XtSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A7C813738;
	Fri,  4 Sep 2026 09:08:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ELe3HKiKmmphdQAAD6G6ig
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
Subject: [PATCH v4 2/3] drm/edid: Add drm_edid_detect_panel_size()
Date: Fri,  4 Sep 2026 11:07:01 +0200
Message-ID: <20260904090850.43060-3-tzimmermann@suse.de>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: DFDDB1FBF2
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Add drm_edid_detect_panel_size() to extract the panel's preferred
display resolution from a given EDID. Required for setting up DRM's
panel orientation quirks in sysfb drivers.

v4:
- fix test for EDID PTD (Jani)
v3:
- mention use case in documentation (Jani)
- use is_detailed_timing_descriptor() (Jani)
- rename helper to drm_edid_detect_panel_size()
v2:
- handle EDID without pixel timing descriptor (Sashiko)
- fix checks for width and height pointers

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 47 ++++++++++++++++++++++++++++++++++++++
 include/drm/drm_edid.h     |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 9990a836d0b6..1331efb4876c 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -7852,3 +7852,50 @@ bool drm_edid_is_digital(const struct drm_edid *drm_edid)
 		drm_edid->edid->input & DRM_EDID_INPUT_DIGITAL;
 }
 EXPORT_SYMBOL(drm_edid_is_digital);
+
+/**
+ * drm_edid_detect_panel_size - Get a panel's size from EDID
+ * @drm_edid: EDID of the panel.
+ * @width: Returns the panel's width in pixels per scanline, if given
+ * @height: Returns the panel's height in scanlines, if given
+ *
+ * This function detects the preferred size of a panel from the given
+ * EDID. There is no such information stored in the EDID block directly,
+ * but the preferred mode often corresponds to the panel's native geometry.
+ *
+ * This helper should only be used during initialization before the
+ * connector is available. For regular use, retrieve the available display
+ * modes with the connector functions.
+ *
+ * Return: Zero on success, or a negative errno code otherwise.
+ */
+int drm_edid_detect_panel_size(const struct drm_edid *drm_edid,
+			       unsigned int *width, unsigned int *height)
+{
+	const struct edid *edid = drm_edid->edid;
+	const struct detailed_timing *dt;
+	const struct detailed_pixel_timing *pt;
+
+	/*
+	 * Use display mode from the Preferred Timing Descriptor. For old
+	 * and obscure displays, we might need better heuristics.
+	 */
+
+	if (edid->revision < 4 || !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
+		return -EINVAL; /* no Preferred Timing Descriptor */
+
+	dt = &edid->detailed_timings[0];
+
+	if (!is_detailed_timing_descriptor(dt))
+		return -EINVAL;
+
+	pt = &dt->data.pixel_data;
+
+	if (width)
+		*width = (pt->hactive_hblank_hi & 0xf0) << 4 | pt->hactive_lo;
+	if (height)
+		*height = (pt->vactive_vblank_hi & 0xf0) << 4 | pt->vactive_lo;
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_edid_detect_panel_size);
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 04f7a7f1f108..a2617aa34edf 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -490,5 +490,7 @@ u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid);
 bool drm_edid_match(const struct drm_edid *drm_edid,
 		    const struct drm_edid_ident *ident);
 bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk);
+int drm_edid_detect_panel_size(const struct drm_edid *drm_edid,
+			       unsigned int *width, unsigned int *height);
 
 #endif /* __DRM_EDID_H__ */
-- 
2.55.0

