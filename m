Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249DA3C13FD
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778828060; cv=pass; b=Kq2o+4fqFLOXoMRQtYX+ZlIcMSKntO5hgPUx+Gw2+wEfFgtgo/L6fsde+Z9i8annu+P3yHGx+DUUa3tSvsc54kqgunYcbT2ebiboq3NlCpCknPmF7AjB6daSs5ey52nA21ChDLPTR+ZS5TcXbHqpLkHYHID78sTIeFOmw7uLXEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778828060; c=relaxed/simple;
	bh=+zDO4k/9Tgy4q0LSQYpj77MT3b6n3APYAMy8uyw53OI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F49w3WOsUpvKL17GqVx8GgZ9VODUXNw77zJSqsnuHOg94SEiSEQq9KQgEw4CdOScbs/ch3dawO98ZF+Vn6Qp2XGXxUD460aPv6R3D6PQ3RLyrUWKlE0PxiWFc4q/OtZl53lFvInIKZEMVo0u+dFayc8J07WUKcdJTgFSo5M6rXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=it-loops.com; spf=pass smtp.mailfrom=it-loops.com; dkim=fail (0-bit key) header.d=it-loops.com header.i=@it-loops.com header.b=kMDDxkIv reason="key not found in DNS"; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=it-loops.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=it-loops.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=it-loops.com header.i=@it-loops.com header.b="kMDDxkIv"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67c2b4809baso17354974a12.3
        for <linux-efi@vger.kernel.org>; Thu, 14 May 2026 23:54:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778828057; cv=none;
        d=google.com; s=arc-20240605;
        b=NCfl6gVMWJVOkpeeXIpkybz1RGUHzdB21PQEis0T6CMabGkYC6QiUon575+i9wcpih
         ZrIqqxj/FnH7RI6C00e4m6qTV4XNvPo/mnozv9K22ECpCeJlA6LSFAayDFury4XBxp0/
         3kI69p8zsY0PR6duM7c/iJFZlrpwsLCKZL14R4mMeWbW2CMIcOspWEsY9lhGmSE0L1bZ
         LUe4YSRDNp8WkNMtCrUU1pvaJ/6mg1ltl9rJIrCbqFneBfrbc03utb5meWFlyOFLuwDC
         OgSx9F89eBnIeEI4reDuzJPG2kjhygEs+oYjvYTPZdVM71BmlqxvrCjHpWte2cK2E6nt
         TPDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+zDO4k/9Tgy4q0LSQYpj77MT3b6n3APYAMy8uyw53OI=;
        fh=WTf6DA68sbOooBrvmHZKqqnLOKYbgA3oanvgRajIBmg=;
        b=TjrvXvWClmNBnqFkQOewkRBe+TczIIpGi6TUpNTSbpOCvxN28KaxYITBUNVgEqzC8I
         /Q8zPmhuV59+J2c6pY74T9cnl6G0cHKfe9E3kW377Oi6v6gomDdTAJ4UCKRnqKsqvPxI
         KuoXSzYJf24dbl7K+G4BCY5xyjzCGavVJatusa/RMsKoudUv9c8sNMACPglP+d7GlyVy
         opKzTNUnJjkl5KW2qRtRALUi3PedTlyDQT0MfmsUYrAJExp9ArYM0RPpKBFaVfNRZFId
         PB0tsiBF7FoVGTexvVx9r+/JzwfKGqzqYg5IPI7+CAhPNF34IREdi1e+9maP91zV6nzS
         JMxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=it-loops.com; s=google; t=1778828057; x=1779432857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zDO4k/9Tgy4q0LSQYpj77MT3b6n3APYAMy8uyw53OI=;
        b=kMDDxkIvj5Uw7X4ikmX2iNaMj9CKp96+/CmV44U/RnSJBQRCMeJ0X1e2IFedR0Gfk4
         WPZKpZStCRiBfQNDKmMq4yS+Vu6Il/+wp+yJRQvHBgadk95VBqlVTVvFSMovIwlX1c21
         aEr41kOC+0EUHw+6ojC3E3fl9l8IM7SCnYvhg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778828057; x=1779432857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+zDO4k/9Tgy4q0LSQYpj77MT3b6n3APYAMy8uyw53OI=;
        b=jpPimkgyNgk9bYFzkYUzfgKxL+U0ETWbjd9R635cMZcYK1dpSj8IpqQ5LV0bWCwGS4
         /qfv371E7+dqVZr7LIjeOn1Mppb/uHiMR/QFDYlokUuEIxfPo3s+fbhaxu8ml0B6pMuN
         n4CtyYJcVkoZUN++9mjP0KQ/MXOpF5lQqGeGIPUBk3YJFVF+fOy5g5XCF+acUXcSwoyn
         sYUPGIQPXISCJFg9V6TIFmHS51YYgxbFQGid96eMI/gIMi4NOA6xNYSDPh70CgyIG2X4
         TQ10RbJ5A9XGiVS173dFsCKU1opMaSWs8Y3VBg+W/XjAyoTAsbxJjukrA/5WscnTNJsk
         iqFw==
