Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210494825DB;
	Thu,  1 Oct 2026 06:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835729; cv=none; b=hVWvNDQuSI3QYNtiScoHoMX4Flm4ZWtZMch+jOVYBv8JFNDN7OCFXjxSHI7G47G9Hp492La0q5B0K6LAbcdBNDBZl4bupndfv0t1tYNHacDl6OVPu6duN6RgKBW2DSktoqhauGsD4SinNR2w9Xg3X1jGvyGkZER13cyu6g5I2Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835729; c=relaxed/simple;
	bh=JLVfBy4PHGJcEXFtlZjO4AUqTcGC3kK+OYZ+6qwyXzc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPpyCZZDwzGOOfoYdtgvA/on9cnRQzk6SlxA7jOeHmnGxmWMEgtc1Wue95RmCCIegELUpE5mYmmlQb8tquipeUD8k3U6bpWYe+Ol+SAYQ5uSLGYID05duPq3JVaCOSuCH5uoLtIcr/oJGsGJpXA+8HFBC6xBuLUYD/h4cH/dcJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RCG3wBH7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yQVNmWeg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Von0o+4F; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jRo71syp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RCG3wBH7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yQVNmWeg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Von0o+4F";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jRo71syp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E38BD21F47;
	Thu,  1 Oct 2026 06:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790835722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxxiZzxGZtQ8dDeTk0eXVZPKYhiMQRKmZl768e9bcnY=;
	b=RCG3wBH7ZIBH7ayF9NFLIPS+N6xcHrRcW9VIgjVuBRi8uwTUP/wNU3YpgXy5bU5sVS484k
	D5dY08bCkqTPG84zogJFBsiNv8qRia0RjolotJcynlJEBCepKJFXsGnRdqx+2nxkikEO/+
	e1nqPuOXWMrIHxc8oGl/c1U2NtOwUI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790835722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxxiZzxGZtQ8dDeTk0eXVZPKYhiMQRKmZl768e9bcnY=;
	b=yQVNmWeg/u9xr6T0GTRr1ZNG081meJgF3ZbGctj0aANClaeIM4skr91VjY2Zgc7v6v27dH
	uYVCkQanyQzTRnCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Von0o+4F;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jRo71syp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790835717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxxiZzxGZtQ8dDeTk0eXVZPKYhiMQRKmZl768e9bcnY=;
	b=Von0o+4Ft6+iTVsOUFDw9cx2GkVBZT2RUH30hS7UXQRZK0tkHg43lH4Pp5eqi2yosKFd/K
	GF1uEpF1x++KJrlUEjpIobs5Q+uBjpgwOiFp67K54FCNVfNoszjtGveqGAwlE02lcRpKpH
	7PCqKHGg2gnDaShMnMGMSJGwPKQkvBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790835717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxxiZzxGZtQ8dDeTk0eXVZPKYhiMQRKmZl768e9bcnY=;
	b=jRo71syp0Kw3ym1aQ17uSom5aDCHEFaPziWSbSKyygsIrzLjUSZ4IyMXlDcyPk9jCEFmAe
	nOpJt8cMZwsj9jBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3392B1368E;
	Thu,  1 Oct 2026 06:21:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BatoBQX8vWovXgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Thu, 01 Oct 2026 06:21:57 +0000
Date: Thu, 01 Oct 2026 08:21:56 +0200
Message-ID: <87y0ci2b5n.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	linux-sound@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	patches@opensource.cirrus.com,
	Shenghao Ding <shenghao-ding@ti.com>,
	Kevin Lu <kevin-lu@ti.com>,
	Baojun Xu <baojun.xu@ti.com>,
	Sen Wang <sen@ti.com>
Subject: Re: [PATCH v2 4/5] ALSA: hda: tas2781: Switch to use acpi_bus_get_primary_device()
In-Reply-To: <8782185.NyiUUSuA9g@rafael.j.wysocki>
References: <4766532.LvFx2qVVIh@rafael.j.wysocki>
	<8782185.NyiUUSuA9g@rafael.j.wysocki>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E38BD21F47
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim,intel.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 

On Wed, 30 Sep 2026 20:42:36 +0200,
Rafael J. Wysocki wrote:
> 
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.
> 
> This addresses a potential use-after-free that may occur if the
> device returned by acpi_get_first_physical_node() is removed right
> after dropping its ACPI companion's physical_node_lock in that
> function.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> This patch depends on new material in linux-next.
> 
> If you maintain the code updated by it, please consider ACKing it, so I can
> pick it up and remove the problematic API replaced by it during the 7.4
> merge window.
> 
> In the absence of feedback, it will be resent again when 7.4-rc1 is out.
> 
> Thanks!

Acked-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi
