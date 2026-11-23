Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795439138;
	b=EYbw5DdVsnlqEWo5FQDwAnBg3WyceyymNtHVMeUImhWrvyGvXRcvtBoJ5n8Iy9+NwVmT
	 jdVj4QaUj7E+aJL6MFaOHuT6mUik40jbymrHyCZTpeXZ1znVrk6ww7E4Qw9Q3jWYu5UXP
	 gMNzb/pnBjXpZjtatzKoObXtefSinT4rZV+KfwX+lhfBPLpRnVKBS12yd9XRCC5A49BbW
	 St6O//dzRYtx05QL6hSNcAXMAliM5EbT+C6yZynG/bEZP26sVExvbRQdV/0Fkk7+0zOeW
	 bEga+t1qE+daqEhW2YHrTkaCmCDdG+bXCNBvVG7s6r+GfOL1v3/ojHOklKQKomsovqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795439138;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Message-ID:
	 Subject:To:Cc:In-Reply-To:References:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding;
	bh=1bHuhh2uAVUu3FM0LF1RB62M3IsC+d8Z+EU7PPZwqno=;
	b=QSzNLan8k1BIiPRJCp7Il71S61NbfPPwqR842fc1QVO+cwF6roPqw5nUugk5Ssh67O/d
	 3Le74f494iyrB+6xvOAOks4doLtzsUv6CsphrNZZz58opyt8kECrl316Ef5GGlaLapAiu
	 tpcu/oOORFdQV5MQa6sAMQWA3oLrIoEHKCpXXNoNRMnyEL9WxQOBKE3K7lmbI6ryajw3E
	 42zs15UMmp6jOd93J2elTV89qAl9f8cVnujjHB3Ur+mThLRsFu/HWlnqvYEDse3ge86C+
	 2c4ZWw1fvpqeqsroVuoNlAkXMmZBJU2j942IsazCfieMpN9cytsKBiIcSg2f9hun+OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SWviKd04;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B2C606A31A
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 13:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91B2C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SWviKd04
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1b563e32936so149287c88.1
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 05:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795439137; x=1796043937; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:cc:to:subject:message-id:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1bHuhh2uAVUu3FM0LF1RB62M3IsC+d8Z+EU7PPZwqno=;
        b=SWviKd04PJM3ZF50Nym+v5r6rPiQVQMBFld61+q6xufVROjSGxWbfrwb9rfWeFInmh
         0CQwyz2zfOkDGBIFC5BLblPDRzKb6zT+SmCJX4THjp3NSXAQEr7Z6njySsTnzxlfagvD
         tRS+imCcGf61CgNLh+XcZghh0+yQ5FvbZnpRQTjQrhMs3ATTL6nsWuxF6fkuqFnyqcYc
         qm0LEhDe9Vp3xoNIVXcLjTR8xrUs2PWKJTrhLuyo+fgF7iPNeUivhlKpDYtYlX0BngmT
         jdFLwAQloqSrMlN3Viahkfs33ClfnB/VMMsbPSj8ARSYn69JN39FRrzzYMDZhLoSLTnk
         SYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795439137; x=1796043937;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:cc:to:subject:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1bHuhh2uAVUu3FM0LF1RB62M3IsC+d8Z+EU7PPZwqno=;
        b=FQK2geWo3i0yXj4kmMfWwe1XGQQPbOcBhnYoZa4Kio9oSp3egbEXz315cxWvSrSWsP
         JkNpYgz8/lbTkU/d0R19AZkCSs/i5wtL03+KvtuCgkg24UlyZbmOw0YJ9GakbQ7HNF/c
         Oi745Zzgn82DqQMuC+a5MA98dla3Ci9T09xMWxBB3qtkaA/aaTZsDA6vUnatECN1EEKs
         VpRLHzIhapWJrrZ1DrH/5WStKjxnVcPy2NKWbTVhwrpPKULqzJ+dQNG3W3MvA2agzqXd
         GGyq3xX2hZLmmRtVpIL/IWo4R6x8pNMeHQh8YS4mNywRz4a2KSmNgrxCLQYEpg4hq/sL
         NDGA==
