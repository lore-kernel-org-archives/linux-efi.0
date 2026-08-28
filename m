Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF05C396D03;
	Fri, 28 Aug 2026 10:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912016; cv=none; b=Zj8nI/ydfgKislLcDzgItF1cDUcY2/rxKh3MghT7MrMoUMtmj+M/KJS1uXvzgVOK1Yv09QtR6fjU95/yIAqzSUuVB3e3nHsYWp+Iip0BF70Y7Tqwzextf44O0L8X7kEAQWJqSff7PGaKIue/lfS1ylKzyzUcQ5UjGxTcduhgC2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912016; c=relaxed/simple;
	bh=YcdCASgBMokbVvqCzdKxPSD6x3NdQ+oKQweujJ7iAXI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WJI/7DrpQ2QTAOhx8KnKX8gVZdpbXNUWf5CR/DnVuaVYGzyR4oEPncnI48SsuiUd3boUgnpgPkK9F88uIOGsw488qlm5lQfS+vt7JXQFfGbdWPt5UFjX8vZdYRzq3b/x26c6FagZ/Iqp/5FOCrbDbzRZANywgjnV7FSPxV1WPUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RP7EcIwi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RP7EcIwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCB71F00A3A;
	Fri, 28 Aug 2026 10:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787912015;
	bh=YcdCASgBMokbVvqCzdKxPSD6x3NdQ+oKQweujJ7iAXI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=RP7EcIwiBX4Adzg65eo4MjBYmaA5l0mIg1wNe/t8ok6C92lr5XDayKFmEGegXAxDS
	 q/mgWiGd9S8AIfl9eG3ZZ0Lug2TNZsMEyGOHfvCrPXcBsoXo7tMH7rKs6SiA+wL9B4
	 z8a8PzWrj1+fFYtJ9QAvEJ+0JVffIlfwLg6Pu9kz9PHfatkoS6pTHMibG5ii+hF3VG
	 Ruxqc5oSimY7D0oDoil14Mm4BFR7cdOgqxC7pnzZ/RKiLXK0O9CrMy3KZL57yAs6JD
	 A7jpTKhGjAP1IlKSnPIRhLL3oAC4Y8jIdgV4JW5od/ZnU5NR25P8kiD9SswHU1i1vV
	 2BIG/7pSEit/w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7C83E1980078;
	Fri, 28 Aug 2026 06:13:33 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 28 Aug 2026 06:13:33 -0400
X-ME-Sender: <xms:S1-RauO8hN9m7Mdn3fLYZQNiST2bawhzi_nZLewqE9jGxFcm5B3e3g>
    <xme:S1-RanwyC0SZCfVh87NK3JK_Fa-Xiz1Y8QVqs3bX_4EQB14aX_7gRSEAfgkEQiSln
    k-bDwIfSOK0OAw5lmaxxMrZTxc_1qbHBKa12F0aL3yZwuH6tdFPuEDm>
X-ME-Proxy-Cause: dmFkZTGKsUzSPcoc0l+0wvLSxwUgs5hNyfe5ZWPHfmp92EaUIT9y3ULsrW2nVKDVS6C87N
    bZsu3XSlowxgzth5X88+zDla82yS+HRk/PmBczOG11W08qMzJZM/o57+ncVBpEEIousABx
    5CoYu8k1+l1Wh6JuJ7bgHYd/VSsYBZXPCLLgxee4XOoVssT2LXWZ+YncWcHo0EFkhSiyfW
    cglFHLybEIdnG0SuoTCSE7Qs6rrzYxuG7iD35HbDjCVZyhu9eEuo3my6r9zyASF1eFUT1v
    s+97UPxCeoGSwBZRM4yQkvuP+9StDl5rUTm4YfXwlhawkd3mdUK3JfLVH9tZi9usG4RWf6
    YnPe0AHURn6QXAqqONt2tzhVCKJUhnaItnyp1bHJKd2q8wYji3D7CeXOBkalQnaOLzDkyQ
    lRkX8qowwdZZvHrBhTxEG1LBYlQpNnf4OVg+6CP5hD7fNGClq4GIzv5flxNyn8rU0we9Dl
    o8OAQdzga+msPxiO2nfkPRhGB3+lxN/ljsNEOHFQsXaalpSnW5bVjFfepM6QGpAG0vXnT7
    pfCrk1Ejs+SJja57xLBt/JNMpxQ7bFLAIvIq9WNGBBkK+dpV9Nx69HyRMkjaH6w2b9QUWG
    4E0++Dsh5r0BDKIhp4ub5Ax7gBS8HHFaKaGFY/+3vnhLZ5iqedxWLupn5i8Q
X-ME-Proxy: <xmx:TV-Rapv7HZJ9k5Al6FoYDoCPWB9VvDX-acFKI-Dmra1U8SeOLqyNPw>
    <xmx:TV-RalhkKrQoQkoB0Tv8v6lK8_d3hfI4LlbiGJLwwnndwPFNcTnkSA>
    <xmx:TV-RanahcflpMgLm6TeD4Zld6OifHBL4w5QWFSgdFoQVYxBD7kVFGQ>
    <xmx:TV-RasY6PFIuHRouRi7pADEuqrRwl5trTlugaVkv5rTae8P2qSvsNw>
    <xmx:TV-RakxTu5ayMyKqzSyuTgLniqPNLDHbaTFsJkbG3gBTHJH3LyGnoRGz>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 87397F8007B; Fri, 28 Aug 2026 06:13:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 28 Aug 2026 12:13:10 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Johnny.Fan" <johnny.fan@cixtech.com>
Cc: "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 linux-rtc@vger.kernel.org, "Feng Tang" <feng.tang@linux.alibaba.com>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 cix-kernel-upstream@cixtech.com, bob.zhang@cixtech.com, jie.fu@cixtech.com
Message-Id: <6adfa384-d232-4e80-a6f1-fa51780107d3@app.fastmail.com>
In-Reply-To: <apFHoVVdhJsmBXDR@JohnnyFan>
References: <20260828031519.2749354-1-johnny.fan@cixtech.com>
 <549999fa-4b1a-4f53-872a-9036a377f8cf@app.fastmail.com>
 <apFHoVVdhJsmBXDR@JohnnyFan>
Subject: Re: [PATCH] rtc: efi: restore alarm support with runtime capability probe
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 28 Aug 2026, at 10:32, Johnny Fan wrote:
> On Fri, Aug 28, 2026 at 09:26:42AM +0200, Ard Biesheuvel wrote:
> Hi Ard,
>
> One additional data point: this is not a hypothetical requirement
> -- multiple CIX customers have explicitly requested RTC wakeup
> support (both suspend-to-RAM and power-off wakeup) on these
> platforms, which is part of why we are motivated to restore the
> alarm functionality rather than work around it.
>

Fair enough - I'll queue this as a fix.
