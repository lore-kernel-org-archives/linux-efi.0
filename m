Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076912F691D
	for <linux-efi@vger.kernel.org>; Fri, 18 Sep 2026 07:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717278; cv=none; b=p2u7fCMnWHZgGiFj5E+IIPRQr0OVsRIZRukivqOlLyPOuMZOPq4eh4+7hmCqofFooOEXvk/nO1oX9RGqQOQLUpHI+sFV3Q3RKsi7J+gonfzm7T4hTzGHm5JpnRtXTZRZM4TqOjtcMcpcQt26Lg+tQcou23XQhTq54U//W0wqEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717278; c=relaxed/simple;
	bh=VaQRPbdE5ZMe79jiWvwqKPU9sGCSdXB4T4pwiTG7a9M=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=rfwomP/U86SsKCzimxvv0LAZVi1/f7x8RXH392HbmoX/A2ltDUHsNejV+sYqcWYgsWDY06QXBBReKC2mFk2KRnf2P9TNemrijaf6dH/AeM5KsEc5Vl8qILGDtpvcv5lm/8YqCE1vJxdUPAClO/+grhv+TpiTDLvDlY9E2uUz14c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4NkIfkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4NkIfkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4371F00898;
	Fri, 18 Sep 2026 07:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717261;
	bh=iSPd4nZ0D11kwmK8/wKlqzxDQXWnyxbAgGRwTuBgXfE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=P4NkIfkDo0AkRReJINxUCR30LavYTQsZPVg4igvjTgTaOxiOzVzNY8DN2TYLVIRtR
	 AIpfPwao4ZsAu+dbYCSa0crrGQBWlu5Tml1+goIEzA/B4qaDlgd6tf+3wyYzLo1KYZ
	 ZzJSesqWG0usN0EXLTQvMAVOzTUNCmGsBe3hpK9aqiUDHE8TejnbjTB+nkDoIaWgNk
	 7n/oe125Zxii4fEDEPIFDBfbgXgWQkLNxoMFKtsMh/cDJ9YSpVeerGnjbx/Bh1/scQ
	 aG1z/SDtQczuBk0U8zLag0DKL5jpmw7506FQB0AiKPIXgLceN01GmOcDU8Mc1kXINb
	 G7UljOLdxZUxg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id E1838198005E;
	Fri, 18 Sep 2026 03:40:58 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 18 Sep 2026 03:40:58 -0400
X-ME-Sender: <xms:Ceusauchnpbd8i-PV_gOgTkvg-EoVPlyFUhmqE4pfjruJi801xINMA>
    <xme:CeusajDNTKItO5C2EG7SFPnb6sc7zIqN5ssAslvxnRLzfXFrt9r_UE95TInu_x6A_
    ADcV8P8HwjefkD3hhZxJA0PDr9cKpuJCUZNVGOhgnJIZOHTG8Axs1yj>
X-ME-Proxy-Cause: dmFkZTGa4VA+2O+Tz0pIvtRzJ3ayOXhSXYw7OYrYkJhCWqbenIbEz3WyksuMKE9P7JxZPw
    GWgEpDpU3aAv1OU5+esIL/88+Xl6f0uciIzMG1Er8aE+vW271njkNfxFULwkmgLrONnhuO
    4+lXAENCTrdeKNJD1tJS8oFVge6qKbhpNTyLZLIUlZyLvT8ofvpPWbdZTVDqY3TlGHdwHc
    X+eoJXNkH3h0fO7ymlvLv2vdQeIGjqmfFK1TVarAGQ+x11awu87vS66ObYP35e3rFYO2qu
    m+iV1bhctzQ/8V8Ey9WQf23/BewK6YKIq22phOlTGrkguQ22gn8G3QnnBlBBe0hmaAwSI7
    K7yFEehOwJSw3wvjx/8CwKtJAvW2V/SMVoz0OwvM5Q9CzfvSiXjZf2iLIlZXvbvrupf79o
    QP82+sPQPs1OvEU8WzlYR+6BnPLy1SUAHVgZpBdGoJBd3VGvpEAbvepFeBkLCMRosMB835
    Sztz88FHOfe4YKV2YK4l5t2pv6Utk/SXP0mzd6bDWsSAzwwfMD8qEdVvHSPW2JbDFsbcOQ
    bjCa3oveW6kIjGdy4ZMM/E6IaZQNUg2PZyxkKRTeYKcEL0I3wrBOBR58AZ9FKH49OO6ugr
    0Wki4d99/sYqXfAEcBxJypu9FM0+sirklnITFurt77fVGkJ9onjRM0WGXvRw
X-ME-Proxy: <xmx:CuusakDlJCH1rMRfmlTwTmgp5YKQ4yZhNrbbSACpP_gqGtzEI9aQJQ>
    <xmx:CuusaowgexhWWceWHz1_C9ZxbBwug0IHbA2aQFTd320mgZUBu9_cHA>
    <xmx:Cuusap1__l_tV49at6JzgoRRNNNiCedeqRB2IzdCWUJu86IFAyhykA>
    <xmx:CuusagzSbt-oN2PH4eNBBD8SONPpMiK_Saa_CMeda7PcasHWhTjMKg>
    <xmx:CuusaoELqwXaHQFHwUPNYS06zh1y-yTtRdsi4VlriHCJS72nfbP7YatN>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 639C3F8007E; Fri, 18 Sep 2026 03:40:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 18 Sep 2026 09:40:37 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jonathan Corbet" <corbet@lwn.net>, linux-doc@vger.kernel.org
Message-Id: <203b540d-2a53-4080-9344-dcf9063e62fe@app.fastmail.com>
In-Reply-To: <20260917165035.15187-1-singhpra@juniper.net>
References: <20260917071600.5587-1-singhpra@juniper.net>
 <60d0b7a5-cc1f-4841-b4f2-754e1b921794@app.fastmail.com>
 <20260917165035.15187-1-singhpra@juniper.net>
Subject: Re: [PATCH] efivarfs: avoid slow QueryVariableInfo() in statfs()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 17 Sep 2026, at 18:50, Prashant Singh wrote:
> On Thu, 17 Sep 2026, at 10:36, Ard Biesheuvel wrote:
>> Could we instead introduce a mount option that disables used/available
>> reporting entirely? Feel free to set the default to 'disabled' when
>> CONFIG_PREEMPT_RT is set.
>
> Will do. I'll add a bool mount option (e.g. statfs_capacity) that, when
> disabled, skips QueryVariableInfo() in statfs() and reports 0
> used/available, defaulting to disabled under CONFIG_PREEMPT_RT.
>

Let's call it nostatfs.

> If you'd rather df still show numbers without the per-statfs firmware
> call, I could instead prime the value once at mount and serve that
> (stale but non-zero) as a "cached" mode -- i.e. a tri-state option:
>
>   statfs_capacity=live|cached|off
>     live   - current behaviour: rate-limited QueryVariableInfo() on statfs()
>     cached - prime once at mount, serve the static value (no per-statfs call)
>     off    - report 0 used/available (no firmware call at all)
>
>   default: live on non-RT, off on CONFIG_PREEMPT_RT
>
> Happy either way.
>

No, let's keep it simple. Thanks.

