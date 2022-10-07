Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539B9C433F5
	for <linux-efi@archiver.kernel.org>; Fri,  7 Oct 2022 08:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJGI4e (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 7 Oct 2022 04:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJGI43 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 7 Oct 2022 04:56:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF12DED1C;
        Fri,  7 Oct 2022 01:56:26 -0700 (PDT)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EF3711EC0606;
        Fri,  7 Oct 2022 10:56:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1665132968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xxUcAgRRdNH8/ZTTtj8HOcKS5T9SfdNK203wSP8RP04=;
        b=ht4h39A/HHSsP2HY+YmjEU+S72Ere6qYzgD3rQkxEaYCvNgsHXYBomnjCAAdsxmXNsKtKU
        hwWfkDev95Zh9I1eOFct5pkIVQ7nDzwp+CB/vOWdR0uFXk1Uxgp2NLhOyQvc2VuNXVnFU9
        IMHdzNjOWJijYxWRCuLZ+aWM6ecGRGA=
Date:   Fri, 7 Oct 2022 10:56:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH v2 02/16] x86/compressed: efi-mixed: move 32-bit
 entrypoint code into .text section
Message-ID: <Yz/posPv6infDtDU@zn.tnic>
References: <20220921145422.437618-1-ardb@kernel.org>
 <20220921145422.437618-3-ardb@kernel.org>
 <Yz6xBROUBPyaUSoB@zn.tnic>
 <CAMj1kXGCWmay_=cncZpZwXoyLgzt7=2dVuXHaaQU=K6NEXrezQ@mail.gmail.com>
 <Yz64aMVo4W+D70Fz@zn.tnic>
 <CAMj1kXHi4TgGd=vicfxVOUnzDrhSfsiR=572L6cEwi47JO17jw@mail.gmail.com>
 <CAMj1kXEkX=dZ0uUAdXoe5JC_Zv2+ndTMYwDiixYmWT-ip8OOOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXEkX=dZ0uUAdXoe5JC_Zv2+ndTMYwDiixYmWT-ip8OOOg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Oct 06, 2022 at 02:27:54PM +0200, Ard Biesheuvel wrote:
> I'll add the below in the next revision

LGTM.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
