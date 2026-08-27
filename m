Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FFA37C92B
	for <linux-efi@vger.kernel.org>; Thu, 27 Aug 2026 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839749; cv=none; b=HxuxxSJPM6hbN0uMu+7ZeiJpQaKW8Hn/oFduFtEX9rmP/VVDr24D6GoBIb7qlUmJ29f+gEDKMJsThhyUB4MOBqb4PUg+YYmsjSX2Abj/Vv6iygxH3B0K9CbAVNl/LYbyuK4CxK/q1LOYvilkDGH2ENp1pD8ydLiT8g8bPhmCb48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839749; c=relaxed/simple;
	bh=Ca3PoKBt5YojbmsMUD2c3cCKZKqgHo2oirWHwI+0DAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bt3A1PHYlMkuhqX8Cs8o459RSqY7bQlENSm7WVRajhK1ZA2cXk535WMIMy9nV5myhi6blY1fgxxsu0WOdqc3Qr7pTFiHOBgthDSeDmsrbmOd1B2po/LrOCqXKFJ9e7kjUIw362ww/p5Yec8USMkedFepA9CA5Dz/4HjEsJ87UVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=scWtY0Mp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7QnZuwy7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J7e/mTEp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NzSRZ1CL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="scWtY0Mp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7QnZuwy7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J7e/mTEp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NzSRZ1CL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7D0E61F841;
	Thu, 27 Aug 2026 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787839656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=inMzVHiVBcCLJ2+S7e7paRJRrABOr+WAxBkmBAGotf4=;
	b=scWtY0MpjphaXr5P2UwQzhPVGTt/ohsX2XliSbhDuh8Mf5u6M3Mq/VpJjVTdNrDm4S+BLM
	6DbhQHVRojnY29OVlcuXdTvXDEnVlOwQVuUUCL6CsBfsMaVsMzMCwgvg+vpFNJKGWTJdEj
	fk/fo9rba7NPOFgZRtB50HdavfkFySc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787839656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=inMzVHiVBcCLJ2+S7e7paRJRrABOr+WAxBkmBAGotf4=;
	b=7QnZuwy71biK55TMmHsWTEMR7zuvwfpCEzIIfTzWcMXPxmQiYaqctwrnjiEONxOQ36trwm
	1wVh7OOPOwr+sgDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="J7e/mTEp";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NzSRZ1CL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787839652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=inMzVHiVBcCLJ2+S7e7paRJRrABOr+WAxBkmBAGotf4=;
	b=J7e/mTEpZoVKw2gNUopxUmZ18igpsEGpQHffTL+N4eZkXgN4r2qA72tuKA+TKOb/UzG5Bz
	aSXN+IqBeqmVTshzKNbn+i2A4lLDP3xXp6A0XFmKFnDNxd3VG8WmVHPgnAzFRPv7iZRarR
	OoiGLV7k0kIyeUUIhYIOv91uKGJSMKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787839652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=inMzVHiVBcCLJ2+S7e7paRJRrABOr+WAxBkmBAGotf4=;
	b=NzSRZ1CLtTPRBUTERgxjWFBgcSKrDBCGBai0ax2S+IMOHCab/pGcICbEimCAkpVrqfVIl2
	EtW7PiAxnUI7ZpCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5EC91352C;
	Thu, 27 Aug 2026 14:07:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xG6WNqNEkGp0FQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 27 Aug 2026 14:07:31 +0000
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
Subject: [PATCH 0/3] sysfb: Fix display output on Lenovo D330 (and others)
Date: Thu, 27 Aug 2026 16:01:36 +0200
Message-ID: <20260827140726.420734-1-tzimmermann@suse.de>
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
X-Rspamd-Queue-Id: 7D0E61F841
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

The kernel mis-interprets the display geometry given by the Lenovo
D330 as incorrect. The values are correct, but the display output
is rotated by 90°. With the kernel's firmware quirk applied the output
is garbled.

Remove the firmware quirk for the Lenovo D330 and let DRM's sysfb
drivers set the correct panel orientation instead. To make this work
for any display mode, use the panel size for looking up the correct
orientation.

Tested on a Lenovo D330-10IGM IdeaPad.

Thomas Zimmermann (3):
  drm/edid: Add drm_edid_get_preferred_size()
  drm/sysfb: Use preferred panel size for panel orientation quirks
  firmware/sysfb: Remove rotation quirk for Lenovo D330

 drivers/firmware/efi/sysfb_efi.c |  9 -------
 drivers/gpu/drm/drm_edid.c       | 40 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sysfb/efidrm.c   | 17 +++++++++++++-
 drivers/gpu/drm/sysfb/ofdrm.c    | 16 ++++++++++++-
 drivers/gpu/drm/sysfb/vesadrm.c  | 17 +++++++++++++-
 include/drm/drm_edid.h           |  2 ++
 6 files changed, 89 insertions(+), 12 deletions(-)


base-commit: dc462ab791b686c48545c160ecc81be64f77a846
-- 
2.55.0

