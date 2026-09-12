Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2616F429802;
	Sat, 12 Sep 2026 08:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202543; cv=none; b=WjPMt0REg57YjSiGzSsu632gZGtssrsuBDAUTln9mItkOmib13MQ8VkXmgdBCwMXGlml78ThF8m21aA8z+8E5vGT9tXvz1sOjy8JxOJQaLZHa3aWKcBwOXol/RrtyCjoqKlDtxWF5mY70QVj03ze2Xi6FKjyDPOMErkku2qLCEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202543; c=relaxed/simple;
	bh=imROA7H3+czajTh2rKfRqdn21rlRtDUOheAnxPHki4M=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=InKlUhCPBopdYEXR4/KP3bSxVQ/O125Uan2gZQ4agOutj2XocoNPs8B9PHeP2MuzkEQEEM1fsqYsVWxw/zaASrC9Lk5NED7qQYJPM5tyXfQh3vBmy8nH3GjENenja4bBbnMgtZ/ODsveDh0jCMDk9UZ2kP2np/RmTXJIFWiuwBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sg5ZAlxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sg5ZAlxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C33D1F00898;
	Sat, 12 Sep 2026 08:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789202541;
	bh=imROA7H3+czajTh2rKfRqdn21rlRtDUOheAnxPHki4M=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Sg5ZAlxl+X0XvpN63m5oDTos4dM9XLtSJq2TEThBCUbMwAJS8zSqf2xrdDc3ukyhw
	 YC0rX98k5Je4uhXe4E4KL+RYv4EUlfz2Bbhig1bglr4HwO9SL+sfk9L0gg0AQVyhWL
	 tpFY99olNhZVX5iTHz0vyCDarjHjdjrvon4KxI9hy+swaKSySd78Q91hIszTH+3Jdk
	 VhdNmmUCNYSUqz7yIuzbfE9W/vypjbAKEOwrqCHlr2fYGWCPawKpRbQ5cxeEQMNw0C
	 +CupjhpuZz3EAs9kC1UKlnscSkdfsAcjXywcm78c8O6o+u/SL8G4Z603XfTsFnuhfI
	 L57rNV2TojQIQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6A5CD198003A;
	Sat, 12 Sep 2026 04:42:19 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 04:42:19 -0400
X-ME-Sender: <xms:aBClaqadaGA3cW7yBAiJavDftfPuXHDekvJYDpLExP4dOonPTSvIjQ>
    <xme:aBClaoMXxS43DU3aGW0o9jczSCZEP46Wf_HKQqA5pFxnQOfm8cBQ_y5pDW7Wtx2W0
    uj8FDzKb9UqTFHXmrkJa4rCtByFw2MjdOCtzPEcizMJzNWrbXmbhA>
X-ME-Proxy-Cause: dmFkZTG3p6HovJHCcVlrBFjfcn6R7cadeQWsKAyNwAxVuYGi1cLQO2kSjdYHoGqVeBNwaX
    kMR2fY3I9tW3NEM+aYTykBiocH3objfnpWH9q/in/k8rtjOKSqMedMKzrYpU2kjT9Vd+PL
    s11uzXGcDmw84pAqkfTH2HQLtUaJglB+ZgJj3kjTk+D92gyNcRzApLFOd0peGseKhD9lRo
    ElZ4AJL9hDEbvR9Rupa79Vs3ck6mnUMtc8/Mpd6wm8hxSW/UB6S0Ilw7/oZWzvEkqlB18w
    EoU+TozVBNpgQFEmEdlueJC8GuuGR+aek+ZK/eEzQMaBQKSMoQ9Y5scV1HUD4xNpffT1kp
    152Qg9Yg9T+eXnl7Jyb4SVtWHMoRJtVC6SrjSzGgEqrW+CkoIS5NIMXrfP4sTPRzBgTWGQ
    M3OnfiheQ+86/YKfcf4A86JfrRFK+Qcz7UMXnVsls/HyrBTUSPdSLQs6wAmsycYfeACRaK
    pLjWo2ecOqP58Oa6Cg63wxdrmgy5hMV4jGZyGcqZteeAqj0xuQT3f5qeQ23Ff/GJ/zyOkE
    rDcHMbcbtEs9LwzeH+RMeCvRdzrJGaRHFZjpK0hxk5nBqQ5XjjTf6dIXG7C8Cg+S1vr8f1
    fLDVWTYEcypGAkHPU8shOjvdle05QZi+CzGK0LHndVzLDD5Y0I1oWPkZHtNw
X-ME-Proxy: <xmx:axClaoCg3WIhOo4GzAf0RqfQQRy1iuEfQjutgIfjgQfrVFbMmjTKsQ>
    <xmx:axClakm23X6KhB0RNfmKt6ZB0pEy_gYqW1ahjuluEByik51WIgWBQA>
    <xmx:axClareOUgOSeaySV3rXCjSOdvdhg-e2vBmYF0U7ugecP4KEShsDlA>
    <xmx:axClagQpfGcbGXqWg7UgOmqrBgQDr8I4qk-Lb9izvGQN8M-5GBjTIA>
    <xmx:axClaqvM83dum0aTlVN8R_sGifN2ZDsxweqvhBet3S_g6sw3Iacl3YMe>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 461B3F8007E; Sat, 12 Sep 2026 04:42:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 12 Sep 2026 10:41:56 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Borislav Petkov" <bp@alien8.de>
Cc: "Kiryl Shutsemau" <kirill@shutemov.name>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Vincent Mailhol" <mailhol@kernel.org>,
 x86@kernel.org
Message-Id: <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com>
In-Reply-To: <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
 <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of panic()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 12 Sep 2026, at 08:10, Borislav Petkov wrote:
> On Fri, Sep 11, 2026 at 09:32:26AM +0200, Ard Biesheuvel wrote:
>> Thanks. Can this be applied as a fix please? I need it to base efi/next
>> on it for the next cycle.
>
> You mean I stick it into tip and give you an immutable tag to merge?
>

If you're not taking it as a fix, then yes, please.

