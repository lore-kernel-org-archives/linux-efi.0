Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285BF3A1A28
	for <linux-efi@vger.kernel.org>; Mon, 30 Mar 2026 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774867975; cv=pass; b=f1NTvNr5x6DsKjGvR2Q4fvWkbYAEL0NTiZSAI8AhD5hmf7lQYqSp1qgNZTfaCg/940qq5tqy7Feg4iD+nzTXMdXwXIAdSGmIBo4d+fwGvk5btSGQFtrH3P50L32AcstpNbnV2ILffHV3H31aTqGJu2tfCWk2h23AibpokXxdkac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774867975; c=relaxed/simple;
	bh=F3VazHzopeDjZWarFbUGSy9fAQOZAtVoVtrCnQM3z+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QRUJ0vAdE6soET26orFHVVJwuTMHsI/I+0ghdbBd+43T3W+sycuB1V3niJ+R6+VB9zzjNBgQwVgRZ/vTXFbFu33QbNleCiMwOCicSj272BGZ3gfPiRglgnBCrUQpO3EqO27fIbhHVVxWYeIYsZ7eVMLeXKT/XCWBOTWG7blUShw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXJclH3B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BsowsSTM; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXJclH3B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsowsSTM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774867973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rscamLmE47bElMCajG81H3iJ8AJKAGLT4qfMLFw7Qms=;
	b=eXJclH3Bdf06KVb2T2v/S4L8DafxCIOBoyx6u1bC+xXI3kONv0Ue8ZgLTnZ/yZYI6E5i/+
	W3MJ+zLo+fTUVgYulpHPAxyYoiFHdqd5J503co9EeNTzdDdsGxHlVYquL2fZV3x7HYq1Yv
	RXAdxItprWE5hqy0E3oyJ/8f/fjZ73k=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-Hirr1Ue9PLia26cDxLuDgw-1; Mon, 30 Mar 2026 06:52:52 -0400
X-MC-Unique: Hirr1Ue9PLia26cDxLuDgw-1
X-Mimecast-MFC-AGG-ID: Hirr1Ue9PLia26cDxLuDgw_1774867970
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38a469b8bcbso18331241fa.1
        for <linux-efi@vger.kernel.org>; Mon, 30 Mar 2026 03:52:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774867970; cv=none;
        d=google.com; s=arc-20240605;
        b=VG3dDxSwPADtgWDyEgg3rMOoTSs/5ZmFHSKyZD2VXubMgXXOwSZU1wmJnewp4UshTf
         6Bjo6tjoB54KiD3u9oVlx9yQLevRJ1bk3XyZAsS0k2Xk9vDc/d6JATnfg+QLanfulCy3
         3Zs+ppHGdDnCfIiIu4lAwe54HK4Vexx+WljtokZnYqkPGc59QwrxrNHnEieXpg3LcCY2
         D2eVVOMQBpqOxPIxbz4iwc1QERtQiHVchmr4485jSzEOyCaeA1EgtrQIcszuPF/CxdHQ
         WgD72LwjkwV9V/42ghExGxHDOTpjFYwjaW7ZWAADPGHxCkRUWs/etuLkkkUdTQcFGCqR
         KYDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rscamLmE47bElMCajG81H3iJ8AJKAGLT4qfMLFw7Qms=;
        fh=iR8LFXi0+EpyzoFW3HX7A2mdFnLKxBt70BxRhRdeZXM=;
        b=AVGynS+64vGvC68ewIqZvSHukZm4LUG2efMV4NN3qLPE8xxORfz68p6TwKjUejxL+E
         fOXzhJJFnMiQjpF3hC1idIOn7yxXpx3AMEF/atay0rFGHp1lb1+LV/QWzZQBSTLJfsu8
         RYtyvyERViuRil6t0OBBr1/1M1pEf7UdwNUHEcJKaiKVil6oPVF+G+pPo3ixXHLKN5b6
         t38U1wNosFglAO/TOS2D4KxaWgoDm3e/m1HdvAXumram+tRxysw4Kfp0E6ZQ9c/coKqC
         YXSyOutcj7dNvwCPpO0vE/le3mDzW1LYuk+6PThLP10PDjEtgpCkXvaW1KnPnYRV1hdc
         VCww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774867970; x=1775472770; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rscamLmE47bElMCajG81H3iJ8AJKAGLT4qfMLFw7Qms=;
        b=BsowsSTMleJkcbgLVPGfL539lK/KIfkYzdVjOu/nsZ7IM6sZ2XzXoJPeDvlnytsAl/
         EJTL3KPpBSXAe1R3sIOY8Fk9ISwHWD4+siEyD0MwgTHP+hfNiZ4XyMKdW+jb0SvKQ91/
         UHHSb+q1nYYzJGu/2W360QylJDT4zytBLQ79N8WObRoe63omQJk4MQlWEcnbLP3tAmmt
         YYUYCsk87KIzBJaWh7WOCs3ajM03iQXs6HIhJNElnZ5y4/mr9fBHHyq1blC2997+cAyF
         4HFWCpqixwwlPf0Swzc7YPLosZmFwAGqvKRctSPf6NawtYBN/IDM91Zr+TMZHe3fj2nd
         G4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774867970; x=1775472770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rscamLmE47bElMCajG81H3iJ8AJKAGLT4qfMLFw7Qms=;
        b=SpS0Gpss69RSgKXt1Z4IG3CqIA9c9Ux7gDszNIRCCR5QQDZ5z6rHBO1MlJOqfCMCIg
         cmnMIue7l+FQlKDBE1dkC/uCqj7tyJ3QeXk3lxQZA5nyQmhvcqC+iD4FDMQF0kTWBavt
         R4W2CBQj/6H4/bHecJHHvnfiJ/h85/BP+auPehSnNtHPx6br6qKFs/IPHmllrqEmcKtz
         UJVCqk1vBsCdM4ySNCwhds5/gUmGflBGQdWoUUKWxxM2eW5E8Hj6lyUdQE+yEcscVv4d
         omowRb4XuKf3+CClrBNfyKy+kWn/ASDxURCwtebIlfsXazFwBkHDrjL8uD6cLTKzLOfx
         pq8A==
