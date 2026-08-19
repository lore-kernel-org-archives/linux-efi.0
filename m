Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F019489861;
	Wed, 19 Aug 2026 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157037; cv=none; b=SYZMCFyN5gRZL/t5fVCH+nMfnqMNkGnpkLqxvl05lHtcZ9GwWTOc2C4uYV7KJ7/Lek5q1/b9CfND8KOwjqbIeomJGErUSEY04HCjx5/75GofJ32o1oaHM/DGpeejJZuo1OXGDTFTab4ZmlDC+7CI2WDoE/Blje0s5pUR/ijiREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157037; c=relaxed/simple;
	bh=k6v3SaglDUCewteuFXVt6DG1RzLNMb4XdvCSAQj3l2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzCtysO+6mCOdGSNvmbP9nWNtyukJvB6EQmFFe79t3g2u6GvhAIZw4UiWM0mptPMN41wNoY5H37m5TwAfMcGvjMsSUt4srU/xo1d/ClAGwuRkXK27S9ii8XWrfTpwTPX9vtvwb/m6mLYk8KLiMmxwLEoax0av9M4uKo52uv8D2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astier.eu; spf=pass smtp.mailfrom=astier.eu; dkim=pass (2048-bit key) header.d=astier.eu header.i=@astier.eu header.b=bXsVS9j1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PVOuqDA+; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astier.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astier.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astier.eu header.i=@astier.eu header.b="bXsVS9j1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PVOuqDA+"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 88BD27A0105;
	Wed, 19 Aug 2026 12:30:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 19 Aug 2026 12:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=astier.eu; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1787157034; x=1787243434; bh=LB3LEC2789
	H9F6ctczT5CnNl4kze8bV2MjpmR+VQNo8=; b=bXsVS9j1bJYZIH+AMis6yzkqjK
	mZ0op4lcg029P+QU+YRoAA9DQtR84Kn5iC8/dTuSW0UcncCZvg6Rv5+SzBp43bry
	3NMiBtHDeyQyyYJpbptfe4JqqHOEIoE6qRlPiiV3mJe3VYkSifK03glR1bonhjcL
	W35jYRZP9MfjInov8HfGAUMHlhO4P3rtEf0/b9NerAL/jhuu/DsTh7lJkR9AJ191
	6GkowoYWdcnhwt6UUsG8wm6J6aMLdH5m0bnQjMMJFnzzgp7jq7H2gzyhy912OGFk
	CIHoVqlklhd/gOrgrklhQ9y0K9htW7NoSagmukN4j/N5T9JtsfTljSpd2+wQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787157034; x=1787243434; bh=LB3LEC2789H9F6ctczT5CnNl4kze8bV2Mjp
	mR+VQNo8=; b=PVOuqDA+ZUMH5T7nzEC4tTN65OhF2iM3bs1bDtRpotDe7qrbLmD
	UovBm6O3IWMJTU5pophMQcvArsZFgm2lKFmf0W5rRbtP4B9QIV8saotXeWFdLOAx
	5aEmz+xatlr0T60/oRgK3P6x0Q652gKLfhAWw8dt6VxJoo64zZ1z9XXOEkbiXEQN
	IfTSK3ii9hbmn4RYKgxNIcEudz1ptzncV+/DrV4wfjIubv45GZGRPsHZiyI+gpIF
	sY7afZ0oo6ocDpxj6PBCCOY6clXW+REDrrENOIQY7t9bxnMbKNhcNVuCTFSJWZe1
	0wmWw7q63i58yOI5Ci6HyEj2uw4dnwLn+0Q==
X-ME-Sender: <xms:KtqFaqXhr_DbHVFZd8HOGlrFM6AmRPrk0e5Z7BRq0zGAqUTurlo19Q>
    <xme:KtqFaoF7Wh_1NaR8RPKlvwtBk5UJoQymCXgDtZPLvaZbW0aa1nns7kzYA1r4ISHdQ
    enkVR81g426hZFqdEYPkcbK9WER5p5_cP1laddxHL-VENcKzHBvrw>
