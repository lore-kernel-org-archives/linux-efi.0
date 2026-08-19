Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6AE30274D
	for <linux-efi@vger.kernel.org>; Wed, 19 Aug 2026 12:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787143870; cv=none; b=jRzj0L5YEseGzt3gz8LbyS0p4bk/6tM92cvPzXMO81rMrbTesRfqoH4B8YjfB+keHGKS1vWKGXDQLF8apCtv1/RiRi2iWDaisF4QzV2QWSNVvbgg4jq9j40omdV7MWKZ22Tg+xoT15Eo60I/24eRCKtj4/wPE/p4HOaANJ7Caxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787143870; c=relaxed/simple;
	bh=bW4qoXZuZdVvn3IHXwlnimORX+YXH8TLCJ57aT5HivQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=FYwC2BKDJQBDBPiZ0s+7ZC3pjKbM77AHLySuDVp0Rx8D8HsVMnoELiiE6h7Q5fVYsbcrrrFFQUa8CEUSSJP/V9XJ/FZ6lEi+z5EEtUFFxLOe3rEPAq4Jkuxz9E31WiT2WsadBLbKXaV/k87RXY06RuCuNXRbmBu+aOo56uUmgd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VskvlA5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VskvlA5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EF41F00A3E;
	Wed, 19 Aug 2026 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787143869;
	bh=w6/NlsucFgi8NXxtT/cnsL/H0uuYre8Be7OcGNSScLQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VskvlA5Re4Y3nq82XMu7MS6uMz9IEs050OmPu0naTb0CRCO1umKT7sy6rXUJ4ln9Z
	 q4ReKIxYmjQVXq6c6/286fSAt8RcjMruIaPS38K9VAC/weDk2Qs3sElbEtLTgwgbrW
	 LuXPchIqYf3Xwby3QQsq3xQQdnWlHa8/BgeiGtEkE/sAP+i5xje0Fv48G77M4ocOVf
	 R4So6hiQf1TNHdVfRUuq0bpkzabMhaWCGaYjg6KjjDbp9OEToavfDvPksqIDXCvL5+
	 fmqa4J/oR4IwRMGLwIxFyfJa8sGfl7ASIJtuIEcP0LjRypvRcm75vpyaUMCUn1MUQS
	 0LZNX3LUWU0gw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 78CC01980074;
	Wed, 19 Aug 2026 08:51:07 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 19 Aug 2026 08:51:07 -0400
X-ME-Sender: <xms:tqaFapfztTxZraTVJgeMKudg47tZzSHV3haWPjgzuHZhVUVRc4jQqQ>
    <xme:tqaFaiA1Fa_EJkm4WnNF6LISWTOhSNrocm4nzJm4FKIEP0taufLvgXDD0jeoMY-29
    _yDOts41hO27896oTt6yOhBtmTrWq9cd361eT2S2uEOFOYYENsCjai9>
X-ME-Proxy-Cause: dmFkZTE6PQORpasiR9yaTgVv34fsNGh5YEX5MV9cmE7q73w8Jxt7C7qRIockF7+k3uOYAO
    9m4mw7nTfnpaFu+7PINnykuaO3iSQiaebf/rwomXc/v/Cr1WBn833nKxBiGuxH8Cu7ynqE
    tTiVnxeYul7J+EBsCezZpQ9AEC+l3NKkIsgFCxD9qFBzDjhJ+9rLgMRHPyUR/iIoZkLS3t
    oqQXZPPf+SIIDgHPgpf6GEJ80yIPc1NUp7eavnOwD3zGVPrR1629JycUwi9iEGVzgkOKV3
    a6vFIONKPqKI5mjIndDWcaG77ASHquSIJfTOM+WIB51JtFsBccUv/yTj0VqN0GfGc7K8SV
    1o7RJEj0c1aLZm/AuYxI39DGhf2I0I4fpGyfSJj3u8lTN9VPGPMdY4P2U9q/Or6Q+5TNc+
    nPZF+KxU9NTgjH5LGiqN1s9pagN1ovSvfj/v0Qs49tyEa6g3sDvRgGQ/8oBavRM+kd89bx
    NQIwAS7rlfrNe9MvGko0r8w4JEZwGG0jYEAl2Y875+X9IAmMXpllBlszDLF42b2pENZXJh
    SdC8Yc+eDKyX7J4zDJsch7/1D1VVQiFmIb7JLSYAYHVlnZGE8mXueXX5bWbbbcMgIdf4bw
    13QvZZrG1/A/II8oQ7thl6IQDupVm/nu5v1GnDXgPJAdKqutyiWS5HvOlC+g
X-ME-Proxy: <xmx:u6aFauvcH9uHi364SoIC1u7xo46uQ3QSPzQM7EBYAtk1i8aWNAucEg>
    <xmx:u6aFasgnH7mHZdn058zJ7ri9wZfRpPU-Aqpar2g14rBquq3UY1l0Og>
    <xmx:u6aFai39zfDVzZaV493JZB1r4YQG22day2V_kBBKwrBI1F3I50P3og>
    <xmx:u6aFak-5iSW9HSzr3t6hwxHjge2k9jyPTrhAoSpikWIhXLtWJyjLlw>
    <xmx:u6aFaoPnzGW4Qkjhefz7ozY6azMXJcNnu7FeRybGuX02HOL6YBGBNJJq>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D7315F80070; Wed, 19 Aug 2026 08:51:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 19 Aug 2026 15:50:42 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>,
 "Ross Philipson" <ross.philipson@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-efi@vger.kernel.org, "Daniel P. Smith" <dpsmith@apertussolutions.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 dave.hansen@linux.intel.com, "Matthew Garrett" <mjg59@srcf.ucam.org>,
 "James Bottomley" <James.Bottomley@hansenpartnership.com>, peterhuewe@gmx.de,
 "Andy Lutomirski" <luto@amacapital.net>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, davem@davemloft.net,
 "Jonathan Corbet" <corbet@lwn.net>, kanth.ghatraju@oracle.com,
 daniel.kiper@oracle.com, "Andrew Cooper" <andrew.cooper3@citrix.com>,
 trenchboot-devel@googlegroups.com
Message-Id: <f85782ed-efb3-4045-9d37-2ed4847e1500@app.fastmail.com>
In-Reply-To: <alKI9mUBTOCjPbbG@kernel.org>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
 <20260711160110.267780-11-ross.philipson@gmail.com>
 <alKI9mUBTOCjPbbG@kernel.org>
Subject: Re: [PATCH v2 10/10] tpm-buf: Add TPM buffer support header for standalone
 reuse
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 11 Jul 2026, at 21:18, Jarkko Sakkinen wrote:
> On Sat, Jul 11, 2026 at 09:01:10AM -0700, Ross Philipson wrote:
>> Extract all the functions and definitions for TPM buffer handling
>> and separate them into their own header.
>> 
>> Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
>> ---
>>  drivers/char/tpm/tpm-buf.c |  3 +-
>>  include/linux/tpm.h        | 34 +--------------------
>>  include/linux/tpm_buf.h    | 60 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 63 insertions(+), 34 deletions(-)
>>  create mode 100644 include/linux/tpm_buf.h
>> 
...
>
> I would probably ack them all as I've seen these many times and
> there's not much anything new. Just waiting for additional
> feedback before applying them.
>

Will these be going into v7.3 then?


