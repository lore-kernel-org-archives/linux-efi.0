Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044613F39EE;
	Tue,  4 Aug 2026 10:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837767; cv=none; b=V2PqI9n10r7tMJjq4WZkjX1ObH8mxJ9RLPFemIui5vSsuN3gYDfE7tutPhH5mJiR0R2gXqQZFsZ1qkQFpe/OpYgUmyRGAR1nHSBCcsd4vWJQd/li76JJhlKJUGJwqQjJTnXHX0VQ/B3ll/0ADHVX6sJQle64P+NoJc/xyDI4AYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837767; c=relaxed/simple;
	bh=2hzoAJy9CF9uKpXtmbWGVwCrBLs6dzhdFqCezCjBZjU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=fDbpnwNC83BsuNNgz9jSt8vYBJTmXEvOxhpS8EdBUVITE24uCNeQWmV/W/j874y9BYQxPQnq+EMeXbZ2hOk6apchiVushro9NOb5/Njl+ujONeJMvN2ENegbMKJyyKpMecuoHnmmlmRGlfGZ0Rr+AsrP+XITM57y6nIqHxdoXcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzTvQa6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzTvQa6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EC21F00A3A;
	Tue,  4 Aug 2026 10:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785837765;
	bh=tPgURZHzY1elpzLKUgnLjyJ3z2YksABCXcMI2UeBLjg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=TzTvQa6mDuGmf0lRxAZHuszTt7kkxTD6D/mpDQVIpyyO5dxah+JDfeO4oHKlHOJQ9
	 +S+r2aKbTIeBWxceA7Aq2p4pKTVYJcnkSK1FTH49caq1wUwathTvi5TnT4s3RSvqe7
	 4axSvEnDo9i0InUOfKBVRJ1vxeGmuqTGZkbwSfLwuC0SufBrmVQAHd6DquyjoEZzh5
	 1Xly8kE+MFnKSEj/RJt/nS1LW2Zpho+P+nq00jxTjff3Fe1WId/GBU3HaKH8tT58B2
	 ljAvrPsGmqYHMgK3AtUbI4a0cnil2/1rXHGYxgVsIA0yWwwXigE/r5CdPD3fpqA7Kn
	 z3MnlM527HIPg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id D68021980072;
	Tue,  4 Aug 2026 06:02:43 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 04 Aug 2026 06:02:43 -0400
X-ME-Sender: <xms:wrhxaiK56mDGmnzx1dsAtBksOGU8c7Yg1PFgaTJ-PratPaAskB-3Yw>
    <xme:wrhxak8zLClgsakH5Cw5EfYTX5MlUsan49jO_5Z30VsnFUCGiMJS7lASfrK3YwTNH
    ipNUWpt5ddOyjSLG3Eg47jJVKD69m4f5KfnH0_N9zy5sipaGs__WG0o>
X-ME-Proxy-Cause: dmFkZTEYnWHp3VZYtfm4jJIKqaxGMQhu2TfXtKsGinMGrdq8jfvXERRBoaGqE4JH8Gz/DR
    wnSQ3TLcpNwx0k9qkpxc4yz9KWtaqY8drdHBneLrE82EA09fjGWORZGrtXrlikQqsZQGrc
    wYG4Dk/Cl8Ta0+6jqJGqA5Wlw/2eG4DXioQXu2Gf8J4zJwVSRrozayZmVY0f9ngQiHDXzV
    jiptQuDQUlp6bb5/tDyTk51ZoAc1FRWZumXJqukTiG9qgiSQm/VlES8R7bTgu/6mEH2d9J
    /lbfSOEY8XbneuNvODiZVrTPNTgSmTG1Yx75iCmnWM8/VUeI5KeTLlCZIwHwHG/ODJY2hE
    6OyfP6dUbs9RbLKvLSQrez3owh7d2FH+qHmy9+1Zp2qp9MXxnnARkI+e+VBwxmm+/uUgg7
    ecwNMFfOcw8g6wksvb3MpEOMXjtAa16/aD8jPcdCQ2lhqkh3dP2Rp7fCcYiHMETinA9VCW
    XRpYizFBbc4glOnkiBkbF/mGGrZGjL6yUR/TL4CUTTlEhByeusmusM+bGHNcbHkBA9J9yn
    di3Y6O/DCRlxsOwPzgTVdljU6DosUt18BEeCFgidRU6yeA838b/jQ8WyFNGFVj4f8ALcYT
    V0daOCh659zdl2GTRXbX3rrpKYmmsC98qsOtsgRbRzktRzXTlB4Zl5+mJ+pQ
X-ME-Proxy: <xmx:w7hxarUT4h3whakCoU3maUvgkdQwJIXChCjND1QwyVTGiyZD4lTxUQ>
    <xmx:w7hxashbz_ttu6SvY3BbvIArkUCGYu4c_RvoBM0yZ6GvoWa0woIb_A>
    <xmx:w7hxai8MWea0YZZab9KRlKpqtQYHByBNU1HJI0S7VuO-e_EAW4yBVg>
    <xmx:w7hxamaroQl51QTsnkP37WGsfKr37qVYPWRFYq3QolohRnL4fC-h7w>
    <xmx:w7hxah35nhhyQc8n1BEHCRi5-DlzomCUKO-pFPU8-0fy0OKrml_yInrZ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4AB55F80063; Tue,  4 Aug 2026 06:02:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 04 Aug 2026 13:02:21 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: x86@kernel.org, "Anisse Astier" <an.astier@criteo.com>,
 stable@vger.kernel.org, "Ravi Bangoria" <ravi.bangoria@amd.com>
Message-Id: <d8186408-1b46-4d01-a140-ca1008c6d7f8@app.fastmail.com>
In-Reply-To: <20260801144258.15977-2-ardb@kernel.org>
References: <20260801144258.15977-2-ardb@kernel.org>
Subject: Re: [PATCH] efivarfs: Cache occupied and available space
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 1 Aug 2026, at 17:42, Ard Biesheuvel wrote:
> Ravi reports that statfs() may be called by unprivileged users on the
> efivarfs mount point, resulting in repeated calls to QueryVariableInfo()
> which are disproportionately costly on x86 systems where the variable
> store is backed by SMM, as each SMM entry requires a rendez-vous of all
> the CPUs.
>
> So cache the output of QueryVariableInfo(), and invalidate the cached
> values when an entry is added or deleted, or the variable store is
> synchronized after a suspend/resume sequence.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
> Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  fs/efivarfs/internal.h |  2 ++
>  fs/efivarfs/super.c    | 21 +++++++++++---------
>  fs/efivarfs/vars.c     |  9 +++++++++
>  3 files changed, 23 insertions(+), 9 deletions(-)
>

Applied to efi/next
