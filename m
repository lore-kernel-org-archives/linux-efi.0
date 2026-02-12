Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCF335972
	for <linux-efi@vger.kernel.org>; Thu, 12 Feb 2026 01:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770859830; cv=none; b=FDz2pP/fV+UYRR9x6YMNM20tpPWzenVMl/YQ4Ikbg7OCmLh81sxRiREEZtwXiJrL7B7152hba1cLQF59l7Zuz+4YOStbdoWNSSqJi6EuBy5pj+qVcxARki3e5+ljMdBgbim+LLRyXwd8WWTy8O2mFdR/Ilo/RL17Gz7LHGbRr/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770859830; c=relaxed/simple;
	bh=KgiA3wWySdtu27emmfFx9TmT091bq+yUVCdDCtZD06E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmxZbKn4OUdog88qXtKiWKj+6+IDcKwMZnG8f50nmPn9WjfanjSil2H+R3jdeXRBcfVzMPfB+Su/+z4lnQKuFMghx7Lt6pWROQjSNE6GUumHdGVvP3UksHUphIfUHBbcO30ug2gV2B29BGmNwda8WQtUbDjcq8sA6c3HQ8sxx+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AstQJRbp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GKGmUkrr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AstQJRbp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GKGmUkrr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770859828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bY4z6uuO6pRuPz5GN5A8CgMrwxk/puAYj4i3AjMGr9s=;
	b=AstQJRbpgZMBDfedPSvIG3Xnm5M2B//WLIDQk+TQjtOT3E6HivpB5auxwSEoGzSe4NadKB
	4VX0yKUdUPfE+Bo5cB8Zvun30ncCADH3u1Nmka9q4M8pdlDxKVaJGgVOJpoBiAOn5fAxAe
	d9b0KsQkGsIPO7slZKuV4rPPHflHXtk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-okk_5BAFMBC5sQgKDDms_Q-1; Wed, 11 Feb 2026 20:30:26 -0500
X-MC-Unique: okk_5BAFMBC5sQgKDDms_Q-1
X-Mimecast-MFC-AGG-ID: okk_5BAFMBC5sQgKDDms_Q_1770859826
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aad5fec176so51835875ad.2
        for <linux-efi@vger.kernel.org>; Wed, 11 Feb 2026 17:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770859825; x=1771464625; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bY4z6uuO6pRuPz5GN5A8CgMrwxk/puAYj4i3AjMGr9s=;
        b=GKGmUkrrbyream/4X1gm8LzWWQTYogwaWoUAN3ffdevUBmJlEEeGFN0ibUVRN/k9tK
         RjeYEMt0KWiTkt+6BXlgB4+SwLrEx3SR7yZgeIQO4JpRnfTdkz7/fjUukGVLHzcO6Dw3
         gGnEyzcxouaSAMPg/WWx1qJtznn1N2idu9R8SkuRGTvKjLerOo1h09B+ucytt3kGi9rn
         TgOOHZsORTcBwMq53N/P7KApSODNDcM7tgOj2vwigNjKGfFXYinj1JlBxiy6RfEIhrO9
         qCut5DDh2casD0/iIQYvXKgFyDdHh4Dd4i5TL7wWKoAmdX6kAg/vXHJwQEJa8CPwwF9J
         W3vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770859825; x=1771464625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bY4z6uuO6pRuPz5GN5A8CgMrwxk/puAYj4i3AjMGr9s=;
        b=Q6PIq/Sa8MortJgLKS9cg6gf1RqCnTWVc/YUxQQ7b5lfjWJGOCVEhEIg6NT6JU9wbV
         VS8UztRL6qWTnSQ58tg66rlIUX5A3gMNe5m0ov3VWEKRL6ruFZUpzZPkLXiUWAhE4Mdi
         In+OZ06gFRiBHF2tbD8NoyOzzv9wsA+9MjuL+0IA2JSjXtrdZjtpKqxq52fDIJhN9IHx
         q9p3jHDrptobQTcf93BB/umVArMf6UtcEyQjj+iHyZvxS5B+llXfrbnWOY9lgm1r8y5A
         jeLc4HayZclgojrI8jFAMiktCv4imU7o6k5p6say2RCqAUA5Pm4WbK1ewb/h4oGKQZDU
         Gu0g==
X-Forwarded-Encrypted: i=1; AJvYcCUsFYnkN1ohu9TaL9o8nc4jnKYzwU0qByh1Wq35r9kV+cG40Lqi2Ry2WjgV/DmqZl/xozYtLocAbxg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTjr6f5YnHwgusRTvdNv432cZuSgRCkZCecmaiRK/jBhHKbLbq
	l08xnyEkXEe67Wmsx0NiORGqi/ubkwA03KN3tiXFdNrwFJ/fPu8apEw2Tx/29Zu2W3zjyk8wppP
	O0azEGy7gUBTIsE0t9YVC252YQUqNb+7GcsuZgXiJefuTLKT8B3cDfZ4K9jlNjQ==
