Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D182FB0B2
	for <linux-efi@vger.kernel.org>; Tue,  1 Sep 2026 08:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250882; cv=none; b=NfBEakGzk57LOZaZ/3RisuXuRAj9utm/xSK69pcZCZIcshDrwc5XPDiCtf6dE2kGoc3e6GXJvSGllad8aCxoiKnMP+6XrHFK8p8pgOJ9lxG/pa125sluKytFM/MIyAuxrusGVc8NZ2Uw3B4d2jl0Ew3rh8QWJoxBLpGA4wap6fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250882; c=relaxed/simple;
	bh=ENPyT9e2wb1bx8EOV0kFZAwLh0CXAK4psRnDk/9Bcyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HuPg144/eBbRCP2Vl9LBdzWlD1M+Aslj2NMjJyjUiJlZ3KtzQIj02CmcJ0eJibtDAGYBbA56aLb/uSBPq2YWDTrgreffq15+YH9sP1JMVGGo5SCFBbqvRpeSnAfTLti1KUyqvqHEjX/OuOqSSa54VIvZtxyLDP3lGoGTqguEc44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tXexI+L2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I0YYzyeX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xTNE44ya; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aOoGbo78; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tXexI+L2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I0YYzyeX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xTNE44ya";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aOoGbo78"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F58321B4B;
	Tue,  1 Sep 2026 08:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788250868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C+C0MuvUqbKPAQnwEa/54xKMaiWFSD2wYLIk/axKn4g=;
	b=tXexI+L2PuW0/vsyZsOkzYJR9Z9Bczr+5HwMyFQ+o2ldG1MALRCblRfYD8eMnvlKC5NfgM
	wcBuGpjWPR02pVcVgdThb53fEoqmSwug6TpT6dYmY70hCSDPQnZZxtp5i/ajjLEC7SyZUC
	JiWYUvK/PKdVIfcEUatZw1M/pja/OW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788250868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C+C0MuvUqbKPAQnwEa/54xKMaiWFSD2wYLIk/axKn4g=;
	b=I0YYzyeXM5lSLOfAnT0i3QHkKyq+O3X+8DhZCLxRa70KbRjerNEJIuYBlFCBaUVypFXc0H
	OKKdDmRoHD2l0TBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xTNE44ya;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aOoGbo78
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788250864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C+C0MuvUqbKPAQnwEa/54xKMaiWFSD2wYLIk/axKn4g=;
	b=xTNE44yai8coG++JpnaDxNJCDtdexWqPRe9VEswey0l8v7zywCDaS9+CWWe2aJ+PgNhaT3
	64bT7FroKZd9CJ/RWdUoxBITQFR/2rn2gOMecvTtjIF9PGs5hynSBvb0+6Wny7ALoOhX48
	fRaCFYX1S4gghDw5Nk8olO/T6pGsn80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788250864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C+C0MuvUqbKPAQnwEa/54xKMaiWFSD2wYLIk/axKn4g=;
	b=aOoGbo7858M1vJxRNzsr6sSZspHptaUc2t3U3O75CZhrhwsWKtoIcHFYZj0Asna+p42j3q
	ZuW2E97DjU8Z1XCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF13413515;
	Tue,  1 Sep 2026 08:21:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pLMqMe+KlmqFfAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 01 Sep 2026 08:21:03 +0000
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
Subject: [PATCH v3 0/3] sysfb: Fix display output on Lenovo D330 (and others)
Date: Tue,  1 Sep 2026 10:17:34 +0200
Message-ID: <20260901082057.37617-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.51
X-Rspamd-Queue-Id: 4F58321B4B
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO

The kernel mis-interprets the display geometry given by the Lenovo
D330 as incorrect. The values are correct, but the display output is
rotated by 90°. With the kernel's firmware quirk applied, the output
is garbled.

Remove the firmware quirk for the Lenovo D330 and let DRM's sysfb
drivers set the correct panel orientation instead. To make this work
for any display mode, use the panel size for looking up the correct
orientation.

Tested on a Lenovo D330-10IGM IdeaPad.

v3:
- rename EDID helper to drm_edid_detect_panel_size()
- clean up EDID code (Jani)
- mention possible dependency on device firmware version
v2:
- reorder patches to have the immediate fix first
- detect and handle broken EDID better (Sashiko)
- fix width/height pointer check (Sashiko)

Thomas Zimmermann (3):
  firmware/sysfb: Remove rotation quirk for Lenovo D330
  drm/edid: Add drm_edid_detect_panel_size()
  drm/sysfb: Use preferred panel size for panel orientation quirks

 drivers/firmware/efi/sysfb_efi.c |  9 ------
 drivers/gpu/drm/drm_edid.c       | 47 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sysfb/efidrm.c   | 17 +++++++++++-
 drivers/gpu/drm/sysfb/ofdrm.c    | 18 ++++++++++--
 drivers/gpu/drm/sysfb/vesadrm.c  | 17 +++++++++++-
 include/drm/drm_edid.h           |  2 ++
 6 files changed, 97 insertions(+), 13 deletions(-)


base-commit: aa389a514292b196ae89c6515568b3329abeec63
-- 
2.55.0