X-Forwarded-Encrypted: i=1; AFNElJ88ZqW4aiotUWtpB3yMqFOanKGJi7K7LdwOOhA7HgBKGPJbaEkHFcGV5cvRQE8GTCdxaHsD4zT9cQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFHgp92rUFTN0oe+d+TSlL6IhZcWcT1F2wcU6m9ZcMlUji1jyw
	WzoM7WfUa49JwcZ6IMcNSPXksuwXQXTbTlxW2IBsDXJI78HNFtn2ChgYaSFKSqitXWvFo/+K9Nn
	2Wf3GJ0fBg1Uk8+KsEvC0tVTLJ2TsdHTPXo1R6ei7oiqnF1a2HQsh3Zc=
X-Gm-Gg: Acq92OFtSeIv/WRUzkgWJaYfMzhIxdCKvLG2jenf/rF1mYWAWxCpF41tNRXJcTn+zvp
	9OFQh2mL1V/7dj6qIHPMT7umfDfQRA91utFrpe8imPtUl102eRumpK2nLSgLv9J3wVVKm+WPU4c
	ZKh7Oyvp8zmmKwic6gM9CP1OLVPu5EAakx+itGrGlkCjYyHWNSolDp/PPc7W0TjbaFeLVNZ/TMk
	WfzLXk6bQxmDfCxJkaX+8r7yN/SApXA+4vyGwLMSHJJugM5N1J6WCjXgWAHMjIobHKr/nDTJ+1y
	bOdeUiP6
X-Received: by 2002:a17:907:9801:b0:bd0:8e74:85a3 with SMTP id
 a640c23a62f3a-bd5178f9146mr136045766b.26.1778828057421; Thu, 14 May 2026
 23:54:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALG0vJuaU_5REU55Hg170LipPLj7Tt0V3icn7XzxLY-8+jsx-A@mail.gmail.com>
 <20251120055748.GM2912318@black.igk.intel.com> <aSGTghJyX-u-leL6@wunner.de>
 <6e7aa10e-9938-4ab1-af14-b3d2906c211a@panix.com> <CALG0vJv7ZA8byAF25pKqh9fEBpfgbXk+cAE6s9K1N6ZvVRroUw@mail.gmail.com>
 <628342c2-15c5-4890-84ae-dc29df2c5f16@panix.com> <CALG0vJt9x5Oh3DvAvFJR88u2oD063aRyhcufOXHNwv6YKCU44g@mail.gmail.com>
In-Reply-To: <CALG0vJt9x5Oh3DvAvFJR88u2oD063aRyhcufOXHNwv6YKCU44g@mail.gmail.com>
From: Michael Guntsche <michael.guntsche@it-loops.com>
Date: Fri, 15 May 2026 08:54:04 +0200
X-Gm-Features: AVHnY4K5JlpDA8yXuZAkRPwOV4pj8GaTUwmlTBUE0m65VZymA16RPDRQKhluGxA
Message-ID: <CALG0vJuoF92whbgkzb-a01m4X+=3L2CZDvyVu4gpB7tAFFKACw@mail.gmail.com>
Subject: Re: Oops when returning from hibernation with changed thunderbolt status
To: Kenneth Crudup <kenny@panix.com>
Cc: Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, 
	"rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>, linux-pm@vger.kernel.org, 
	linux-efi@vger.kernel.org, maarten.lankhorst@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2026 at 10:05=E2=80=AFPM Michael Guntsche
<michael.guntsche@it-loops.com> wrote:
> Since this was still happening to me with 7.0.6 I went back to 6.14 on
> a whim to see if I can see anything specific there. After coming back
> from hibernation (which worked) I noticed that there were no efi
> variables at all. The kernel log showed the following
<snip>

> So it looks like that I ALWAYS had this issue with my notebook but up
> to 6.14 this resulted in a warning and starting with 6.15 it became a
> panic and lock. What I do not understand at all though is why I am
> apparently the only one that can trigger it repeatedly and others are
> not seeing this issue.
>
So I looked at the dmesg output with a connected and unconnected dock
and the memory layout is different. What I am wondering now is how
this is working in the hibernate case.

* Machine goes into hibernation with the dock connected
* During hibernation the dock is unplugged
* On resume the firmware is doing a full init (sans the dock) and
hands-it-over to the boot kernel which continues with this new mapping
* The hibernation image is being loaded with a different memory layout
* Once this image resumes it tries to access efivars which are now
somewhere else apparently and panics.

Is the hibernation resume code accounting for this change in memory
layout in any way?

Kind regards,
Michael Guntsche
