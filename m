Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984E952ED5D;
	Thu, 10 Sep 2026 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.218.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789061810; cv=none; b=VpzRmeV5arVatvFwaS6yCd1Q8Pmx0A2sQJPj0Z/F32I79ZP4Ad5unHmlH3uh9v1FwglH4vxnZj1srN/vpfVOnSb+87k9G16tVHZfSwpvK64gfZXQ2x4e+QrSemE7khrHoVv/NfXwu2fDnQ1NX8OFoVinhFnp0qrl/FaCSTneenY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789061810; c=relaxed/simple;
	bh=AABB2SRjfuIP4cpJEOHdE2jj3ijavPqXiUOC64YAtJM=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=I+XUnKIKEG1Ij/rxX01Ve44GjDjRcH1xbV+Zib2TpnfiqgthOL9/R2DrgEuKRgcGgP8PGmi5zb6EnxuGle4S3+y8xZND4f+DgQA2oonw1bVLTOEL8ckp/lHVndcwjlc57hmHkuldQoRqaMHvYFsLrbyCH3KE8u17L66b2hA0nuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=MbIW2n8w; arc=none smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="MbIW2n8w"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 72D0A3E2682;
	Thu, 10 Sep 2026 17:30:55 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (trex-blue-0.trex.outbound.svc.cluster.local [100.97.158.21])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0FD213E28F9;
	Thu, 10 Sep 2026 17:30:51 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Trail-Minister: 0943853f1ec20cf0_1789061455294_4094673451
X-MC-Loop-Signature: 1789061455294:475509611
X-MC-Ingress-Time: 1789061455293
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.158.21 (trex/8.0.2);
	Thu, 10 Sep 2026 17:30:55 +0000
Received: from pdx1-roundcube50 (ip-66-33-200-4.dreamhost.com [66.33.200.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4hgl7t60pJz2v;
	Thu, 10 Sep 2026 10:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1789061450;
	bh=pLiLo734Ydfu6Iz2JPKseHf5Iwizp3QoMl0jNzO+ZQc=;
	h=Date:From:To:Cc:Subject:Content-Type:Content-Transfer-Encoding;
	b=MbIW2n8wIv3wbU/W1T0vdT68M5w0YTh91UzzfLNcsuNZ589pNqljZK+tSHAYIb2G/
	 MmJzwQfIrkJ+CN0GIIQoWl1yR1efxqVWPJk282RXI9dTjqzACbIhz+DNTUrFpx/UVR
	 +uATwLdxUNtcH2XJfosJ33apNPZiD2FVbEYeMtiyrx4Oh5vX4B3Eir+hWnZbLJ9T5G
	 rUp+k5jVH3iEHN37of4ewlf1vzmeh3gr7ATgdy9wXH/+hcO4FHHcijvyOfONp/7pwL
	 l3UaGJiwcuJ06eYmw49N4HxvImVZlP308RqKpxvKaU1AfBwQj+JgdrFwdzMfY3Ma/K
	 /94P3iNXNin4A==
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 10:30:50 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-efi@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] block: store GPT attributes as a raw value
In-Reply-To: <20260908-fix_gpt_entry_attributes-v1-1-a4dcb417e8fc@kernel.org>
References: <20260908-fix_gpt_entry_attributes-v1-1-a4dcb417e8fc@kernel.org>
Message-ID: <3205907d756584ad1c5c7129aa126433@stgolabs.net>
X-Sender: dave@stgolabs.net
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-09-08 11:58, Vincent Mailhol wrote:
> struct _gpt_entry_attributes currently models the GPT partition entry
> attributes field with bitfields. This is broken on machines using the
> __BIG_ENDIAN_BITFIELD ABI because GPT always stores the attributes on
> disk as a 64-bit little-endian.
> 
> No current code consumes individual fields from that structure. So just
> remove struct _gpt_entry_attributes entirely and replace it by an 
> __le64
> value in struct _gpt_entry instead. This lets users apply endian-aware
> masks explicitly when inspecting attribute bits.
> 
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>
