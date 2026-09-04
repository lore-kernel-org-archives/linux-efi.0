Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE1A3BFE5A
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 09:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512948; cv=none; b=haF6wWiHbHB6dKtTaxtdtAwDBRENo58pUcavJlZNho7acXN2IIyAXZJ8otfxBqRPeFyCUulZKRPHFYoCCpsI68t2akb68KfAVNtepb6mJHsz6+NtVS17FCcp2lZuHxqTaR0fBP54H/ubiRKBhS9ooC5fkxyCqVMw6cgvnZ9uZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512948; c=relaxed/simple;
	bh=hi5YRYYhsTgYB0kp3f5OIly5P7jdu+OeSnZZrWgCSxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/LhNcEGX4f7pw85Uip3jBBqBAAKzHBqZMvvUeAtRY7Gs1g9aP2XD3+PERt56VOqsD6S+hnawM9lE7euOBaiWJ2i6RlpQ1A4Ur9sYb5M3QsQCYWpIGJRQy+gA4iTrc9HiOYu03KvkQyQ4F6Wd6NDasoUyxuMp/B4tRCWKosuqPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bmUgXlhD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HJcJfmNs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mfk9RidB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MtygzCmq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bmUgXlhD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HJcJfmNs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mfk9RidB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MtygzCmq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B8081FB96;
	Fri,  4 Sep 2026 09:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=bmUgXlhDeIkVZFybV37vp6vQFC9QVBL/K1/0XOh8KoLCpkLt26BVKhCAPZhsBWwk0loOkm
	HVbm1/SVs9x3we9SyChzJF13K/px+IaOiwTDCYvZESOzflShyI6HYzIhaY67RO6WP0xsyO
	B6sD9wXVqXKh4kW/31Co9wkt2i449nA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=HJcJfmNskZRWi6xBmq3BNUteQxduFRr/25xnPz0ISo933HqLlAxIlciFo4X8rIA+XGw7mX
	5MOE5c3nbz6zs/AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=Mfk9RidBP/mgkTS4tFTPnl5TRDgVJu7JeoXAUrs4DQ1XuG+upNs3Ns6Oz51EZVQHhKIqDZ
	pQu16Emz8JdJ0XWD+qilCKlE6fWS0oAn4NL+lrgVFYBRGHqTFe+5VFtMbvCrE6dk04tC/1
	/d3B+DsHbs8SMgoI3chLraedoXZqM78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtHEuer+6rDk5OW61PMSdMfBTVlgbWHd3PYyCjHMeT8=;
	b=MtygzCmqfJ0gHr0T+YBgVLnhXrH3znZ29BqGSuUaO9u5EGCjyIjKfG8MK1oditMRrJ+Cdy
	oxpaetOCAScuVKDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2692913736;
	Fri,  4 Sep 2026 09:08:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IF73B6iKmmphdQAAD6G6ig
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
Subject: [PATCH v4 1/3] firmware/sysfb: Remove rotation quirk for Lenovo D330
Date: Fri,  4 Sep 2026 11:07:00 +0200
Message-ID: <20260904090850.43060-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904090850.43060-1-tzimmermann@suse.de>
References: <20260904090850.43060-1-tzimmermann@suse.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

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