X-Gm-Gg: AZuq6aJy2gFTopqskPWpj8/4e/b1Rh8NTBRU0xT+MJRDR9rqs8seaqeUbVgPu3uD1PA
	Ds5e2KLai2JvpAneE81J3+xBdHiZeNwgl4LjP5wMQ6C6uHNlHPympFmIXzYs2P0/HNSVYr+eB18
	CYptSjqwjc/kHMLZMG3KH91tuoGMm6d9UCYyu76iVLb3eqqPN+5OfFlxX/KYMwe2SgBYDRVYF3T
	CN94y8MN6obokJ3iQpO1Zwv0SzWUKm7jYjh1DxkR7R4Zr8SbzXshvWByejVoeWepHdyzoZnv3b9
	f5xW8QFxy/pKZYUE8ILWl4WeA6WbhVnQe8umYKhTX1o74KFxnxRDq9FUiZZDZD8PujHXNgdN0b6
	MzyfVgMiiGxeY
X-Received: by 2002:a05:6a20:e20d:b0:38d:fc34:c88d with SMTP id adf61e73a8af0-3944887601cmr937860637.55.1770859825460;
        Wed, 11 Feb 2026 17:30:25 -0800 (PST)
X-Received: by 2002:a05:6a20:e20d:b0:38d:fc34:c88d with SMTP id adf61e73a8af0-3944887601cmr937804637.55.1770859824883;
        Wed, 11 Feb 2026 17:30:24 -0800 (PST)
Received: from localhost ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e197f7e0bsm3248413a12.27.2026.02.11.17.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 17:30:24 -0800 (PST)
Date: Thu, 12 Feb 2026 09:28:43 +0800
From: Coiby Xu <coxu@redhat.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>, 
	Alexander Egorenkov <egorenar@linux.ibm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Dave Hansen <dave.hansen@intel.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "open list:S390 ARCHITECTURE" <linux-s390@vger.kernel.org>, 
	"open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)" <linux-efi@vger.kernel.org>, 
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>, "open list:KEYS/KEYRINGS_INTEGRITY" <keyrings@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] integrity: Make arch_ima_get_secureboot
 integrity-wide
Message-ID: <aY0rZp9ROwfjPgD8@Rk>
References: <20260203041434.872784-1-coxu@redhat.com>
 <20260203041434.872784-2-coxu@redhat.com>
 <66f9d13875e81a965984e2a661e992a3fe43c516.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <66f9d13875e81a965984e2a661e992a3fe43c516.camel@linux.ibm.com>

On Mon, Feb 09, 2026 at 03:43:08PM -0500, Mimi Zohar wrote:
>On Tue, 2026-02-03 at 12:14 +0800, Coiby Xu wrote:
>> EVM and other LSMs need the ability to query the secure boot status of
>> the system, without directly calling the IMA arch_ima_get_secureboot
>> function. Refactor the secure boot status check into a general function
>> named arch_get_secureboot.
>>
>> Reported-and-suggested-by: Mimi Zohar <zohar@linux.ibm.com>
>> Suggested-by: Roberto Sassu <roberto.sassu@huawei.com>
>> Signed-off-by: Coiby Xu <coxu@redhat.com>
>
>Thanks, Coiby.  Other than unnecessarily splitting a line, the patch set looks
>good.  As soon as the open window closes, I'll queue these patches for linux-
>next.

Hi Mimi, thanks for reviewing the patch set! Would you like me to send a
new version with the line splitting issue fixed?

>
>> diff --git a/security/integrity/ima/ima_efi.c b/security/integrity/ima/ima_efi.c
>> index 138029bfcce1..27521d665d33 100644
>> --- a/security/integrity/ima/ima_efi.c
>> +++ b/security/integrity/ima/ima_efi.c
[...]
>>  {
>> -	if (IS_ENABLED(CONFIG_IMA_ARCH_POLICY) && arch_ima_get_secureboot()) {
>> +	if (IS_ENABLED(CONFIG_IMA_ARCH_POLICY) &&
>> +	    arch_get_secureboot()) {
>
>No need to split the line here or below.
>
>
>>  		if (IS_ENABLED(CONFIG_MODULE_SIG))
>>  			set_module_sig_enforced();
>>  		if (IS_ENABLED(CONFIG_KEXEC_SIG))
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index 5770cf691912..6d093ac82a45 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -949,8 +949,8 @@ static int ima_load_data(enum kernel_load_data_id id, bool contents)
>>
>>  	switch (id) {
>>  	case LOADING_KEXEC_IMAGE:
>> -		if (IS_ENABLED(CONFIG_KEXEC_SIG)
>> -		    && arch_ima_get_secureboot()) {
>> +		if (IS_ENABLED(CONFIG_KEXEC_SIG) &&
>> +		    arch_get_secureboot()) {
>
>===>
>
>Mimi
>
>>  			pr_err("impossible to appraise a kernel image without a file descriptor; try using kexec_file_load syscall.\n");
>>  			return -EACCES;
>>  		}
>

-- 
Best regards,
Coiby

