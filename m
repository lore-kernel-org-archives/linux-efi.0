Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300B23D967A
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 09:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788168725; cv=none; b=SgUZd2uq50+tYTWoLkH0gn+SUVdxvn8HUBZqagBOKmjsB4YbQCiSL6X0uu019tFlb+ckoBjx2L3raCx6qmJQdOzzmXDPdm1u5U42OpNALxILyyPan6Z+MK3AXzdiDj637QdnGarp+1VFQhxQmneirYjRdj3DjCIOdoQsRkFKVFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788168725; c=relaxed/simple;
	bh=sLwEbW4dWi/OlOc9G7fzXWOChgiD8TExj64O2/nNbLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TUtnBe8uCStY/c50aGxV8FJEWLL3Xo7kk9+CE+3NVoBlHH3A3h+XQHhsZgJ24GfmBhEMeHBsvWdT4WxsIb3lI4pSZg0rjjL4y+t3zG4IlLhsAaOqN2/NfJ7SyV3fOilyYG5mN4Ruo8/rcGNTogo/wAYgtXxvFnMhwo/fif4njl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ximaWWVM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FrBdVoAy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sK2AdpeJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qVWsAH8E; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ximaWWVM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FrBdVoAy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sK2AdpeJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qVWsAH8E"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65A2E1FCCB;
	Mon, 31 Aug 2026 09:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788168630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gndYjH18gEh5OBYMLuYabw0N1W6HMuDvq88x3yx3aBQ=;
	b=ximaWWVMO4wGi237uQ4g6p7n3w6x6wjzplVgTZ9QeByqI2+Wq9PWZHnMNlhaQIYR3CGHRN
	G+QOEsXzic2cOvhMkaFI0xoFJZPHRM+eM1rfm9bkpE8wwfX2AvxTbG+ONbUWQgGotBW1fh
	CmLOPEiclXtOpHph7+WheibQ4DEPdso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788168630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gndYjH18gEh5OBYMLuYabw0N1W6HMuDvq88x3yx3aBQ=;
	b=FrBdVoAygZjKOsTwiCRmylQ14uJt7aV6Tok/wPAlPEp9xehoh/3durhtPfEq3/OIP5yzcI
	OZKyWbCzA++CFFDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788168626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gndYjH18gEh5OBYMLuYabw0N1W6HMuDvq88x3yx3aBQ=;
	b=sK2AdpeJgv8pSxFTDzSkxkHpX/BQh7nuPkZ7gYNoTekPa8BNBAUHsi+X6rGlnvGssm8935
	dkIYGa68gibhBx6OEoMQGpRhzjxUf0jUGRqExAJjcFuIO4yApF7EHwyHW0qyXfhaBqeeli
	fWw33yeB09p+zBI7fbtzPsXGeiyEaaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788168626;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gndYjH18gEh5OBYMLuYabw0N1W6HMuDvq88x3yx3aBQ=;
	b=qVWsAH8EbqJU03Ff1nIOrRO14p8Di9MOyLcnh13m1mYLU3mQeoETljNXn4fVDYveIW4cPU
	MYsSotdUw/G46PDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF2DC13685;
	Mon, 31 Aug 2026 09:30:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HfktObFJlWoFUwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 31 Aug 2026 09:30:25 +0000
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
Subject: [PATCH v2 0/3] sysfb: Fix display output on Lenovo D330 (and others)
Date: Mon, 31 Aug 2026 11:27:47 +0200
Message-ID: <20260831093020.494701-1-tzimmermann@suse.de>
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
X-Spam-Score: -3.30
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]

The kernel mis-interprets the display geometry given by the Lenovo
D330 as incorrect. The values are correct, but the display output
is rotated by 90°. With the kernel's firmware quirk applied the output
is garbled.

Remove the firmware quirk for the Lenovo D330 and let DRM's sysfb
drivers set the correct panel orientation instead. To make this work
for any display mode, use the panel size for looking up the correct
orientation.

Tested on a Lenovo D330-10IGM IdeaPad.

v2:
- reorder patches to have the immediate fix first
- detect and handle broken EDID better (Sashiko)
- fix width/height pointer check (Sashiko)

Thomas Zimmermann (3):
  firmware/sysfb: Remove rotation quirk for Lenovo D330
  drm/edid: Add drm_edid_get_preferred_size()
  drm/sysfb: Use preferred panel size for panel orientation quirks

 drivers/firmware/efi/sysfb_efi.c |  9 -------
 drivers/gpu/drm/drm_edid.c       | 46 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sysfb/efidrm.c   | 17 +++++++++++-
 drivers/gpu/drm/sysfb/ofdrm.c    | 18 +++++++++++--
 drivers/gpu/drm/sysfb/vesadrm.c  | 17 +++++++++++-
 include/drm/drm_edid.h           |  2 ++
 6 files changed, 96 insertions(+), 13 deletions(-)


base-commit: edb0a89a038079d0d86e768b30a72d053d3e39e0
-- 
2.55.0