X-Gm-Message-State: APuU4Z9WBGC+cT18rD6Hqi+9GQblJKFSTDjLIf+UrBlUQBfJsxvTz63Y
	7/dn8kYkEqoE3sBUfIlg0+YlIseJK59yP/6gUZ3eYoF8H0UuD734EfP2YEo3Nsfd
X-Gm-Gg: AZFdTZc3jRnBYiHdW4Vpmn8aJsjD9nH/mJT0PljOgqVhdRmd9MRjtLkXQq3eUO5J8YT
	Q+qh3ygBryZNRwMM4O6bxrp7+8heWuYbpLSjzcmESDbC+qgScr99TQ3jlvzcNzEQtJjwc+qWS/Y
	XHi3A6/y2aJShZSEdU5MXlde3PCFUlUGKrYzYo5omDobF4+CLZ5tCWW3dydjeeuQkl4IJH1AKFb
	tGHiQ9vQ+Hzo1Hd7eF3G2fYF4XgDabmKRcR00NCgvIcAkWD1F9f5PINhPnBIDVPL8dkkKKd3JzU
	jZZoXtsliyzTkkps4jRibtmNp1+nqPG82df7nekd+Bm0wjNYIqpcITflTe2jIO5vkMj7Y2E4Zcq
	g7K8O6mL4mp95AepPW0fjZVmbasfQr99GTlZ4vPylg7PRztqRukNcKzs/CDrmWyNSKSxJJUUqIK
	+VTHt3sAAibsUhSiRZpTvN/b9AquFlF+4qixCvtzTxxOZwMiokBTqGsK2skySJxDp0g26Fin7Oc
	cfPTYq0SWbgB2x7+uoEEIDsLn+syfeMWUH0CppFaJNJOxP4K0COiDnUj7kbEXtJFPwjmO4g4DM2
	5j6ezaKAGWNl5NEe/Fq9QSTsF0qGDy20W1GzYnEys25szintpV9YGiHH5Fv0EtdOegHvsA0UjKp
	lCcMPxVXnGKvjfvjMIKflQiDKgUML
X-Received: by 2002:a05:701b:291b:b0:1b5:3878:a9d2 with SMTP id a92af1059eb24-1b5568e950amr9846972c88.20.1795439136572;
        Mon, 23 Nov 2026 05:05:36 -0800 (PST)
Received: from [127.0.0.1] (ip68-107-67-45.sd.sd.cox.net. [68.107.67.45])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ff27bsm30856311c88.6.2026.11.23.05.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:05:35 -0800 (PST)
From: jasmeet.bhatia.us@gmail.com
Message-ID: <f3a4f1245736cbff8152a46fb60fe984@gmail.com>
Subject: Re: [PATCH 0/2] x86/efi: Disregard stale EFI config tables after
 kexec
To: ardb+git@google.com
Cc: linux-efi@vger.kernel.org
In-Reply-To: <20261123094228.466164-4-ardb+git@google.com>
References: <20261123094228.466164-4-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 23 Nov 2026 13:05:35 +0000
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ard,

On Mon Nov 23, 2026 at 1:42 AM -08:00, Ard Biesheuvel wrote:
> [...]
> Patch #1 wires up efi_config_table_is_usable() for x86, and uses it to
> disregard the INITRD and Memory Attributes tables when booting via kexec.
> This fixes a panic when kexec'ing without an initrd, and supersedes the
> existing handling of the Memory Attributes table, which does not cover
> all cases.
>=20
> Patch #2 does the same for the TPM event log table, so that the EFI stub
> can allocate it as EFI loader data again without regressing kexec.
> [...]

I've tested both patches on my Framework Laptop 16 (AMD Ryzen AI 300)
running Linux 7.4-rc4, and the results look good!

- Hibernation: 4/4 successful platform hibernation/resume cycles with=20
both EFI patches applied. The original inconsistent E820 memory map=20
error no longer occurs, and the saved sessions restore correctly.

- kexec: Successfully booted into the patched kernel using systemctl=20
kexec. The kernel correctly marked the inherited MEMATTR, INITRD, and=20
TPMEventLog EFI configuration tables as unusable and booted normally.=20
The results suggest that both patches are working as intended on my=20
hardware.

Tested-by: Jasmeet (Jazz) Bhatia <jasmeet.bhatia.us@gmail.com>

Thanks again for preparing these fixes!

Jazz=0D

