Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F79282F34
	for <linux-efi@vger.kernel.org>; Thu, 27 Aug 2026 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839771; cv=none; b=TwQ82+apc/BTGtCgYa/Cbclwsa9VxgI2MI7PqrNifAQzV3VWZ0Ypr8/7rlid5RUdZNFMFgU/XARfmU3W4GAQT9qx9MlCQpLCVkwEA47ysIH+0ncXQ5lv/AwPAE/aUcDAbK916Fnf+kUPpL0qrQ90D48LTPu9Jn9SC7rHip2rM3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839771; c=relaxed/simple;
	bh=kOrCg8GIMxOK9A07IjZXkfBu71zLp4kLvhVLo1yrGD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+y/V8dr+FFpqIP69OrX0xflxOxxxlmQwDyaw0XDaDzoEKgkJtqffZvltA90t2u2mI6qBGSftXyTmW/kGRCZ4Gsgmo/4k9uqk6sAqukDJevDe9dKqD5qfHnLd/1FHBftnK5/OjY61gLsU1bYz5yp5p5psVa52n3J+f1dF7npaP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rfKOf9rw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Psjcah1L; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TTqp/2+T; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DQlpDUX9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rfKOf9rw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Psjcah1L";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TTqp/2+T";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DQlpDUX9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E86341FB10;
	Thu, 27 Aug 2026 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787839657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djgWvt4e8p3+bDLjlAAtcfxzd5WTSVUL9hU/N3Q57wo=;
	b=rfKOf9rwb59oYxjFsmIkjBmbHFvwUVPfJTmR2t0lchf3ArIby6bbCx8HDoauKiHXwZqgtm
	+5PikoCezB/HGUGWWPfHNP4GRrCzoroZANZlniWgiC36zm5AhkqnqbyWSeeU2IfjAoFipu
	6f7p3B3WR6PoNSsBeYlpZXIbopXJd98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787839657;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djgWvt4e8p3+bDLjlAAtcfxzd5WTSVUL9hU/N3Q57wo=;
	b=Psjcah1LAMamJ8VeOVtL9hG8DUeAPkwyxJwkjAeuxjJ+473Hz1XuBhdC07OY2dXjw5R9oC
	1HYi8duLye4Zt/Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787839652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djgWvt4e8p3+bDLjlAAtcfxzd5WTSVUL9hU/N3Q57wo=;
	b=TTqp/2+TnG/JRyaizOl4Q8dvpq2PwzXGeoI092fish+f/NNHS6evh3v3nbV93S7hQQR1jJ
	t/jwMpC0khPjAr/1A/JlIDDRUT938YkbNyqpXTg5d0ysgD1GyGH4JiaO2xOHbbtl9yjC5Z
	6Isa/GbrP9KRG27xhIVcGWO47h2Vts8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787839652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djgWvt4e8p3+bDLjlAAtcfxzd5WTSVUL9hU/N3Q57wo=;
	b=DQlpDUX9VDjArrzwDkFqgBjG23MkBDs2b5FT4e1/MKtS/a9xv/nkayorhVCwXMAqlm1GNZ
	uoy8mofSyUR20+AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 955EB1352D;
	Thu, 27 Aug 2026 14:07:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kGwSI6REkGp0FQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 27 Aug 2026 14:07:32 +0000
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
Subject: [PATCH 1/3] drm/edid: Add drm_edid_get_preferred_size()
Date: Thu, 27 Aug 2026 16:01:37 +0200
Message-ID: <20260827140726.420734-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827140726.420734-1-tzimmermann@suse.de>
References: <20260827140726.420734-1-tzimmermann@suse.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Add drm_edid_get_preferred_size() to extract the panel's preferred
display resolution from a given EDID. Required for DRM's panel
orientation quirks.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 drivers/gpu/drm/drm_edid.c | 40 ++++++++++++++++++++++++++++++++++++++
 include/drm/drm_edid.h     |  2 ++
 2 files changed, 42 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 07970e5b5f65..02cbf8de1128 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2844,6 +2844,46 @@ u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid)
 }
 EXPORT_SYMBOL(drm_edid_get_panel_id);
 
+/**
+ * drm_edid_get_preferred_size - Get a panel's preferred size from EDID
+ * @drm_edid: EDID that contains panel ID.
+ * @width: Returns the panel's width in pixels per scanline, if given
+ * @height: Returns the panel's height in scanlines, if given
+ *
+ * This function detects the preferred size of a panel from the given
+ * EDID. There is no such information stored in the EDID block directly,
+ * but the preferred mode often corresponds to the panel's native geometry.
+ *
+ * Return: Zero on success, or a negative errno code otherwise.
+ */
+int drm_edid_get_preferred_size(const struct drm_edid *drm_edid,
+				unsigned int *width, unsigned int *height)
+{
+	const struct edid *edid = drm_edid->edid;
+	const struct detailed_pixel_timing *pt;
+
+	if (drm_edid->size < EDID_LENGTH)
+		return -EINVAL;
+
+	/*
+	 * Use whatever the Preferred Timing Descriptor tells us. For old
+	 * and obscure displays, we might need better heuristics.
+	 */
+
+	if (edid->revision < 4 && !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
+		return -EINVAL; /* no Preferred Timing Descriptor */
+
+	pt = &edid->detailed_timings[0].data.pixel_data;
+
+	if (*width)
+		*width = (pt->hactive_hblank_hi & 0xf0) << 4 | pt->hactive_lo;
+	if (*height)
+		*height = (pt->vactive_vblank_hi & 0xf0) << 4 | pt->vactive_lo;
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_edid_get_preferred_size);
+
 /**
  * drm_edid_read_base_block - Get a panel's EDID base block
  * @adapter: I2C adapter to use for DDC
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 04f7a7f1f108..981aeeb6ddf9 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -487,6 +487,8 @@ void drm_edid_get_product_id(const struct drm_edid *drm_edid,
 void drm_edid_print_product_id(struct drm_printer *p,
 			       const struct drm_edid_product_id *id, bool raw);
 u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid);
+int drm_edid_get_preferred_size(const struct drm_edid *drm_edid,
+				unsigned int *width, unsigned int *height);
 bool drm_edid_match(const struct drm_edid *drm_edid,
 		    const struct drm_edid_ident *ident);
 bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk);
-- 
2.55.0

