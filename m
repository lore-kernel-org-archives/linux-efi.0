Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6945D5FF
	for <linux-efi@vger.kernel.org>; Tue,  1 Sep 2026 08:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250890; cv=none; b=n2KfbQ4suhRlm+zQPXACdA778rtBEvknKDiuo41s7OScEU9dQR7qFRSoyx1oLSLkcLPx+3uP37lu83prXohJFTScgDml8gvLAPL6b8jpJpVBAkl2vEOGFemqudX+2ZBzKNe8YIB86ZmjutBWdFAlulpi4ANqAjf3Xy4gKlgw3WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250890; c=relaxed/simple;
	bh=hi5YRYYhsTgYB0kp3f5OIly5P7jdu+OeSnZZrWgCSxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYnNnVg5rq/HzTxAw05NwO4JQtjKQAgBEOMthq0vgHqXoJQya2ptl0A5IgegCKlL4KWvHK4SvmsMQ5e3i2w0qWc/SDoa0fS70zQo7xFmKJVh+nYXqSEJs0ElMz1fd8GgDRB82ss80cAPZp2T7aE5Zd4CZ/pgltAj4fVYLeg5TXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iajZMWm4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5EcejYh1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JLJaCauR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PpJBbCPJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iajZMWm4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5EcejYh1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JLJaCauR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PpJBbCPJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4984D22472;
	Tue,  1 Sep 2026 08:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788250869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=iajZMWm4039XJ9s3NqlAFNYigNKQX6cBxfw5lhkvc8rbybmrwwOk51CMLpp5ro0MY6sfqS
	wzRQZW3HnUrpNjoAKTl6BeXUkCrM23zerrCUvHcBut9E3D8QY7kz8/xqL7f8L8QpPR9HoI
	caa4tCXxH31ESAzaYsb8uIfSzGrlpLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788250869;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=5EcejYh1Op+CUoUh88FVd7U9Ri/M0W0oMYtYcJM6lJ+3W/NIumTce0ZzwpAHEepDXjvW4+
	WH6jHQhTqWErzWBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JLJaCauR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PpJBbCPJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788250865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=JLJaCauRFpNsur8Xs7KgEr31exHmIvkCI448IUg0YFMThoEsgqvbxWJEadB9vGPGRV25Ic
	ccKSzEy4ycK748e4xnbXsXGLlaVybFaUVCXywFS3qJseLGZGfelJeFpe1/nQZormwOYUUe
	mezFJiUkIaP1qgDFkFSQZE5yIK4ojMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788250865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=PpJBbCPJ66vyz2zMMjqBWRZr8UVccV4J69orKxxwlF0D6Hcns3raa8T4gD+gmQMtzELat3
	Oo0JUinE38PmTnBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4D19136A2;
	Tue,  1 Sep 2026 08:21:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EImOMvCKlmqFfAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 01 Sep 2026 08:21:04 +0000
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
Subject: [PATCH v3 1/3] firmware/sysfb: Remove rotation quirk for Lenovo D330
Date: Tue,  1 Sep 2026 10:17:35 +0200
Message-ID: <20260901082057.37617-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901082057.37617-1-tzimmermann@suse.de>
References: <20260901082057.37617-1-tzimmermann@suse.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4984D22472
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLqtkr6cif1ebgurukgmwdm7xc)];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.51

The Lenovo D330 is a notebook with detachable display. The display
is installed in landscape orientation, but the display mode is in
portrait orientation. By default, the display output is rotated to
the left by 90°.

The sysfb quirk breaks the display by swapping display width and
height; and thus mixing up the display geometry. Fix this by keeping
the display as-is. The sysfb DRM drivers, usually efidrm, will pick
the correct panel orientation for the display.

The exact behavior might depend on the version of the BIOS release,
but the exact version numbers of broken and good releases are unknown.
Users are advised to update to the latest firmware.

Tested on a Lenovo D330-10IGM IdeaPad with firmware 8NCN43WW.

v3:
- mention possible dependency on BIOS release in commit description

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/sysfb_efi.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index 685283bb7327..2338de73c62c 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -301,15 +301,6 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 		},
 		.callback = efifb_swap_width_height,
 	},
-	{
-		/* Lenovo D330 with 800x1280 or 1200x1920 portrait screen */
-		.matches = {
-			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
-					"Lenovo ideapad D330-10IGM"),
-		},
-		.callback = efifb_swap_width_height,
-	},
 	{
 		/*
 		 * Lenovo IdeaPad Duet 3 10IGL5 and 10IGL5-LTE with
-- 
2.55.0

