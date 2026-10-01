Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EA33749FA;
	Thu,  1 Oct 2026 06:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835709; cv=none; b=iMRKOmvARbvYgZHC4t7FShJZRgoGEB6zX/xBfzQz01e3ZNw7Bqnn5773WcLFW2kMfgXAyR4BnEnscd3WcxRClI4yfIzvBLv3IjwyZSm8A4jnO87Gn2M+rvUcwO3Pu9lnK6Zt/EFzaGqYZgrOaAdB00zPNdgTIwa54XsViIPZkG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835709; c=relaxed/simple;
	bh=+v19fspQo6RqCAOXqc92x40I0rbiMxUdPLzoun4FxlQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHcURsJP9GmakYbYmc8Kb+lCqRth7tMHqMO4D4RMjsKlUMF7VSFFutzyB4a33ldxJP6Qw131v1tgIunFR07hAYv0ZtVAavotGlSqohXEI330ONB58C4FYpFoYjBcz0V8yD2FYxTtVGZQ6c8j8+4QduDab0i6q8hYeU4V0IwmqJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yD+m+xKy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gaopvcIS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ktvli22g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nPaAN4jt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yD+m+xKy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gaopvcIS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ktvli22g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nPaAN4jt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF80621F5A;
	Thu,  1 Oct 2026 06:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790835701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b5uPq6Sw9e1GVSid52TMaijlXpM/bbx4l5Q+dHa1Mj0=;
	b=yD+m+xKyXZD5Nl2heLBQdqq4Vpm7m/YYCE+8cmIzQHTRSPz4hbBFqwfjYKTAF9SZPPYk1R
	LLfGmHyzXRKPWmc/s2wRz4C9DsA5NCmN3wACGOpNNhCXd7g0tR4thU32n0FdGiJalZyunr
	3QS1OIbgd1UQLrNhgcMzTvFf7CP5b7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790835701;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b5uPq6Sw9e1GVSid52TMaijlXpM/bbx4l5Q+dHa1Mj0=;
	b=gaopvcISW7aUYJkJFmgPYdrUJIFDx1gXiLHur8En/t1JhMCEilU5PakxNIJNmZy6sjLbx4
	8/YsJvwwXjLRmgDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790835696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b5uPq6Sw9e1GVSid52TMaijlXpM/bbx4l5Q+dHa1Mj0=;
	b=ktvli22gindUY8O/AJ2eojCIf6ReFubzVRo5BmZXNIC0HuJrAP88QlZvQMbnt9ryPEzv6p
	3G404bxhG1V5DoXt/HlLlljZ66FZLuyxUL8Bc3sGE94+q+XivK0F4CDcuGfekyXT49KV/h
	2dTeUnQM1EbpONRSMrSTskedBMAgKMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790835696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b5uPq6Sw9e1GVSid52TMaijlXpM/bbx4l5Q+dHa1Mj0=;
	b=nPaAN4jtMq3aKF55aSboX+E1o0E2K/DiJCxQEd4VRHPlyTsAiv3gY19HemvVyKVHSFZVyK
	PpYqiI0EwtTc8qCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5039136A5;
	Thu,  1 Oct 2026 06:21:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LSOhMO/7vWpdXQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Thu, 01 Oct 2026 06:21:35 +0000
Date: Thu, 01 Oct 2026 08:21:35 +0200
Message-ID: <87zewy2b68.wl-tiwai@suse.de>
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
Subject: Re: [PATCH v2 3/5] ALSA: hda: cs35l41: Switch to use acpi_bus_get_primary_device()
In-Reply-To: <6200303.MhkbZ0Pkbq@rafael.j.wysocki>
References: <4766532.LvFx2qVVIh@rafael.j.wysocki>
	<6200303.MhkbZ0Pkbq@rafael.j.wysocki>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.966];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,intel.com:email];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -3.29
X-Spam-Level: 

On Wed, 30 Sep 2026 20:42:15 +0200,
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
