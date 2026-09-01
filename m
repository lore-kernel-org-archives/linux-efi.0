Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137A370AE5
	for <linux-efi@vger.kernel.org>; Tue,  1 Sep 2026 08:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250879; cv=none; b=PbCkv5URcKvIjeeZt89okDb+ekfAzNfrEQ1F0IwgFcmeZJXplpAahjyIFUx2N+JcCN1N9RbC2EGZO/qA/MPN9Vj1N/fIyxjh2kK4i//8KNyjchu0U3mEOe/j2cW0pwm0QrRJRBDs/9dA/zO5wl2F/9rm8AwqLerQMr0G0MDYyDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250879; c=relaxed/simple;
	bh=lMr95ZLhUJUmUV7/tM7okiIpldS3NsaAHszTvswpFLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ap3IoKp4OYJcKl3AJOSp3fn+awzUYW+QdHHSikeMIYoYr6rTTu7TYzh9fi4ggyYGKDgXydanNnVaGSIXTPCQAnrIOUpt2Rl/CajgLsHxzZYRIeXpVoEcZI4KpR6Q+8U4o3n1/RXW28vhJzlD/gdrjrJWsGRjd1/lHLfSUCxhjRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Pv3jR78t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vh7VeuC0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Eh0RnWt8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GxYj3aUF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Pv3jR78t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vh7VeuC0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Eh0RnWt8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GxYj3aUF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A43A61FD80;
	Tue,  1 Sep 2026 08:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788250869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4mkO4Iwn+BHkXvq70/8/xMCcRd0R1cwKq46ZqtGKh4=;
	b=Pv3jR78tYFNY1u4ue1Vkc+h9b2aii4AhMQd+TZUBbDf3PVIK/7IYQ7KyHm/qGTkHhFSrag
	9F9A2ZbB0V/yNwnXWZO/3HCwWoyWsprAIaHCTbbtNBYHQIi1yocvXHhS/m+BI2ajioNv0z
	ihIeKgMD5QKkruDNKzHgZpipDLfGj2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788250869;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4mkO4Iwn+BHkXvq70/8/xMCcRd0R1cwKq46ZqtGKh4=;
	b=Vh7VeuC0SiQThaiTVtODC93RBnuS9Ko2Xtqtn5myE3DVryptq7xWhw9q9A+cj5yQ15uGqI
	Lngzh6f7UZmkSrDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Eh0RnWt8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GxYj3aUF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788250865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4mkO4Iwn+BHkXvq70/8/xMCcRd0R1cwKq46ZqtGKh4=;
	b=Eh0RnWt8Dgi/F6nDTvESi8M4vMb+QcOZkdLVY2SdeIc5nSCHECxIjVOBodfs1SDhyAKv7G
	mxMzRR9zS3KITc+C8TVDWLWOwbK7w2cLtRKCIOjhSjjB0mJ/R2NA7mAiH89+/92u3g8ktH
	yyEMnZ3NTbh0k0El9t39+wtpyqme900=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788250865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4mkO4Iwn+BHkXvq70/8/xMCcRd0R1cwKq46ZqtGKh4=;
	b=GxYj3aUFMRL+JlqBmrP3hS+I9wKpj3yN7+CN8UToSJWn63Paz3oB+MS+AdrRSfW2EPTtwP
	xBi5t/MB1LeXC4AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A985136B2;
	Tue,  1 Sep 2026 08:21:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ICH4DPGKlmqFfAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 01 Sep 2026 08:21:05 +0000
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
Subject: [PATCH v3 2/3] drm/edid: Add drm_edid_detect_panel_size()
Date: Tue,  1 Sep 2026 10:17:36 +0200
Message-ID: <20260901082057.37617-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901082057.37617-1-tzimmermann@suse.de>
References: <20260901082057.37617-1-tzimmermann@suse.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A43A61FD80
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Add drm_edid_detect_panel_size() to extract the panel's preferred
display resolution from a given EDID. Required for setting up DRM's
panel orientation quirks in sysfb drivers.

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
index 9990a836d0b6..d5d9e77dc91b 100644
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
+	if (edid->revision < 4 && !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
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

