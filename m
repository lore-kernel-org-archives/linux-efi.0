Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DCC423160
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 09:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512951; cv=none; b=h4KKE3/+pDoB/2W/R8ivWAXGACWYKByQpKmQCfl4bC61JeDL5wxGW5j7HSjbDEV7wx0hVjG+k5wbevMkrFzYFFP+GInp/dAEUx/abd9h1hPsiWHOj3KqGnSyTeSMrflYNl/uILHf0wHQ51XK6PAlHiDbgS4A1l785X6ZX+Rd4Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512951; c=relaxed/simple;
	bh=Mqyj1Yr+5RrwPxP34suJfIqM9sKQoOEEnLF3O+1iZng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=slqIrk5rp9nNLELpFyFWTF2/IO3lpV5E50i1IDuqkDrl4TbzDaMFUrz9D36c2K3rm6eHKO/3qgJN+G6u6rdz3IMvygsACTupH9Ecc4rAKwI73SNQelW+yvLvC3iciy3mEScAPlXpaS3IgsXBwU+jJ5XmD3GitgPq2Gmkux69MEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V4tjkCdX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i2QV3NA4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VeQBZ/Y2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DtThAcAf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V4tjkCdX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i2QV3NA4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VeQBZ/Y2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DtThAcAf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 373A122B3B;
	Fri,  4 Sep 2026 09:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N5wNo5A0H4PiTXjX7KcJL0forrC1nZmb4KlHoG1cGlM=;
	b=V4tjkCdXKjUBDFSI+c3flVLyC2jaC1B7MZbYbwSwq/nV5DWukFA4pkftbAjcyyoCSNNFfz
	wSF2YAp8XO0IYGXcsXMG+iBzJgNeoiOT+ndghh6ubUnvXKEkI3Wz1xT3KOo/v/+O6Kp0U/
	7BgqEGfG4qmdTF5Tsz+eFAkYAoplfns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N5wNo5A0H4PiTXjX7KcJL0forrC1nZmb4KlHoG1cGlM=;
	b=i2QV3NA4akDv9uHy/H0zVdP4D392sxqU6TmfwhusFoDFJMPDLhyVPVyTm0Jabk6MmxsD8S
	ujDmzgSbg4YFnBAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VeQBZ/Y2";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DtThAcAf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788512936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N5wNo5A0H4PiTXjX7KcJL0forrC1nZmb4KlHoG1cGlM=;
	b=VeQBZ/Y2WIVMYry8k6dRPoTePW5X/KTYK+q79uKAIrjLniHOve4IyRm+p4QQL79ziqt4K9
	w/2JI2nZOrlP4Z5WSYONVHWOaZsLr2ftWhM5IZlyQMcc2+ShwIrd6X/S0anV45zcoqkz6k
	qaEJuxgoKoyTeO9iei4ck6TVzfG/DfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788512936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N5wNo5A0H4PiTXjX7KcJL0forrC1nZmb4KlHoG1cGlM=;
	b=DtThAcAfL4+REoAM6/ALkFrjNkH8Fzy4QkpEc9/gg0i8cYyaFf5HxrsRLsGYrolzioywAv
	/TmfiHodnERh0CDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C337A13726;
	Fri,  4 Sep 2026 09:08:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6RdDLqeKmmphdQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 04 Sep 2026 09:08:55 +0000
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
Subject: [PATCH v4 0/3] sysfb: Fix display output on Lenovo D330 (and others)
Date: Fri,  4 Sep 2026 11:06:59 +0200
Message-ID: <20260904090850.43060-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.55.0
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
X-Rspamd-Queue-Id: 373A122B3B
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[redhat.com,kernel.org,linaro.org,linux.intel.com,ffwll.ch,gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.51

The kernel mis-interprets the display geometry given by the Lenovo
D330 as incorrect. The values are correct, but the display output is
rotated by 90°. With the kernel's firmware quirk applied, the output
is garbled.

Remove the firmware quirk for the Lenovo D330 and let DRM's sysfb
drivers set the correct panel orientation instead. To make this work
for any display mode, use the panel size for looking up the correct
orientation.

Tested on a Lenovo D330-10IGM IdeaPad.

v4:
- fix test for EDID PTD (Jani)
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

