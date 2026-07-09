Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D075B19AD5C
	for <linux-efi@vger.kernel.org>; Thu,  9 Jul 2026 05:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783573372; cv=none; b=rq8ur0yXlRxo6FH3oon/p4QEXiuEtp37N9ig19WxUEU2X/t7FBio/XDMolqYgnSfXOLkRkv2CJbcOgBOp4gsTPyerQO8UAG0lCGu/l4ZVrAiGc63Xb45uuHFX1BxuzDEXZMyAVF1aKvmIYv30Q6ZvMnM1/9BViVVYmteaat1dqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783573372; c=relaxed/simple;
	bh=xpqKsLKvQAK5FV5hbi9nx/R9kelahTbg+c8O/2JGm+Y=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=KAKleq9Z2JZ2YePxmNxm5as/rFI/EUrcq1uZ5d0MSXKNOWsWvC5bRmTbalVFr2G6GJYvCATSfmOe3ahg9GLufBkeyK2Gp9uRxr1FlAZRy36rGOVNf9W7QPhk5FKC72NAl/eXz8RtUGeobHYV98Tz9vIHg8dBsB/M+pRaQe+XK2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gkv/5IHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gkv/5IHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265601F00A3D;
	Thu,  9 Jul 2026 05:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783573371;
	bh=xpqKsLKvQAK5FV5hbi9nx/R9kelahTbg+c8O/2JGm+Y=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Gkv/5IHuqI8Nb3ZsMjcZ3yLYhHyrVP6UluRrpYQQyHQ8DlhByJ/ybwQ8Vty0Lk8yi
	 wNqaLFHbeH2OsMax5PuA0vIcqdnlIsHL6tdPou8s93+4Xg1msojG0GTaWUD/I8lu6v
	 kSIrFwAYADfvk9k+/wNMQ4cUzQ5NB+glYrPfHwz3PGQ62a7RD8pGpIQsyArpu++2fG
	 rDcF2dx/rF9RoXLozAS/pROeIUAPpG7tVOc1LkQ20W7jWXtQLfGWUsmrMQpR0WhQf/
	 Hd0KxUdzIp8T0Jb20JKWj7OH5mS9X9dRx8zHaDqTussKzy0P7ppAjZE5GT5mUEV3NH
	 YPHCWeWDHmxVg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 11E1CF40068;
	Thu,  9 Jul 2026 01:02:50 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Thu, 09 Jul 2026 01:02:50 -0400
X-ME-Sender: <xms:eStPakaMc7Gpm1oba-v1Dr6kSUZsqO4BUmNfT00GwQ4dkzNcjtRj_Q>
    <xme:eStPaqNxUD4I4topNN9bJhL5NiGlIKqUEZS40qL6QQ54nImNLExROfTm34NQHgwXk
    9u26HSnrLiTzijB75Ga4mBk9mEm2eoE93BF6NTwTPkNhbyH3onqbvMi>
X-ME-Proxy-Cause: dmFkZTGQCmhnjIGfkfKlxiJNtDmAthU47hZWoQYekJEY4Q0r14KZaDRLCQ4nYc//xhbvQY
    VWBrNYcUG92Dn2aiM+H/50I8/haxaSG5EPw26+ndZBt5S2nMGHfZXCGxaPbxXUL6Hi1ovO
    3i7fajaJfdIBqqWiFbaO8fgMbOuVBzwYSAZa5vrDdJjE3uXuqRGuLgABTHehNbpT8YW8QC
    60ODAnyp3tj1brRG4N2m5+irPotMCq2xqsTNV8DZbQMMBpnaRltb2jrSQHdkvF207I217c
    j+r6f27zg3oRr9oQ2Dha+o/7rnMWjOBiSJeADMePXaObt8KdjG02k4JF9VybGaBGVZ7PEM
    cJ3EX4GI7F19BEspEtikjZ0QyoiL7gHPhwTroCp3dw7bysOy8hlYkbxAvmOy6s2rQHghgg
    atltxkPWAvn315o76UIJx7xi+w0eN2c2tmvFSKb6m9OnZY0is7Ao++eRvH1G/MVJODCwfO
    roqWZHmLFFJzfSlsEuy2bA2F1FC+QsaJOJPXAuhalpwzq1Mi1QLIP8hKLY+ew8NIjbT1uF
    EtJ2Vnbq4KNzBjgSchFYrWTJsHohZXtvTjA+iBfaEyHM1JMZay2f3QPAJXXyplv/R2TECf
    9TQNuSvQrVTl2qHcPyJToGEtQ4DoDBbR8IBzuyvI1kDU4g2jk7DsDfFnc8+Q
X-ME-Proxy: <xmx:eitPauEXOLeRFQTvNHZWl3O_OXBJTZiYU_TgKAf2wwjQQDAYNI7nQA>
    <xmx:eitPat2OSGkSsDq9WN2UlAOudopHH9qFL386bO9QISCJrSPHh8XVlg>
    <xmx:eitPau9999N4C_pgDsLFdRIFP8YPBAUpm8LTgcORbNG3Knkmj0r8-Q>
    <xmx:eitPaoGkP8esq_SaP3Er6oJZyJxshx3fSyliCksRo6VfXfeBkQnV7g>
    <xmx:eitPasgu0FjbMaqi7U5t3khX4IA9Anxpsn8CGKvbhu_BUBLhgLe3cNAx>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E0A8F182007E; Thu,  9 Jul 2026 01:02:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ATXqerFj33O3
Date: Thu, 09 Jul 2026 08:02:28 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Borislav Petkov" <bp@suse.de>, "Andy Lutomirski" <luto@kernel.org>,
 "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>
Message-Id: <361838e6-76e6-4ad3-95ab-994a56bf5f9e@app.fastmail.com>
In-Reply-To: <akUG8giyFn2a3Lts@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <akUG8giyFn2a3Lts@gmail.com>
Subject: Re: [PATCH v3 0/7] efi/runtime-wrappers: bound the wait for EFI runtime
 service calls
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 1 Jul 2026, at 15:28, Breno Leitao wrote:
> Hello Ard,
>
> On Tue, Jun 16, 2026 at 05:09:33AM -0700, Breno Leitao wrote:
>> When an EFI runtime service call hangs in firmware, the kworker on
>> efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
>> The kernel currently waits indefinitely on the completion, and the
>> caller holds efi_runtime_lock for the duration, so every subsequent
>> EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
>> handlers, ...) is wedged until reboot. The only externally visible
>> symptom is a "workqueue lockup" message and userspace processes
>> piling up uninterruptibly on the semaphore.
>
> I'd appreciate your thoughts on this approach. Is there anything you'd
> like me to adjust or improve before we move forward?
>

This looks fine now, apologies for the delayed response.

I've queued this up for v7.3