X-ME-Received: <xmr:KtqFauc4fpKem4fFCPHwgV2zxc1B_Af0cEMoOfBit28voLUgG_JV_VNfo_5r4_rnLan1jaUmtdw6Ik9MbbViNF7n6fEUB_67W5hxmVKv>
X-ME-Proxy-Cause: dmFkZTFsj9NIgBuR6iJa4VFFAlbKVoABCIV0mkCBM5PDdMqMI9XJ7JFRL1XmbKEQNHYyG6
    UQjkFQBOgzznIbtfTxsCsFUo2lV8caIHHoWn67BxV01gtR52KmYtfdrCtmrD0jFd4y/hSM
    oQTBDSBA9FU01x9+Bkqp56Z8lTx6u5ZVWoYJ0mHQNrJZY16isfAGkVPQJt+lGveRGkL1ga
    H3sZZGNDzHXO0FDy67Mf/zvZa++XH2ft9dEUXWrG6qoJRVXjasKmxL3kkngtxsm3bies5s
    OjV2pcbEGHGafNvRXSfXJMuoM7JelHnnTGb858fSXfIFQE0VgKqV1YgEekO+ogAXYlQ0oH
    QPo5vJDxjnUYq3ldKnCBsffH1aVde2i481zAjd4n00uD7fKrp69RdfWeqXMz41TJ79h3VQ
    IHkDRdFlORdpqX1jEgVqtOLVKmX/bWb3ijOvb8Pen70sWCw9nRwptaO3u7/sq4HVJKciLa
    kU0RqHL+0om7JsJiI8WWZYzu/PPVvuKMOWoL3grrzwOhjE8/HJrjZP28uf00L7ORLAPiag
    v3/KasRKa1jpLjFKLVEvAqvg/OuWF96m7zW9tAxEYZ4RqMyMXXcmGGzW7CahQH4/XKE9UC
    O2cvm6CHk40+vsQwAOawlCqTd3RFzotksW5Ea+a02FcrmSyw3jqa5LwdMyXg
X-ME-Proxy: <xmx:KtqFahIezpHklumOxypxulN7p_9IKrn_y_imwC7DJTTXf2PBG13Crg>
    <xmx:KtqFarFBmO5uRogQN_VcS1U1t_Nacpni0V5xxGw0wKZS4Xv_OZJFrQ>
    <xmx:KtqFasA_dmbf-OFPqbdeo2mdWECXIbH2MqrSPwEh7nyueiyz8iY4wg>
    <xmx:KtqFam__YmvQYkFFBWwHGZ7SSu6AfUOUxqyCT-zNVSGDS2eLa-5yXA>
    <xmx:KtqFauDIk7P4SnERXvKJAYgn2uRfKxIncAaXX9DR5AEdAZMkLSNjW704>
Feedback-ID: iccec46d4:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 12:30:11 -0400 (EDT)
Date: Wed, 19 Aug 2026 18:29:35 +0200
From: Anisse Astier <anisse@astier.eu>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] efivarfs: Rate limit statfs() handler
Message-ID: <aoXZ7xBT546YKdOY@kanto>
References: <20260818141150.905336-1-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818141150.905336-1-ardb@kernel.org>

Hi Ard,

I like the new approach, it's much simpler and easier to understand

On Tue, Aug 18, 2026 at 04:11:50PM +0200, Ard Biesheuvel wrote:
> Ravi reports that statfs() may be called by unprivileged users on the
> efivarfs mount point, which may result in a flood of calls to the
> QueryVariableInfo() runtime service. These calls are disproportionately
> costly on x86 systems where the variable store is backed by SMM, as each
> SMM entry requires a rendez-vous of all the CPUs.
> 
> So rate limit the calls to QueryVariableInfo() at twice per second, and

It's already a high-rate in performance sensitive environment. I'd have
gone higher at once per 10 seconds for example. But really, this is
minor, so please consider this:

Reviewed-by: <anisse@astier.eu>

Regards,

Anisse
