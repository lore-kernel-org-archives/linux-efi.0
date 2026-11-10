Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794326642;
	b=sQRq1cN0XzDaZRKRP8GkN5tQZCJmJkbf5MwviAVlT9QxbpNOB8NtaN5xT5Bda5CabF+7
	 g3kCNSU2+AfRnhpkDxVwWtqGujqVng4iXi5AiIfjg61BL2KXhp2mkvWQfjPkYXAxE9WnX
	 /fRRP7oVeuQ3XiibXuCMY+TwyDc70NugSi360MTgJ2Un5XLo6GfPhKluVMTxlxNtZgXpZ
	 wkd37Sj436tos01EE/RGthTIN0TK/e/yhcTxkcBjOdK9eaAneAnwsjUubZBcF3Mw/OZPI
	 iV3YYB4E460hddxv2AMjVDMl0zhcOl3GO6GDwoOowfE2qhAm7NsdCYro6QeFl5jVjYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794326642;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=w7agHuXtBJI6ahKZzHDMUpFWZT/q/VA7pg0wHCd8yCY=;
	b=J8mUXAetFn/ONHHPmC1kdAn6VK5VUr0wpGRghDLqmXbFQVqHZssFIPHaWOixGpWh+xcX
	 lQgKpR+LNsv7RIY8gUm3u42UdrxPl0UE/4peQk88D6qcJBFODw76e7Y/OQOdMKi80TAxu
	 gJW5iu2UV/iDY2WoOgcADtQl/LD1pZc8uDAQJ7WGv8AgAou4pt4RTyQIQeZjI7kPcVrOV
	 eDIpcyLbGcftyl5B1IPq3ARu/u5Ysj/5mpg2lcjueUP5E0HC30ymQw4yKZYo+CTgFsobX
	 73bUYaGkuNDIuWWG/ePKUbyvgirlt0VVPvrK9iS9sMqrxgizXuJqE9awCMy0LQxZwjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kHaj9GV9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1075606A323;
	Tue, 10 Nov 2026 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kHaj9GV9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56E91F008A1;
	Tue, 10 Nov 2026 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326641;
	bh=w7agHuXtBJI6ahKZzHDMUpFWZT/q/VA7pg0wHCd8yCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kHaj9GV9K5ZCAeq/HZGYZvkFdn1diYI98q6gPGdcdwPXWecqeV7sjrMMve5SKyC4p
	 ubzJkBkk9ykKSRVUG7s7Eq627ohVLzvhTg96tatx1yC4yeLWal3gXlHUyvoFjTysK4
	 KbGW43ZLPBHbaNMlvNuRrNj8nVtv00LDmjRYbs/V7pu1M6aSc6xCQdjM6+OMZvPsOZ
	 J7rEV7axlH04+Wb40eJcbUoK+fH1DbFaWscG9vkyX78Mf7f0yv+Pyz5kWD2Y3ClUrd
	 uFP2ZkUbCQgQvAceT41SkYHN3O5kf55d1C7FRGGYiwQLEc9D4lUXs/jv9xbzfNTf2d
	 fyiPA+dVdQH/Q==
Date: Tue, 10 Nov 2026 17:03:55 +0100
From: Christian Brauner <brauner@kernel.org>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Dave Hansen <dave.hansen@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/7] init: discoverable root partitions
Message-ID: <20261110-fachlehrer-anhaften-unkenntlich-86fc48b56f8f@brauner>
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>

On Mon, Nov 02, 2026 at 10:29:07PM +0100, Vincent Mailhol wrote:
> This series adds root discovery directly into the kernel so that people
> who are not using an initrd can still benefit from it.

Nothing has changed since
https://lore.kernel.org/r/20260617-irritation-rollen-wirst-7d636cbfec92@brauner

-- 
