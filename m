Return-Path: <SRS0=Mume=Z2=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288D6C43603
	for <linux-efi@archiver.kernel.org>; Wed,  4 Dec 2019 10:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED778205ED
	for <linux-efi@archiver.kernel.org>; Wed,  4 Dec 2019 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575454458;
	bh=eV/OG+wDQFYfv5Ue03UDnIlBmXN/EqkPTPMh7OoORZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qaSifvO5aWNKJ3NAPPC/Xo1PQfvEdxCmLmvVtWrdrMCA4WX9xkvNCBCWIBexzy8Jy
	 2yxgqcUJzq1kP+k5wHPSVIoQbwICWNiCnkZXn/R/hmm4lsUdAHuTsQ5dSlFq1rO8ag
	 PHeYE3H+3DYs2BDaRc7o4w7wWFY2B+hyblCPvLWE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfLDKOR (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 4 Dec 2019 05:14:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38735 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLDKOR (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 4 Dec 2019 05:14:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so7820666wrh.5;
        Wed, 04 Dec 2019 02:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3SqaxowF8V8CPgMsCKyGumZmEAzs8aY4VegZwp5+TJI=;
        b=f6raTZTe79rlg7+fJKgUTxXXJGhcd07fCb9NQihp35dE+7aiwdBDZ8kKQ7AP+0BxiN
         CBoVs0ibvXFlm+DyTKLnA1St0+1gmLZVP+RJaA4nrHM0bSKAL65Rfd2DksonyBs0L3Cu
         hDubG4qC5KU1pPmIvEOy/UhkIdY41uu3mBR8zfZxQ8d4+Iow+U+CGFyftZEsR372B5Qo
         moteIbv3TNBcxP35csUxJT018haSIcA1ztkkvlRwmiRHHMRfBbCSnaYMZszgFMwWABC+
         UQJTs0EeXjjFTexPavo0XzfzMwSzsdiOrR2wtLSIdECLw+VNstkhiSA3SOZiqNSzxNGV
         1lGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3SqaxowF8V8CPgMsCKyGumZmEAzs8aY4VegZwp5+TJI=;
        b=e0r5hsaa959s6bGmQ3IsxdwUqx3W3cZYrpszYYvXZFc6zkYXuolAx/EEltN7ztTvSx
         mZ/WV6rFeFElaZZBcSsEVVhLOHbI96YO9CTsKkgubvZO4NoTLYbMeGH74PuwZWyM54ra
         w9SKtdR+GXgpChf0OKWF0T5TBSGd1+lNO0bW9rbXLKP9s9v6h8Z7noKkR03pq9zeUH9u
         X0saNmwlwpfqMNPxT4q3tYvz5IofU4ZmBWGMRIyaxLfsB3xG2kbYUuVQYhVhYJuB1wbH
         bAQWqSqzGTs6OMWbDDUE0YT2SNuEcYkmaOQTsHxdBZylLd1VTpHmxuP4Too29hEmBQwo
         EQDg==
X-Gm-Message-State: APjAAAWg6faCeT5sQEzr8xwj0ha3rOL1rMCv+juTcJ7eK1uFKhCNvxXR
        7bH1vSN6bdJ6kpDI3oz09MmS0Ye8
X-Google-Smtp-Source: APXvYqynMfBJtkF2DxLQaA4sUUx4cn+Cwkjpd9I9MD1TWmeTnTAX5UQC4joBUKLuTCYAuFkI9DZozA==
X-Received: by 2002:adf:a746:: with SMTP id e6mr3200398wrd.329.1575454455106;
        Wed, 04 Dec 2019 02:14:15 -0800 (PST)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id r15sm6282851wmh.21.2019.12.04.02.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 02:14:14 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:14:12 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Dave Young <dyoung@redhat.com>
Cc:     linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Weiser <michael@weiser.dinsnail.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        kexec@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/efi: update e820 about reserved EFI boot services
 data to fix kexec breakage
Message-ID: <20191204101412.GD114697@gmail.com>
References: <20191204075233.GA10520@dhcp-128-65.nay.redhat.com>
 <20191204075917.GA10587@dhcp-128-65.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204075917.GA10587@dhcp-128-65.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org


* Dave Young <dyoung@redhat.com> wrote:

> On 12/04/19 at 03:52pm, Dave Young wrote:
> > Michael Weiser reported he got below error during a kexec rebooting:
> > esrt: Unsupported ESRT version 2904149718861218184.
> > 
> > The ESRT memory stays in EFI boot services data, and it was reserved
> > in kernel via efi_mem_reserve().  The initial purpose of the reservation
> > is to reuse the EFI boot services data across kexec reboot. For example
> > the BGRT image data and some ESRT memory like Michael reported. 
> > 
> > But although the memory is reserved it is not updated in X86 e820 table.
> > And kexec_file_load iterate system ram in io resource list to find places
> > for kernel, initramfs and other stuff. In Michael's case the kexec loaded
> > initramfs overwritten the ESRT memory and then the failure happened.
> 
> s/overwritten/overwrote :)  If need a repost please let me know..
> 
> > 
> > Since kexec_file_load depends on the e820 to be updated, just fix this
> > by updating the reserved EFI boot services memory as reserved type in e820.
> > 
> > Originally any memory descriptors with EFI_MEMORY_RUNTIME attribute are
> > bypassed in the reservation code path because they are assumed as reserved.
> > But the reservation is still needed for multiple kexec reboot.
> > And it is the only possible case we come here thus just drop the code
> > chunk then everything works without side effects. 
> > 
> > On my machine the ESRT memory sits in an EFI runtime data range, it does
> > not trigger the problem, but I successfully tested with BGRT instead.
> > both kexec_load and kexec_file_load work and kdump works as well.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>


So I edited this to:

 From: Dave Young <dyoung@redhat.com>

 Michael Weiser reported he got this error during a kexec rebooting:

   esrt: Unsupported ESRT version 2904149718861218184.

 The ESRT memory stays in EFI boot services data, and it was reserved
 in kernel via efi_mem_reserve().  The initial purpose of the reservation
 is to reuse the EFI boot services data across kexec reboot. For example
 the BGRT image data and some ESRT memory like Michael reported.

 But although the memory is reserved it is not updated in the X86 E820 table,
 and kexec_file_load() iterates system RAM in the IO resource list to find places
 for kernel, initramfs and other stuff. In Michael's case the kexec loaded
 initramfs overwrote the ESRT memory and then the failure happened.

 Since kexec_file_load() depends on the E820 table being updated, just fix this
 by updating the reserved EFI boot services memory as reserved type in E820.

 Originally any memory descriptors with EFI_MEMORY_RUNTIME attribute are
 bypassed in the reservation code path because they are assumed as reserved.

 But the reservation is still needed for multiple kexec reboots,
 and it is the only possible case we come here thus just drop the code
 chunk, then everything works without side effects.

 On my machine the ESRT memory sits in an EFI runtime data range, it does
 not trigger the problem, but I successfully tested with BGRT instead.
 both kexec_load() and kexec_file_load() work and kdump works as well.

Thanks,

	Ingo