X-Gm-Message-State: AOJu0YxHbBe9CEu5wEUaH1HhmPZJlX98nubCZc4yAenZlmbXz3UP1Vbt
	fZJoHxR+lNkegm93BwJV1wN7M6A08Oup+0YhxUnpsF16RiNWfkcG118LBGn/2vPlrnYCz+Bq5GM
	GnbzgMc+SAo6jnLjYCTWUHPTO5mkqERTNyM2+GfMtAF+9KXi6zQVf7Idjc5ZbPqnNCTLTmFUXOa
	ijD/O6JcIl+CgusCXZ+SKlyjfQ2bKa7zdAXE3f
X-Gm-Gg: ATEYQzyacWHjFjKJ6dQUWDwyLOMBmTid8GMuMbz2GM/plXVhM5jxHInxe+aXpPzgVIt
	W3hytK6IKxvqJkB78xQEgUpnKLhAMKjabqXKleGjfqbTZnJN2JKAs0t+qlsWDcCdwDE0xuFZ3qS
	5qMsP5KS6yxLCdTT53VxanDv9Db1Rq85BfPPx38ESGr84Z95AN185ANyW/YhPZ7fYdJapvXf0wg
	Ai9EQGF5kOUWMZO5hwjHEjUr4JCgDxn+ED3hrDMP6/rCBymCJrKrqJiKWZmrVJZhyZX
X-Received: by 2002:a05:651c:552:b0:38a:4e7a:c236 with SMTP id 38308e7fff4ca-38c731604fcmr45046901fa.12.1774867970164;
        Mon, 30 Mar 2026 03:52:50 -0700 (PDT)
X-Received: by 2002:a05:651c:552:b0:38a:4e7a:c236 with SMTP id
 38308e7fff4ca-38c731604fcmr45046851fa.12.1774867969648; Mon, 30 Mar 2026
 03:52:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260326132655.1733873-7-ardb+git@google.com>
In-Reply-To: <20260326132655.1733873-7-ardb+git@google.com>
From: Dave Young <dyoung@redhat.com>
Date: Mon, 30 Mar 2026 18:53:35 +0800
X-Gm-Features: AQROBzBbiXW0SDOlACTBp8fxmD0IeOpVpE4TSNGZihiC1yy_raUcvWo2SHWGYH4
Message-ID: <CALu+AoS-mbOfRV+ZOJSgd4PJUGxuszw_EoKojkK+T8Vq-=K+6g@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86/efi: Re-enable memory attributes table for kexec
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Gregory Price <gourry@gourry.net>, Usama Arif <usamaarif642@gmail.com>, 
	Jiri Slaby <jirislaby@kernel.org>, Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 26 Mar 2026 at 21:27, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The EFI memory attributes table augments the EFI memory map, and
> provides permission attributes for all runtime code and data regions
> that are otherwise mapped read-write-execute in their entirety.
>
> Currently, this table is disregarded when doing kexec boot on x86, for
> two reasons:
> - the boot services data region that holds the table is not reserved
>   correctly, and may contain garbage at kexec time
> - a misguided sanity check on the size of the table is likely to trigger
>   on kexec, as the EFI memory map has been trimmed down by that time.
>
> Fix both issues, so that the EFI memory attributes table can be taken
> into account again at kexec time. Note that this requires that the call
> to efi_memattr_init() is moved to a later point for x86.

I vaguely remember when we discussed this issue in old threads
efi_mem_reserve can not work for kexec_load syscall, but I think after
the commit a2498e5c453b it should just work.   So I think it looks
good, thanks Ard!

Thanks
Dave

